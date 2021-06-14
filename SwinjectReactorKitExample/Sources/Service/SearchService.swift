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
    let url: URL?
    let id: Int?
}

protocol SearchServiceType {
    func searchUser(id: String) -> Observable<SearchUserResult>
}

final class SearchService: SearchServiceType {
    
    private let provider: MoyaProvider<NetworkAPI>
    
    init(provider: MoyaProvider<NetworkAPI>) {
        self.provider = provider
    }
    
    func searchUser(id: String) -> Observable<SearchUserResult> {
        return provider.rx.request(.searchUser(query: id))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .map { user -> SearchUserResult in
                let item = user.items.first
                
                return SearchUserResult(
                    nickname: item?.login,
                    url: URL(string: item?.avatar_url ?? ""),
                    id: item?.id
                ) 
            }
            .asObservable()
    }
}
