//
//  ImageService.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/14.
//

import Foundation

import Moya
import RxSwift

protocol ImageServiceType {
    func fetchImage(with url: URL?) -> Observable<Data?>
}

final class ImageService: ImageServiceType {
    private let provider: MoyaProvider<NetworkAPI>
    
    init(provider: MoyaProvider<NetworkAPI>) {
        self.provider = provider
    }
    
    func fetchImage(with url: URL?) -> Observable<Data?> {
        if let url = url {
            let data = try? Data(contentsOf: url)
            return .just(data)
        }
        
        return .just(nil)
    }
    
    /// Retrieves (or creates should it be necessary) a temporary image's local URL on cache directory for testing purposes
    /// - Parameter name: image name retrieved from asset catalog
    /// - Parameter imageExtension: Image type. Defaults to `.jpg` kind
    /// - Returns: Resulting URL for named image
    func createLocalUrl(forImageNamed name: String, imageExtension: String = "jpg") -> URL? {
        let fileManager = FileManager.default

        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Unable to access cache directory")
            return nil
        }

        let url = cacheDirectory.appendingPathComponent("\(name).\(imageExtension)")

        // If file doesn't exist, creates it
        guard fileManager.fileExists(atPath: url.path) else {
            // Bundle(for: Self.self) is used here instead of .main in order to work on test target as well
            guard let image = UIImage(named: name, in: Bundle(for: Self.self), with: nil),
                  let data = image.jpegData(compressionQuality: 1) else {
                print("Impossible to convert to jpg data")
                return nil
            }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }

        return url
    }
}
