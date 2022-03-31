//
//  Constants.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import Foundation
import UIKit

class Constants {
    class String {
        static let minLength = 8
        static let urlRandomImage = "https://source.unsplash.com/collection/1065412"
        static let key = "key"
    }
    
    class Colors {
        static let appMainColor = UIColor(red: 92 / 255,
                                          green: 47 / 255,
                                          blue: 99 / 255,
                                          alpha: 1)
    }
    
    class Image {
        static let iconTitle = UIImage(named: "icon")
        static let infoImage = UIImage(systemName: "gearshape.2.fill")
        static let infoRandomImage = UIImage(systemName: "line.3.horizontal")
        
        static let tabBarImagePhoto = UIImage(systemName: "photo.on.rectangle")
        static let tabBarImagePhotoFill = UIImage(systemName: "photo.on.rectangle.fill")
        static let tabBarImageRandom = UIImage(systemName: "photo.on.rectangle.angled")
        static let tabBarImageRandomFill = UIImage(systemName: "photo.on.rectangle.angled.fill")
        static let tabBarImageSearch = UIImage(systemName: "magnifyingglass")
        static let tabBarImageSearchFill = UIImage(systemName: "rectangle.and.text.magnifyingglass.rtl")
        static let tabBarImageProfile = UIImage(systemName: "person")
        static let tabBarImageProfileFill = UIImage(systemName: "person.fill")
    }
    
    class Dimensions {
        static let cellsSpacing = CGFloat(4)
        static let sectionHeight = CGFloat(4)
    }
    
}
