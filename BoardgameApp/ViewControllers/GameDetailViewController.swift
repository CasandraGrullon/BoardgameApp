//
//  GameDetailViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var numberofPlayerLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    
    private var game: Game
    
    init?(game: Game, coder: NSCoder) {
        self.game = game
        super.init(coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
