//
//  ResponseValidator.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

struct GlobalResponseValidator: ResponseValidatorProtocol {
    
    func validation<T: Codable>(response: HTTPURLResponse?, data: Data?) -> (Result<T, RequestError>) {
        guard let response = response, let data = data else {
            return .failure(RequestError.connectionError)
        }
        switch response.statusCode {
        case 200:
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                return .success(model)
            } catch {
                print("JSON Parse Error")
                print(error)
                return .failure(.jsonParseError)
            }
        case 404:
            do {
                let model = try JSONDecoder().decode(NotFoundErrorModel.self, from: data)
                return .failure(.notFound(model.error ?? ""))
            } catch {
                return .failure(.notFound("Error 404"))
            }
        case 400...499:
            return .failure(RequestError.authorizationError)
        case 500...599:
            return .failure(.serverUnavailable)
        default:
            return .failure(RequestError.connectionError)
        }
    }
}
