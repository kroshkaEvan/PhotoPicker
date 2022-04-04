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
        static let searchBar = "Please enter search term above...".localizated()
        static let share = "Share image".localizated()
        static let delete = "Delete image".localizated()
        static let cancel = "Cancel".localizated()
        static let title = "How would you like to add a photo?".localizated()
        static let takePhoto = "Take photo".localizated()
        static let settings = "Settings".localizated()
        static let select = "Select photo from the library".localizated()
        static let help = "Help".localizated()
        static let web = "Web page".localizated()
        static let logOut = "Log Out".localizated()
        static let logOutMessage = "Log out of your account?".localizated()
        static let errorAllFields = "Fill in all fields".localizated()
        static let errorPassword = "Lenght of password is less than 8 charcters".localizated()
        static let back = "Back".localizated()
        static let uhOh = "Uh - oh".localizated()
        static let email = "Enter your email".localizated()
        static let newPassword = "Сreate new password".localizated()
        static let newUser = "Create new username".localizated()
        static let signUp = "Sign up".localizated()
        static let passwordPlaceholder = "Password".localizated()
        static let name = "Name".localizated()
        static let chooseName = "Choose username".localizated()
        static let errorLogIn = "You couldn't log in, check your password or create an account".localizated()
        static let registr = "Don't have an account? Sign up.".localizated()
        static let logIn = "Log In".localizated()
        static let swipe = "Swipe left/right to choose a random image".localizated()
        static let library = "Photo library".localizated()
        static let errorSearch = "Enter a query in the search box and select the photo you want to download".localizated()
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
