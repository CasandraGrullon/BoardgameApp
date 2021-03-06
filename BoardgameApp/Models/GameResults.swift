//
//  Game.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct GameResults: Codable {
    let games: [Game]
}
struct Game: Codable, Hashable {
    let id: String
    let name: String
    let yearPublished: Int?
    let minPlayers: Int?
    let maxPlayers: Int?
    let minPlaytime: Int?
    let maxPlaytime: Int?
    let minAge: Int?
    let description: String
    let imageURL: String
    let thumbURL: String
    let price: String
    let averageUserRating: Double
    let rulesURL: String?
    
    //coding keys to rename properties from json to fit Swift standards
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case yearPublished = "year_published"
        case minPlayers = "min_players"
        case maxPlayers = "max_players"
        case minPlaytime = "min_playtime"
        case maxPlaytime = "max_playtime"
        case minAge = "min_age"
        case description
        case imageURL = "image_url"
        case thumbURL = "thumb_url"
        case price
        case averageUserRating = "average_user_rating"
        case rulesURL = "rules_url"
    }
}
