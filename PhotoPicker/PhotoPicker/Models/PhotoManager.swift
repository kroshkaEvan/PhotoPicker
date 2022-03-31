//
//  PhotoManager.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 24.03.22.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class PhotoService {
    
    static func retrievePhoto(completion: @escaping([Photo]) -> Void) {
    
        let db = Firestore.firestore()
        
        db.collection("photos").getDocuments { (snapshot, error) in
            
            if error != nil {return}
            
            var photos = [Photo]()
            
            let documents = snapshot?.documents
            if let documents = documents {
                
                for doc in documents {
                    
                    let p = Photo(snapshot: doc)
                    if p != nil {
                        photos.insert(p!, at: 0)
                    }
                    
                }
            }
            completion(photos)
        }
        
    }
    
    
    static func savePhoto(selectedImage: UIImage, completion: @escaping(Double) -> Void) {
        
        let photoData = selectedImage.jpegData(compressionQuality: 1)
        if photoData == nil {return}
        
        let filename = UUID().uuidString
        
        let userId = Auth.auth().currentUser?.uid
        if userId == nil {return}
        
        let ref = Storage.storage().reference().child("images/\(userId!)/\(filename)")
        
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
             
            if error == nil {
                
                createDatabaseEntry(ref: ref)
            }
        }
        uploadTask.observe(.progress) { (taskSnapshot) in
            
            let pct = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            
            completion(pct)
        }
        
    }
    
    static private func createDatabaseEntry(ref: StorageReference) {
        
        ref.downloadURL { (url, error) in
            if error == nil {
                
                let photoId = ref.fullPath
                
                let user = LocalStorageService.loadUser()
                
                let userId = user?.userId
                let username = user?.username
                
                let df = DateFormatter()
                df.dateStyle = .full
                let date = df.string(from: Date())
                
                let metadata = ["photoId": photoId, "byId": userId, "byUsername" : username, "date": date , "url": url!.absoluteString]
                
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    
                    if error != nil {
                        return
                    }
                }
            }

        }
    }
}

