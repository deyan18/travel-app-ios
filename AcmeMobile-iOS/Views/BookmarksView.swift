//
//  BookmarksView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var vm: MainViewModel

    var body: some View {
        NavigationStack {
            tripsList
                .navigationTitle("Bookmarks")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    var tripsList: some View {
        ScrollView {
            ForEach(vm.trips) { trip in
                if vm.currentUser?.bookmarkedTrips.contains(trip.UID) ?? false {
                    NavigationLink(destination: TripDetailView(trip: trip)) {
                        tripItem(trip: trip)
                            .frame(maxWidth: 600)
                    }
                    .accentColor(.primary)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
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
