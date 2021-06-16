//
//  MockImageService.swift
//  SwinjectReactorKitExampleTests
//
//  Created by 한상진 on 2021/06/16.
//

@testable import SwinjectReactorKitExample
import Foundation
import RxSwift

final class MockImageService: ImageServiceType {
    
    private var makeRequestFail = false
    
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    func fetchImage(with url: URL?) -> Single<Data?> {
        Single.create { [weak self] single in
            guard let self = self else { 
                single(.error(ImageDownloadError.selfError))
                return Disposables.create() 
            }
            
            if self.makeRequestFail {
                single(.error(ImageDownloadError.dataError))
            } else {
                single(.success(Data("test".utf8)))
            }
            
            return Disposables.create()
        }
    }
}
