//
//  MockSearchService.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/16.
//

import Foundation
import Moya
import RxSwift

@testable import SwinjectReactorKitExample

final class MockSearchService: SearchServiceType {
    // 이거만 Mock화 하면 됨
    func searchUser(id: String) -> Observable<SearchUserResult> {
        
        if self.isError {
            return Observable.error(ImageDownloadError.dataError)    
        } else if self.responseIsNil {
            return Observable.just(
                SearchUserResult(
                    nickname: nil, 
                    urlData: Data("test data".utf8), 
                    id: nil
                )
            )    
        } else {
            return Observable.just(
                SearchUserResult(
                    nickname: "hansangjin96", 
                    urlData: Data("test data".utf8), 
                    id: 57659933
                )
            )
        }
    }
    
    var provider: MoyaProvider<NetworkAPI> = .init()
    
    let isError: Bool
    let responseIsNil: Bool
    
    init(
        isError: Bool = false,
        responseIsNil: Bool = false
    ) { 
        self.isError = isError
        self.responseIsNil = responseIsNil
    }
    
    init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((NetworkAPI) -> Endpoint)?, imageService: ImageServiceType) {
        self.isError = false
        self.responseIsNil = false
        
    }
}
