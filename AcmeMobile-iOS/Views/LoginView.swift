//
//  LoginView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

enum LoginViewState {
    case logIn
    case signUp
    case forgotPassword
}

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignUp = false
    @State private var loginViewState: LoginViewState = .logIn
    private var textFieldBgColor = Color.white.opacity(0.7)
    
    
    var body: some View {
        ZStack{
            
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(loginViewState == .logIn ? "Log In" : loginViewState == .signUp ? "Register" : "Forgot Password")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                customTextField(title: "Email", text: $email, backgroundColor: textFieldBgColor)
                
                switch loginViewState {
                case .logIn:
                    customTextField(title: "Password", text: $password, backgroundColor: textFieldBgColor)
                    forgotPassword
                    customButton(title: "Log In") {
                        // Perform login action
                    }
                case .signUp:
                    customTextField(title: "Password", text: $password, backgroundColor: textFieldBgColor)
                    customTextField(title: "Confirm Password", text: $confirmPassword, backgroundColor: textFieldBgColor)
                    customButton(title: "Sign Up") {
                        // Perform login action
                    }
                case .forgotPassword:
                    customButton(title: "Send Email") {
                        // Perform login action
                    }
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
