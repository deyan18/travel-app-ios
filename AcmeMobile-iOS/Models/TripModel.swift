//
//  TripModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation

struct Trip: Identifiable {
    let id = UUID()
    let origin: String
    let destination: String
    let price: Double
    let startDate: String
    let endDate: String
    let description: String
    let imageURL: String
}
