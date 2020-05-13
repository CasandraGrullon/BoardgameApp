//
//  ProfilePageViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureCollectionView()
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
    

    
}
extension ProfilePageViewController: UICollectionViewDelegateFlowLayout {
    
}
extension ProfilePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else {
            fatalError("unable to cast to game cell")
        }
        return cell
    }
    
    
}
