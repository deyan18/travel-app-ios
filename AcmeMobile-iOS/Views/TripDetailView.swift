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
    @State private var weather: WeatherModel?

    
    var body: some View {
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
                Spacer()
                Text(PRICE_FORMATTER.string(from: NSNumber(value: trip.price)) ?? "")
                    .fontWeight(.bold)
                bookmarkButton
            }

            HStack(alignment: .bottom, spacing: 4) {

                Text(formatDate(trip.startDate))
                    .font(.footnote)
                Text("-")
                    .font(.caption)
                    .fontWeight(.light)
                Text(formatDate(trip.endDate))
                    .font(.footnote)
                Spacer()
            }


            customButton(title: vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false ? "Trip Purchased" : "Purchase", backgroundColor: .accentColor, foregroundColor: .white, iconName: "cart"){
                showingPurchaseAlert.toggle()
            }
            .disabled(vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false)
            .padding(.horizontal,40)
            .padding(.top, 10)
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








            HStack{
                Text("Trip details")
                    .font(.footnote)
                    .fontWeight(.medium)
                Spacer()
            }.padding(.top)

            Divider()
            Text(trip.description)
                .font(.footnote)


            weatherView
                .padding(.vertical)

            mapView
                .padding(.bottom)

        }.padding(.horizontal)
            .scrollIndicators(.hidden)
            .onAppear{
                Task{
                    weather = await getWeather(location: trip.destinationCoordinate)

                }
                setRegion()

            }
    }

    func setRegion(){
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trip.originCoordinate.latitude, longitude: trip.originCoordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }

    var weatherView: some View{
        VStack {
            if weather != nil{

                HStack {
                    if let url = weather!.iconURL {
                        AsyncImage(url: url) { image in
                            image
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(weather!.city)
                            .font(.title2)
                        Text(weather!.currentTemperature)
                            .font(.system(size: 50))
                            .foregroundColor(.primary)
                        Text(weather!.weather.description)
                            .font(.headline)


                    }

                }
                HStack(spacing: 14) {
                    Label(weather!.maxTemperature, systemImage: "thermometer.sun.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .red)
                    Label(weather!.minTemperature, systemImage: "thermometer.snowflake")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .blue)
                    Label(weather!.humidity, systemImage: "humidity.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .blue)
                }

                Spacer()
            }
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var bookmarkButton: some View{
        Image(systemName: vm.currentUser?.bookmarkedTrips.contains(trip.UID) ?? false ? "bookmark.fill" : "bookmark")
            .font(.title3)
            .padding(.top, 3)
            .onTapGesture {
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
