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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCollectionViewDataSource()
        fetchGames(for: "catan")
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
        let topResults = Array(games[0...2])
        let low = Array(games[3...middleIndex])
        let high = Array(games[middleIndex + 1..<games.count])
        
        snapshot.appendItems(topResults, toSection: .main)
        snapshot.appendItems(low, toSection: .second)
        snapshot.appendItems(high, toSection: .third)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    //CollectionView
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
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
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Game>()
        snapshot.appendSections([.main, .second, .third])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

