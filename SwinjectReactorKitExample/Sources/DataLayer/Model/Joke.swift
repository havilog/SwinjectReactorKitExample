//
//  Joke.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/06/15.
//

import Foundation

struct JokeReponse: Decodable {
    let type: String
    let value: Joke
}

struct Joke: Decodable {
    let id: Int
    let joke: String
    let categories: [String]
}
