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
    @IBOutlet weak var gamesCollectionTopAnchor: NSLayoutConstraint!
    
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
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGames(search: "")
        configureCollectionView()
        configureRefresh()
        filtersCollectionView.isHidden = true
        
    }
    private func configureRefresh() {
        searchBar.delegate = self
        refreshControl = UIRefreshControl()
        gamesCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    private func configureCollectionView() {
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        gamesCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
    }
    @objc private func loadData() {
        getGames(search: "")
        addedFilters.removeAll()
    }
    private func getGames(search: String) {
        BoardGameAPIClient.getGames(searchQuery: search) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Unable to get data", message: "issue loading data from api \(appError)")
                    self?.refreshControl.endRefreshing()
                }
            case .success(let games):
                self?.games = games
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
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
extension ExplorePageViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
}
extension ExplorePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == gamesCollectionView {
            let itemSpacing: CGFloat = 5
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
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
            cell.filter = filter
            cell.delegate = self
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
        filtersCollectionView.isHidden = false
        var gamesFiltered = [Game]()
        
        if let genre = genreFilter.first {
            gamesFiltered = games.filter {$0.categories.first?.id == genre}
        }
        if let age = Int(ageFilter.first ?? "0") {
            gamesFiltered = games.filter {$0.minAge == age}
        }
        if let maxPlayers = Int(numberOfPlayersFilter.first ?? "6") {
            gamesFiltered = games.filter {$0.maxPlayers == maxPlayers}
        }
        if let price = priceFilter.first {
            gamesFiltered = games.filter {Double($0.price) ?? 0 <= Double(price) ?? 0}
        }
        
        games = gamesFiltered
        
    }
    
    
}
extension ExplorePageViewController: RemoveFilter {
    func tappedRemoveButton(cell: FilterCell, filter: String) {
        for (index, filters) in addedFilters.enumerated() {
            if filters == filter {
                addedFilters.remove(at: index)
            }
        }
        // TODO: need to add functionality
        //removes the filter from the filters collection view, but that will not update the games collectionview
        
    }
    
}
