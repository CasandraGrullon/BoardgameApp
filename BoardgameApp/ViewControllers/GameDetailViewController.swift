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
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var numberofPlayerLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    public var game: Game?
    public var categories = [Category]()
    public var reviews = [GameReview]() {
        didSet {
            DispatchQueue.main.async {
                self.reviewsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        updateUI()
    }
    private func configureTableView() {
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
    }
    private func updateUI() {
        guard let game = game else {return}
        getCategories()
        getGameReviews(gameId: game.id)
        gameImageView.kf.setImage(with: URL(string: game.imageURL))
        nameLabel.text = game.name
        priceLabel.text = "$\(game.price)"
        gameDescription.text = game.description
        ageLabel.text = "Age: \(game.minAge)+"
        numberofPlayerLabel.text = "\(game.minPlayers) - \(game.maxPlayers) players"
        playtimeLabel.text = "Average Game Time: \t\(game.minPlaytime) - \(game.maxPlaytime) minutes"
        if game.averageUserRating >= 5 {
            star1Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star2Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star3Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star4Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star5Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else if game.averageUserRating >= 4 && game.averageUserRating < 5 {
            star1Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star2Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star3Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star4Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star5Button.setImage(UIImage(systemName: "star"), for: .normal)
        } else if game.averageUserRating >= 3 && game.averageUserRating < 4 {
            star1Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star2Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star3Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star4Button.setImage(UIImage(systemName: "star"), for: .normal)
            star5Button.setImage(UIImage(systemName: "star"), for: .normal)
        } else if game.averageUserRating >= 2 && game.averageUserRating < 3 {
            star1Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star2Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star3Button.setImage(UIImage(systemName: "star"), for: .normal)
            star4Button.setImage(UIImage(systemName: "star"), for: .normal)
            star5Button.setImage(UIImage(systemName: "star"), for: .normal)
        } else if game.averageUserRating >= 1 && game.averageUserRating < 2{
            star1Button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            star2Button.setImage(UIImage(systemName: "star"), for: .normal)
            star3Button.setImage(UIImage(systemName: "star"), for: .normal)
            star4Button.setImage(UIImage(systemName: "star"), for: .normal)
            star5Button.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            star1Button.setImage(UIImage(systemName: "star"), for: .normal)
            star2Button.setImage(UIImage(systemName: "star"), for: .normal)
            star3Button.setImage(UIImage(systemName: "star"), for: .normal)
            star4Button.setImage(UIImage(systemName: "star"), for: .normal)
            star5Button.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
    }
    private func getCategories() {
        BoardGameAPIClient.getGameCategories { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not get categories from api error: \(error)")
            case .success(let categories):
                self?.categories = categories
                DispatchQueue.main.async {
                    for category in categories {
                        self?.categoriesLabel.text = category.name
                    }
                }
            }
        }
    }
    private func getGameReviews(gameId: String) {
        BoardGameAPIClient.getReviews(gameId: gameId) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to get user reviews \(error)")
            case .success(let reviews):
                self?.reviews = reviews
            }
        }
    }

}
extension GameDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewCell else {
            fatalError("could not cast to ReviewCell")
        }
        let review = reviews[indexPath.row]
        cell.configureCell(review: review)
        return cell
    }
    
    
}
extension GameDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
