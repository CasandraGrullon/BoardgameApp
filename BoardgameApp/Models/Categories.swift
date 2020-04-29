//
//  Categories.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [Category]
}
struct Category: Codable {
    let id: String
    let name: String
}
