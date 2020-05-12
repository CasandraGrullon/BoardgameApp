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
    @IBOutlet weak var addFiltersButton: UIButton!
    @IBOutlet weak var allAgesButton: UIButton!
    @IBOutlet weak var childrenButton: UIButton!
    @IBOutlet weak var teensButton: UIButton!
    @IBOutlet weak var adultsButton: UIButton!
    @IBOutlet weak var twoFourButton: UIButton!
    @IBOutlet weak var fourSixButton: UIButton!
    @IBOutlet weak var sixPlusButton: UIButton!
    @IBOutlet weak var cheapButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var expensiveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
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
    private var isCellSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        configureCollectionView()
        clearButton.isHidden = true
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
    
    @IBAction func AgeButtonPressed(_ sender: UIButton) {
        clearButton.isHidden = false
        if sender == allAgesButton {
            allAgesButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            allAgesButton.tintColor = .white
            return
        } else if sender == childrenButton {
            filters.append("children")
            ageFilter.append("5")
            childrenButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            childrenButton.tintColor = .white
        } else if sender == teensButton {
            filters.append("teen")
            ageFilter.append("12")
            teensButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            teensButton.tintColor = .white
        } else if sender == adultsButton {
            filters.append("adults")
            ageFilter.append("17")
            adultsButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            adultsButton.tintColor = .white
        }
    }
    
    @IBAction func numberPlayersButtonPressed(_ sender: UIButton) {
        clearButton.isHidden = false
        if sender == twoFourButton {
            filters.append("2 - 4 players")
            numberOfPlayersFilter.append("4")
            twoFourButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            twoFourButton.tintColor = .white
        } else if sender == fourSixButton {
            filters.append("4 - 6 players")
            numberOfPlayersFilter.append("6")
            fourSixButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            fourSixButton.tintColor = .white
        } else if sender == sixPlusButton {
            filters.append("6 + players")
            numberOfPlayersFilter.append("10")
            sixPlusButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            sixPlusButton.tintColor = .white
        }
    }
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        clearButton.isHidden = false
        if sender == cheapButton {
            filters.append("$")
            priceFilter.append("10")
            cheapButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            cheapButton.tintColor = .white
        } else if sender == middleButton {
            filters.append("$$")
            priceFilter.append("30")
            middleButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            middleButton.tintColor = .white
        } else if sender == expensiveButton {
            filters.append("$$$")
            priceFilter.append("50")
            expensiveButton.backgroundColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
            expensiveButton.tintColor = .white
        }
    }

    @IBAction func addFiltersButtonPressed(_ sender: UIButton) {
        delegate?.didAddFilters(filters: filters, ageFilter: ageFilter, numberOfPlayersFilter: numberOfPlayersFilter, priceFilter: priceFilter, genreFilter: genreFilter, vc: self)
        dismiss(animated: true)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        filters.removeAll()
        priceFilter.removeAll()
        ageFilter.removeAll()
        numberOfPlayersFilter.removeAll()
        genreFilter.removeAll()
        isCellSelected = false
        expensiveButton.backgroundColor = .clear
        expensiveButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        middleButton.backgroundColor = .clear
        middleButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        cheapButton.backgroundColor = .clear
        cheapButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        twoFourButton.backgroundColor = .clear
        twoFourButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        fourSixButton.backgroundColor = .clear
        fourSixButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        sixPlusButton.backgroundColor = .clear
        sixPlusButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        allAgesButton.backgroundColor = .clear
        allAgesButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        childrenButton.backgroundColor = .clear
        childrenButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        teensButton.backgroundColor = .clear
        teensButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
        adultsButton.backgroundColor = .clear
        adultsButton.tintColor = #colorLiteral(red: 0.6345325112, green: 0.3519191146, blue: 1, alpha: 1)
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
        isCellSelected = true
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (completed) in
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                if self.isCellSelected {
                    cell?.transform = CGAffineTransform.identity
                    cell?.clipsToBounds = true
                    cell?.layer.borderColor = .init(srgbRed: 3, green: 0, blue: 3, alpha: 1)
                    cell?.layer.borderWidth = 3
                } else {
                    cell?.transform = CGAffineTransform.identity
                    cell?.clipsToBounds = true
                    cell?.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0)
                    cell?.layer.borderWidth = 0
                }
                
            })
        }
        
    }
    
    
}
