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
    @IBOutlet weak var removeButton: UIButton!
    public static let reuseIdentifier = "gameCell"
    
    public func configureCell(game: Game) {
        removeButton.isHidden = true
        removeButton.isEnabled = false
        nameLabel.text = game.name
        gameImageView.kf.setImage(with: URL(string: game.thumbURL))
    }
    public func configureCell(collected: CollectedGame) {
        removeButton.isHidden = false
        removeButton.isEnabled = true
        nameLabel.text = collected.gameName
        gameImageView.kf.setImage(with: URL(string: collected.gameImage))
    }
    @IBAction func removeButtonPressed(_ sender: UIButton) {
    }
    
}
