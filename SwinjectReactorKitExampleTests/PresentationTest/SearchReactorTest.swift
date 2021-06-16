//
//  SearchReactorTest.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/16.
//

import Foundation
import Quick
import Nimble
import ReactorKit

@testable import SwinjectReactorKitExample

// Action을 받았을 때 State로 잘 변경되는지 테스트
final class SearchReactorTest: QuickSpec {
    override func spec() {
        describe("seachUser Action이 들어왔을 때") {
            context("서버에서 정상적인 값을 받았을 때") {
                let mockSearchService = MockSearchService()
                let reactor = SearchReactor(searchService: mockSearchService)
                reactor.action.onNext(.searchUser(id: "hansangjin96"))

                it("search state가 정상적으로 바뀐다.") {
                    expect(reactor.currentState.searchResult).to(equal("hansangjin96"))
                    expect(reactor.currentState.searchIDResult).to(equal("57659933"))
                    expect(reactor.currentState.searchAvartarImageData).to(equal(Data("test data".utf8)))
                }
            }
            
            context("Mutation에서 catchError했을 때") {
                let mockSearchService = MockSearchService(isError: true)
                let reactor = SearchReactor(searchService: mockSearchService)
                reactor.action.onNext(.searchUser(id: "hansangjin96"))

                it("search state가 바뀌지 않고 initialState가 나온다.") {
                    expect(reactor.currentState.searchResult).to(equal(reactor.initialState.searchResult))
                    expect(reactor.currentState.searchIDResult).to(equal(reactor.initialState.searchIDResult))
                    expect(reactor.currentState.searchAvartarImageData).to(beNil())
                    
                }
            }
            
            context("서버에서 Nil값을 받았을 때") {
                let mockSearchService = MockSearchService(responseIsNil: true)
                let reactor = SearchReactor(searchService: mockSearchService)
                reactor.action.onNext(.searchUser(id: "hansangjin96"))

                it("search state가 default value로 바뀐다.") {
                    expect(reactor.currentState.searchResult).to(equal("없음"))
                    expect(reactor.currentState.searchIDResult).to(equal("0"))
                    expect(reactor.currentState.searchAvartarImageData).to(equal(Data("test data".utf8)))
                }
            }
        }
    }
}
