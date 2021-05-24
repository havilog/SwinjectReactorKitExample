//
//  File.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Foundation

protocol NetworkServiceType {
    func doSomeAPICall()
}

final class NetworkService: NetworkServiceType {
    func doSomeAPICall() {
        print(#function)
    }
}
