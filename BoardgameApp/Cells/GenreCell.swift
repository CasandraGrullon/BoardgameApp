//
//  GenreCell.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/30/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    
    public func configureCell(category: Category) {
        
        genreLabel.text = category.name
    }
}
