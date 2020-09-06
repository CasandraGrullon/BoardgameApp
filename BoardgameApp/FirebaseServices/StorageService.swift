//
//  StorageService.swift
//  BoardgameApp
//
//  Created by casandra grullon on 4/28/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    private let storageRef = Storage.storage().reference()
    
    private init() {}
    
    public static let shared = StorageService()
    
    //MARK:- Method to store user profile image to firebase
    public func uploadPhoto(userId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> () ){
        //1. make an instance of the image data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        //2. make an instance to the Storage Reference
        var photoReference: StorageReference!
        
        //3. need to unwrap the userID to store the photo on firebase
        if let userId = userId {
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        }
        //4. StorageMetadata of type jpg
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        //5. method to download user's photo to firebase
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
