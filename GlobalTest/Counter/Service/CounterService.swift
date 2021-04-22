//
//  CounterService.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

/*

 This is Product Service, responsible for making api calls of getting products.
 
 */

typealias NextPathCompletionHandler = (Result<NextPath, RequestError>) -> Void
typealias ResponseCodeCompletionHandler = (Result<ResponseCode, RequestError>) -> Void

protocol CounterServiceProtocol {
    func getNextPath(completionHandler: @escaping NextPathCompletionHandler)
    func getResponseCode(nextPath: String, completionHandler: @escaping ResponseCodeCompletionHandler)
}

/*
 ProductsEndpoint is URLPath of Product Api calls
 */

private enum CounterEndpoint {
    
    case nextPath
    case responseCode(String)
    
    var path: String {
        switch self {
        case .nextPath:
            return "http://localhost:8000"
        case .responseCode(let nextPath):
            return nextPath
        }
    }
}

class CounterService: CounterServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: CounterServiceProtocol = CounterService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getNextPath(completionHandler: @escaping NextPathCompletionHandler) {
        self.requestManager.performRequestWith(url: CounterEndpoint.nextPath.path, httpMethod: .get) { (result: Result<NextPath, RequestError>) in
            completionHandler(result)
        }
    }
    
    func getResponseCode(nextPath: String, completionHandler: @escaping ResponseCodeCompletionHandler) {
        self.requestManager.performRequestWith(url: CounterEndpoint.responseCode(nextPath).path, httpMethod: .get) { (result: Result<ResponseCode, RequestError>) in
            completionHandler(result)
        }
    }
}
