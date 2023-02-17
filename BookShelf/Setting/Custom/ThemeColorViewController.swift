//
//  ThemeColorViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/02/11.
//

import UIKit
class ThemeColorViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(ThemeColorViewCell.self, forCellWithReuseIdentifier: "Gridcell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .systemGray6
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .mainColor()
        navigationItem.title = "カスタムテーマ"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        collectionView.pin.all()
    }
    
}
extension ThemeColorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gridcell", for: indexPath) as? ThemeColorViewCell {
            switch (true) {
            case indexPath.row == 0:
                cell.backgroundColor = UIColor.lightGray
            case indexPath.row == 1:
                cell.backgroundColor = UIColor.systemMint
            default: break

            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        UIScreen.main.bounds.width * 0.02
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing section: Int) -> CGFloat {
        UIScreen.main.bounds.width * 0.02
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 75) / 4, height: (view.frame.size.width) / 3)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.setState(ThemeColor.lightGray, forKey: "key")
            UserDefaults.standard.synchronize()
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .mainColor()
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
                self.navigationController?.navigationBar.standardAppearance = appearance
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
               
                let tabAppearance = UITabBarAppearance()
                tabAppearance.configureWithOpaqueBackground()
                tabAppearance.backgroundColor = .mainColor()
                self.tabBarController?.tabBar.standardAppearance = tabAppearance
                self.tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
            }
            collectionView.backgroundColor = .mainColor()
            NotificationCenter.default.post(name: Notification.Name("aaa"), object: nil, userInfo: .none)
            
        } else if  indexPath.row == 1 {
            UserDefaults.standard.setState(ThemeColor.systemMint, forKey: "key")
            UserDefaults.standard.synchronize()
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .mainColor()
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
                self.navigationController?.navigationBar.standardAppearance = appearance
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
                let tabAppearance = UITabBarAppearance()
                tabAppearance.configureWithOpaqueBackground()
                tabAppearance.backgroundColor = .mainColor()
                self.tabBarController?.tabBar.standardAppearance = tabAppearance
                self.tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
            }
            collectionView.backgroundColor = .mainColor()
            NotificationCenter.default.post(name: Notification.Name("aaa"), object: nil, userInfo: .none)
        } 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 130, right: 15)
    }
}

func navigationBar15(){
    
}
