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
        container.register(Bool.self, name: "isStub") { resolver in
            false
        }
        
        container.register(NetworkRepositoryType.self) { resolver in
            NetworkRepository()
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
        // TODO: 에러 잡기
//        container.autoregister(MoyaProvider<NetworkAPI>.self, initializer: MoyaProvider<NetworkAPI>.init)
//        container.autoregister(URLSessionType.self, initializer: URLSession.init)
//        container.autoregister(ImageServiceType.self, initializer: ImageService.init)
//        container.autoregister(SearchServiceType.self, initializer: SearchService.init)
//        try! container.verify()
    }
    
    private func configureContainerPureSwinject() {
    }
    
    func getContainter() -> Container {
        return self.container
    }
    
    func resolve<T>(name: String? = nil) -> T {
        guard let dependency = container.resolve(T.self, name: name) else {
            fatalError("\(T.self) Error")
        }
        
        print(T.self, "resolved")
        
        return dependency
    }
}

@propertyWrapper
final class Dependency<T> {
    let wrappedValue: T
    
    init() {
        // 앱 실행 시 isStub는 false, Test에서 true로 다시 register
        let isStub: Bool = DIContainer.shared.resolve(name: "isStub")
        self.wrappedValue = DIContainer.shared.resolve(name: isStub ? "stub" : nil)
    }
}
