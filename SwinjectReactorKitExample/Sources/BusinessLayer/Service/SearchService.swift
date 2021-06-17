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

final class SearchService: SearchServiceType {    
    // swinject를 property wrapper로 감싸 dependency injection
    @Dependency var networkRepository: NetworkRepositoryType
    @Dependency var imageService: ImageServiceType
    
    func searchUser(id: String) -> Observable<SearchUserResult> {
        return self.networkRepository.fetch(endpoint: .searchUser(query: id), for: User.self)
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
