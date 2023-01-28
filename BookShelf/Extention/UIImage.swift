//
//  UIImage.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/10/25.
//

import UIKit
import Nuke

extension UIImageView {
    
    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = UIImage() //cell再利用対策
            return
        }
        Nuke.loadImage(with: url, into: self)
    }
    
}

