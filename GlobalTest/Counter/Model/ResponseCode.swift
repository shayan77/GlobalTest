//
//  ResponseCode.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

struct ResponseCode: Codable {
    let path: String?
    let responseCode: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case responseCode = "response_code"
    }
}
