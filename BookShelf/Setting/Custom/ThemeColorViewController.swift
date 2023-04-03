////
////  ThemeColorViewController.swift
////  bookShelf
////
////  Created by shota yoshida on 2023/02/11.
////
//
//import UIKit
//class ThemeColorViewController: UIViewController {
//
//    private let collectionView: UICollectionView = {
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        cv.alwaysBounceVertical = true
//        cv.register(ThemeColorViewCell.self, forCellWithReuseIdentifier: "themeCell")
//        cv.showsHorizontalScrollIndicator = true
//        return cv
//    }()
//
//    var colors: [UIColor] = [UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1),UIColor(red: 31/255, green: 30/255, blue: 99/255, alpha: 1),UIColor(red: 194/255, green: 226/255, blue: 210/255, alpha: 1),UIColor(red: 92/255, green: 40/255, blue: 51/255, alpha: 1)]
//    var t: [String] = ["知的","真夜中","マカロン","図書館"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(collectionView)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = .white
//        navigationItem.title = "カスタムテーマ"
//        self.navigationController?.navigationBar.tintColor = .naviTintColor
//    }
//
//    override func viewDidLayoutSubviews(){
//        super.viewDidLayoutSubviews()
//        collectionView.pin.all()
//    }
//
//}
//
//extension ThemeColorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return t.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themeCell", for: indexPath) as? ThemeColorViewCell {
//            cell.colorConfigure(themeName: t[indexPath.row] , themeColor: colors[indexPath.row])
//            return cell
//        }
//        return UICollectionViewCell()
//
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        UIScreen.main.bounds.width * 0.02
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing section: Int) -> CGFloat {
//        UIScreen.main.bounds.width * 0.02
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (view.frame.size.width - 75) / 4, height: (view.frame.size.width) / 3)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
////            UserDefaults.standard.setState(ThemeColor.intellectual, forKey: "key")
//            UserDefaults.standard.synchronize()
//            if #available(iOS 15.0, *) {
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = .mainBackground
//                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
//                self.navigationController?.navigationBar.standardAppearance = appearance
//                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//                self.navigationController?.navigationBar.tintColor = .naviTintColor
//
//                let tabAppearance = UITabBarAppearance()
//                tabAppearance.configureWithOpaqueBackground()
//                tabAppearance.backgroundColor = .mainBackground
//                self.tabBarController?.tabBar.standardAppearance = tabAppearance
//                self.tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
//            }
//
//            NotificationCenter.default.post(name: Notification.Name("colorSet"), object: nil, userInfo: .none)
//
//        } else if  indexPath.row == 1 {
////            UserDefaults.standard.setState(ThemeColor.midNight, forKey: "key")
//            UserDefaults.standard.synchronize()
//            if #available(iOS 15.0, *) {
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = .mainBackground
//                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
//                self.navigationController?.navigationBar.standardAppearance = appearance
//                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//                self.navigationController?.navigationBar.tintColor = .naviTintColor
//
//                let tabAppearance = UITabBarAppearance()
//                tabAppearance.configureWithOpaqueBackground()
//                tabAppearance.backgroundColor = .mainBackground
//                self.tabBarController?.tabBar.standardAppearance = tabAppearance
//                self.tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
//            }
//
//            NotificationCenter.default.post(name: Notification.Name("colorSet"), object: nil, userInfo: .none)
//        } else if  indexPath.row == 2 {
////            UserDefaults.standard.setState(ThemeColor.macarons, forKey: "key")
//            UserDefaults.standard.synchronize()
//            if #available(iOS 15.0, *) {
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = .mainBackground
//                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
//                self.navigationController?.navigationBar.standardAppearance = appearance
//                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//                self.navigationController?.navigationBar.tintColor = .naviTintColor
//
//                let tabAppearance = UITabBarAppearance()
//                tabAppearance.configureWithOpaqueBackground()
//                tabAppearance.backgroundColor = .mainBackground
//                self.tabBarController?.tabBar.standardAppearance = tabAppearance
//                self.tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
//            }
//
//            NotificationCenter.default.post(name: Notification.Name("colorSet"), object: nil, userInfo: .none)
//
//    } else if  indexPath.row == 3 {
////        UserDefaults.standard.setState(ThemeColor.library, forKey: "key")
//        UserDefaults.standard.synchronize()
//        if #available(iOS 15.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .mainBackground
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
//            self.navigationController?.navigationBar.standardAppearance = appearance
//            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//            self.navigationController?.navigationBar.tintColor = .naviTintColor
//
//            let tabAppearance = UITabBarAppearance()
//            tabAppearance.configureWithOpaqueBackground()
//            tabAppearance.backgroundColor = .mainBackground
//            self.tabBarController?.tabBar.standardAppearance = tabAppearance
//            self.tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
//        }
//
//
//        NotificationCenter.default.post(name: Notification.Name("colorSet"), object: nil, userInfo: .none)
//    }
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 15, left: 15, bottom: 130, right: 15)
//    }
//}
//
//func navigationBar15(){
//
//}
