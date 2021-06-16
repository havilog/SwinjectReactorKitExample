//
//  PurchaseService.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Foundation
import RxSwift
import Moya
import Swinject

struct SearchUserResult: Equatable {
    let nickname: String?
    let urlData: Data?
    let id: Int?
}

protocol SearchServiceType: AnyObject {
    // 테스트하려는 함수
    func searchUser(id: String) -> Observable<SearchUserResult>
    
    // Moya를 위한 protocol
//    associatedtype T: TargetType
    var provider: MoyaProvider<NetworkAPI> { get set }
    init(
        isStub: Bool,
        sampleStatusCode: Int,
        customEndpointClosure: ((NetworkAPI) -> Endpoint)?,
        imageService: ImageServiceType
    )
    
}

extension SearchServiceType {
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

final class SearchService: SearchServiceType {    
    // swinject
//    @Dependency private var provider: MoyaProvider<NetworkAPI>
//    @Dependency private var imageService: ImageServiceType
    
    private var imageService: ImageServiceType
    var provider: MoyaProvider<NetworkAPI>
    
    init(
        isStub: Bool = false, 
        sampleStatusCode: Int = 200, 
        customEndpointClosure: ((NetworkAPI) -> Endpoint)? = nil,
        imageService: ImageServiceType
    ) {
        self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
        self.imageService = imageService
    }
    
    func searchUser(id: String) -> Observable<SearchUserResult> {
        return provider.rx.request(.searchUser(query: id))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .map { user -> (nickname: String?, url: URL?, id: Int?) in
                let item = user.items.first
                
                return (
                    nickname: item?.login,
                    url: URL(string: item?.avatar_url ?? ""),
                    id: item?.id
                )
            }
            .asObservable()
            .flatMapLatest { [weak self] result -> Observable<SearchUserResult> in
                guard let self = self else { return .empty() }
                
                return self.imageService.fetchImage(with: result.url)
                    .asObservable()
                    .catchError { error -> Observable<Data?> in
                        print("Error catched in searchService")
                        return .just(nil)
                    }
                    .map { data -> SearchUserResult in
                        return SearchUserResult(nickname: result.nickname, urlData: data, id: result.id)
                    }
            }
    }
}
