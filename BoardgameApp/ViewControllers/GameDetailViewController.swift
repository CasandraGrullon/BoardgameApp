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
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
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
                self.reviewsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        updateUI()
    }
    private func configureCollectionView() {
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
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

extension GameDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 4
        let maxSize: CGFloat = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 2
        let totalSpace: CGFloat = (numberOfItems * itemSpacing) * 2.5
        let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
extension GameDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = reviewsCollectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? ReviewCell else {
            fatalError("could not cast to review cell")
        }
        let review = reviews[indexPath.row]
        cell.configureCell(review: review)
        return cell
    }
    
    
}
