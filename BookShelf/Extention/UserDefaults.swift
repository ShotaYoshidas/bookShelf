//
//  UserDefaults.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/04/01.
//

import Foundation
import UIKit

extension UserDefaults {
    var theme: Theme {
        get {
            // #functionを使うことで文字列定義する必要がなく、型安全に使用できる。
            // この場合keyは"theme"になる。#function == theme
            register(defaults: [#function: Theme.defaultMode.rawValue])
            guard let string = string(forKey: #function) else { return .defaultMode }
            return Theme(rawValue: string) ?? .defaultMode
        }
        set {
            set(newValue.rawValue, forKey: #function)
        }
    }
}


enum Theme: String {
    case lightMode = "ライト"
    case darkMode = "ダーク"
    case defaultMode = "デフォルト"

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .lightMode:
            return .light
        case .darkMode:
            return .dark
        case .defaultMode:
            return .unspecified
        }
    }
}

