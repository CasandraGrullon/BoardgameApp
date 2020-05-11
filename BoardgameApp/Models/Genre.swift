//
//  Genre.swift
//  BoardgameApp
//
//  Created by casandra grullon on 5/11/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct Genre {
    let name: String
    let id: String
    let image: String
}
extension Genre {
    init?(_ dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let image = dictionary["image"] as? String else {
                return nil
        }
        self.name = name
        self.id = id
        self.image = image
    }
}

