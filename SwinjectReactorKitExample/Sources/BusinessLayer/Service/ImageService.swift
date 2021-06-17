//
//  ImageService.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/14.
//

import Foundation

import Moya
import RxSwift

// MARK: URLSession Mock

protocol URLSessionType {
    func dataTask(
        with request: URLRequest, 
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionType {}

// MARK: ImageService

protocol ImageServiceType {
    func fetchImage(with url: URL?) -> Single<Data?>
}

final class ImageService: ImageServiceType {

    @Dependency private var urlSession: URLSessionType
    private var task: URLSessionTask?
    
    func fetchData(url: URL, completion: @escaping (Result<Data, ImageDownloadError>) -> Void) {
        let request = URLRequest(url: url)
        
        // before task
        self.task?.cancel()
        
        // current task
        let task = self.urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else { 
                print("ImageDownloadError.networkError", error!.localizedDescription)
                completion(.failure(ImageDownloadError.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("ImageDownloadError.responseError")
                completion(.failure(ImageDownloadError.responseError))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                print("ImageDownloadError.statusError")
                completion(.failure(ImageDownloadError.statusError))
                return
            }
            
            guard data != nil else {
                print("ImageDownloadError.dataError")
                completion(.failure(ImageDownloadError.dataError))
                return
            }
            
            print("data received")
            completion(.success(data!))
            
            CachStorage.shared.cachedImage.setObject(data! as NSData, forKey: url as NSURL)
        }
        
        task.resume()

        self.task = task
    }
    
    func fetchImage(with url: URL?) -> Single<Data?> {
        return Single<Data?>.create { [weak self] single in
            guard let self = self else { 
                print("self error")
                single(.error(ImageDownloadError.selfError))
                return Disposables.create() 
            }
            
            guard let url = url else { 
                print("url error")
                single(.error(ImageDownloadError.urlError))
                return Disposables.create() 
            }
            
            // cache에서 검사해서 있으면 리턴
            if let cachedImage = CachStorage.shared.cachedImage.object(forKey: url as NSURL) {
                print("cached Image returned")
                single(.success(cachedImage as Data))
                return Disposables.create()
            }
            
            // cache가 없으면 Network통신
            self.fetchData(url: url) { result in
                switch result {
                case .success(let data):
                    single(.success(data))
                    
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {
                self.task?.cancel()
            }
        }
    }
}

enum ImageDownloadError: Error {
    case selfError
    case urlError
    case networkError
    case responseError
    case statusError
    case dataError
}
