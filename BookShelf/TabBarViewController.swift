//
//  TabBarViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/15.
//

import UIKit
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
    
    let overlay:UIView = {
        let ol = UIView()
        ol.backgroundColor = .black.withAlphaComponent(0.9)
        return ol
    }()
    
    let text:UITextView = {
        let t = UITextView()
        t.textColor = .white
        t.text = "＜使用方法＞\n「どこでも本棚」のご利用ありがとうございます。\n本の画像を長押しすると選択メニューが表示され、本棚間の移動と削除が可能になりました。"
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 18)
        t.isEditable = false
        t.backgroundColor = .clear
        return t
    }()
    
    let uiImageView:UIImageView = {
        let i = UIImageView()
        i.layer.masksToBounds = false
        i.image = UIImage(named:"MenuImage2")
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    let button:UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 4
        b.backgroundColor = .darkGray
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        notification()
        selectedIndex = 2
        tutorialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        overlay.pin.all()
        text.pin.topCenter(60).size(CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2))
        
        uiImageView.pin.below(of: text,aligned: .center).size(CGSize(width: UIScreen.main.bounds.width * 0.81, height: UIScreen.main.bounds.height * 0.5))
        
        button.pin.below(of: uiImageView,aligned: .center).size(CGSize(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.06)).margin(8)
    }
    @objc func tapButton(_ sender: UIButton){
        overlay.isHidden = true
    }
             
    @objc func setupTab() {
        let nsb = UINavigationController(rootViewController: sb)
        let mbs = UINavigationController(rootViewController: mv)
        let nsv = UINavigationController(rootViewController: sv)
        if #available(iOS 15, *) {
            let appearance: UITabBarAppearance = .init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = .darkGray
        viewControllers = [nsb,mbs,nsv]
    }
    @objc func tabc() {
        let nsb = UINavigationController(rootViewController: sb)
        let mbs = UINavigationController(rootViewController: mv)
        let nsv = UINavigationController(rootViewController: sv)
        if #available(iOS 15, *) {
            let appearance: UITabBarAppearance = .init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = .darkGray
        viewControllers = [nsb,mbs,nsv]
    }
    func notification() {
        NotificationCenter.default.addObserver(self, selector: #selector(serchKandokuUpdate), name: Notification.Name("SerchKandokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(serchTumidokuUpdate), name: Notification.Name("SerchTumidokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(barcodeKandokuUpdate), name: Notification.Name("BarcodeKandokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(barcodeTumidokuUpdate), name: Notification.Name("BarcodeTumidokuUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(manualInputData), name: Notification.Name("ManualInput"), object: nil)
        
        
    }
    
    func tutorialSetup() {
        view.addSubview(overlay)
        overlay.addSubview(text)
        overlay.addSubview(uiImageView)
        overlay.addSubview(button)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.tapButton(_:)), for: UIControl.Event.touchUpInside)
//        UserDefaults.standard.set(false, forKey: "visit") //リセット用
        let visit = UserDefaults.standard.bool(forKey: "visit")
        if visit {
            //二回目以降
            overlay.isHidden = true
        } else {
            UserDefaults.standard.set(true, forKey: "visit")
        }
    }
    
    @objc private func serchKandokuUpdate(_ notification: Notification) {
        guard let book: Item = notification.userInfo?["serchBook"] as? Item else { return }
        mv.SerchKandokuUpdate(newBook1: book)
    }
    
    @objc private func serchTumidokuUpdate(_ notification: Notification) {
        guard let book: Item = notification.userInfo?["serchBook"] as? Item else { return }
        mv.SerchTumidokuUpdate(newBook2: book)
    }
    
    
    @objc private func barcodeKandokuUpdate(_ notification: Notification) {
        guard let book: Book = notification.userInfo?["serchBook"] as? Book else { return }
        mv.BarcodeKandokuUpdate(newBook3: book)
    }
    
    @objc private func barcodeTumidokuUpdate(_ notification: Notification) {
        guard let book: Book = notification.userInfo?["serchBook"] as? Book else { return }
        mv.BarcodeTumidokuUpdate(newBook4: book)
    }
    
    @objc private func manualInputData(_ notification: Notification) {
        guard let title = notification.userInfo?["title"] as? String else { return }
        guard let author = notification.userInfo?["author"] as? String else { return }
        guard let thumnail = notification.userInfo?["thumnail"] as? UIImage else { return }
        mv.manualInputData(title: title, author: author, thumnail: thumnail)
    }
    
    
}

