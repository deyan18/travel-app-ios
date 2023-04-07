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
    var iconName: String
    
    var body: some View {
        Button(action: action) {
            HStack{
                if iconName != ""{
                    Image(systemName: iconName)
                }
                Text(title)
            }
                .font(.headline)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(15.0)
        }
    }
    
    init(title: String, backgroundColor: Color = .white, foregroundColor: Color = .blue,iconName: String = "", action: @escaping () -> Void ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
        self.iconName = iconName
    }
}


func customTextField(title: String, text: Binding<String>, isLowerCase: Bool = false, backgroundColor: Color? = Color.gray.opacity(0.7)) -> some View {
    TextField(title, text: text)
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .autocapitalization(isLowerCase ? .none : .words )
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

func tripItem(trip: Trip, isCompactOn: Binding<Bool>) -> some View {
    VStack{
        AsyncImage(url: URL(string: trip.imageURL))
        { image in
            image.resizable()
        } placeholder: {

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    ProgressView()
                }

        }
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))

        HStack(alignment: .bottom, spacing: 4) {
            Text(trip.origin)
                .font(.callout)
            Text("to")
                .font(.caption)
                .fontWeight(.light)
            Text(trip.destination)
                .font(.callout)

            if !isCompactOn.wrappedValue {
                Spacer()

                Text(FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
                    .fontWeight(.bold)

                Image(systemName: "bookmark")
            }

        }

        HStack(alignment: .bottom, spacing: 4) {

            Text(trip.startDate)
                .font(isCompactOn.wrappedValue ? .caption: .footnote)
            Text("-")
                .font(.caption)
                .fontWeight(.light)
            Text(trip.endDate)
                .font(isCompactOn.wrappedValue ? .caption: .footnote)

            if !isCompactOn.wrappedValue {
                Spacer()
            }

        }

        if isCompactOn.wrappedValue {
            HStack(alignment: .bottom, spacing: 4) {
                Text(FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
                    .fontWeight(.bold)

                Image(systemName: "bookmark")
            }
        }


    }
}


struct UploadImageButton: View {
    @State var showImagePicker = false
    @Binding var image: UIImage
    var url = ""

    var body: some View {
        Button {
            showImagePicker.toggle()
        } label: {
            if url == "" {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .background(Image(systemName: "camera.fill").foregroundColor(.primary))
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 100))

            } else {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .background(Image(systemName: "camera.fill").foregroundColor(.primary))
                    .background(
                        AsyncImage(url: URL(string: url))
                        { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
    }
}

func tripImageView(url: String, cornerRadius: CGFloat = 15, maxHeight: CGFloat = 250) -> some View {
    AsyncImage(url: URL(string: url))
    { image in
        image.resizable()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: maxHeight)
    } placeholder: {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: maxHeight)
            .overlay {
                ProgressView()
            }

    }

}


func profileImageView(url: String, size: CGFloat = 50) -> some View {
    var cornerRadius: CGFloat = 100

    return AsyncImage(url: URL(string: url))
    { image in
        image.resizable()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
    } placeholder: {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .overlay {
                ProgressView()
            }

    }

}
