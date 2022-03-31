//
//  Photo.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 24.03.22.
//

import Foundation
import UIKit

struct Photo {
    enum Error: String, Error {
        case CouldntGetImageData = "Couldn't get data from iamge"
        case CouldntWriteImageData = "Couldn't write image data"
    }

    let image: UIImage
    let label: String

    init(image: UIImage, label: String) {
        self.image = image
        self.label = label
    }

    init?(filePath: NSURL) {
        if let image = UIImage(
            contentsOfFile: filePath.relativePath!
            )
        {
            let label = filePath.deletingPathExtension?
                .lastPathComponent ?? ""
            self.init(image: image, label: label)
        }
        else {
           return nil
        }
    }

    func saveToDirectory(directory: NSURL) throws {
        let timeStamp = "\(NSDate().timeIntervalSince1970)"
        let fullDirectory = directory
            .appendingPathComponent(timeStamp)
        try NSFileManager.defaultManager.createDirectoryAtURL(
            fullDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        let fileName = "\(self.label).jpg"
        let filePath = fullDirectory
            .URLByAppendingPathComponent(fileName)
        if let data = UIImageJPEGRepresentation(self.image, 1) {
            if !data.writeToURL(filePath, atomically: true) {
                throw Error.CouldntWriteImageData
            }
        }
        else {
            throw Error.CouldntGetImageData
        }
    }
}
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About


class PhotoStore: NSObject {
    var photos = [Photo]()
    var cellForPhoto:
        (Photo, NSIndexPath) -> UICollectionViewCell

    init(
        cellForPhoto: (Photo,NSIndexPath) -> UICollectionViewCell
        )
    {
        self.cellForPhoto = cellForPhoto

        super.init()
    }

    func saveNewPhotoWithImage(
        image: UIImage,
        labeled label: String
        ) throws -> NSIndexPath
    {
        let photo = Photo(image: image, label: label)
        try photo.saveToDirectory(self.getSaveDirectory())
        self.photos.append(photo)
        return NSIndexPath(
            forItem: self.photos.count - 1,
            inSection: 0
        )
    }

    func loadPhotos() throws {
        self.photos.removeAll(keepCapacity: true)

        let fileManager = NSFileManager.defaultManager()
        let saveDirectory = try self.getSaveDirectory()
        let enumerator = fileManager.enumeratorAtPath(
            saveDirectory.relativePath!
        )
        while let file = enumerator?.nextObject() as? String {
            let fileType = enumerator!.fileAttributes![NSFileType]
                as! String
            if fileType == NSFileTypeRegular {
                let fullPath = saveDirectory
                    .URLByAppendingPathComponent(file)
                if let photo = Photo(filePath: fullPath) {
                    self.photos.append(photo)
                }
            }
        }
    }
}

extension PhotoStore: UICollectionViewDataSource {
    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int
    {
        return self.photos.count
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
        ) -> UICollectionViewCell
    {
        let photo = self.photos[indexPath.item]
        return self.cellForPhoto(photo, indexPath)
    }
}

private extension PhotoStore {
    func getSaveDirectory() throws -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        return try fileManager.URLForDirectory(
            .DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: true
        )
    }
}
