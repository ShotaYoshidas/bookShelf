//
//  TabBarViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/15.
//

import UIKit
//importはひとつ記入すればいいの？
import PinLayout
class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    func setupTab() {
        //viewContrllerも一つの定数として扱って、tabBarItem等のプロパティも使用できるてきな？
        let firstViewController = FirstViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "tab1", image: .none, tag: 0)
        let secondViewController = SecondViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        //viewControllersとは？
        viewControllers = [firstViewController, secondViewController]
    }
}
