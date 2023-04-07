//
//  LoginView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


enum LoginViewState {
    case logIn
    case signUp
    case forgotPassword
}

struct LoginView: View {

    @EnvironmentObject var vm: MainViewModel

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignUp = false
    @State private var loginViewState: LoginViewState = .logIn

    @State var img: UIImage = UIImage(named: "EmptyImage")!
    private var textFieldBgColor = Color.white.opacity(0.7)
    
    
    var body: some View {
        ZStack{
            VStack {
                if loginViewState != .signUp {
                    Image("LogoWhite")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            email = "ttest@email.com"
                            password = "11111111"
                            loginUser()
                        }
                }

                customTitle(text: loginViewState == .logIn ? "Log In" : loginViewState == .signUp ? "Register" : "Forgot Password", foregroundColor: .white)
                    .padding(.bottom,loginViewState == .signUp ? 10 : 30)
                
                switch loginViewState {
                case .logIn:
                    emailField
                    passwordField
                    forgotPassword
                    customButton(title: "Log In", action: loginUser)
                case .signUp:
                    UploadImageButton(image: $img)
                    customTextField(title: "Name", text: $name, backgroundColor: textFieldBgColor)
                    emailField
                    passwordField
                    customSecureField(title: "Confirm Password", text: $confirmPassword, backgroundColor: textFieldBgColor)
                    customButton(title: "Sign Up", action: registerUser)
                case .forgotPassword:
                    emailField
                    customButton(title: "Send Email", action: recoverPassword)
                }
                
                bottomButtons
                
            }.padding(35)

            
        }
        .frame(maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.accentColor, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            .edgesIgnoringSafeArea(.all))
        
    }

    var emailField: some View{
        customTextField(title: "Email", text: $email, isLowerCase: true, backgroundColor: textFieldBgColor)
    }

    var passwordField: some View{
        customSecureField(title: "Password", text: $password, backgroundColor: textFieldBgColor)
    }
    
    var bottomButtons: some View{
        HStack{

            switch loginViewState {
            case .logIn:
                customButton(title: "Sign Up") {
                    withAnimation {
                        loginViewState = .signUp
                    }
                    
                }
            case .signUp, .forgotPassword:
                customButton(title: "Log In", iconName: "chevron.backward") {
                    withAnimation {
                        loginViewState = .logIn
                    }
                    
                }
                
            }

            customButton(title: "Google", action: {vm.googleLogin()})
                }
                .padding(.top, 40)
        
    }

    var forgotPassword: some View{
        Button(action: {
            withAnimation {
                loginViewState = .forgotPassword
            }
            
        }) {
            Text("Forgot your password?")
                .foregroundColor(.white)
                .underline()
        }.padding(.bottom, 20)
    }

    func loginUser(){
        vm.isLoading = true
        if validateFields() {
            Task{
                do{
                    try await Auth.auth().signIn(withEmail: email, password: password)
                    vm.signedIn = true
                    await vm.fetchCurrentUser()
                    vm.isLoading = false
                }catch{
                    vm.isLoading = false
                    vm.setError(error)
                }
            }
        }
    }

    func recoverPassword(){
        vm.isLoading = true
        if validateFields() {
            Task{
                do{
                    try await Auth.auth().sendPasswordReset(withEmail: email)
                    vm.isLoading = false
                    vm.alertUser("Recovery email sent.")
                    withAnimation {
                        loginViewState = .logIn
                    }
                }catch{
                    vm.isLoading = false
                    vm.setError(error)
                }
            }
        }
    }

    func registerUser(){
        vm.isLoading = true
        if validateFields() {
            Task{
                do{
                    try await Auth.auth().createUser(withEmail: email, password: password)
                    guard let userUID = Auth.auth().currentUser?.uid else {return}
                    let storageRef = Storage.storage().reference().child("ProfilePictures").child(userUID)
                    guard let imgData = img.jpegData(compressionQuality: 0.8) else { return }
                    let _ = try await storageRef.putDataAsync(imgData)
                    let imgURL = try await storageRef.downloadURL()
                    let user = User(UID: userUID, email: email, name: name, pfpURL: imgURL.absoluteString)

                    vm.saveUserData(user)
                    vm.isLoading = false
                    vm.signedIn = true
                    Task{
                        await vm.fetchCurrentUser()
                    }

                }catch{
                    vm.isLoading = false
                    try await Auth.auth().currentUser?.delete()
                    vm.setError(error)
                }
            }
        }
    }



    func validateFields() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            vm.alertUser("Please enter a valid email.")
            return false
        }


        if loginViewState != .forgotPassword && password.count < 8 {
            vm.alertUser("Please enter a valid password.")
            return false
        }

        if loginViewState == .signUp{
            if password != confirmPassword {
                vm.alertUser("Passwords do not match.")
                return false
            }

            if name.count < 1 || name.count > 20{
                vm.alertUser("Please enter a valid name.")
                return false
            }

        }

        return true
    }


    

    
}
