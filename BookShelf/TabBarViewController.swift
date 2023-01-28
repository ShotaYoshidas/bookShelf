//
//  TabBarViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/15.
//

import UIKit
//importはひとつ記入すればいいの？
import PinLayout
import XLPagerTabStrip

class TabBarViewController: UITabBarController {
    let sb:SerchBookViewController = {
        let sb = SerchBookViewController()
        sb.tabBarItem = UITabBarItem(title: "本を探す", image: UIImage(systemName:"magnifyingglass.circle"), tag: 0)
        return sb
    }()
    let mv:MainBookShelfViewController  = {
        let mv = MainBookShelfViewController()
        mv.tabBarItem = UITabBarItem(title: "本棚", image: UIImage(systemName: "books.vertical"), tag: 0)
        return mv
    }()
    
    let sv:SettingViewController = {
        let sv = SettingViewController()
        sv.tabBarItem = UITabBarItem(title: "その他", image: UIImage(systemName: "ellipsis.circle"), tag: 0)
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        NotificationCenter.default.addObserver(self, selector: #selector(SerchKandokuUpdate), name: Notification.Name("SerchKandokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SerchTumidokuUpdate), name: Notification.Name("SerchTumidokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BarcodeKandokuUpdate), name: Notification.Name("BarcodeKandokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BarcodeTumidokuUpdate), name: Notification.Name("BarcodeTumidokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ManualInputData), name: Notification.Name("ManualInput"), object: nil)
    }
    @objc private func SerchKandokuUpdate(_ notification: Notification) {
        guard let book: Item = notification.userInfo?["serchBook"] as? Item else { return }
        mv.SerchKandokuUpdate(newBook1: book)
    }
    
    @objc private func SerchTumidokuUpdate(_ notification: Notification) {
        guard let book: Item = notification.userInfo?["serchBook"] as? Item else { return }
        mv.SerchTumidokuUpdate(newBook2: book)
    }
    
    
    @objc private func BarcodeKandokuUpdate(_ notification: Notification) {
        guard let book: Book = notification.userInfo?["serchBook"] as? Book else { return }
        mv.BarcodeKandokuUpdate(newBook3: book)
    }
    
    @objc private func BarcodeTumidokuUpdate(_ notification: Notification) {
        guard let book: Book = notification.userInfo?["serchBook"] as? Book else { return }
        mv.BarcodeTumidokuUpdate(newBook4: book)
    }
   
    @objc private func ManualInputData(_ notification: Notification) {
        guard let title = notification.userInfo?["title"] as? String else { return }
        guard let author = notification.userInfo?["author"] as? String else { return }
        guard let thumnail = notification.userInfo?["thumnail"] as? UIImage else { return }
        mv.manualInputData(title: title, author: author, thumnail: thumnail)
    }
    
    func setupTab() {
        let nsb = UINavigationController(rootViewController: sb)
        let mbs = UINavigationController(rootViewController: mv)
        let nsv = UINavigationController(rootViewController: sv)
        if #available(iOS 15, *) {
                    let appearance: UITabBarAppearance = .init()
                    appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
        UITabBar.appearance().tintColor = .darkGray
        viewControllers = [nsb,mbs,nsv]
    }
}

