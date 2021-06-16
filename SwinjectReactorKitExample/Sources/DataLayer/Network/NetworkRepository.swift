//
//  MoyaProvider.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/16.
//

import Foundation

import RxSwift
import Moya

protocol MoyaProviderType {
    // Moya를 위한 protocol
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get set }
    init(
        isStub: Bool,
        sampleStatusCode: Int,
        customEndpointClosure: ((T) -> Endpoint)?
    )
    
    func fetch<Model: Decodable>(endpoint: T, for type: Model.Type) -> Single<Model>
}

extension MoyaProviderType {
    static func consProvider(
        _ isStub: Bool = false, 
        _ sampleStatusCode: Int = 200, 
        _ customEndpointClosure: ((T) -> Endpoint)? = nil
    ) -> MoyaProvider<T> {
        if isStub == false {
            return MoyaProvider<T>()
        } else {
            // 테스트 시에 호출되는 stub 클로져
            let endPointClosure = { (target: T) -> Endpoint in
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
            return MoyaProvider<T>(
                endpointClosure: customEndpointClosure ?? endPointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        }
    }
}

final class NetworkRepository<Target: TargetType>: MoyaProviderType {

    var provider: MoyaProvider<Target> = .init()
    
    init(
        isStub: Bool = false, 
        sampleStatusCode: Int = 200, 
        customEndpointClosure: ((Target) -> Endpoint)? = nil
    ) {
        self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
    
    func fetch<Model: Decodable>(endpoint: Target, for type: Model.Type) -> Single<Model> {
        return provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .map(Model.self)
    }
}
