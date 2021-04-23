//
//  Test_CounterService.swift
//  GlobalTestTests
//
//  Created by Shayan Mehranpoor on 4/22/21.
//

import XCTest
@testable import GlobalTest

final class CounterServiceTests: XCTestCase {
    
    var sut: CounterService?
    var nextPathJson: Data?
    var responseCodeJson: Data?
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "next-path", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.nextPathJson = data
            } catch {
                
            }
        }
        
        if let path = bundle.path(forResource: "response-code", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.responseCodeJson = data
            } catch {
                
            }
        }
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_getNextPath() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = nextPathJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = CounterService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async next path test")
        var nextPath: NextPath?
        
        // When
        sut?.getNextPath(completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let path):
                nextPath = path
            case .failure:
                XCTFail()
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(nextPath?.path == "http://localhost:8000/34e0a89e-a381-11eb-93a1-acde48001122/")
    }
    
    func test_getResponseCode() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = responseCodeJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = CounterService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async response code test")
        var responseCode: ResponseCode?
        
        // When
        sut?.getResponseCode(nextPath: "http://localhost:8000/34e0a89e-a381-11eb-93a1-acde48001122/", completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let response):
                responseCode = response
            case .failure:
                XCTFail()
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(responseCode?.responseCode == "9c20ca90-6b44-433e-9d4c-bdabe9268bc7")
    }
}
