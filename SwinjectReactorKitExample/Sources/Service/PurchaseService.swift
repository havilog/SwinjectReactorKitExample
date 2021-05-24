//
//  PurchaseService.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Foundation

protocol SomeType {}
class SomeClass: SomeType {}

protocol PurchaseServiceType {
    func loadProductList(identifiers: [String])
    func requestPurchasePayload(productId: String)
    func purchaseTransactionStart()
}

final class PurchaseService: PurchaseServiceType {
    
    let dependency: NetworkServiceType
    
    init(
        dependency: NetworkServiceType
    ) {
        self.dependency = dependency
    }
    
    func loadProductList(identifiers: [String]) {
        dependency.doSomeAPICall()
        print(#function)
    }
    
    func requestPurchasePayload(productId: String) {
        dependency.doSomeAPICall()
        print(#function)
    }
    
    func purchaseTransactionStart() {
        dependency.doSomeAPICall()
        print(#function)
    }
}
