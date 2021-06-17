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

class ImageServiceTest: XCTestCase {
    
    var sut: ImageService!
    var container: Container!

    override func setUpWithError() throws {
        self.container = DIContainer.shared.getContainter()
        container.register(Bool.self, name: "isStub") { resolver in
            return true
        }
        
        container.register(URLSessionType.self, name: "stub") { resolver in
            MockURLSession()
        }
        
        sut = .init()
        XCTAssertNotNil(sut)
    }
    
    func test_이미지_다운로드_Single_url이_nil일때_성공() {
        let expectedResponse = ImageDownloadError.urlError
        
        // when
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
        } catch {
            // then
            // Observable을 catchError 안했을 때, onError로 sequence가 끝날 경우 first() 에서 error throw
            XCTAssertEqual(error as! ImageDownloadError, expectedResponse)
        }
    }
    
    func test() {
        // when
        // self == nil
        let expectedResponse = ImageDownloadError.selfError
        
        do {
            _ = try sut.fetchImage(with: NetworkAPI.baseURLForTest)
                .do(onSubscribe: { [weak self] in
                    self?.sut = nil
                })
                .toBlocking().first()
            XCTFail("catch에서 error 잡아야함.")
        } catch {
            // then
            XCTAssertEqual(expectedResponse, error as! ImageDownloadError)
        }
    }
    
    func test2() {
        let expectedResult = NetworkAPI.sampleDataForTest
        // when
        // 정상 url 
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
