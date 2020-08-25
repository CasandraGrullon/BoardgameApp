//
//  EditProfileViewController.swift
//  BoardgameApp
//
//  Created by casandra grullon on 5/13/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var displayEmailSegment: UISegmentedControl!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    private var selectedImage: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.profilePictureImageView.image = self.selectedImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Upload Profile Picture", message: nil, preferredStyle: .actionSheet)
        let photogallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           alertController.addAction(camera)
        }
        alertController.addAction(photogallery)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    @IBAction func doneEditingButtonPressed(_ sender: UIBarButtonItem) {
        guard let username = userNameTextField.text, !username.isEmpty, let profilePicture = selectedImage else {
            DispatchQueue.main.async {
                self.showAlert(title: "Missing Fields", message: "All fields are required")
            }
            return
        }
        
         let resizeImage = UIImage.resizeImage(originalImage: profilePicture, rect: profilePictureImageView.bounds)
        
        guard let user = Auth.auth().currentUser else { return }
        
        StorageService.shared.uploadPhoto(userId: user.uid, image: resizeImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Unable to upload photo", message: error.localizedDescription)
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = username
                request?.photoURL = url
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Could not save changes", message: "\(error)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Updated", message: "")
                        }
                        let profileVC = ProfilePageViewController()
                        self?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                })
            }
        }
        
    }
    

}
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
