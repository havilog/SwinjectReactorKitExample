//
//  SceneDelegate.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let searchService: SearchServiceType = SearchService()
        let searchReactor: SearchReactor = .init(searchService: searchService)
        
        let vc = SearchViewController(reactor: searchReactor)
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

