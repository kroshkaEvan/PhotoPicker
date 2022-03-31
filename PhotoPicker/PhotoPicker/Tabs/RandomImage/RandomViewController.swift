//
//  FilterViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit

class RandomViewController: UIViewController, UIGestureRecognizerDelegate {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.appMainColor
        alertSwipe()
        setupNavigationBarItem()
        setupSwipeGesture()
        setupView()
    }
    
    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(swipeAction))
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(swipeAction))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    private func setupNavigationBarItem() {
        let rightBarButton = UIBarButtonItem(image: Constants.Image.infoRandomImage,
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(didTapLoad))
        rightBarButton.tintColor = .systemBackground
        navigationItem.setRightBarButtonItems([rightBarButton],
                                              animated: true)
    }
    
    private func setupView() {
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func alertSwipe() {
        let alertLogOut = UIAlertController(title: "Swipe left/right to choose a random image",
                                            message: "",
                                            preferredStyle: .alert)
        alertLogOut.addAction(UIAlertAction(title: "OK",
                                            style: .cancel,
                                            handler: nil))
        present(alertLogOut, animated: true)
    }
    
    @objc private func didTapLoad() {
        if imageView.image != nil {
            guard let image = imageView.image else {return}
            let activityVC = UIActivityViewController(activityItems: [image],
                                                   applicationActivities: nil)
            present(activityVC, animated: true)
        } else {
            alertSwipe()
        }
    }
    
    @objc private func swipeAction() {
        if let urlString = URL(string: Constants.String.urlRandomImage) {
            do {
                let data = try Data(contentsOf: urlString)
                self.imageView.image = UIImage(data: data)
            } catch {
                print("error load")
            }
        }
    }
}
