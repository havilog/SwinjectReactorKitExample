//
//  MockNetworkRepository.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/17.
//

import Foundation
import Moya
import RxSwift

@testable import SwinjectReactorKitExample

//class MockNetworkRepository: NetworkRepositoryType {
//    var provider: MoyaProvider<NetworkAPI>
//
//    required init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((NetworkAPI) -> Endpoint)?) {
//        self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
//    }
//    
//    func fetch<Model>(endpoint: NetworkAPI, for type: Model.Type) -> Single<Model> where Model : Decodable {
//        return .create { observer in
//            observer(.success())
//            return Disposables.create()
//        }
//        self.provider.rx.request(.searchUser(query: "hansangjin96"))
//    }
//}
