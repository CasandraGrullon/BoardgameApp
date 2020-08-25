//
//  SectionKind.swift
//  BoardgameApp
//
//  Created by casandra grullon on 8/25/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

enum SectionKind: Int, CaseIterable {
    case main
    case second
    case third
    
    var itemCount: Int {
        switch self {
        case .main:
            return 1
        default:
            return 2
        }
    }
    var nestedGroupHeight: NSCollectionLayoutDimension {
        switch self {
        case .main:
            return .fractionalWidth(1.0)
        default:
            return .fractionalWidth(0.8)
        }
    }
    var sectionTitle: String {
        switch self {
        case .main:
            return "Top Results"
        case .second:
            return "More Results"
        case .third:
            return "Other Results"
        }
    }
    var orthogonalBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .main:
            return .groupPaging
        case .second:
            return .continuous
        case .third:
            return .continuous
        }
    }
}
