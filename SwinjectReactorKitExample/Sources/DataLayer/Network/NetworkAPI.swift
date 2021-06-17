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

extension NetworkAPI {
    static var baseURLForTest: URL = URL(string: "https://avatars.githubusercontent.com/u/57659933?v=4")!
    
    static let sampleDataForTest: Data = Data(
            """
            {
            "total_count": 1,
            "incomplete_results": false,
            "items": [
            {
            "login": "hansangjin96",
            "id": 57659933,
            "node_id": "MDQ6VXNlcjU3NjU5OTMz",
            "avatar_url": "https://avatars.githubusercontent.com/u/57659933?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/hansangjin96",
            "html_url": "https://github.com/hansangjin96",
            "followers_url": "https://api.github.com/users/hansangjin96/followers",
            "following_url": "https://api.github.com/users/hansangjin96/following{/other_user}",
            "gists_url": "https://api.github.com/users/hansangjin96/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/hansangjin96/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/hansangjin96/subscriptions",
            "organizations_url": "https://api.github.com/users/hansangjin96/orgs",
            "repos_url": "https://api.github.com/users/hansangjin96/repos",
            "events_url": "https://api.github.com/users/hansangjin96/events{/privacy}",
            "received_events_url": "https://api.github.com/users/hansangjin96/received_events",
            "type": "User",
            "site_admin": false,
            "score": 1
            }
            ]
            }
            """.utf8
        )
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
        switch self {
        default:
            let user = User(
                total_count: 1,
                incomplete_results: false,
                items: [
                    User.Item(
                        login: "hansangjin96", 
                        id: 57659933, 
                        node_id: "MDQ6VXNlcjU3NjU5OTMz",
                        avatar_url: "https://avatars.githubusercontent.com/u/57659933?v=4",
                        gravatar_id: "",
                        url: "https://api.github.com/users/hansangjin96",
                        html_url: "https://github.com/hansangjin96",
                        followers_url: "https://api.github.com/users/hansangjin96/followers",
                        following_url: "https://api.github.com/users/hansangjin96/following{/other_user}",
                        gists_url: "https://api.github.com/users/hansangjin96/gists{/gist_id}", 
                        starred_url: "https://api.github.com/users/hansangjin96/starred{/owner}{/repo}", 
                        subscriptions_url: "https://api.github.com/users/hansangjin96/subscriptions",
                        organizations_url: "https://api.github.com/users/hansangjin96/orgs",
                        repos_url: "https://api.github.com/users/hansangjin96/repos",
                        events_url: "https://api.github.com/users/hansangjin96/events{/privacy}",
                        received_events_url: "https://api.github.com/users/hansangjin96/received_events",
                        type: "User",
                        site_admin: false,
                        score: 1
                    )
                ]
            )
            
            return try! JSONEncoder().encode(user)
            
//            if let data = try? JSONEncoder().encode(user) {
//                return data    
//            } else {
//                return Data()
//            }
        }
        
    }
    
    var task: Task {
        switch self {
        case .searchUser(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["User-Agent": "request"]
    }
}
