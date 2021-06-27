//
//  RequestTokenResponse.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation

struct RequestTokenResponse: Codable {
    
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
