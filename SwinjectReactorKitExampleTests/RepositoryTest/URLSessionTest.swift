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

@testable import SwinjectReactorKitExample

class URLSessionTest: XCTestCase {
    
    var sut: ImageService!
    var disposeBag: DisposeBag = .init()

    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
        XCTAssertNotNil(sut)
    }
    
    func 테스트_네트워크_통신_성공_200_sampleData() {
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
    
    func 테스트_네트워크_통신_실패_410_statusError() {
        sut = .init(session: MockURLSession(makeRequestFail: true))
        
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
