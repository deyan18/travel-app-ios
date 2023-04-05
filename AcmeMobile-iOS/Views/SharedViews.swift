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

func customTitle(text: String, foregroundColor: Color = .black) -> some View {
    Text(text)
        .font(.largeTitle)
        .fontDesign(.rounded)
        .foregroundColor(foregroundColor)
        .fontWeight(.bold)

}

func tripItem(origin: String, destination: String, price: String, startDate: String, endDate: String, imageURL: String) -> some View {
    VStack{
        AsyncImage(url: URL(string: imageURL))
        { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))

        HStack(alignment: .bottom, spacing: 4) {
            Text(origin)
                .font(.callout)
            Text("to")
                .font(.caption)
                .fontWeight(.light)
            Text(destination)
                .font(.callout)
            Spacer()

            Text(price)
                .fontWeight(.bold)

            Image(systemName: "bookmark")
        }

        HStack(alignment: .bottom, spacing: 4) {

            Text(startDate)
                .font(.footnote)
            Text("-")
                .font(.caption)
                .fontWeight(.light)
            Text(endDate)
                .font(.footnote)

            Spacer()
        }
    }
}


