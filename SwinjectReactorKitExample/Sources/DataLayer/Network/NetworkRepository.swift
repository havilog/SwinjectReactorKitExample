//
//  MoyaProvider.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/16.
//

import Foundation

import RxSwift
import Moya

protocol NetworkRepositoryType {
    // Moya를 위한 protocol
//    associatedtype T: TargetType
    var provider: MoyaProvider<NetworkAPI> { get }
    init(
        isStub: Bool,
        sampleStatusCode: Int,
        customEndpointClosure: ((NetworkAPI) -> Endpoint)?
    )
    
    func fetch<Model: Decodable>(endpoint: NetworkAPI, for type: Model.Type) -> Single<Model>
}

extension NetworkRepositoryType {
    static func consProvider(
        _ isStub: Bool = false, 
        _ sampleStatusCode: Int = 200, 
        _ customEndpointClosure: ((NetworkAPI) -> Endpoint)? = nil
    ) -> MoyaProvider<NetworkAPI> {
        if isStub == false {
            return MoyaProvider<NetworkAPI>()
        } else {
            // 테스트 시에 호출되는 stub 클로져
            let endPointClosure = { (target: NetworkAPI) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }

                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
            return MoyaProvider<NetworkAPI>(
                endpointClosure: customEndpointClosure ?? endPointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }
}

final class NetworkRepository: NetworkRepositoryType {

    let provider: MoyaProvider<NetworkAPI>
    
    init(
        isStub: Bool = false,
        sampleStatusCode: Int = 200, 
        customEndpointClosure: ((NetworkAPI) -> Endpoint)? = nil
    ) {
        self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
    
    func fetch<Model: Decodable>(endpoint: NetworkAPI, for type: Model.Type) -> Single<Model> {
        return provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .map(Model.self)
    }
}
