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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {return}
        userNameLabel.text = user.displayName
        userEmailLabel.text = user.email
    }

    @IBAction func editProfileButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}
