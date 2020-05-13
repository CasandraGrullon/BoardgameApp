//
//  EditProfileViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 5/13/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: DesignableImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var displayEmailSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
    }
    @IBAction func doneEditingButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}
