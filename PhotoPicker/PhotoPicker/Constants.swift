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
    }
    
    class Dimensions {
        static let cellsSpacing = CGFloat(4)
        static let sectionHeight = CGFloat(4)
    }
}
