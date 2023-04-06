//
//  TripDetailView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct TripDetailView: View {
     var trip: Trip
    
    var body: some View {
        ZStack{


            ScrollView{
                AsyncImage(url: URL(string: trip.imageURL))
                { image in
                    image.resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))

                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 250)

                } placeholder: {

                    RoundedRectangle(cornerRadius: 15, style: .continuous)

                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .overlay {
                            ProgressView()
                        }

                }


                HStack(alignment: .bottom, spacing: 4) {
                    Text(trip.origin)
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("to")
                        .font(.body)
                        .fontWeight(.light)
                        .padding(.bottom, 1)
                    Text(trip.destination)
                        .font(.title2)
                        .fontWeight(.medium)

                }

                HStack(alignment: .bottom, spacing: 4) {

                    Text(trip.startDate)
                        .font(.footnote)
                    Text("-")
                        .font(.caption)
                        .fontWeight(.light)
                    Text(trip.endDate)
                        .font(.footnote)
                }

                Image(systemName: "bookmark")
                    .font(.title2)
                    .padding(.top, 3)


                HStack{
                    Text("Description")
                        .font(.footnote)
                        .fontWeight(.medium)
                    Spacer()
                }

                Divider()
                Text(trip.description)
                    .font(.footnote)

                Spacer()
            }.padding(.horizontal)

            VStack{
                Spacer()
                HStack(spacing: 15){
                    Spacer()
                    Text(FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
                        .fontWeight(.bold)

                    customButton(title: "Purchase", backgroundColor: .accentColor, foregroundColor: .white, iconName: "cart") {
                        //
                    }
                    .frame(maxWidth: 200)
                    Spacer()
                }
                .padding(.top, 20)
                .background(.thinMaterial)
            }

        }





        
    }
}
