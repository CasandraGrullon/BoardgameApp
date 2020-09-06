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
    
    private var collections = ["My Games", "Wishlist"] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        doneButton.isEnabled = false
    }
    //MARK:- CollectionView config
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    //MARK:- Function to add a game to a collection
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if selectedCollection == "My Games" {
            DatabaseService.shared.addToCollection(userGames: game, wishlist: nil) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Could not save to collection at this time", message: "error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Saved to Your Games Collection", message: "\(self?.game?.name ?? "") is now in your collection", completion: { (action) in
                            self?.dismiss(animated: true)
                        })
                    }
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
                        self?.showAlert(title: "Saved to your Wishlist", message: "\(self?.game?.name ?? "") is now in wishlist", completion: { (action) in
                            self?.dismiss(animated: true)
                        })
                    }
                }
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
//MARK:- CollectionView delegate and datasource
extension AddToCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = view.frame.width
        let adjustedWidth = CGFloat(maxWidth * 0.5)
        return CGSize(width: adjustedWidth, height: adjustedWidth * 0.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
        cell.collectionNameLabel.numberOfLines = 0
        cell.collectionNameLabel.text = collection
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.805752337, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 13
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doneButton.isEnabled = true
        let selectedCell = collections[indexPath.row]
        selectedCollection = selectedCell
    }
}
