//
//  LoginView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

enum LoginViewState {
    case logIn
    case signUp
    case forgotPassword
}

struct LoginView: View {

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignUp = false
    @State private var loginViewState: LoginViewState = .logIn
    @State private var showError = false
    @State private var errorMessage = ""
    private var textFieldBgColor = Color.white.opacity(0.7)
    
    
    var body: some View {
        ZStack{
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .frame(width: 100, height: 100)
                customTitle(text: loginViewState == .logIn ? "Log In" : loginViewState == .signUp ? "Register" : "Forgot Password", foregroundColor: .white)
                    .padding(.bottom, 30)
                

                
                switch loginViewState {
                case .logIn:
                    customTextField(title: "Email", text: $email, backgroundColor: textFieldBgColor)
                    customTextField(title: "Password", text: $password, backgroundColor: textFieldBgColor)
                    forgotPassword
                    customButton(title: "Log In", action: loginUser)
                case .signUp:

                    customTextField(title: "Name", text: $name, backgroundColor: textFieldBgColor)
                    customTextField(title: "Email", text: $email, backgroundColor: textFieldBgColor)
                    customSecureField(title: "Password", text: $password, backgroundColor: textFieldBgColor)
                    customSecureField(title: "Confirm Password", text: $confirmPassword, backgroundColor: textFieldBgColor)
                    customButton(title: "Sign Up") {
                        // Perform login action
                    }
                case .forgotPassword:
                    customTextField(title: "Email", text: $email, backgroundColor: textFieldBgColor)
                    customButton(title: "Send Email", action:{})
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
    
    var bottomButtons: some View{
        HStack{
            customButton(title: "Google") {
                // Perform login action
            }
            switch loginViewState {
            case .logIn:
                customButton(title: "Sign Up") {
                    withAnimation {
                        loginViewState = .signUp
                    }
                    
                }
            case .signUp, .forgotPassword:
                customButton(title: "Log In") {
                    withAnimation {
                        loginViewState = .logIn
                    }
                    
                }
                
            }}
        .padding(.top, 40)
        .alert(errorMessage, isPresented: $showError, actions: {})
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
        if validateFields() {
            Task{
                do{
                    try await Auth.auth().signIn(withEmail: email, password: password)
                }catch{
                    await setError(error)
                }
            }
        }
    }

    func recoverPassword(){
        if validateFields() {
            Task{
                do{
                    try await Auth.auth().sendPasswordReset(withEmail: email)
                    alertUser("Recovery email sent.")
                }catch{
                    await setError(error)
                }
            }
        }
    }

    func registerUser(){
        if validateFields() {
            Task{
                do{
                    try await Auth.auth().createUser(withEmail: email, password: password)
                    guard let userUID = Auth.auth().currentUser?.uid else {return}
                    let user = User(UID: userUID, email: email, name: name)

                    try Firestore.firestore().collection("Users").document(userUID).setData(from: user)
                }catch{
                    await setError(error)
                }
            }
        }
    }



    func validateFields() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            alertUser("Please enter a valid email.")
            return false
        }


        if loginViewState != .forgotPassword && password.count < 8 {
            alertUser("Please enter a valid password.")
            return false
        }

        if loginViewState == .signUp{
            if password != confirmPassword {
                alertUser("Passwords do not match.")
                return false
            }

            if name.count < 1 || name.count > 20{
                alertUser("Please enter a valid name.")
                return false
            }

        }

        return true
    }

    func alertUser(_ message: String){
        errorMessage = message
        showError.toggle()
    }

    func setError(_ error: Error) async{
        await MainActor.run(body: {
            alertUser(error.localizedDescription)
        })
    }


    
}
