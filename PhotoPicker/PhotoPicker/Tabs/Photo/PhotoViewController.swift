//
//  ViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit
import FirebaseAuth
import Photos
import PhotosUI

class PhotoViewController: UIViewController {
    private let numberOfItemsInSection = 3

    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: Constants.Dimensions.cellsSpacing / 2,
                                           left: Constants.Dimensions.cellsSpacing,
                                           bottom: Constants.Dimensions.cellsSpacing / 2,
                                           right: Constants.Dimensions.cellsSpacing)
        
        let cellWidth = (view.bounds.width
                         - layout.sectionInset.left
                         - layout.sectionInset.right
                         - Constants.Dimensions.cellsSpacing
                         * (CGFloat(numberOfItemsInSection) + 1)) / CGFloat(numberOfItemsInSection)
        let cellHeight = cellWidth
        layout.minimumLineSpacing = Constants.Dimensions.cellsSpacing
        layout.minimumInteritemSpacing = Constants.Dimensions.cellsSpacing
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width,
                                            height: Constants.Dimensions.sectionHeight)
        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = Constants.Colors.appMainColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem?.tintColor = .label
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkStatusAuth()
    }
    
    private func checkStatusAuth() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(photosCollectionView)
        photosCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        photosCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func didTapAdd() {
        presentPhotoActionSheet()
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.photosCollectionView)
            if let indexPath = photosCollectionView.indexPathForItem(at: touchPoint) {
                let actionSheet = UIAlertController(title: nil,
                                              message: nil,
                                              preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Copy image",
                                              style: .default,
                                              handler: {[weak self] _ in self?.copyImage(Image.images[indexPath.row])}))
                actionSheet.addAction(UIAlertAction(title: "Share image",
                                              style: .default,
                                              handler: {[weak self] _ in self?.shareImage(Image.images[indexPath.row])}))
                actionSheet.addAction(UIAlertAction(title: "Delete image",
                                              style: .default,
                                              handler: {[weak self] _ in self?.delete(indexPath)}))
                actionSheet.addAction(UIAlertAction(title: "Cancel",
                                              style: .cancel,
                                              handler: nil))
                present(actionSheet, animated: true)
            }
        }
    }
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedPhoto = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        DispatchQueue.main.async {
            Image.images.append(selectedPhoto)
            self.photosCollectionView.reloadData()
        }
    }
    
    private func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile photo",
                                            message: "How would you like to add a photo?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentCamera()}))
        actionSheet.addAction(UIAlertAction(title: "Select photo from the library",
                                            style: .default,
                                            handler: {[weak self] _ in self?.presentPhotoLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true)
    }
    
    func presentPhotoLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Image.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            cell.imageView.image = Image.images[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath,
                                    animated: true)
    }
}

extension PhotoViewController {
    private func copyImage(_ image: UIImage) {
        UIPasteboard.general.image = image
    }
    private func shareImage(_ image: UIImage) {
        let shareVC = UIActivityViewController(activityItems: [image],
                                               applicationActivities: nil)
        present(shareVC, animated: true)
    }
    private func delete(_ imageIndex: IndexPath) {
        DispatchQueue.main.async {
            Image.images.remove(at: imageIndex.row)
            self.photosCollectionView.deleteItems(at: [imageIndex])
            self.photosCollectionView.reloadData()
        }
    }
}


