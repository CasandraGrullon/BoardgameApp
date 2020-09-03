//
//  ExplorePageViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ExplorePageViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    typealias Datasource = UICollectionViewDiffableDataSource< SectionKind, Game >
    private var dataSource: Datasource!
    private var searchController: UISearchController!
    
    private var searchText = "" {
        didSet {
            DispatchQueue.main.async {
                self.fetchGames(for: self.searchText)
            }
        }
    }
    private var setFilter = Bool()
    private var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        configureCollectionViewDataSource()
        configureSearchController()
        fetchGames(for: "")
    }
    // API data
    private func fetchGames(for query: String) {
        APIClient().fetchGames(for: query) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "API Error", message: "\(error.localizedDescription)")
                }
            case .success(let games):
                DispatchQueue.main.async {
                    self?.updateSnapshot(with: games)
                    self?.games = games
                }
            }
        }
    }
    // datasource snapshot
    private func updateSnapshot(with games: [Game]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main, .second, .third])
        let middleIndex = games.count / 2
        guard middleIndex > 0 else {
            snapshot.appendItems(games, toSection: .second)
            return
        }
        let topResults = Array(games[0...3])
        let low = Array(games[4...middleIndex])
        let high = Array(games[middleIndex + 1..<games.count])
        
        snapshot.appendItems(topResults, toSection: .main)
        snapshot.appendItems(low, toSection: .second)
        snapshot.appendItems(high, toSection: .third)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.805752337, blue: 1, alpha: 1)
        navigationItem.title = "Explore"
        if setFilter {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(filterButtonPressed(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonPressed(_:)))
        }
    }
    //searchController
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search by game name"
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
    }
    //CollectionView
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.resignFirstResponder()
    }
    @objc private func filterButtonPressed(_ sender: UIBarButtonItem) {
        fetchGames(for: "")
        let storyboard = UIStoryboard(name: "MainAppStoryboard", bundle: nil)
        let filtersVC = storyboard.instantiateViewController(identifier: "FilterViewController") { (coder) in
            return FilterViewController(coder: coder)
        }
        filtersVC.delegate = self
        present(UINavigationController(rootViewController: filtersVC) , animated: true)
    }
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                fatalError("unable to retrieve section kind")
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 6
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: sectionKind.itemCount)
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: sectionKind.nestedGroupHeight)
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [innerGroup])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = sectionKind.orthogonalBehaviour
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    private func configureCollectionViewDataSource() {
        dataSource = Datasource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, game) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier, for: indexPath) as? GameCell else {
                fatalError("could not dequeue Game Cell")
            }
            cell.configureCell(game: game)
            return cell
        })
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView, let sectionKind = SectionKind(rawValue: indexPath.section) else {
                fatalError("could not dequeue header view")
            }
            if self.searchText.isEmpty {
                header.textLabel.text = ""
            } else {
                header.textLabel.text = sectionKind.sectionTitle
            }
            header.textLabel.textColor = .systemGray2
            header.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return header
        }
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Game>()
        snapshot.appendSections([.main, .second, .third])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
extension ExplorePageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        searchText = text
    }
}
extension ExplorePageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainAppStoryboard", bundle: nil)
        if let game = dataSource.itemIdentifier(for: indexPath) {
            let detailVC = storyboard.instantiateViewController(identifier: "GameDetailTableViewController") { (coder) in
                return GameDetailTableViewController(coder: coder, game: game)
            }
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
extension ExplorePageViewController: FiltersAdded {
    func didAddFilters(ageFilter: [String], numberOfPlayersFilter: [String], priceFilter: [String], playtimeFilter: [String], filterSet: Bool, vc: FilterViewController) {
        setFilter = filterSet
        if setFilter {
            for filter in priceFilter {
                games = games.filter {$0.price <= filter}
            }
            for filter in ageFilter {
                games = games.filter {$0.minAge ?? 0 <= Int(filter) ?? 0}
            }
            for filter in numberOfPlayersFilter {
                games = games.filter {$0.minPlayers ?? 0 == Int(filter) ?? 0}
            }
            for filter in playtimeFilter {
                games = games.filter {$0.maxPlaytime ?? 0 == Int(filter) ?? 0}
            }
            updateSnapshot(with: games)
        }
    }
}
