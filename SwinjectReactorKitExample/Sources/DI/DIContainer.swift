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

final class DIContainer {
    
    // MARK: Singleton
    
    static let shared: DIContainer = .init()
    private init() { configureContainerSwinjectSafeAuto() }
    
    private let container: Container = .init()
    
    private func configureContainer() {
        container.register(NetworkServiceType.self) { resolver in NetworkService() }
        
        container.register(PurchaseServiceType.self) { resolver in
            PurchaseService(dependency: resolver.resolve(NetworkServiceType.self)!)
        }
    }
    
    private func configureContainerSwinjectSafeAuto() {
        container.autoregister(NetworkServiceType.self, initializer: NetworkService.init)
        container.autoregister(PurchaseServiceType.self, initializer: PurchaseService.init)
        
        try! container.verify()
    }
    
    private func configureContainerPureSwinject() {
    }
    
    func resolve<T>() -> T {
        guard let dependency = container.resolve(T.self) else {
            fatalError("PurchaseServiceType Error")
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
