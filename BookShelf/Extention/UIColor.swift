//
//  UIColor.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/02/11.
//

import UIKit

enum ThemeColor:String {
    case intellectual//124
    case midNight//40
    case macarons//72
    case library
}
var themeColor: ThemeColor? = UserDefaults.standard.getState(forKey: "key") // nil
extension UIColor {
    
    static func mainColor() -> UIColor {
    themeColor = UserDefaults.standard.getState(forKey: "key")
        UserDefaults.standard.synchronize()
        switch themeColor  {
        case.intellectual:
            return UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1)
        case.midNight:
            return UIColor(red: 31/255, green: 30/255, blue: 99/255, alpha: 1)
        case.macarons:
            return UIColor(red: 194/255, green: 226/255, blue: 210/255, alpha: 1)
        case.library:
            return UIColor(red: 92/255, green: 40/255, blue: 51/255, alpha: 1)
        case .none:
            return UIColor.red
        }
        
    }
    
    static func cellColor() -> UIColor {
        themeColor = UserDefaults.standard.getState(forKey: "key")
            UserDefaults.standard.synchronize()
            switch themeColor  {
                
            case.intellectual:
//                return UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1)
                return UIColor(red: 230/255, green: 229/255, blue: 239/255, alpha: 1)
            case.midNight:
                return UIColor(red: 162/255, green: 162/255, blue: 173/255, alpha: 1)
//                return UIColor(red: 31/255, green: 30/255, blue: 99/255, alpha: 1)main
            case.macarons:
                return UIColor(red: 248/255, green: 204/255, blue: 209/255, alpha: 0.9)
            case.library:
                return UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 0.9)
            case .none:
                
                return UIColor.red
            }
    }
    
    static func naviTintColor() -> UIColor {
        themeColor = UserDefaults.standard.getState(forKey: "key")
            UserDefaults.standard.synchronize()
            switch themeColor  {
            case.intellectual:
//                return UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1)
                return UIColor(red: 62/255, green: 58/255, blue: 58/255, alpha: 1)
            case.midNight:
                return UIColor(red: 220/255, green: 213/255, blue: 200/255, alpha: 1)
                
//                return UIColor(red: 31/255, green: 30/255, blue: 99/255, alpha: 1)main
            case.macarons:
                return UIColor(red: 66/255, green: 66/255, blue: 111/255, alpha: 1)
            case.library:
                return .black
                
            case .none:
                
                return UIColor.red
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
