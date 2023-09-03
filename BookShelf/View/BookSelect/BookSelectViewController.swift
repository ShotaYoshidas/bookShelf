//
//  BookSelectViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/24.
//

import UIKit
import Foundation
import PinLayout
import XLPagerTabStrip
import RealmSwift

protocol bookTextDelegate: AnyObject {
    func updateText(memo: String,id: String)
}


protocol BookShelfModelDeleteDelegate: AnyObject {
    func deleteBook(id: String)
}

protocol BookMoveDelegate: AnyObject {
    func moveBook(id: String)
}



class BookSelectViewController: UIViewController,UIAdaptivePresentationControllerDelegate {
    weak var delegate: bookTextDelegate? = nil
    weak var deleteDelegate: BookShelfModelDeleteDelegate? = nil
    weak var moveBookDelegate: BookMoveDelegate? = nil
    let id: String
    let titleName: String
    let authorName: String
    let imageData: Data
    let memo: String
    let saveTime: String
    let vc:Int
    init(titleName: String,authorName: String,imageData: Data,id: String,memo: String,saveTime: String,vc: Int){
        self.id = id
        self.titleName = titleName
        self.authorName = authorName
        self.imageData = imageData
        self.memo = memo
        self.saveTime = saveTime
        self.vc = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    lazy var usegeButton: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(menuTaped), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    
    var moveButton: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        u.tintColor = .naviTintColor
        return UIBarButtonItem(customView: u)
    }()
    let memoTextView: UITextView = {
        let qt =  UITextView()
        qt.textColor = .naviTintColor
        qt.backgroundColor = .cellColor
        qt.font = UIFont.systemFont(ofSize: 17)
        qt.layer.cornerRadius = 10
        qt.isEditable = true
        return qt
    }()
    let toolbar = UIToolbar()
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                target: nil,
                                action: nil)
    
    let done = UIBarButtonItem(title: "完了",
                               style: .done,
                               target: self,//なんかでる(FIXするとビルド時エラー)
                               action: #selector(didTapDoneButton))
    
    let tagImage: UIImage = {
        let i = UIImage(systemName: "bookmark.square", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor]))
        return i ?? UIImage()
    }()
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = false
        cv.register(BookSelectCell.self, forCellWithReuseIdentifier: "Cell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        navigationItem.title = titleName
        view.addSubview(collectionView)
        view.addSubview(memoTextView)
        collectionView.delegate = self
        collectionView.dataSource = self
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        memoTextView.inputAccessoryView = toolbar
        memoTextView.text = memo
        self.navigationController?.navigationBar.tintColor = .naviTintColor
        self.navigationItem.rightBarButtonItems = [usegeButton]
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        collectionView.pin.topCenter().width(UIScreen.main.bounds.width).height(UIScreen.main.bounds.height * 0.38)
        memoTextView.pin.below(of: collectionView).center().width(UIScreen.main.bounds.width * 0.95).height(UIScreen.main.bounds.width * 0.8).margin(30)
    }
   
    
    @objc func didTapDoneButton() {
        memoTextView.resignFirstResponder()
        delegate?.updateText(memo: memoTextView.text,id: id)
        collectionView.reloadData()
    }
    
    @objc func menuTaped(sender: UIButton) {
        let alert = UIAlertController(title: .none, message: "Menu", preferredStyle: .actionSheet)
        if vc == 1 {
            let moveToTumidoku = UIAlertAction(title: "積読書へ移動", style: .default) { [self] (action) in
                moveBookDelegate?.moveBook(id: self.id)
                self.navigationController?.popViewController(animated: false)
            }
            alert.addAction(moveToTumidoku)
        } else {
            let moveToKandoku = UIAlertAction(title: "完読書へ移動", style: .default) { [self] (action) in
                moveBookDelegate?.moveBook(id: self.id)
                self.navigationController?.popViewController(animated: false)
            }
            alert.addAction(moveToKandoku)
        }
        let delete = UIAlertAction(title: "本を削除", style: .destructive) { [self] (action) in
            let deleteAlert = UIAlertController(title: "本当に削除しますか", message: .none, preferredStyle: .alert)
            let ok = UIAlertAction(title: "はい", style: .default) { [self] (action) in
                deleteDelegate?.deleteBook(id: self.id)
                self.navigationController?.popViewController(animated: false)
            }
            let cancel = UIAlertAction(title: "いいえ", style: .cancel) { (acrion) in
                self.dismiss(animated: true, completion: nil)
            }
            deleteAlert.addAction(cancel)
            deleteAlert.addAction(ok)
            present(deleteAlert, animated: true, completion: nil)
            
        }
        alert.addAction(delete)
        let cancel = UIAlertAction(title: "キャンセル", style: .default) { (acrion) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("モーダルから戻ったよ")
    }
    
}

extension BookSelectViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? BookSelectCell {
            cell.BookSelectConfigure(imageData: imageData, titleName: titleName,authorName: authorName,saveTime: saveTime, memoCount: memoTextView.text.count)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.95, height: view.frame.size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 45, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
    
    
}
