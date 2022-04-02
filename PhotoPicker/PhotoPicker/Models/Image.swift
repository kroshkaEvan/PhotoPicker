//
//  Image.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import UIKit
import Foundation

class Image: Codable {
    static let shared = Image()
    static var images = [Image]()
    static var unsplashImages = [UnsplashImage]()
    static var selectedImages = [UIImage]()
    static var numberOfItemsInSection = 2
    var imagePath: String?
    
    init() {}
    
    public enum CodingKeys: String, CodingKey {
        case imagePath
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.imagePath, forKey: .imagePath)
    }
}

struct UnsplashImage: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

