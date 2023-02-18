//
//  MainBookShelfViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/11/03.
//

import UIKit
import XLPagerTabStrip

enum LayoutType {
    case list
    case grid
}

class MainBookShelfViewController: ButtonBarPagerTabStripViewController,UICollectionViewDelegateFlowLayout {
    private var layoutType:LayoutType = .list
    lazy var collectionView: ButtonBarView = {
        let cv = buttonBarView
        return cv!
    }()
    lazy var scrollView: UIScrollView = {
        let sv = containerView
        return sv!
    }()
    let listImage: UIImage = {
        let i = UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
        return i ?? UIImage()
    }()
    let gridImage: UIImage = {
        let i = UIImage(systemName: "square.grid.3x3.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
        return i ?? UIImage()
    }()
    let sortImage: UIImage = {
        let i = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
        return i ?? UIImage()
    }()
  
    private let bc: BookShelfViewController = .init()
    private let wbc:WillBookShelfViewController = .init()
    override func viewDidLoad() {
        view.backgroundColor = .mainColor()
        settings.style.buttonBarMinimumLineSpacing = -1
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = .naviTintColor()
        settings.style.buttonBarItemBackgroundColor = .cellColor()
        settings.style.buttonBarItemTitleColor = .naviTintColor()
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
        settings.style.selectedBarHeight = 2
        super.viewDidLoad()
        navigationBar15()
        let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(sort))
        let layoutChangeBarButtonItem = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(layoutChange))
        self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        self.navigationController?.navigationBar.tintColor = .naviTintColor()
        NotificationCenter.default.addObserver(self, selector: #selector(call), name: Notification.Name("aaa"), object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let topInset = view.safeAreaInsets.top
        let width = view.frame.size.width
        let height = view.frame.size.height
        collectionView.frame = CGRect(x: 0, y: topInset, width: width, height: 38)
        scrollView.frame = CGRect(x: 0, y: topInset + 38, width: width, height: height)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [bc, wbc]
    }
   
    @objc func call() {
        
        settings.style.selectedBarBackgroundColor = .naviTintColor()
        settings.style.buttonBarItemBackgroundColor = .cellColor()
        settings.style.buttonBarItemTitleColor = .naviTintColor()
        super.viewDidLoad()
        view.backgroundColor = .mainColor()
        self.navigationController?.navigationBar.tintColor = .naviTintColor()
        collectionView.backgroundColor = .mainColor()
        collectionView.reloadData()
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor()]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            UITabBar.appearance().tintColor = .naviTintColor()
            
            let sortImage = UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
            let listImage = UIImage(systemName: "square.grid.3x3.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
            let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(sort))
            let layoutChangeBarButtonItem = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(layoutChange))
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        }
    }
    
    
    @objc func layoutChange(sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("layoutChange"), object: nil, userInfo: .none)
        let sortImage = UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
        let listImage = UIImage(systemName: "square.grid.3x3.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
        let gridImage = UIImage(systemName: "square.grid.3x3.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor()]))
        switch layoutType {
        case .list:
            self.layoutType = .grid
            let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(sort))
            let layoutChangeBarButtonItem = UIBarButtonItem(image: gridImage, style: .plain, target: self, action: #selector(layoutChange))
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        case .grid:
            self.layoutType = .list
            let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(sort))
            let layoutChangeBarButtonItem = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(layoutChange))
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        }
        }
        
    @objc func sort(sender: UIButton) {
        let alert = UIAlertController(title: .none, message: "並び替え", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
                    let screenSize = UIScreen.main.bounds
                    alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        let newSave = UIAlertAction(title: "登録が新しい順", style: .default) { [self] (action) in
            bc.sort()
            wbc.sort()
            
        }
        let oldSave = UIAlertAction(title: "登録が古い順", style: .default) { [self] (action) in
            bc.dateRsort()
            wbc.dateRsort()
        }
        
        let cancel = UIAlertAction(title: "やめておく", style: .cancel) { (acrion) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(newSave)
        alert.addAction(oldSave)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func navigationBar15(){
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor()]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.title = "本棚"
        }   }
    
    func SerchKandokuUpdate(newBook1: Item) {
        bc.SerchKandokuUpdate(newBook1: newBook1)
    }
    
    func SerchTumidokuUpdate(newBook2: Item) {
        wbc.SerchTumidokuUpdate(newBook2: newBook2)
    }
    
    func BarcodeKandokuUpdate(newBook3: Book) {
        bc.BarcodeKandokuUpdate(newBook3: newBook3)
    }
    func BarcodeTumidokuUpdate(newBook4: Book) {
        wbc.BarcodeTumidokuUpdate(newBook4: newBook4)
        
    }
    func manualInputData(title:String,author:String,thumnail:UIImage) {
        bc.getData3(title: title,author: author, thumnail: thumnail)
    }
    
}







