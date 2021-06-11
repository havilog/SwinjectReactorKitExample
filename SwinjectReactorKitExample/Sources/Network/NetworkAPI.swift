//
//  NetworkAPI.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/11.
//

import Foundation
import Moya

enum NetworkAPI {
    case searchUser(query: String)
}

extension NetworkAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .searchUser:
            return "search/users"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchUser(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    
}
