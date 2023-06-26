//
//  SecondViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/15.
//

import UIKit
import PinLayout
import CoreMedia
import AVFoundation
import XLPagerTabStrip
import RealmSwift


class BookShelfViewController: UIViewController, bookTextDelegate,BookShelfModelDeleteDelegate,IndicatorInfoProvider, BookMoveDelegate, UIGestureRecognizerDelegate, BookFavoDelegate {
    weak var deleteDelegate: BookShelfModelDeleteDelegate? = nil
    private let model: BookShelfModel = .init()
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "Gridcell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .mainBackground
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar15()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView1), name: Notification.Name("bookupdate"), object: nil)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        collectionView.pin.all()
    }
    
    @objc private func updateCollectionView1(_ notification: Notification) {
        collectionView.reloadData()
        if let pagerTabStrip = self.parent as? ButtonBarPagerTabStripViewController {
            pagerTabStrip.buttonBarView.reloadData()
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo: IndicatorInfo = {
            let info = IndicatorInfo.init(title: "完読書:\(model.roadBooks.count)冊")
            return info
        }()
        return itemInfo
    }
    
    func moveBook(id: String) {
        model.moveBook(id: id)
    }
    
    func updateText(memo: String, id: String) {
        model.updateText(memo: memo, id: id)
    }
    
    func deleteBook(id: String) {
        model.deleteBook(id: id)
    }
    
    func SerchKandokuUpdate(newBook1: Item) {
        model.SerchKandokuUpdate(newBook1: newBook1)
    }
    func BarcodeKandokuUpdate(newBook3: Book) {
        model.BarcodeKandokuUpdate(newBook3: newBook3)
    }
    
    func getData3(title:String,author:String,thumnail:UIImage) {
        model.addNewBook3(title: title, author: author, thumnail: thumnail)
    }
    
//    datesort
    func sort(favoFilter: FavoFilter){
        model.dateSort(favoFilter: favoFilter)
    }
    func dateRsort(favoFilter: FavoFilter){
        model.dateRsort(favoFilter: favoFilter)
    }
//　　favosort
    func favoSelect(id: String) {
           model.favoSelct(id: id)
        
       }
    func favofilterTrue() {
        model.favofilterTrue()
    }
    func favoFilterCancel() {
        model.favofilterCancel()
    }
    
//    layout
    func layoutChange(){
        collectionView.reloadData()
    }
    
    func navigationBar15() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainBackground
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}

extension BookShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.roadBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard model.roadBooks.count > indexPath.row else { return UICollectionViewCell() }
        switch layoutType {
        case .list:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
                cell.configure(imageData: model.roadBooks[indexPath.row].imageData, titleName: model.roadBooks[indexPath.row].title, authorName: model.roadBooks[indexPath.row].author,saveTime: model.roadBooks[indexPath.row].saveTime)
                return cell
            }
        case .grid:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gridcell", for: indexPath) as? GridCollectionViewCell {
                cell.gridConfigure(imageData: model.roadBooks[indexPath.row].imageData)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bs = BookSelectViewController(titleName: model.roadBooks[indexPath.row].title, authorName: model.roadBooks[indexPath.row].author, imageData: model.roadBooks[indexPath.row].imageData,id: model.roadBooks[indexPath.row].id,memo:model.roadBooks[indexPath.row].memo,saveTime: model.roadBooks[indexPath.row].saveTime,vc: 1,favo: model.roadBooks[indexPath.row].favoKey)
        
        navigationController?.pushViewController(bs, animated: true)
        
        bs.delegate = self
        bs.deleteDelegate = self
        bs.moveBookDelegate = self
        bs.favoDeledate = self
    }
            
        func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
                let move = UIAction(title: "積読書へ移動", image: UIImage(systemName: "books.vertical")) { action in
                    self.moveBook(id: self.model.roadBooks[indexPath.row].id)
                }
                let delete = UIAction(title: "削除", image: UIImage(systemName: "trash"),attributes: .destructive) { action in
                    self.deleteBook(id: self.model.roadBooks[indexPath.row].id)
                }
                return UIMenu(title: "Menu", children: [move,delete])
            })
        }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .list:
//            print("aaaa\(layoutType)")
            return CGSize(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.2)
            
        case .grid:
//            print("aaaa\(layoutType)")
            let w = UIScreen.main.bounds.width / 5
            return CGSize(width: w, height: w * 1.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        UIScreen.main.bounds.width * 0.02
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing section: Int) -> CGFloat {
        UIScreen.main.bounds.width * 0.02
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





