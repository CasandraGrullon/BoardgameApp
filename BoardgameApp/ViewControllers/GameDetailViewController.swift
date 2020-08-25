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
    @IBOutlet weak var addToCollectionButton: UIBarButtonItem!
    
    public var game: Game
    public var categories = [Category]()
    public var reviews = [GameReview]() {
        didSet {
            DispatchQueue.main.async {
                self.reviewsCollectionView.reloadData()
            }
        }
    }
    private var isGameInCollection = false
    private var isUserOwned = false
    
    init?(coder: NSCoder, game: Game) {
        self.game = game
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureCollectionView()
        uiAsync()
        checkCollections()
    }
    private func configureCollectionView() {
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
    }
    private func uiAsync() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    private func updateUI() {
        //guard let game = game else {return}
        navigationItem.title = game.name
        //getCategories()
        //getGameReviews(gameId: game.id)
       gameImageView.kf.setImage(with: URL(string: game.imageURL))
        nameLabel.text = game.name
        priceLabel.text = "$\(game.price)"
        let gameDes = game.description.replacingOccurrences(of: "<p>", with: "\n").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<br />", with: "").replacingOccurrences(of: "</h4>", with: "").replacingOccurrences(of: "<h4>", with: " ").replacingOccurrences(of: "<em>", with: "").replacingOccurrences(of: "</em>", with: "").replacingOccurrences(of: "<strong>", with: "").replacingOccurrences(of: "</strong>", with: "").replacingOccurrences(of: "<ul>", with: "").replacingOccurrences(of: "<li>", with: "").replacingOccurrences(of: "</ul>", with: "").replacingOccurrences(of: "</li>", with: "")
        gameDescription.text = gameDes
        guard let age = game.minAge, let minPlayers = game.minPlayers, let maxPlayers = game.maxPlayers, let minPlaytime = game.minPlaytime, let maxPlaytime = game.maxPlaytime else {return}
        ageLabel.text = "Age: \(age)+"
        numberofPlayerLabel.text = "\(minPlayers) - \(maxPlayers) players"
        playtimeLabel.text = "Average Game Time: \t\(minPlaytime) - \(maxPlaytime) minutes"
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
//    private func getCategories() {
//        APIClient.getGameCategories { [weak self] (result) in
//            switch result {
//            case .failure(let error):
//                print("could not get categories from api error: \(error)")
//            case .success(let categories):
//                self?.categories = categories
//                DispatchQueue.main.async {
//                    for category in categories {
//                        self?.categoriesLabel.text = category.name
//                    }
//                }
//            }
//        }
//    }
//    private func getGameReviews(gameId: String) {
//        APIClient.getReviews(gameId: gameId) { [weak self] (result) in
//            switch result {
//            case .failure(let error):
//                print("unable to get user reviews \(error)")
//            case .success(let reviews):
//                self?.reviews = reviews.filter {$0.description != nil}
//            }
//        }
//    }
    private func checkCollections() {
        //guard let game = game else {return}
        DatabaseService.shared.isInUserOwnedCollection(collectedGame: game) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to check collection error: \(error.localizedDescription)")
            case .success(let result):
                self?.isGameInCollection = result
                if result == false {
                    self?.isUserOwned = false
                    self?.addToCollectionButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal, barMetrics: .default)
                } else {
                    self?.isUserOwned = true
                    self?.addToCollectionButton.setBackgroundImage(UIImage(systemName: "minus"), for: .normal, barMetrics: .default)
                }
            }
        }
        DatabaseService.shared.isInWishlistCollection(collectedGame: game) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to check collection error: \(error.localizedDescription)")
            case .success(let result):
                self?.isGameInCollection = result
                self?.isUserOwned = false
                if result == true {
                    self?.addToCollectionButton.setBackgroundImage(UIImage(systemName: "minus"), for: .normal, barMetrics: .default)
                } else {
                    self?.addToCollectionButton.setBackgroundImage(UIImage(systemName: "plus"), for: .normal, barMetrics: .default)
                }
            }
        }
        
    }
    
    @IBAction func gameRulesButtonPressed(_ sender: UIButton) {
        guard let rulesURL = game.rulesURL else {
            rulesButton.isHidden = true
            return
        }
        guard let url = URL(string: rulesURL) else {
            return
        }
        let safariPage = SFSafariViewController(url: url)
        present(safariPage, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isGameInCollection == false {
            guard let addToCollectionVC = segue.destination as? AddToCollectionViewController else {
                return
            }
            addToCollectionVC.game = game
        } else {
            DatabaseService.shared.removeFromCollection(userOwned: isUserOwned, collectedGame: nil, game: game) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Unable to delete at this time: \(error.localizedDescription)")
                    }
                case .success:
                    guard let game = self?.game else {return}
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Removed From Collection", message: "\(game.name) has been removed")
                    }
                }
            }
        }
        
    }
    
    
}

extension GameDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 11
        let maxSize: CGFloat = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 1
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
