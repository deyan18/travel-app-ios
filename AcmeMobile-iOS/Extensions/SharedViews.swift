//
//  SharedViews.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

func setPriceFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "es_ES")
    formatter.currencySymbol = "€"
    return formatter
}

let PRICE_FORMATTER = setPriceFormatter()

func formatDate(_ date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"

    return formatter.string(from: date)
}


struct customButton: View {
    var title: String
    var backgroundColor: Color
    var foregroundColor: Color
    var action: () -> Void
    var iconName: String
    
    var body: some View {
        Button(action: action) {
            HStack{
                if title == "Google"{
                    Image("GoogleIcon")
                        .resizable()
                        .frame(width: 20, height: 20)

                }else if iconName != "" {
                        Image(systemName: iconName)
                }
                Text(title == "Google" ? "" : title)

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
        tripImageView(url: trip.imageURL, maxHeight: 200)

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

                Text(PRICE_FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
                    .fontWeight(.bold)

                Image(systemName: "bookmark")
            }

        }

        HStack(alignment: .bottom, spacing: 4) {

            Text(formatDate(trip.startDate))
                .font(isCompactOn.wrappedValue ? .caption: .footnote)
            Text("-")
                .font(.caption)
                .fontWeight(.light)
            Text(formatDate(trip.endDate))
                .font(isCompactOn.wrappedValue ? .caption: .footnote)

            if !isCompactOn.wrappedValue {
                Spacer()
            }

        }

        if isCompactOn.wrappedValue {
            HStack(alignment: .bottom, spacing: 4) {
                Text(PRICE_FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
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

    } placeholder: {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.gray.opacity(0.2))
            .scaledToFill()
            .frame(maxHeight: maxHeight)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                ProgressView()
            }

    }
    .aspectRatio(contentMode: .fill)
    .frame(maxHeight: maxHeight)
    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

}


func profileImageView(url: String, size: CGFloat = 50) -> some View {
    let cornerRadius: CGFloat = 100

    return AsyncImage(url: URL(string: url))
    { image in
        image.resizable()
            .scaledToFill()
            .frame(maxWidth: size, maxHeight: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    } placeholder: {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .scaledToFill()
            .frame(maxWidth: size, maxHeight: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                ProgressView()
            }

    }

}

