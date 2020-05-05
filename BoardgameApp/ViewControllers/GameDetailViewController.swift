//
//  GameDetailViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import SafariServices

class GameDetailViewController: UITableViewController {
    
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
    @IBOutlet weak var rulesButton: UIButton!
    @IBOutlet weak var addToCollection: UIBarButtonItem!
    
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
        let gameDes = game.description.replacingOccurrences(of: "<p>", with: "\n").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<br />", with: "").replacingOccurrences(of: "</h4>", with: "").replacingOccurrences(of: "<h4>", with: " ").replacingOccurrences(of: "<em>", with: "").replacingOccurrences(of: "</em>", with: "")
        gameDescription.text = gameDes
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
                self?.reviews = reviews.filter {($0.title != nil) && $0.description != nil}
            }
        }
    }
    
    @IBAction func gameRulesButtonPressed(_ sender: UIButton) {
        guard let rulesURL = game?.rulesURL else {
            rulesButton.isHidden = true
            return
        }
        guard let url = URL(string: rulesURL) else {
            return
        }
        let safariPage = SFSafariViewController(url: url)
        present(safariPage, animated: true)
    }
    
    @IBAction func addToCollectionButtonPressed(_ sender: UIBarButtonItem) {
        //save to user collection on firebase and profile view
        
    }
}
extension GameDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()
        if tableView == reviewsTableView {
            count = reviews.count
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewCell else {
            fatalError("could not cast to ReviewCell")
        }
        if tableView == reviewsTableView {
            
            let review = reviews[indexPath.row]
            cell.configureCell(review: review)
            
        }
        return cell
    }
    
    
}
extension GameDetailViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        if tableView == reviewsTableView {
            let review = reviews[indexPath.row]
            if review.description == nil || review.title == nil {
                height = 100
            } else {
                height = 190
            }
        } else if tableView == self{
            return 200
        }
        return height
    }
}
