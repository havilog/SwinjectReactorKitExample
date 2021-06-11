//
//  PurchaseService.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Foundation
import RxSwift
import Moya

protocol SearchServiceType {
    func searchUser(id: String) -> Single<User.Item?>
}

final class SearchService: SearchServiceType {
    
//    @Dependency private var networkService: NetworkServiceType
    private let provider: MoyaProvider<NetworkAPI> = .init()
    
    func searchUser(id: String) -> Single<User.Item?> {
        return provider.rx.request(.searchUser(query: id))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .map { $0.items.first }
    }
}
