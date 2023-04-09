//
//  TripDetailView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI
import MapKit

struct TripDetailView: View {
    @EnvironmentObject var vm: MainViewModel
     var trip: Trip
    @State private var showingPurchaseAlert = false
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
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

                mapView


                Spacer(minLength: 200)
            }.padding(.horizontal)
                .scrollIndicators(.hidden)

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

        }.onAppear{
            setRegion()

        }





        
    }

    func setRegion(){
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trip.originCoordinate.latitude, longitude: trip.originCoordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
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

    var mapView: some View{
        let annotations = [
            TripLocation(name: "Origin", coordinate: trip.originCoordinate),
            TripLocation(name: "Destination", coordinate: trip.destinationCoordinate)

        ]
        return Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotations) {
            MapMarker(coordinate: $0.coordinate, tint: .accentColor)
        }
        .frame( height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 15))

    }
}

struct TripLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
