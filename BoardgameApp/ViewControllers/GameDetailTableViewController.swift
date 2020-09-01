//
//  GameDetailViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import SafariServices

class GameDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
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
    
    private weak var flowLayout: UICollectionViewFlowLayout!
    
    public var game: Game
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
        configureCollectionView()
        uiAsync()
        checkCollections()
    }
    private func configureCollectionView() {
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        
        if let flowLayout = flowLayout,
            let collectionView = reviewsCollectionView {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
    }
    private func uiAsync() {
        DispatchQueue.main.async {
            self.updateUI()
            self.getGameReviews(gameId: self.game.id)
            self.configureNavBar()
        }
    }
    private func getGameReviews(gameId: String) {
        APIClient().fetchGameReviews(gameId: gameId) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to get user reviews \(error)")
            case .success(let reviews):
                self?.reviews = reviews.filter {$0.description != nil && $0.title != nil}.sorted {$0.date > $1.date}
            }
        }
    }
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.805752337, blue: 1, alpha: 1)
        navigationItem.title = game.name
        if isGameInCollection {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: self, action: #selector(removeFromCollectionButtonPressed(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addToCollectionButtonPressed(_:)))
        }
    }
    private func updateUI() {
        guard game.rulesURL != nil else {
            rulesButton.isHidden = true
            return
        }
        gameImageView.kf.setImage(with: URL(string: game.imageURL))
        nameLabel.text = game.name
        priceLabel.text = "$\(game.price)"
        gameDescription.text = game.description.formatString()
        guard let age = game.minAge, let minPlayers = game.minPlayers, let maxPlayers = game.maxPlayers, let minPlaytime = game.minPlaytime, let maxPlaytime = game.maxPlaytime else {return}
        ageLabel.text = "Ages: \(age)+"
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
    private func checkCollections() {
        DatabaseService.shared.isInUserOwnedCollection(collectedGame: game) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to check collection error: \(error.localizedDescription)")
            case .success(let result):
                self?.isGameInCollection = result
                if result == false {
                    self?.isUserOwned = false
                } else {
                    self?.isUserOwned = true
                }
            }
        }
    }
    
    @IBAction func gameRulesButtonPressed(_ sender: UIButton) {
        guard let rulesURL = game.rulesURL else {
            return
        }
        guard let url = URL(string: rulesURL) else {
            return
        }
        let safariPage = SFSafariViewController(url: url)
        present(safariPage, animated: true)
    }
    
    @objc private func addToCollectionButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "MainAppStoryboard", bundle: nil)
        let addToCollection = storyboard.instantiateViewController(identifier: "AddToCollectionViewController") { (coder) in
            return AddToCollectionViewController(coder: coder)
        }
        addToCollection.game = game
        addToCollection.modalPresentationStyle = .popover
        addToCollection.view.bounds.size = CGSize(width: view.bounds.width, height: view.bounds.height / 2)
        present(addToCollection, animated: true)
    }
    @objc private func removeFromCollectionButtonPressed(_ sender: UIBarButtonItem) {
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

extension GameDetailTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = view.frame.width
        let maxHeight = view.frame.height
        let adjustedWidth = CGFloat(maxWidth * 0.9)
        let adjustedHeight = CGFloat(maxHeight / 5)
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
extension GameDetailTableViewController: UICollectionViewDataSource {
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

