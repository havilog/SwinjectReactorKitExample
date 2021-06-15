//
//  MockURLSession.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 홍경표 on 2021/06/15.
//

@testable import SwinjectReactorKitExample
import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = { }
    
    override func resume() {
        resumeDidCall()
    }
    
    override func cancel() {
        print("MockURLSessionDataTask Cancelled!")
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
