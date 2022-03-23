//
//  MainViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        let scalingRatio = CGFloat(0.7)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.3,
                                                      dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: scalingRatio,
                                                                        y: scalingRatio)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity },
                                       delayFactor: CGFloat(0.3))
        propertyAnimator.startAnimation()
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage?,
                                     selectedImage: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: PhotoViewController(),
                                   title: "Photo library",
                                   image: Constants.Image.tabBarImagePhoto,
                                   selectedImage: Constants.Image.tabBarImagePhotoFill),
            createNavController(for: RandomViewController(),
                                   title: "",
                                   image: Constants.Image.tabBarImageRandom,
                                   selectedImage: Constants.Image.tabBarImageRandomFill),
            createNavController(for: SearchViewController(),
                                   title: "",
                                   image: Constants.Image.tabBarImageSearch,
                                   selectedImage: Constants.Image.tabBarImageSearchFill),
            createNavController(for: ProfileViewController(),
                                   title: "Profile",
                                   image: Constants.Image.tabBarImageProfile,
                                   selectedImage: Constants.Image.tabBarImageProfileFill)
        ]
    }
}

