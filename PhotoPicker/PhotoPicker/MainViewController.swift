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
        let scalingRatio = CGFloat(0.5)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.4,
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
                                   image: UIImage(systemName: "photo.on.rectangle.angled"),
                                   selectedImage: UIImage(systemName: "photo.on.rectangle.fill")),
            createNavController(for: FilterViewController(),
                                   title: "",
                                   image: UIImage(systemName: "paintbrush"),
                                   selectedImage: UIImage(systemName: "paintbrush.fill")),
            createNavController(for: SearchViewController(),
                                   title: "",
                                   image: UIImage(systemName: "magnifyingglass"),
                                   selectedImage: UIImage(systemName: "rectangle.and.text.magnifyingglass.rtl")),
            createNavController(for: ProfileViewController(),
                                   title: "Profile",
                                   image: UIImage(systemName: "person"),
                                   selectedImage: UIImage(systemName: "person.fill"))
        ]
    }
}

