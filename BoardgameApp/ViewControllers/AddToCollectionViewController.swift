//
//  AddToCollectionViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 5/13/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class AddToCollectionViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var game: Game?
    private var selectedCollection: String?
    
    private var collections = ["Your Games", "Wishlist"] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        doneButton.isEnabled = false
    }
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if selectedCollection == "Your Games" {
            DatabaseService.shared.addToCollection(userGames: game, wishlist: nil) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Could not save to collection at this time", message: "error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Saved to Your Games Collection", message: "\(self?.game?.name ?? "") is now in your collection")
                    }
                    self?.dismiss(animated: true)
                }
            }
            
        } else if selectedCollection == "Wishlist" {
            DatabaseService.shared.addToCollection(userGames: nil, wishlist: game) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Could not save to collection at this time", message: "error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Saved to your Wishlist", message: "\(self?.game?.name ?? "") is now in wishlist")
                    }
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
extension AddToCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 3
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
extension AddToCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionCell else {
            fatalError("could not cast to collectioncell")
        }
        let collection = collections[indexPath.row]
        cell.collectionNameLabel.text = collection
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.4936085343, green: 0.9875773787, blue: 1, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.805752337, blue: 1, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doneButton.isEnabled = true
        let selectedCell = collections[indexPath.row]
        selectedCollection = selectedCell
    }
    
    
}
