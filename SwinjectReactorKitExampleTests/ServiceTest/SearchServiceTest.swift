//
//  SearchServiceTest.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/16.
//

import XCTest
import Quick
import Nimble
import Moya

@testable import SwinjectReactorKitExample

class SearchServiceTest: QuickSpec {
    
    override func spec() {    
        // given: 설명하려는 동작
        describe("SearchService searchUser 했을 때") {
            
            // when: 해당 동작
            context("잘못된 입력이면") {
                var sut: SearchService!
                var result: SearchUserResult!
                
                beforeEach {
                    let imageServiceMock = MockImageService(makeRequestFail: true)
                    // sut: system under test
                    sut = SearchService(
                        isStub: true,
                        imageService: imageServiceMock
                    )
                    result = try! sut.searchUser(id: "Hansangjin96")
                        .toBlocking()
                        .first()
                }
                
                // then: 발생할 것으로 예상되는 동작
                it("에러가 나온다.") {
                    let expectedResult = SearchUserResult(nickname: "hansangjin96", urlData: nil, id: 57659933)
                    expect(result).to(equal(expectedResult))
                }
            }
            
            // when: 해당 동작
            context("정상적이면(?)") {
                var sut: SearchService!
                var result: SearchUserResult!
                
                beforeEach {
                    let imageServiceMock = MockImageService()
                    // sut: system under test
                    sut = SearchService(
                        isStub: true,
                        imageService: imageServiceMock
                    )
                    result = try! sut.searchUser(id: "Hansangjin96")
                        .toBlocking()
                        .first()
                }
                
                // then: 발생할 것으로 예상되는 동작
                it("SearchUserResult가 나온다.") {
                    let expectedResult = SearchUserResult(nickname: "hansangjin96", urlData: Data("test".utf8), id: 57659933)
                    expect(result).to(equal(expectedResult))
                }
            }
        }
    }
}
