//
//  UserModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var UID: String
    var email: String
    var name: String
    var pfpURL: String

    enum CodingKeys: CodingKey{
        case id
        case UID
        case email
        case name
        case pfpURL
    }
}
