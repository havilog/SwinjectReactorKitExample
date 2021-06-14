//
//  DIContainer.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/24.
//

import Foundation
import Swinject
import SwinjectSafeAuto
import PureSwinject
import Moya

final class DIContainer {
    
    // MARK: Singleton
    
    static let shared: DIContainer = .init()
    private init() { 
//        configureContainerSwinjectSafeAuto() 
        configureContainer()
        print(#file.split(separator: "/").last!, #function)
    }
    
    private let container: Container = .init()
    
    private func configureContainer() {
        container.register(MoyaProvider<NetworkAPI>.self) { resolver in
            MoyaProvider<NetworkAPI>()
        }
        
        container.register(URLSessionType.self) { resolver in
            URLSession.init(configuration: .default)
        }
        
        container.register(ImageServiceType.self) { resolver in
            ImageService.init()
        }
        
        container.register(SearchServiceType.self) { resolver in
            SearchService.init()
        }
    }
    
    private func configureContainerSwinjectSafeAuto() {
        
        container.autoregister(MoyaProvider<NetworkAPI>.self, initializer: MoyaProvider<NetworkAPI>.init)
        container.autoregister(URLSessionType.self, initializer: URLSession.init)
        container.autoregister(ImageServiceType.self, initializer: ImageService.init)
        container.autoregister(SearchServiceType.self, initializer: SearchService.init)
        try! container.verify()
    }
    
    private func configureContainerPureSwinject() {
    }
    
    func resolve<T>() -> T {
        guard let dependency = container.resolve(T.self) else {
            fatalError("\(T.self) Error")
        }
        
        print(T.self, "resolved")
        
        return dependency
    }
}

@propertyWrapper
class Dependency<T> {
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}
