//
//  CounterViewModel.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation
import RxSwift
import RxCocoa

final class CounterViewModel {
        
    enum CounterError {
        
        case networkError(RequestError)
        case tooManyRequestError
        
        var errorValue: String {
            switch self {
            case .networkError(let error):
                return error.localizedDescription
            case .tooManyRequestError:
                return "Too Many Request"
            }
        }
    }
    
    public var savedResponseCode: String {
        return DataManager.shared.responseCode
    }
    
    public var savedCounter: Int {
        return DataManager.shared.counter
    }
    
    private var counterService: CounterServiceProtocol
    private var nextPath: String?
    
    init(counterService: CounterServiceProtocol) {
        self.counterService = counterService
    }
    
    public let successResponse: PublishSubject<(model: ResponseCode, counter: Int)> = PublishSubject()
    public let errorResponse: PublishSubject<CounterError> = PublishSubject()
    
    private let dispatchQueue = DispatchQueue(label: "Globaltest.apiSerial.queue", qos: .background)
    private let semaphore = DispatchSemaphore(value: 0)
    
    public func fetchContent() {
        dispatchQueue.async {
            self.getNextPath()
            self.semaphore.wait()
            self.getResponseCode()
        }
    }
    
    private func getNextPath() {
        counterService.getNextPath() { [weak self] result in
            guard let self = self else { return }
            self.semaphore.signal()
            switch result {
            case .success(let nextPath):
                self.nextPath = nextPath.path ?? ""
            case .failure(let requestError):
                self.errorResponse.onNext(.networkError(requestError))
            }
        }
    }
    
    private func getResponseCode() {
        guard let nextPath = self.nextPath else { return }
        counterService.getResponseCode(nextPath: nextPath) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let responseCode):
                DataManager.shared.counter += 1
                DataManager.shared.responseCode = responseCode.responseCode ?? ""
                self.successResponse.onNext((model: responseCode, counter: DataManager.shared.counter))
            case .failure(let requestError):
                self.errorResponse.onNext(.networkError(requestError))
            }
        }
    }
}
