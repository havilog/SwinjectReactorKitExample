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
        case setPurchaseResult
    }
    
    struct State {
        var purchaseResult: Bool = false
    }
    
    // MARK: Properties
    
    @Dependency var purchaseService: PurchaseServiceType
    let initialState: State
    
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
            purchaseService.loadProductList(identifiers: [])
            return .just(.setPurchaseResult)
        }
    }
}

// MARK: Reduce

extension ViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPurchaseResult:
            newState.purchaseResult = true
        }
        return newState
    }
}

// MARK: Method

private extension ViewReactor {
} 
