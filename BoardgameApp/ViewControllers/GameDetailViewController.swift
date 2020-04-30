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
    @IBOutlet weak var reviewsTableView: UITableView!
    
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
        priceLabel.text = game.price
        gameDescription.text = game.description
        ageLabel.text = "Age: \(game.minAge)+"
        numberofPlayerLabel.text = "\(game.minPlayers) - \(game.maxPlayers) players"
        playtimeLabel.text = "Average Game Time: \t\(game.minPlaytime) - \(game.maxPlaytime) minutes"
        averageRatingLabel.text = "Rated \(game.averageUserRating)/10"
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
