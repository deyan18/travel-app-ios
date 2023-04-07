//
//  TripModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Trip: Identifiable, Codable{
    @DocumentID var id: String?
    let UID: String
    let origin: String
    let destination: String
    let price: Double
    let startDate: Date
    let endDate: Date
    let description: String
    let imageURL: String

    enum CodingKeys: CodingKey{
        case id
        case UID
        case origin
        case destination
        case price
        case startDate
        case endDate
        case description
        case imageURL
    }
}


