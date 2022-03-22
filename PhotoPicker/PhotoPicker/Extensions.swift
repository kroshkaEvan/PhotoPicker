//
//  Extensions.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 22.03.22.
//

import Foundation
import UIKit

extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    }
}
