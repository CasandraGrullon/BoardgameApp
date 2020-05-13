//
//  ReviewCell.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/30/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStars: UIButton!
    @IBOutlet weak var threeStars: UIButton!
    @IBOutlet weak var fourStars: UIButton!
    @IBOutlet weak var fiveStars: UIButton!
    
    
    public func configureCell(review: GameReview) {
        userNameLabel.text = review.user.username
        titleLabel.text = review.title
        descriptionLabel.text = review.description
        if review.rating == 5 {
            oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            twoStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            threeStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fourStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fiveStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else if review.rating == 4 {
            oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            twoStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            threeStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fourStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fiveStars.setImage(UIImage(systemName: "star"), for: .normal)
        } else if review.rating == 3 {
            oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            twoStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            threeStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fourStars.setImage(UIImage(systemName: "star"), for: .normal)
            fiveStars.setImage(UIImage(systemName: "star"), for: .normal)
        } else if review.rating == 2 {
            oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            twoStars.setImage(UIImage(systemName: "star.fill"), for: .normal)
            threeStars.setImage(UIImage(systemName: "star"), for: .normal)
            fourStars.setImage(UIImage(systemName: "star"), for: .normal)
            fiveStars.setImage(UIImage(systemName: "star"), for: .normal)
        } else if review.rating == 1 {
            oneStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
            twoStars.setImage(UIImage(systemName: "star"), for: .normal)
            threeStars.setImage(UIImage(systemName: "star"), for: .normal)
            fourStars.setImage(UIImage(systemName: "star"), for: .normal)
            fiveStars.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            oneStar.setImage(UIImage(systemName: "star"), for: .normal)
            twoStars.setImage(UIImage(systemName: "star"), for: .normal)
            threeStars.setImage(UIImage(systemName: "star"), for: .normal)
            fourStars.setImage(UIImage(systemName: "star"), for: .normal)
            fiveStars.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
