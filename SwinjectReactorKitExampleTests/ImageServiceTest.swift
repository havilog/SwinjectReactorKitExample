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

class ImageServiceTest: XCTestCase {
    
    var sut: ImageService!
    var disposeBag: DisposeBag = .init()

    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
        XCTAssertNotNil(sut)
    }
    
    func test_이미지_다운로드_성공() {
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
    
    func test_이미지_다운로드_Single_성공() {
        var expectedResponse = ImageDownloadError.urlError
        
        // given
        // url == nil
        do {
            _ = try sut.fetchImage(with: nil)
//                .catchError { error in
//                    print("catchedERRR")
//                    XCTAssertEqual(error as! ImageDownloadError, expectedResponse)
//                    return .just(nil)
//                }
                .toBlocking()
                .first()
            XCTFail("catch에서 error 잡아야함.")
        } catch { // Observable을 catchError 안했을 때, onError로 sequence가 끝날 경우 first() 에서 error throw
            XCTAssertEqual(error as! ImageDownloadError, expectedResponse)
        }

        // given
        // self == nil
        expectedResponse = .selfError
        do {
            _ = try sut.fetchImage(with: NetworkAPI.baseURLForTest)
                .do(onSubscribe: { [weak self] in
                    self?.sut = nil
                })
                .toBlocking().first()
            XCTFail("catch에서 error 잡아야함.")
        } catch {
            XCTAssertEqual(expectedResponse, error as! ImageDownloadError)
        }
        
        let expectedResult = NetworkAPI.sampleDataForTest
        // 정상 url
        sut = .init(session: MockURLSession())
        do {
            let result = try sut.fetchImage(with: NetworkAPI.baseURLForTest)
                .toBlocking().first()
            
            // then
            XCTAssertEqual(expectedResult, result)
        } catch {
            XCTFail("try 문에서 error throw하면 안됨")
        }
    }
    
}

// MARK: 연습용

extension ImageServiceTest {
    
    func test_RxTest_연습1() {
        let someObservable = Observable.of(10, 20, 30)
        let result = try! someObservable.toBlocking().first()
        XCTAssertEqual(result, 10)
        
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        let intObservable = Observable.of(10, 20, 30)
            .map { $0 * 2 }
            .subscribeOn(scheduler)
        do {
            let result = try intObservable.observeOn(MainScheduler.instance).toBlocking().toArray()
            XCTAssertEqual(result, [20, 40, 60])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_RxTest_연습2() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let xs = scheduler.createHotObservable([
            Recorded.next(150, 1),
            Recorded.next(210, 0),
            Recorded.next(220, 1),
            Recorded.next(230, 2),
            Recorded.next(240, 4),
            Recorded.completed(300)
        ])
        
        let res = scheduler.start { xs.map { $0 * 2 } }
        
        let correctMessages = [
            Recorded.next(210, 0 * 2),
            Recorded.next(220, 1 * 2),
            Recorded.next(230, 2 * 2),
            Recorded.next(240, 4 * 2),
            Recorded.completed(300)
        ]
        
        let correctSubscriptions = [
            Subscription(200, 300)
        ]
        
        XCTAssertEqual(res.events, correctMessages)
        XCTAssertEqual(xs.subscriptions, correctSubscriptions)
    }
    
    
}
