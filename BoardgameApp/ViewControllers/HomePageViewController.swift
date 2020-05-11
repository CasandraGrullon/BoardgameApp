//
//  HomePageViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class HomePageViewController: UITableViewController {

    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    private var featuredGames = [Game]() {
        didSet {
            DispatchQueue.main.async {
                self.featuredCollectionView.reloadData()
            }
        }
    }
    private var newGames = [Game]() {
        didSet {
            DispatchQueue.main.async {
                self.newCollectionView.reloadData()
            }
        }
    }
    private var popularGames = [Game]() {
        didSet {
            DispatchQueue.main.async {
                self.popularCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGames()
        configureCollectionViews()
    }
    private func configureCollectionViews() {
        newCollectionView.delegate = self
        newCollectionView.dataSource = self
        newCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        
        featuredCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        featuredCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        
    }
    
    private func getGames() {
        BoardGameAPIClient.getGames(searchQuery: "") { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Unable to get data", message: "issue loading data from api \(appError)")
                }
            case .success(let games):
                self?.featuredGames = games.filter {$0.minAge == 13}
                self?.newGames = games.filter {$0.yearPublished == 2019}
                self?.popularGames = games.filter {$0.averageUserRating > 3.5}
            }
        }
    }

}
extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 11
        let maxSize: CGFloat = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 2
        let totalSpace: CGFloat = (numberOfItems * itemSpacing) * 2.5
        let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
}
extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = Int()
        if collectionView == newCollectionView {
            count = newGames.count
        } else if collectionView == featuredCollectionView {
            count = featuredGames.count
        } else if collectionView == popularCollectionView {
            count = popularGames.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else {
            fatalError("could not cast to gameCell")
        }
        if collectionView == newCollectionView {
            let newGame = newGames[indexPath.row]
            cell.configureCell(game: newGame)
        } else if collectionView == featuredCollectionView {
            let featuredGame = featuredGames[indexPath.row]
            cell.configureCell(game: featuredGame)
        } else if collectionView == popularCollectionView {
            let popularGame = popularGames[indexPath.row]
            cell.configureCell(game: popularGame)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "GameDetailViewController") as? GameDetailViewController else {
            print("could not segue to GameDetailViewController")
            return
        }
        if collectionView == newCollectionView {
            let game = newGames[indexPath.row]
            detailVC.game = game
        } else if collectionView == featuredCollectionView {
            let game = featuredGames[indexPath.row]
            detailVC.game = game
        } else if collectionView == popularCollectionView {
            let game = popularGames [indexPath.row]
            detailVC.game = game
        }
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}
