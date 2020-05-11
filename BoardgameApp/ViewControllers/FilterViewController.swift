//
//  FilterViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

protocol FiltersAdded {
    func didAddFilters(filters: [String], ageFilter: [String], numberOfPlayersFilter: [String], priceFilter: [String], genreFilter: [String], vc: FilterViewController)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var ageSegment: UISegmentedControl!
    @IBOutlet weak var playersSegment: UISegmentedControl!
    @IBOutlet weak var priceSegement: UISegmentedControl!
    @IBOutlet weak var addFiltersButton: UIButton!
    
    public var delegate: FiltersAdded?
    public var filters = [String]()
    public var ageFilter = [String]()
    public var numberOfPlayersFilter = [String]()
    public var priceFilter = [String]()
    public var genreFilter = [String]()
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
            ageFilter.append("0")
        } else if sender.selectedSegmentIndex == 1 {
            filters.append("children")
            ageFilter.append("5")
            ageFilter.append("10")
        } else if sender.selectedSegmentIndex == 2 {
            filters.append("teen")
            ageFilter.append("11")
            ageFilter.append("17")
        } else if sender.selectedSegmentIndex == 3 {
            filters.append("adult")
            ageFilter.append("18")
        }
    }
    
    @IBAction func playersSegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filters.append("2 - 4 players")
            numberOfPlayersFilter.append("2")
            numberOfPlayersFilter.append("4")
        } else if sender.selectedSegmentIndex == 1 {
            filters.append("5 - 6 players")
            numberOfPlayersFilter.append("5")
            numberOfPlayersFilter.append("6")
        } else if sender.selectedSegmentIndex == 2 {
            filters.append("6 + players")
            numberOfPlayersFilter.append("6")
        }
    }
    @IBAction func priceSegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filters.append("$")
            priceFilter.append("10")
        } else if sender.selectedSegmentIndex == 1 {
            filters.append("$$")
            priceFilter.append("20")
        } else if sender.selectedSegmentIndex == 2 {
            filters.append("$$$")
            priceFilter.append("40")
        }
    }
    @IBAction func addFiltersButtonPressed(_ sender: UIButton) {
        delegate?.didAddFilters(filters: filters, ageFilter: ageFilter, numberOfPlayersFilter: numberOfPlayersFilter, priceFilter: priceFilter, genreFilter: genreFilter, vc: self)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.row]
        genreFilter.append(genre.id)
        filters.append(genre.name)
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (completed) in
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell?.transform = CGAffineTransform.identity
                cell?.clipsToBounds = true
                cell?.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 3, alpha: 1)
                cell?.layer.borderWidth = 5
            })
        }
        
    }
    
    
}
