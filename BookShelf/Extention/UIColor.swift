//
//  UIColor.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/02/11.
//

import UIKit


extension UIColor {
    static let mainBackground: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.1316016614, green: 0.1316016614, blue: 0.1316016614, alpha: 1)
            } else {
                return #colorLiteral(red: 0.8836668134, green: 0.8898727298, blue: 0.9198075533, alpha: 1)
            }
        }
    
    static let cellColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.2077003717, green: 0.2091588676, blue: 0.2161971629, alpha: 1)
            } else {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    
    
    static let naviTintColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    
    static let UIBarButtonColor: UIColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
}

