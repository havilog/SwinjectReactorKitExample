//
//  NetworkRepositoryTesty.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/17.
//

import Foundation

import Quick
import Nimble
import RxSwift
import RxNimble
import Moya

@testable import SwinjectReactorKitExample

class NetworkRepositoryTest: QuickSpec {
    override func spec() {
        describe("네트워크가 정상이고") {
            var repo: NetworkRepositoryType!
            var result: User!
            context("유저를 검색해서 정상 결과를 받으면") {
                beforeEach {
                    repo = NetworkRepository(isStub: true)
                    result = try! repo.fetch(endpoint: .searchUser(query: ""), for: User.self).toBlocking().first()
                }
                it("샘플데이터와 같은 User를 받는다.") { 
                    
                    let encoded = try! JSONEncoder().encode(result)
                    let expected = NetworkAPI.searchUser(query: "").sampleData
                    
                    expect(encoded).to(equal(expected))
                }
            }
            
            context("response가 successful status code 범위를 벗어나면") {
                beforeEach {
                    repo = NetworkRepository(isStub: true, sampleStatusCode: 404)
                }
                it("MoyaError가 나온다.") {
                    do {
                        result = try repo.fetch(endpoint: .searchUser(query: ""), for: User.self).toBlocking().first()
                        XCTFail()
                    } catch {
                        let expected = error as! MoyaError
                        expect(expected.response!.statusCode).to(equal(404))
                    }
                }
            }
        }
    }
}
