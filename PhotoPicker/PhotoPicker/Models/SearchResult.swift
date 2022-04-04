//
//  SearchResult.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 27.03.22.
//

import Foundation

struct SearchResult: Decodable {
    let total: Int
    let results: [UnsplashImage]
}
