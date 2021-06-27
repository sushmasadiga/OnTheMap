//
//  CreateStudentResponse.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation

struct CreateStudentResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
