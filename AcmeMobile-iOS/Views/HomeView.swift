//
//  HomeView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI
import MultiSlider

struct HomeView: View {
    @EnvironmentObject var vm: MainViewModel

    @State private var searchOriginText = ""
    @State private var searchDestinationText = ""
    @State private var isCompactOn = false
    @State private var isFiltersOn = false
    @State private var isMapOn = false
    @State private var showFiltersSheet = false
    @State private var startDate = Date.now
    @State private var endDate = Date.now
    @State private var minPrice = 0.0
    @State private var maxPrice = 0.0
    @State private var valueArray: [CGFloat] = [1.0, 2.0]

    var body: some View {
        NavigationStack{
        ZStack{
            ScrollView(){
                LazyVGrid(columns: isCompactOn ? [GridItem(.adaptive(minimum: 160, maximum: 220))] : [GridItem(.flexible())]) {

                    ForEach(vm.trips) { trip in
                        NavigationLink(destination: TripDetailView(trip: trip)) {
                            tripItem(trip: trip, isCompactOn: $isCompactOn)
                        }
                        .accentColor(.black)

                        }
                }
                .padding(.top, 100)

            }.scrollIndicators(.hidden)
                .padding(.horizontal)

            VStack{
                VStack{
                    //customTitle(text: "Explore Trips", foregroundColor: .black.opacity(0.8))
                    HStack {
                        searchBar(text: $searchOriginText, hint: "Origin") {
                        }
                        searchBar(text: $searchDestinationText, hint: "Destination") {
                        }
                    }
                    HStack{
                        filterButton(title: "Filters", icon: "slider.horizontal.3", isOn: $isFiltersOn) {
                            showFiltersSheet = true
                        }
                        filterButton(title: "Compact View", icon: "rectangle.split.3x1", isOn: $isCompactOn) {
                            withAnimation {
                                isCompactOn.toggle()
                            }

                        }
                        filterButton(title: "Map", icon: "map", isOn: $isMapOn) {
                            //
                        }
                    }


                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .background(.thinMaterial)
                Spacer()
            }

        }
        .sheet(isPresented: $showFiltersSheet) {
            FiltersSheetView
                .presentationDetents([.fraction(0.45)])
                .presentationDragIndicator(.visible)
        }
        }
        
    }

    var FiltersSheetView: some View{
        VStack{
            Text("Filters")
                .font(.title2)
                .fontDesign(.rounded)
                .fontWeight(.medium)
            DatePicker(selection: $startDate, in: Date.now..., displayedComponents: .date) {
                Text("Start date: ")
            }
            DatePicker(selection: $endDate, in: startDate..., displayedComponents: .date) {
                Text("End date: ")
            }

            HStack{
                Text("Price range: ")
                MultiValueSlider(value: $valueArray, minimumValue: 1, maximumValue: 5, snapStepSize: 1.0, valueLabelPosition: .top, orientation: .horizontal, outerTrackColor: UIColor(Color.gray), valueLabelFormatter: PRICE_FORMATTER)
                    .frame(height: 100)
            }

            HStack{
                customButton(title: "Remove", backgroundColor: .red, foregroundColor: .white) {
                    //
                }
                customButton(title: "Save", backgroundColor: .accentColor, foregroundColor: .white) {
                    //
                }
            }


        }.padding()
    }
    
    func searchBar(text: Binding<String>, hint: String = "Search", onSearchTapped: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            TextField(hint, text: text)
                .padding(.horizontal, 8)

            if !text.wrappedValue.isEmpty {
                Button(action: {
                    text.wrappedValue = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                })
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    func filterButton(title: String, icon: String, isOn: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack{
                Image(systemName: icon)
                Text(title)
            }
            .font(.footnote)
            .foregroundColor(isOn.wrappedValue ? .white : .black)
            .padding(9)
            .background(isOn.wrappedValue ? Color.accentColor : Color.gray.opacity(0.2))
            .cornerRadius(15.0)
        }
    }

    func tripItem(trip: Trip, isCompactOn: Binding<Bool> = Binding.constant(false)) -> some View {

        var bookmarkButton: some View{
            Image(systemName: vm.currentUser?.bookmarkedTrips.contains(trip.UID) ?? false ? "bookmark.fill" : "bookmark")
                .onTapGesture {
                    vm.bookmarkTrip(tripID: trip.UID)
                }
        }

        return VStack{
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

                    bookmarkButton
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

                    bookmarkButton
                }
            }


        }


    }
    
    
}


struct PriceRangeSlider: View {
    @Binding var lowerValue: Double
    @Binding var upperValue: Double

    var body: some View {
        VStack {
            Text(String(format: "%.2f € - %.2f €", lowerValue, upperValue))
                .foregroundColor(.gray)

            Slider(
                value: Binding(
                    get: { self.lowerValue },
                    set: {
                        if $0 < self.upperValue {
                            self.lowerValue = $0
                        }
                    }
                ),
                in: 0...1000,
                step: 1
            )
            .accentColor(.green)
            .padding(.horizontal)

            Slider(
                value: Binding(
                    get: { self.upperValue },
                    set: {
                        if $0 > self.lowerValue {
                            self.upperValue = $0
                        }
                    }
                ),
                in: 0...1000,
                step: 1
            )
            .accentColor(.green)
            .padding(.horizontal)
        }
    }



}

