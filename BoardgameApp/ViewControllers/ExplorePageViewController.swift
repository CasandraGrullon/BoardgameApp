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
    public var addedFilters = [String]() {
        didSet {
            filtersCollectionView.reloadData()
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
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filterVC = segue.destination as? FilterViewController else {
            fatalError("could not segue to FilterVC")
        }
        filterVC.delegate = self
    }
    
}
extension ExplorePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == gamesCollectionView {
            let itemSpacing: CGFloat = 10
            let maxSize: CGFloat = UIScreen.main.bounds.size.width
            let numberOfItems: CGFloat = 2
            let totalSpace: CGFloat = (numberOfItems * itemSpacing) * 2.5
            let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            let itemSpacing: CGFloat = 2
            let maxSize: CGFloat = UIScreen.main.bounds.size.width
            let numberOfItems: CGFloat = 3
            let totalSpace: CGFloat = (numberOfItems * itemSpacing) * 1.5
            let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
            return CGSize(width: itemWidth, height: itemWidth)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == gamesCollectionView {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else {
             return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
}
extension ExplorePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gamesCollectionView {
             return games.count
        } else {
            return addedFilters.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gamesCollectionView {
            guard let cell = gamesCollectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else {
                fatalError("could not cast to GameCell")
            }
            let game = games[indexPath.row]
            cell.configureCell(game: game)
            return cell
        } else {
            guard let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? FilterCell else {
                fatalError("could not cast to filter cell")
            }
            let filter = addedFilters[indexPath.row]
            cell.filterNameLabel.text = filter
            return cell
        }
        
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
extension ExplorePageViewController: FiltersAdded {
    func didAddFilters(filters: [String], ageFilter: [String], numberOfPlayersFilter: [String], priceFilter: [String], genreFilter: [String], vc: FilterViewController) {
        addedFilters = filters
        guard let minAge = Int(ageFilter.first ?? "0"),
            let minPlayers = Int(numberOfPlayersFilter.first ?? "2"), let maxPlayers = Int(numberOfPlayersFilter.last ?? "6"),
            let price = Double(priceFilter.first ?? "10.00"),
            let genre = genreFilter.first else {
            return
        }
        games = games.filter {$0.minAge == minAge}.filter {$0.minPlayers == minPlayers}.filter {$0.maxPlayers == maxPlayers}.filter {$0.categories.first?.id == genre}
        
    }
    
    
}
