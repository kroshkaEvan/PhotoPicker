//
//  DataManager.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import Foundation
import FirebaseDatabase
import UIKit

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}

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
    
    func save(item: Image) {
        var array = DataManager.shared.loadImagesArray()
        array.insert(item, at: 0)
        UserDefaults.standard.set(encodable: array, forKey: Constants.Strings.key)
    }
    
    func loadImagesArray() -> [Image] {
        let array = UserDefaults.standard.value([Image].self, forKey: Constants.Strings.key)
        return array ?? []
    }
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }}
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func loadImage(fileName:String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func deleteAt(index: Int) {
        var array = loadImagesArray()
        array.remove(at: index)
        update(items: array)
    }
    
    func update(items: [Image]) {
        UserDefaults.standard.set(encodable: items, forKey: Constants.Strings.key)
    }
}
