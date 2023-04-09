//
//  TripModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation
import FirebaseFirestoreSwift
import MapKit

struct Trip: Identifiable, Codable {
    @DocumentID var id: String?
    let UID: String
    let origin: String
    let destination: String
    let price: Double
    let startDate: Date
    let endDate: Date
    let description: String
    let imageURL: String
    let originCoordinate: CLLocationCoordinate2D
    let destinationCoordinate: CLLocationCoordinate2D

    enum CodingKeys: String, CodingKey {
        case id
        case UID
        case origin
        case destination
        case price
        case startDate
        case endDate
        case description
        case imageURL
        case originCoordinate
        case destinationCoordinate
    }
}

extension CLLocationCoordinate2D: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let latitude = try container.decode(CLLocationDegrees.self)
        let longitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
    }
}


