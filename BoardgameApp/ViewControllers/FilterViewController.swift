//
//  FilterViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

protocol FiltersAdded {
    func didAddFilters(filters: [String], vc: FilterViewController)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var ageSegment: UISegmentedControl!
    @IBOutlet weak var playersSegment: UISegmentedControl!
    @IBOutlet weak var priceSegement: UISegmentedControl!
    @IBOutlet weak var addFiltersButton: UIButton!
    
    public var delegate: FiltersAdded?
    public var filters = [String]()
    public var genres = [Genre]() {
        didSet {
            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        configureCollectionView()
    }
    private func configureCollectionView() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
    }
    private func getCategories() {
        DatabaseService.shared.getGenres { [weak self] (result) in
            switch result {
            case .failure(let genreError):
                print("could not get genres from firebase \(genreError.localizedDescription)")
            case .success(let genres):
                self?.genres = genres.sorted {$0.name < $1.name}
            }
        }
    }
    
    @IBAction func ageSegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filters.append("all ages")
        } else if sender.selectedSegmentIndex == 1 {
            filters.append("ages 5 - 10")
        } else if sender.selectedSegmentIndex == 2 {
            filters.append("ages 10 +")
        } else if sender.selectedSegmentIndex == 3 {
            filters.append("ages 18 +")
        }
    }
    
    @IBAction func playersSegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filters.append("2 - 4 players")
        } else if sender.selectedSegmentIndex == 1 {
            filters.append("5 - 6 players")
        } else if sender.selectedSegmentIndex == 2 {
            filters.append("6 + players")
        }
    }
    @IBAction func priceSegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filters.append("$")
        } else if sender.selectedSegmentIndex == 1 {
            filters.append("$$")
        } else if sender.selectedSegmentIndex == 2 {
            filters.append("$$$")
        }
    }
    @IBAction func addFiltersButtonPressed(_ sender: UIButton) {
        delegate?.didAddFilters(filters: filters, vc: self)
        dismiss(animated: true)
    }
    
    
}
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 4
        let maxSize: CGFloat = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 2
        let totalSpace: CGFloat = (numberOfItems * itemSpacing) * 2.5
        let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
    }
}
extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCell else {
            fatalError("could not cast to genre cell")
        }
        let genre = genres[indexPath.row]
        cell.configureCell(genre: genre)
        return cell
    }
    
    
}
