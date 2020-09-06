//
//  HomePageViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

//TODO: add loading spinner
// 1. home page, profile page and explore
class HomePageViewController: UIViewController {
    private var collectionView: UICollectionView!
    typealias Datasource = UICollectionViewDiffableDataSource< SectionKind, Game >
    private var dataSource: Datasource!
    private var searchController: UISearchController!
    
    //MARK:- Activity Indicator spinner and subview
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        spinner.center = CGPoint(x: loadingView.bounds.size.width / 2, y: loadingView.bounds.size.height / 2)
        spinner.color = #colorLiteral(red: 0, green: 0.805752337, blue: 1, alpha: 1)
        return spinner
    }()
    private lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        loadingView.center = self.view.center
        loadingView.backgroundColor = .clear
        loadingView.alpha = 0.7
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        return loadingView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showActivityIndicator(loadingView: loadingView, spinner: spinner)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCollectionViewDataSource()
        fetchGames(for: "")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        hideActivityIndicator(loadingView: loadingView, spinner: spinner)
    }
    //MARK: Fetch Games API Data
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
                    self?.hideActivityIndicator(loadingView: self!.loadingView, spinner: self!.spinner)
                }
            }
        }
    }
    //MARK:- Collection View Diffable Datasource snapshot
    private func updateSnapshot(with games: [Game]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main, .second, .third])

        // seperating games into sections by recent, highly rated, and price
        let featured = games.filter {$0.yearPublished ?? 0 >= 2018}
        let mostPopular = games.filter {$0.yearPublished ?? 0 <= 2017 && $0.averageUserRating >= 3.8 }
        let recommended = games.filter {!featured.contains($0) && !mostPopular.contains($0) && Int($0.price) ?? 0 < 60}
        
        snapshot.appendItems(featured, toSection: .main)
        snapshot.appendItems(mostPopular, toSection: .second)
        snapshot.appendItems(recommended, toSection: .third)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    //MARK:- CollectionView Config
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    //MARK:- CollectionView Compositional Layout
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
    //MARK:- Collection View Datasource config
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
            if sectionKind == .main {
                header.textLabel.text = "Featured"
            } else if sectionKind == .second {
                header.textLabel.text = "Most Popular"
            } else {
                header.textLabel.text = "Recommended"
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
//MARK:- CollectionView Delegate
extension HomePageViewController: UICollectionViewDelegate {
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
