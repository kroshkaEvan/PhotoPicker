//
//  SearchViewController.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    private var timer: Timer?
    private var unsplashImages = [UnsplashImage]()
    private var selectedImages = [UIImage]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: Constants.Dimensions.unsplashSize,
                                           left: Constants.Dimensions.unsplashSize,
                                           bottom: Constants.Dimensions.unsplashSize,
                                           right: Constants.Dimensions.unsplashSize)
        let cellWidth = (view.frame.width
                         - layout.sectionInset.left
                         - layout.sectionInset.right
                         - Constants.Dimensions.cellsSpacing
                         * (CGFloat(2) + 1)) / CGFloat(1)
        let cellHeight = cellWidth * 2
        layout.minimumLineSpacing = Constants.Dimensions.cellsSpacing
        layout.minimumInteritemSpacing = Constants.Dimensions.cellsSpacing
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width,
                                            height: Constants.Dimensions.sectionHeight)
        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: layout)
        collectionView.register(UnsplashImageCell.self,
                                forCellWithReuseIdentifier: UnsplashImageCell.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .darkGray
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = Constants.Strings.searchBar
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchController
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        setupView()
        setupNavigationItems()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        
    }
    
    private func setupNavigationItems() {
        let rightBarButtonItemAdd = UIBarButtonItem(barButtonSystemItem: .action,
                                                        target: self,
                                                        action: #selector(didTapAdd))
        navigationItem.searchController = searchController
        rightBarButtonItemAdd.tintColor = .darkGray
        navigationItem.rightBarButtonItems = [rightBarButtonItemAdd]
    }
    
    private func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil,
                                       animated: true,
                                       scrollPosition: [])
    }
    
    @objc func didTapAdd(sender: UIBarButtonItem) {
        if !selectedImages.isEmpty {
            let activityVC = UIActivityViewController(activityItems: self.selectedImages,
                                                           applicationActivities: nil)
            activityVC.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    self.refresh()
                }
            }
            activityVC.popoverPresentationController?.barButtonItem = sender
            activityVC.popoverPresentationController?.permittedArrowDirections = .any
            present(activityVC, animated: true)
        } else {
            alertSwipe()
        }
    }
    
    private func alertSwipe() {
        let alertLogOut = UIAlertController(title: Constants.Strings.errorSearch,
                                            message: "",
                                            preferredStyle: .alert)
        alertLogOut.addAction(UIAlertAction(title: "OK",
                                            style: .cancel,
                                            handler: nil))
        present(alertLogOut, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.unsplashImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnsplashImageCell.reuseIdentifier,
                                                      for: indexPath)
        if let cell = cell as? UnsplashImageCell {
            cell.unsplashImage = self.unsplashImages[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UnsplashImageCell {
            guard let image = cell.imageView.image else { return }
            self.selectedImages.append(image)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UnsplashImageCell,
           let image = cell.imageView.image,
           let index = self.selectedImages.firstIndex(of: image)  {
            self.selectedImages.remove(at: index)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
            NetworkManager.shared.fetchImages(searchTerm: searchText) { [weak self] searchResult in
                guard let fetchedPhotos = searchResult else { return }
                self?.activityIndicator.stopAnimating()
                self?.unsplashImages = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }
}
