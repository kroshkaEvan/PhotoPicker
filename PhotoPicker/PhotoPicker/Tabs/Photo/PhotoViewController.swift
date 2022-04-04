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
import Kingfisher
import SafariServices

class PhotoViewController: UIViewController {
    private var images = [Image]()
    private var sharedImage = Image()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: Constants.Dimensions.cellsSpacing / 2,
                                           left: Constants.Dimensions.cellsSpacing,
                                           bottom: Constants.Dimensions.cellsSpacing / 2,
                                           right: Constants.Dimensions.cellsSpacing)
        let numberOfItemsInSection = 3
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
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        setupView()
        setupNavigationItems()
        loadImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkStatusAuth()
    }
    
    private func loadImages() {
        self.images = DataManager.shared.loadImagesArray()
        photosCollectionView.reloadData()
    }
    
    private func checkStatusAuth() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    private func setupView() {
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
                let alert = UIAlertController(title: nil,
                                              message: nil,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constants.Strings.share,
                                              style: .default,
                                              handler: {[weak self] _ in self?.shareImage(indexPath.row)}))
                alert.addAction(UIAlertAction(title: Constants.Strings.delete,
                                              style: .default,
                                              handler: {[weak self] _ in
                    DispatchQueue.main.async {
                        DataManager.shared.deleteAt(index: indexPath.row)
                        self?.photosCollectionView.deleteItems(at: [indexPath])}}))
                alert.addAction(UIAlertAction(title: Constants.Strings.cancel,
                                              style: .cancel,
                                              handler: nil))
                present(alert, animated: true)
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
            let path = DataManager.shared.saveImage(image: selectedPhoto)
            self.sharedImage.imagePath = path
            DataManager.shared.save(item: self.sharedImage)
            self.photosCollectionView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
        }
    }
    
    private func presentPhotoActionSheet() {
        let alert = UIAlertController(title: Constants.Strings.title,
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.Strings.takePhoto,
                                      style: .default,
                                      handler: { [weak self] _ in self?.presentCamera()}))
        alert.addAction(UIAlertAction(title: Constants.Strings.select,
                                      style: .default,
                                      handler: {[weak self] _ in self?.presentPhotoLibrary()}))
        alert.addAction(UIAlertAction(title: Constants.Strings.cancel,
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
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
        return DataManager.shared.loadImagesArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            cell.imageView.image = DataManager.shared.loadImage(fileName: DataManager.shared.loadImagesArray()[indexPath.row].imagePath ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath,
                                    animated: true)
        
    }
}

extension PhotoViewController {
    private func shareImage(_ index: Int) {
        let image = DataManager.shared.loadImage(fileName: DataManager.shared.loadImagesArray()[index].imagePath ?? "")
        let activityVC = UIActivityViewController(activityItems: [image ?? ""],
                                                  applicationActivities: nil)
        present(activityVC, animated: true)
    }
}

extension PhotoViewController {
    private func setupNavigationItems() {
        let rightBarButtonItemAdd = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        rightBarButtonItemAdd.tintColor = .darkGray
        let leftBarButtonItemSettings = UIBarButtonItem(image: Constants.Image.infoImage,
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(presentActionSheet))
        leftBarButtonItemSettings.tintColor = .darkGray
        navigationItem.setRightBarButtonItems([leftBarButtonItemSettings, rightBarButtonItemAdd],
                                              animated: true)
    }
    
    @objc private func presentActionSheet() {
        let alert = UIAlertController(title: Constants.Strings.settings,
                                            message: "",
                                            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.Strings.help,
                                            style: .default,
                                            handler: { [weak self] _ in self?.openURL(.help)}))
        alert.addAction(UIAlertAction(title: Constants.Strings.web,
                                            style: .default,
                                            handler: { [weak self] _ in self?.openURL(.webVersion)}))
        alert.addAction(UIAlertAction(title: Constants.Strings.logOut,
                                            style: .destructive,
                                            handler: { [weak self] _ in self?.alertLogOut()}))
        alert.addAction(UIAlertAction(title: Constants.Strings.cancel,
                                            style: .cancel,
                                            handler: nil))
        present(alert, animated: true)
    }
    
    private func alertLogOut() {
        let alertLogOut = UIAlertController(title: Constants.Strings.logOutMessage,
                                            message: "",
                                            preferredStyle: .alert)
        alertLogOut.addAction(UIAlertAction(title: Constants.Strings.cancel,
                                            style: .cancel,
                                            handler: nil))
        alertLogOut.addAction(UIAlertAction(title: Constants.Strings.logOut,
                                            style: .destructive,
                                            handler: { [weak self] _ in self?.didTapLogOut()}))
        present(alertLogOut, animated: true)
    }
    
    private func didTapLogOut(){
        AuthManager.shared.getLogOut { [weak self] successLogOut in
            DispatchQueue.main.async {
                if successLogOut {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self?.present(loginVC, animated: true) {
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    }
                } else {
                    print("User don't log out")
                }
            }
        }
    }

    enum SettingsURLType {
        case webVersion, help
    }
    
    private func openURL(_ type: SettingsURLType) {
        let urlString: String
        switch type {
        case .webVersion : urlString = "https://photoeditorpro.com/"
        case .help : urlString = "https://www.linkedin.com/in/ivan-tsvetkov-44a25a233/"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true)
    }
}
