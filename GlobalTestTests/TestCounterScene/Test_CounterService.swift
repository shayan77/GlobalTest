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
    var path: String?
    
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
        let expectation = XCTestExpectation(description: "Async products test")
        var nextPath: NextPath?
        
        // When
        sut?.getNextPath(completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let path):
                nextPath = path
                self.path = path.path ?? ""
            case .failure:
                XCTFail()
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(nextPath?.path == "")
    }
    
    func test_getCategories() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = responseCodeJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = CounterService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async categories test")
        var responseCode: ResponseCode?
        
        // When
        sut?.getResponseCode(nextPath: self.path ?? "", completionHandler: { (result) in
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
        XCTAssertTrue(responseCode?.responseCode == "124136724")
    }
}
