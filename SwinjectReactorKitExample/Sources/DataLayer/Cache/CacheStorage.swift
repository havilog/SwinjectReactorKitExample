//
//  CacheStorage.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/14.
//

import Foundation

final class CachStorage {
    static let shared = CachStorage()
    let cachedImage: NSCache<NSURL, NSData> 
    
    private init() {
        cachedImage = .init()
        cachedImage.countLimit = 1000
    }
}
