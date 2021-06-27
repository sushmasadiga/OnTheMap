//
//  LogInRequest.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation

struct LoginRequest: Encodable {
    let udacity: UdacityUsernamePassword
}
    
struct UdacityUsernamePassword: Encodable {
    let username: String
    let password: String
}
