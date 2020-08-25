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
    
    private var searchText = String() {
        didSet {
            DispatchQueue.main.async {
                self.fetchGames(for: self.searchText)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self?.updateSnapshot(with: games)
            }
        }
    }
    private func updateSnapshot(with games: [Game]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main, .second, .third])
        let middleIndex = games.count / 2
        guard middleIndex > 0 else {
            snapshot.appendItems(games, toSection: .second)
            return
        }
        let topResults = Array(games[0...2])
        let low = Array(games[3...middleIndex])
        let high = Array(games[middleIndex + 1..<games.count])
        
        snapshot.appendItems(topResults, toSection: .main)
        snapshot.appendItems(low, toSection: .second)
        snapshot.appendItems(high, toSection: .third)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    //searchController
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
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
    }
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                fatalError("unable to retrieve section kind")
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 5
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
                if sectionKind == .main {
                    header.textLabel.text = "Top Games"
                } else if sectionKind == .second {
                    header.textLabel.text = "Popular Games"
                } else {
                    header.textLabel.text = "More Games"
                }
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
