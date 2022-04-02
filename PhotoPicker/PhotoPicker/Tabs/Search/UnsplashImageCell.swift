//
//  UnsplashImageCell.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 27.03.22.
//

import UIKit
import SDWebImage

class UnsplashImageCell: UICollectionViewCell {
    static let reuseIdentifier = "UnsplashImageCell"
    
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.backgroundColor = .darkGray
       imageView.contentMode = .scaleAspectFill
       return imageView
   }()
    
    private lazy var checkMark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Image.checkMark
        imageView.tintColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    var unsplashImage: UnsplashImage! {
        didSet {
            let photoURL = unsplashImage.urls["regular"]
            guard let imageUrl = photoURL,
                    let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateSelectedState()
        setupImageViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSelectedState() {
        imageView.alpha = isSelected ? 0.7 : 1
        checkMark.alpha = isSelected ? 1 : 0
    }
    
    private func setupImageViews() {
        addSubview(imageView)
        addSubview(checkMark)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        checkMark.heightAnchor.constraint(equalToConstant: 55).isActive = true
        checkMark.widthAnchor.constraint(equalToConstant: 55).isActive = true
        checkMark.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        checkMark.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
}
