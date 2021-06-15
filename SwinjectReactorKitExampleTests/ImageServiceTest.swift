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

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionType {
    
    var makeRequestFail = false
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let successResponse = HTTPURLResponse(
            url: NetworkAPI.baseURLForTest, 
            statusCode: 200, 
            httpVersion: "2", 
            headerFields: nil
        )
        
        let failureResponse = HTTPURLResponse(
            url: NetworkAPI.baseURLForTest, 
            statusCode: 410, 
            httpVersion: "2", 
            headerFields: nil
        )
        
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(NetworkAPI.sampleDataForTest, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

class ImageServiceTest: XCTestCase {
    
    var sut: ImageService!
    var disposeBag: DisposeBag = .init()

    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
        XCTAssertNotNil(sut)
    }
    
    func test_이미지_다운로드_성공() {
        let expectation = XCTestExpectation()
        
        // user sample
//        let response = try? JSONDecoder().decode(User.self, from: NetworkAPI.sampleDataForTest)
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
    func test_이미지_다운로드_실패() {
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
