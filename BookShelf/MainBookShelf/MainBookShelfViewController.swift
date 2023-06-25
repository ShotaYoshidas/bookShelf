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
var layoutType:LayoutType = .grid
class MainBookShelfViewController: ButtonBarPagerTabStripViewController,UICollectionViewDelegateFlowLayout {
    lazy var collectionView: ButtonBarView = {
        let cv = buttonBarView
        return cv!
    }()
    lazy var scrollView: UIScrollView = {
        let sv = containerView
        return sv!
    }()
    lazy var sortBarButtonItem: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(sort), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    lazy var layoutChangeBarButtonItem: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(layoutChange), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    lazy var favoBarButtonItem: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "list.star", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(favoSort), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    
    private let bc: BookShelfViewController = .init()
    private let wbc:WillBookShelfViewController = .init()
    override func viewDidLoad() {
        view.backgroundColor = .mainBackground
        settings.style.buttonBarMinimumLineSpacing = -1
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = .naviTintColor
        settings.style.buttonBarItemBackgroundColor = .mainBackground
        settings.style.buttonBarItemTitleColor = .naviTintColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
        settings.style.selectedBarHeight = 2
        super.viewDidLoad()
        navigationBar15()
        self.navigationItem.leftBarButtonItem = favoBarButtonItem
        self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        self.navigationController?.navigationBar.tintColor = .naviTintColor
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
    
    @objc func layoutChange(sender: UIButton) {
        switch layoutType {
        case .list:
            layoutType = .grid
            if let sButton = sortBarButtonItem.customView as? UIButton {
                sButton.setImage(UIImage(systemName: "arrow.up.arrow.down",withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: UIControl.State.normal)
                }
            if let lButton = layoutChangeBarButtonItem.customView as? UIButton {
                lButton.setImage(UIImage(systemName: "list.bullet",withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: UIControl.State.normal)
                }
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        case .grid:
            layoutType = .list
            if let sButton = sortBarButtonItem.customView as? UIButton {
                sButton.setImage(UIImage(systemName: "arrow.up.arrow.down",withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: UIControl.State.normal)
                    
                }
            if let lButton = layoutChangeBarButtonItem.customView as? UIButton {
                lButton.setImage(UIImage(systemName: "square.grid.3x3.fill",withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: UIControl.State.normal)
                }
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        }
        bc.layoutChange()
        wbc.layoutChange()
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
    
    @objc func favoSort(sender :UIButton) {
        
    }
    func navigationBar15(){
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainBackground
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
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







