//
//  FormatString.swift
//  BoardgameApp
//
//  Created by casandra grullon on 8/25/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

extension String {
    func formatString() -> String {
        self.replacingOccurrences(of: "<p>", with: "\n")
            .replacingOccurrences(of: "</p>", with: "")
            .replacingOccurrences(of: "<br />", with: "")
            .replacingOccurrences(of: "</h4>", with: "")
            .replacingOccurrences(of: "<h4>", with: " ")
            .replacingOccurrences(of: "<em>", with: "")
            .replacingOccurrences(of: "</em>", with: "")
            .replacingOccurrences(of: "<strong>", with: "")
            .replacingOccurrences(of: "</strong>", with: "")
            .replacingOccurrences(of: "<ul>", with: "")
            .replacingOccurrences(of: "<li>", with: "")
            .replacingOccurrences(of: "</ul>", with: "")
            .replacingOccurrences(of: "</li>", with: "")
            .replacingOccurrences(of: "<i>", with: "")
            .replacingOccurrences(of: "</i>", with: "").replacingOccurrences(of: "&quot;", with: "\"")
    }
}
