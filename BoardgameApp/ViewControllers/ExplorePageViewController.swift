//
//  ExplorePageViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ExplorePageViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    private var games = [Game]() {
        didSet {
            DispatchQueue.main.async {
                self.gamesCollectionView.reloadData()
            }
        }
    }
    private var searchQuery = "" {
        didSet {
            self.getGames(search: searchQuery)
        }
    }
    private var filters = [String]() {
        didSet {
//            for filter in filters {
//                games.filter {$0.}
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGames(search: "")
        configureCollectionView()
    }
    private func configureCollectionView() {
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        gamesCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
    }
    
    private func getGames(search: String) {
        BoardGameAPIClient.getGames(searchQuery: search) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Unable to get data", message: "issue loading data from api \(appError)")
                }
            case .success(let games):
                self?.games = games
            }
        }
    }

}
extension ExplorePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let maxSize: CGFloat = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 2
        let totalSpace: CGFloat = (numberOfItems * itemSpacing) * 2.5
        let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
extension ExplorePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = gamesCollectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else {
            fatalError("could not cast to GameCell")
        }
        let game = games[indexPath.row]
        cell.configureCell(game: game)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(identifier: "GameDetailViewController") as? GameDetailViewController else {
            print("could not segue to GameDetailViewController")
            return
        }
        detailVC.game = game
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}
