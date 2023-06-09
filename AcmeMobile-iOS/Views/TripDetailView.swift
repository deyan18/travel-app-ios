//
//  TripDetailView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import MapKit
import SwiftUI

struct TripDetailView: View {
    @EnvironmentObject var vm: MainViewModel
    var trip: Trip
    @State private var showingPurchaseAlert = false
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var weather: WeatherModel?

    var body: some View {
        ScrollView {
            tripImageView(url: trip.imageURL)
            tripHeading
            tripButton
            tripDescription

            weatherView
                .padding(.vertical)

            mapView
                .padding(.bottom)

        }
        .frame(maxWidth: 600)
        .padding(.horizontal)
            .scrollIndicators(.hidden)
            .onAppear {
                Task {
                    weather = await getWeather(location: trip.destinationCoordinate)
                }
                setRegion()
            }
    }

    var tripDescription: some View {
        VStack {
            HStack {
                Text("Trip details")
                    .font(.footnote)
                    .fontWeight(.medium)
                Spacer()
            }.padding(.top)

            Divider()
            Text(trip.description)
                .font(.footnote)
        }
    }

    var tripButton: some View {
        customButton(title: vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false ? "Trip Purchased" : (trip.startDate < Date.now ? "Trip not available" : "Purchase"), backgroundColor: .accentColor, foregroundColor: .white, iconName: "cart") {
            showingPurchaseAlert.toggle()
        }
        .disabled((vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false) || trip.startDate < Date.now)
        .padding(.horizontal, 40)
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
    }

    var tripHeading: some View {
        VStack {
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
        }
    }

    func setRegion() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: trip.destinationCoordinate.latitude, longitude: trip.destinationCoordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }

    var weatherView: some View {
        VStack {
            if weather != nil {
                HStack {
                    if let url = weather!.iconURL {
                        AsyncImage(url: url) { image in
                            image
                                .shadow(color: .gray, radius: 5)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    VStack(alignment: .leading) {
                        Text(trip.destination)
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
                        .foregroundStyle(.primary, .red)
                    Label(weather!.minTemperature, systemImage: "thermometer.snowflake")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.primary, .blue)
                    Label(weather!.humidity, systemImage: "humidity.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.primary, .blue)
                }

                Spacer()
            }
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var bookmarkButton: some View {
        Image(systemName: vm.currentUser?.bookmarkedTrips.contains(trip.UID) ?? false ? "bookmark.fill" : "bookmark")
            .font(.title3)
            .padding(.top, 3)
            .onTapGesture {
                vm.bookmarkTrip(tripID: trip.UID)
            }
    }

    var mapView: some View {
        let annotations = [
            TripLocation(name: "Origin", coordinate: trip.originCoordinate),
            TripLocation(name: "Destination", coordinate: trip.destinationCoordinate),
        ]
        return Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotations) {
            MapMarker(coordinate: $0.coordinate, tint: .accentColor)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct TripLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
