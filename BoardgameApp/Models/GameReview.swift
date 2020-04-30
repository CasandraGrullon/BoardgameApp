//
//  Reviews.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct Reviews: Codable {
    let reviews: [GameReview]
}

struct GameReview: Codable {
    let date: String
    let rating: Int
    let title: String?
    let description: String?
    let game: GameReviewed
    let user: ReviewUser
}
struct GameReviewed: Codable {
    let id: ObjectID
}
struct ObjectID: Codable {
    let objectId: String
}
struct ReviewUser: Codable {
    let username: String
    let id: String
}
