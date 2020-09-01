//
//  ProfilePageViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfilePageViewController: UIViewController {
        
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var listener: ListenerRegistration?
    
    private var collectedGames = [CollectedGame]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.collectedGames.isEmpty {
                    self.collectionView.backgroundView = EmptyView(title: "This Collection is Empty", message: "Add to your collections by pressing the plus button a game's page")
                } else {
                    self.collectionView.reloadData()
                    self.collectionView.backgroundView = nil
                }
            }
        }
    }
    private var userOwned = true {
        didSet {
            getUserCollection(userOwned: userOwned)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCollection(userOwned: userOwned)
        configureNavBar()
        updateUI()
        configureCollectionView()
        segmentController.selectedSegmentIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.userGamesCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                print("error getting users game collection \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                let savedGames = snapshot.documents.compactMap {CollectedGame ($0.data())}.filter {$0.userOwned == self?.userOwned}
                self?.collectedGames = savedGames
            }
        })
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {return}
        userNameLabel.text = user.displayName
        userEmailLabel.text = user.email
        profileImageView.kf.setImage(with: user.photoURL)
    }
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
    }
    private func configureNavBar() {
        navigationItem.title = "Your Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(editProfileButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonPressed(_:)))
    }
    @objc private func editProfileButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "MainAppStoryboard", bundle: nil)
        let editProfileVC = storyboard.instantiateViewController(identifier: "EditProfileViewController")
        modalPresentationStyle = .fullScreen
        present(UINavigationController(rootViewController: editProfileVC), animated: true)
    }
    private func getUserCollection(userOwned: Bool) {
        DatabaseService.shared.getCollection(userOwned: userOwned) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not get user collection: \(error.localizedDescription)")
            case .success(let collected):
                self?.collectedGames = collected
            }
        }
    }
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userOwned = true
        } else if sender.selectedSegmentIndex == 1 {
            userOwned = false
        }
    }
    @objc private func signOutButtonPressed(_ sender: UIBarButtonItem) {
        UIViewController.showViewController(storyboardName: "Main", viewcontrollerID: "LoginViewController")
    }
}
extension ProfilePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = view.frame.width
        let maxHeight = view.frame.height
        let adjustedWidth = CGFloat(maxWidth * 0.3)
        let adjustedHeight = CGFloat(maxHeight / 6)
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
extension ProfilePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else {
            fatalError("unable to cast to game cell")
        }
        let collected = collectedGames[indexPath.row]
        cell.configureCell(collected: collected)
        cell.collectedGame = collected
        cell.userOwned = userOwned
        cell.delegate = self
        return cell
    }
}
extension ProfilePageViewController: RemoveGameDelegate {
    func gameRemovedFromCollection(_ game: CollectedGame, userOwned: Bool, cell: GameCell) {
        DatabaseService.shared.removeFromCollection(userOwned: userOwned, collectedGame: game) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Unable to remove from collection at this time error: \(error.localizedDescription)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Game Removed", message: "\(game.gameName) was successfully removed from your collection", completion: { (action) in
                        self?.collectionView.reloadData()
                    })
                }
            }
        }
    }
    
    
}
