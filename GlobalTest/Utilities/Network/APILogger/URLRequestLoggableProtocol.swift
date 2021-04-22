//
//  URLRequestLoggableProtocol.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

protocol URLRequestLoggableProtocol {
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, HTTPMethod: String?)
}
