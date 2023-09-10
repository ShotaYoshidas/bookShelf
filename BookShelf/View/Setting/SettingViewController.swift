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
        t.backgroundColor = .mainBackground
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return t
    }()
    var sections = ["アプリについて","その他","設定"]
    var array: [[String]] = [
        ["アプリについて"],["レビューする","シェアする"],["ダークモード設定"]]
    var cellImage = [["apple.logo"],["ellipsis.bubble","shareplay"],["paintpalette"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationBar15()
       
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
    
    func navigationBar15(){
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainBackground
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.title = "その他"
        }
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
        cell.backgroundColor = .cellColor
        cell.imageView?.image = UIImage(systemName: cellImage[indexPath.section][indexPath.row] , withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.UIBarButtonColor]))
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
            let alert = UIAlertController(title: .none, message: "ダークモード設定", preferredStyle: .actionSheet)
            alert.popoverPresentationController?.sourceView = self.view
            let d = UIAlertAction(title: "ダーク", style: .default) { [self] (action) in
                UserDefaults.standard.theme = .darkMode
                self.view.window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.userInterfaceStyle
                
            }
            let l = UIAlertAction(title: "ライト", style: .default) { [self] (action) in
                UserDefaults.standard.theme = .lightMode
                self.navigationController?.popViewController(animated: false)
                self.view.window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.userInterfaceStyle
            }
            let delete = UIAlertAction(title: "削除する", style: .destructive) { [self] (action) in
                self.navigationController?.popViewController(animated: false)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (acrion) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(d)
            alert.addAction(l)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
                
                
            }
           
            
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
}




