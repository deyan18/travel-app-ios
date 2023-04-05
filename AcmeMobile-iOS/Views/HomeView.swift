//
//  HomeView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct HomeView: View {
    @State private var searchOriginText = ""
    @State private var searchDestinationText = ""
    @State private var isCompactOn = false
    @State private var isFiltersOn = false
    @State private var isMapOn = false
    var body: some View {
        ZStack{



            ScrollView(){
                LazyVGrid(columns: isCompactOn ? [GridItem(.adaptive(minimum: 160, maximum: 220))] : [GridItem(.flexible())]) {
                    ForEach(0..<10) { index in
                        tripItem(origin: "Madrid", destination: "Seoul", price: "499€", startDate: "April 5 2023", endDate: "April 20 2023", imageURL: "https://cdn.britannica.com/57/75757-050-122EC2ED/Changgyong-Palace-background-Seoul.jpg")
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
                            //
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
    
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
