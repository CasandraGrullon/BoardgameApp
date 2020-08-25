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
            return 3
        }
    }
    var nestedGroupHeight: NSCollectionLayoutDimension {
        switch self {
        case .main:
            return .fractionalWidth(0.9)
        default:
            return .fractionalWidth(0.45)
        }
    }
    var sectionTitle: String {
        switch self {
        case .main:
            return "First Section"
        case .second:
            return "Second Section"
        case .third:
            return "Third Section"
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
