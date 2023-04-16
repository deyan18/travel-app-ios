//
//  ProfileView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var triggerNavigation = false
    @State private var openSettings = false
    var body: some View {
        NavigationStack {
            ZStack {
                tripsList
                profileHeading
            }
        }
    }

    var profileHeading: some View {
        VStack {
            VStack {
                profileImageView(url: vm.currentUser?.pfpURL ?? "", size: 80)
                    .onTapGesture(count: 3) {
                        vm.devMode.toggle()
                        vm.alertUser(vm.devMode ? "Developer mode activated" : "Developer mode deactivated")
                    }
                Text(vm.currentUser?.name ?? "")
                    .font(.headline)
                settingsButton
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
            .background(.thinMaterial)
            Spacer()
        }
    }

    var tripsList: some View {
        ScrollView {
            Spacer()
                .frame(height: 170)
            ForEach(vm.trips) { trip in
                if vm.currentUser?.purchasedTrips.contains(trip.UID) ?? false {
                    NavigationLink(destination: TripDetailView(trip: trip)) {
                        tripItem(trip: trip)
                    }
                    .accentColor(.primary)
                }
            }
            Spacer()
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
    }

    var settingsButton: some View {
        NavigationLink {
            SettingsView()
        } label: {
            HStack {
                Image(systemName: "gear")
                Text("Settings")
            }
            .padding(6)
            .font(.footnote)
            .fontWeight(.medium)
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.3)))
        }.foregroundColor(.primary)
    }

    func tripItem(trip: Trip) -> some View {
        var bookmarkButton: some View {
            Image(systemName: vm.currentUser?.bookmarkedTrips.contains(trip.UID) ?? false ? "bookmark.fill" : "bookmark")
                .onTapGesture {
                    vm.bookmarkTrip(tripID: trip.UID)
                }
        }

        return VStack {
            tripImageView(url: trip.imageURL, maxHeight: 200)

            HStack(alignment: .bottom, spacing: 4) {
                Text(trip.origin)
                    .font(.callout)
                Text("to")
                    .font(.caption)
                    .fontWeight(.light)
                Text(trip.destination)
                    .font(.callout)

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
}
