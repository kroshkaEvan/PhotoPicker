//
//  Constants.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import Foundation
import UIKit

class Constants {
    class Strings {
        static let minLength = 8
        static let urlRandomImage = "https://source.unsplash.com/collection/1065412"
        static let key = "key"
        static let searchBar = "Please enter search term above..."
        static let share = "Share image"
        static let delete = "Delete image"
        static let cancel = "Cancel"
        static let title = "How would you like to add a photo?"
        static let takePhoto = "Take photo"
        static let settings = "Settings"
        static let select = "Select photo from the library"
        static let help = "Help"
        static let web = "Web page"
        static let logOut = "Log Out"
        static let logOutMessage = "Log out of your account?"
        static let errorAllFields = "Fill in all fields"
        static let errorPassword = "Lenght of password is less than 8 charcters"
        static let back = "Back"
        static let uhOh = "Uh - oh"
        static let email = "Enter your email"
        static let newPassword = "Сreate new password"
        static let newUser = "Create new username"
        static let signUp = "Sign up"
        static let passwordPlaceholder = "Password"
        static let name = "Name"
        static let chooseName = "Choose username"
        static let errorLogIn = "You couldn't log in, check your password or create an account"
        static let registr = "Don't have an account? Sign up."
        static let logIn = "Log In"
    }
    
    class API {
        static let key = "Client-ID Bg_ep4mL28r_uBtCkchSoJySsiPMWV4c7kLoa392r2k"
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
        
        static let checkMark = UIImage(systemName: "checkmark.circle.fill")
        static let hurts = UIImage(systemName: "heart.fill")

    }
    
    class Dimensions {
        static let cellsSpacing = CGFloat(4)
        static let sectionHeight = CGFloat(4)
        static let unsplashSize = CGFloat(20)
    }
}
