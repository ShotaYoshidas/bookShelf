//
//  UIColor.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/02/11.
//

import UIKit

enum ThemeColor:String {
    case lightGray
    case systemMint
}
var themeColor: ThemeColor? = UserDefaults.standard.getState(forKey: "key") // nil
extension UIColor {
    
    static func mainColor() -> UIColor {
    themeColor = UserDefaults.standard.getState(forKey: "key")
        UserDefaults.standard.synchronize()
        switch themeColor  {
        case.lightGray:
            return UIColor.lightGray
        case.systemMint:
            return UIColor.systemMint
        case .none:
            return UIColor.systemGray6
        }
        
    }
    static func UIBarButtonColor() -> UIColor {
        return UIColor.darkGray
    }
    
    static func bookSelectColor() -> UIColor {
        return UIColor.systemGray5
    }
}

extension UserDefaults {

    func setState(_ value: ThemeColor?, forKey key: String) {
        if let value = value {
            set(value.rawValue, forKey: "key")
        } else {
            removeSuite(named: "key")
        }
    }

    func getState(forKey key: String) -> ThemeColor? {
        if let string = string(forKey: "key") {
            return ThemeColor(rawValue: string)
            
        }
        return nil
    }
}
