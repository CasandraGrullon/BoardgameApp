//
//  SectionKind.swift
//  BoardgameApp
//
//  Created by casandra grullon on 8/25/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

//This enum will be used in the CollectionView Diffable DataSource configure method.
//Creating sections within the collectionview with unique properties
enum SectionKind: Int, CaseIterable {
    case main
    case second
    case third
    
    //number of rows in a section
    var itemCount: Int {
        switch self {
        case .main:
            return 1
        default:
            return 2
        }
    }
    //height for section groups
    var nestedGroupHeight: NSCollectionLayoutDimension {
        switch self {
        case .main:
            return .fractionalWidth(1.0)
        default:
            return .fractionalWidth(0.8)
        }
    }
    //Section Titles
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
    //Scroll Behavior for each section
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
