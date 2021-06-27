//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation

struct OTMResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
