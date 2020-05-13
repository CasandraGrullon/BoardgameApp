//
//  ExploreCell.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/30/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import Kingfisher

class GameCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    public func configureCell(game: Game) {
        nameLabel.text = game.name
        gameImageView.kf.setImage(with: URL(string: game.thumbURL))
    }
    public func configureCell(collected: CollectedGame) {
        nameLabel.text = collected.gameName
        gameImageView.kf.setImage(with: URL(string: collected.gameImage))
    }
}
