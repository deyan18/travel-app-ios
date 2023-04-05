//
//  SharedViews.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct customButton: View {
    var title: String
    var backgroundColor: Color
    var foregroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(15.0)
        }
    }
    
    init(title: String, backgroundColor: Color = .white, foregroundColor: Color = .blue, action: @escaping () -> Void) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }
}


func customTextField(title: String, text: Binding<String>, backgroundColor: Color? = Color.gray.opacity(0.7)) -> some View {
    TextField(title, text: text)
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
}


func customSecureField(title: String, text: Binding<String>, backgroundColor: Color? = Color.gray.opacity(0.7)) -> some View {
    SecureField(title, text: text)
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(10)
}

// add more reusable functions here
