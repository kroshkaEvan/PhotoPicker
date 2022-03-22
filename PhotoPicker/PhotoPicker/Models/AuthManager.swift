//
//  AuthManager.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    
    func registrationNewUser(userName: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        DataManager.shared.isAvailableCreateNewUser(userName: userName,
                                                    email: email,
                                                    password: password) { isAvailable in
            if isAvailable {
                Auth.auth().createUser(withEmail: email,
                                       password: password) { result, error in
                    guard result != nil, error == nil else {
                        completion(false)
                        return
                    }
                    DataManager.shared.addNewUser(email: email,
                                                  username: userName) { successfulInserted in
                        if successfulInserted {
                            completion(true)
                            return
                        } else {
                            completion(false )
                            return
                        }
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func loginUser(userName: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email,
                               password: password) { result, error in
                guard result != nil, error == nil else  {
                    completion(false)
                    return
                }
                completion(true)
            }
        } else if let userName = userName {
            print(userName)
        }
    }
    
    func getLogOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            completion(false)
            print(error)
            return
        }
    }
}
