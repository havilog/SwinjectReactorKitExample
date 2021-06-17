//
//  ImageServiceTest.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/14.
//

import XCTest
import RxSwift
import RxTest
import Nimble
import RxNimble
import Swinject

@testable import SwinjectReactorKitExample

class URLSessionTest: XCTestCase {
    
    var sut: ImageService!
    var container: Container!
    
    override func setUpWithError() throws {
        self.container = DIContainer.shared.getContainter()
        container.register(Bool.self, name: "isStub") { resolver in
            return true
        }
    }

    func test_네트워크_통신_성공_200_sampleData() {

        container.register(URLSessionType.self, name: "stub") { resolver in
            MockURLSession()
        }
        
        sut = .init()
        
        let expectation = XCTestExpectation()
        
        let response = NetworkAPI.sampleDataForTest
        
        sut.fetchData(url: NetworkAPI.baseURLForTest) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, response)
                
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_네트워크_통신_실패_410_statusError() {
        container.register(URLSessionType.self, name: "stub") { resolver in
            MockURLSession(makeRequestFail: true)
        }
        
        sut = .init()
        
        let expectation = XCTestExpectation()
        
        let expectedError = ImageDownloadError.statusError
        
        sut.fetchData(url: NetworkAPI.baseURLForTest) { result in
            switch result {
            case .success:
                XCTFail()
                
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
}
