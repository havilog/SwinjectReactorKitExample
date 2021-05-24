//
//  AppDelegate.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import UIKit
import Swinject
import SwinjectSafeAuto
import PureSwinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        configureDIContainer()
//        configureDIContainerWithPureSwinject()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

private extension AppDelegate {
//    func configureDIContainer() {
//        let container: Container = .init()
//        container.register(NetworkServiceType.self) { resolver in NetworkService() }
//        
//        container.register(PurchaseServiceType.self) { resolver in
//            PurchaseService(dependency: resolver.resolve(NetworkServiceType.self)!)
//        }
//    }
//    
//    func configureDIContainerWithPureSwinject() {
//        let container2: Container = .init()
//        
//        container2.autoregister(NetworkServiceType.self, initializer: NetworkService.init)
//        
//        try! container2.verify()
//        
//        let test = container2.resolve(NetworkServiceType.self)
//    }
}
