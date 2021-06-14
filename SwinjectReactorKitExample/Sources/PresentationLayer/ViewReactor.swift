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
        case searchUser(id: String)
    }
    
    enum Mutation {
        case setSearchResult(SearchUserResult)
    }
    
    struct State {
        var searchResult: String = "before button pressed"
        var searchAvartarImageResult: UIImage? // default image
        var searchIDResult: String = "id ?"
    }
    
    // MARK: Properties
    
    @Dependency private var searchService: SearchServiceType
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
        case let .searchUser(id):
            return searchService.searchUser(id: id) // returns Single<T?>
                .catchError { [weak self] error in
                    print("Error occured!!!!!")
                    self?.errorResult.onNext(error)
                    return .empty()
                }
                .do(onNext: { print($0) })
                .map { .setSearchResult($0) }
                
        }
    }
}

// MARK: Reduce

extension ViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSearchResult(result):
            newState.searchResult = result.nickname ?? "없음"
            newState.searchAvartarImageResult = try? UIImage(data: Data(contentsOf: result.url!))
            newState.searchIDResult = String(result.id ?? 0)
        }
        return newState
    }
}
