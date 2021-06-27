//
//  GetPublicUserDataResponse.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation

struct GetPublicUserDataResponse: Codable {
    let user: User
}
    struct User: Codable {
        let firstName: String
        let lastName: String
        
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
        }
    }
