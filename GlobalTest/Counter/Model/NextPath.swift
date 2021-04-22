//
//  NextPath.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

struct NextPath: Codable {
    let path: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "next_path"
    }
}
