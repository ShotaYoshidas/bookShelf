//
//  settingViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/07.
//

import UIKit
import XLPagerTabStrip
import StoreKit

class SettingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let t = UITableView.init(frame: CGRect.zero, style: .insetGrouped)
        t.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        t.rowHeight = 45
        t.separatorColor = UIColor.black
        t.backgroundColor = .mainColor()
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return t
    }()
    var sections = ["アプリについて","その他","設定"]
    var array: [[String]] = [
        ["アプリについて"],["レビューする","シェアする"],["テーマカラー"]]
    var cellImage = [["apple.logo"],["ellipsis.bubble","shareplay"],["paintpalette"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainColor()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationBar15()
        NotificationCenter.default.addObserver(self, selector: #selector(call), name: Notification.Name("aaa"), object: nil)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
    
    func navigationBar15(){
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor()]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.title = "その他"
        }
    }
    @objc func call() {
        view.backgroundColor = .mainColor()
        
        tableView.backgroundColor = .mainColor()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor()]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        print("よばれた")
    }
    
    
}
extension SettingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = array[indexPath.section][indexPath.row]
        cell.imageView?.image = UIImage(systemName: cellImage[indexPath.section][indexPath.row] , withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.UIBarButtonColor()]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let ex = ExplanationViewController()
            navigationController?.pushViewController(ex, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            SKStoreReviewController.requestReview()
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let activityViewController = UIActivityViewController(activityItems: ["どこでも本棚"], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }else if indexPath.section == 2 && indexPath.row == 0 {
           let tc = ThemeColorViewController()
            navigationController?.pushViewController(tc, animated: true)
        }
        
            
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}


