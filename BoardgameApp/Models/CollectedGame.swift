//
//  WishListGame.swift
//  BoardgameApp
//
//  Created by casandra grullon on 5/13/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct CollectedGame {
    let gameId: String
    let gameName: String
    let gameImage: String
    let userOwned: Bool
}
extension CollectedGame {
    init?(_ dictionary: [String: Any]) {
        guard let gameId = dictionary["gameId"] as? String,
            let gameName = dictionary["gameName"] as? String,
            let gameImage = dictionary["gameImage"] as? String,
            let userOwned = dictionary["userOwned"] as? Bool else {
                return nil
        }
        self.gameId = gameId
        self.gameName = gameName
        self.gameImage = gameImage
        self.userOwned = userOwned
    }
}
