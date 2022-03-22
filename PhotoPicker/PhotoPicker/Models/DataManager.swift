//
//  DataManager.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import Foundation
import FirebaseDatabase

class DataManager {
    static let shared = DataManager()
    private let reference = Database.database().reference()
    
    func isAvailableCreateNewUser(userName: String, email: String, password: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    func addNewUser(email: String, username: String, completion: @escaping (Bool) -> Void) {
        self.reference.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _  in
            completion(error==nil)
        }
    }
}
