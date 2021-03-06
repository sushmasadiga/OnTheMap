//
//  GetStudentLocation.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation

struct GetStudentLocationResponse: Codable {
    let results: [Student]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
