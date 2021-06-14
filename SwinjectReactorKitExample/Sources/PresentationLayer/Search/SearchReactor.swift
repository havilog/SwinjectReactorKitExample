//
//  ViewReactor.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/24.
//

import RxSwift
import ReactorKit

final class SearchReactor: Reactor {
    
    // MARK: Events
    
    enum Action {
        case searchUser(id: String)
    }
    
    enum Mutation {
        case setSearchResult(SearchUserResult)
    }
    
    struct State {
        var searchResult: String = "before button pressed nickname"
        var searchAvartarImageData: Data? 
        var searchIDResult: String = "before button pressed id"
    }
    
    // MARK: Properties
    
    @Dependency private var searchService: SearchServiceType
    private let image = ImageService()
    let initialState: State
    let errorResult: PublishSubject<Error> = .init()
    
    // MARK: Initializers
    
    init() {
        initialState = State()
    }
}

// MARK: Mutation

extension SearchReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .searchUser(id):
            return self.searchUser(with: id)
        }
    }
}

// MARK: Reduce

extension SearchReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSearchResult(result):
            newState.searchResult = result.nickname ?? "없음"
            newState.searchAvartarImageData = result.urlData
            newState.searchIDResult = String(result.id ?? 0)
        }
        return newState
    }
}

// MARK: Private Method

private extension SearchReactor {
    func searchUser(with id: String) -> Observable<Mutation> {
        return searchService.searchUser(id: id)
            .catchError { [weak self] error in
                print("Error searchService catched!!!!!")
                self?.errorResult.onNext(error)
                return .empty()
            }
            .do(onNext: { print($0) })
            .map { .setSearchResult($0) }
        
        
//        return image.fetchImage(with: URL(string: "https://blog.kakaocdn.net/dn/daPJMD/btqCinzhh9J/akDK6BMiG3QKH3XWXwobx1/img.jpg")!)
//            .asObservable()
//            .catchError { [weak self] error in
//                print("Error catched!!!!!")
//                self?.errorResult.onNext(error)
//                return .empty()
//            }
////            .do(onNext: { print($0) })
//            .map { .setSearchResult(SearchUserResult(nickname: "test", urlData: $0, id: 0)) }
    }
}


/*
 3. DI 다시 계층구조 설정
 4. 테스팅
 */
