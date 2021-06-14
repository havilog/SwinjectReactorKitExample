//
//  PurchaseService.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Foundation
import RxSwift
import Moya

struct SearchUserResult {
    let nickname: String?
    let urlData: Data?
    let id: Int?
}

protocol SearchServiceType {
    func searchUser(id: String) -> Observable<SearchUserResult>
}

final class SearchService: SearchServiceType {
    
    private let provider: MoyaProvider<NetworkAPI>
    private let imageService: ImageServiceType
    
    init(
        provider: MoyaProvider<NetworkAPI>,
        imageService: ImageServiceType
    ) {
        self.provider = provider
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
                    .map { data -> SearchUserResult in
                        return SearchUserResult(nickname: result.nickname, urlData: data, id: result.id)
                    }
            }
    }
}
