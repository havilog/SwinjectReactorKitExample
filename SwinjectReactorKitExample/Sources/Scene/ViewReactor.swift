//
//  ViewReactor.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/24.
//

import RxSwift
import Swinject
import ReactorKit

final class ViewReactor: Reactor {
    
    // MARK: Events
    
    enum Action {
        case buttonDidTapped
    }
    
    enum Mutation {
        case setSearchResult(User.Item)
    }
    
    struct State {
        var searchResult: String = ""
    }
    
    // MARK: Properties
    
    @Dependency 
    private var purchaseService: SearchServiceType
    let initialState: State
    let errorResult: PublishSubject<Error> = .init()
    
    // MARK: Initializers
    
    init() {
        initialState = State()
    }
}

// MARK: Mutation

extension ViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .buttonDidTapped:
            return purchaseService.searchUser(id: "hansangjin96")
                .compactMap { $0 }
                .catchError { [weak self] error in
                    self?.errorResult.onNext(error)
                    return .empty()
                }
                .asObservable()
                .map { .setSearchResult($0) }
                
        }
    }
}

// MARK: Reduce

extension ViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearchResult(let result):
            newState.searchResult = result.login
        }
        return newState
    }
}
