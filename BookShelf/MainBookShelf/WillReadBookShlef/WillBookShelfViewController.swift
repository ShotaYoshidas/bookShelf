//
//  WillBookShelfViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/11/03.
//

import UIKit
import XLPagerTabStrip

class WillBookShelfViewController: UIViewController,IndicatorInfoProvider,bookTextDelegate,BookShelfModelDeleteDelegate, BookMoveDelegate {
    private var layoutType:LayoutType = .grid
    func moveBook(id: String) {
        WillModel.moveBook(id: id)
        
    }
    
    func updateText(memo: String, id: String) {
        WillModel.updateText(memo: memo, id: id)
    }
    
    func deleteBook(id: String) {
        WillModel.deleteBook(id: id)
    }
    
    private let WillModel: BookShelfModel = .init()
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "Gridcell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .systemGray6
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar15()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView2), name: Notification.Name("bookupdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLayout), name: Notification.Name("layoutChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(call), name: Notification.Name("aaa"), object: nil)
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        collectionView.pin.all()
    }
    @objc func call() {
        view.backgroundColor = .mainColor()
        collectionView.backgroundColor = .mainColor()
        collectionView.reloadData()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    @objc private func updateCollectionView2(_ notification: Notification) {
        collectionView.reloadData()
        if let pagerTabStrip = self.parent as? ButtonBarPagerTabStripViewController {
            pagerTabStrip.buttonBarView.reloadData()
        }
    }
    
    @objc func changeLayout(){
        switch layoutType {
        case .list:
            self.layoutType = .grid
        case .grid:
            self.layoutType = .list
        }
        collectionView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo: IndicatorInfo = {
            let info = IndicatorInfo.init(title: "積読書:\(WillModel.willBooks.count)冊")
            return info
        }()
        return itemInfo
    }
    
    func SerchTumidokuUpdate(newBook2: Item) {
        WillModel.SerchTumidokuUpdate(newBook2: newBook2)
    }
    
    func BarcodeTumidokuUpdate(newBook4: Book) {
        WillModel.BarcodeTumidokuUpdate(newBook4: newBook4)
    }
    
    func sort(){
        WillModel.dateSort()
    }
    func dateRsort(){
        WillModel.dateRsort()
    }
    
    func navigationBar15() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainColor()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor()]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//            self.title = "本棚"
        }
    }
    
}

extension WillBookShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WillModel.willBooks.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard WillModel.willBooks.count > indexPath.row else { return UICollectionViewCell() }
        switch layoutType {
            
        case .list:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
                cell.configure(imageData: WillModel.willBooks[indexPath.row].imageData, titleName: WillModel.willBooks[indexPath.row].title, authorName: WillModel.willBooks[indexPath.row].author,saveTime: WillModel.willBooks[indexPath.row].saveTime)
                return cell
            }
        case .grid:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gridcell", for: indexPath) as? GridCollectionViewCell {
                cell.gridConfigure(imageData: WillModel.willBooks[indexPath.row].imageData)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bs = BookSelectViewController(titleName: WillModel.willBooks[indexPath.row].title, authorName: WillModel.willBooks[indexPath.row].author, imageData: WillModel.willBooks[indexPath.row].imageData,id: WillModel.willBooks[indexPath.row].id,memo:WillModel.willBooks[indexPath.row].memo,saveTime: WillModel.willBooks[indexPath.row].saveTime, vc: 2)
        bs.delegate = self
        bs.deleteDelegate = self
        bs.moveBookDelegate = self
        navigationController?.pushViewController(bs, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let move = UIAction(title: "完読書へ移動", image: UIImage(systemName: "books.vertical")) { action in
                self.moveBook(id: self.WillModel.willBooks[indexPath.row].id)
            }
            let delete = UIAction(title: "削除", image: UIImage(systemName: "trash"),attributes: .destructive) { action in
                self.deleteBook(id: self.WillModel.willBooks[indexPath.row].id)
            }
            return UIMenu(title: "Menu", children: [move,delete])
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .list:
            return CGSize(width: view.frame.size.width * 0.95, height: view.frame.size.height * 0.2)
        case .grid:
            return CGSize(width: (view.frame.size.width - 75) / 4, height: (view.frame.size.width) / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch layoutType {
        case .list:
            return UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 130, right: UIScreen.main.bounds.width/2 - 80)
        case .grid:
            return UIEdgeInsets(top: 15, left: 15, bottom: 130, right: 15)
        }
    }
    
}




