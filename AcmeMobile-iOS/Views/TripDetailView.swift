//
//  TripDetailView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct TripDetailView: View {
    @EnvironmentObject var vm: MainViewModel
     var trip: Trip
    @State private var showingPurchaseAlert = false
    
    var body: some View {
        ZStack{
            ScrollView{
                tripImageView(url: trip.imageURL)

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

                    Text(formatDate(trip.startDate))
                        .font(.footnote)
                    Text("-")
                        .font(.caption)
                        .fontWeight(.light)
                    Text(formatDate(trip.endDate))
                        .font(.footnote)
                }

                bookmarkButton


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
                    Text(PRICE_FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
                        .fontWeight(.bold)

                    customButton(title: vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false ? "Trip Purchased" : "Purchase", backgroundColor: .accentColor, foregroundColor: .white, iconName: "cart"){
                        showingPurchaseAlert.toggle()
                    }
                            .disabled(vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false)
                            .frame(maxWidth: 200)
                            .alert(isPresented: $showingPurchaseAlert) {
                                Alert(
                                    title: Text("Purchase trip?"),
                                    message: Text("Are you sure you want to purchase this trip for \(PRICE_FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")"),
                                    primaryButton: .default(Text("Purchase")) {
                                        vm.purchaseTrip(tripID: trip.UID)
                                    },
                                    secondaryButton: .cancel()
                                )
                            }


                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(.thinMaterial)
            }

        }





        
    }

    var bookmarkButton: some View{
        Image(systemName: vm.currentUser?.bookmarkedTrips.contains(trip.UID) ?? false ? "bookmark.fill" : "bookmark")
            .font(.title2)
            .padding(.top, 3)
            .onTapGesture {
                print("tap on bookmark")
                vm.bookmarkTrip(tripID: trip.UID)
            }
    }
}
