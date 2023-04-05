//
//  LoginView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Log In")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                
                
                Button(action: {
                    // Handle forgot password action
                }) {
                    Text("Forgot your password?")
                        .foregroundColor(.white)
                        .underline()
                }.padding(.bottom, 20)
                
                
                
                
                Button(action: {
                    // Perform login action
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15.0)
                }
                
                
                
                HStack{
                    Button(action: {
                        // Perform login action
                    }) {
                        Text("Google")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15.0)
                    }
                    Button(action: {
                        // Perform login action
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15.0)
                    }
                }
                .padding(.top, 40)
                
                
                
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
