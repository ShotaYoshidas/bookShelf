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
    var usegeButton: UIBarButtonItem = {
        let u = UIBarButtonItem()
        u.tintColor = UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        return u
    }()
    
    var usegeButton2: UIBarButtonItem = {
        let u = UIBarButtonItem()
        u.tintColor = UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        return u
    }()
    let listImage: UIImage = {
        let i = UIImage(systemName: "line.3.horizontal")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return i
    }()
    let gridImage: UIImage = {
        let i = UIImage(systemName: "square.grid.3x3.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return i
    }()
    let sortImage: UIImage = {
        let i = UIImage(systemName: "arrow.up.arrow.down")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return i
    }()
    private let bc: BookShelfViewController = .init()
    private let wbc:WillBookShelfViewController = .init()
    override func viewDidLoad() {
        view.backgroundColor = .systemGray6
        settings.style.buttonBarMinimumLineSpacing = -1
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = UIColor.gray
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.buttonBarItemTitleColor = UIColor.gray
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 15)
        settings.style.selectedBarHeight = 2
        super.viewDidLoad()
        navigationBar15()
        let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(taped))
        let layoutChangeBarButtonItem = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(layoutChange))
        self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        
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
        NotificationCenter.default.post(name: Notification.Name("layoutChange"), object: nil, userInfo: .none)
        
        switch layoutType {
        case .list:
            print("list")
            self.layoutType = .grid
            
            let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(taped))
            let layoutChangeBarButtonItem = UIBarButtonItem(image: gridImage, style: .plain, target: self, action: #selector(layoutChange))
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
           
        case .grid:
            print("gird")
            self.layoutType = .list
            
            let sortBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(taped))
            let layoutChangeBarButtonItem = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(layoutChange))
            self.navigationItem.rightBarButtonItems = [sortBarButtonItem,layoutChangeBarButtonItem]
           
        }
        }
        
    @objc func taped(sender: UIButton) {
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
            appearance.backgroundColor = UIColor.systemGray6
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
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






