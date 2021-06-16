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
    func searchUser(id: String) -> Observable<SearchUserResult>
}

final class SearchService<Provider: MoyaProviderType>: SearchServiceType {    
    // swinject
//    @Dependency private var provider: MoyaProvider<NetworkAPI>
//    @Dependency private var imageService: ImageServiceType
    
    private let imageService: ImageServiceType
    private let networkRepository: Provider
    
    init(
        imageService: ImageServiceType,
        networkRepository: Provider
    ) {
        self.networkRepository = networkRepository
        self.imageService = imageService
    }
    
    func searchUser(id: String) -> Observable<SearchUserResult> {
        return self.networkRepository.fetch(
            endpoint: NetworkAPI.searchUser(query: id) as! Provider.T,
            for: User.self
        )
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
