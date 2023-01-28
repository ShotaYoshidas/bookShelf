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
protocol bookTextDelegate: AnyObject {
    func updateText(memo: String,id: String)
}

protocol BookShelfModelDeleteDelegate: AnyObject {
    func deleteBook(id: String)
}

protocol BookMoveDelegate: AnyObject {
    func moveBook(id: String)
}

class BookSelectViewController: UIViewController {
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
    init(titleName: String,authorName: String,imageData: Data,id: String,memo: String,saveTime: String,vc: Int) {
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
    
    var usegeButton: UIBarButtonItem = {
        let u = UIBarButtonItem()
        u.tintColor = UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        return u
    }()
    
    var usegeButton1: UIBarButtonItem = {
        let u = UIBarButtonItem()
        u.tintColor = UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        return u
    }()
    
    let memoTextView: UITextView = {
        let qt =  UITextView()
        qt.layer.borderColor = UIColor.white.cgColor
        qt.layer.borderWidth = 1
        qt.textColor = .black
        qt.backgroundColor = .white
        qt.font = UIFont.systemFont(ofSize: 17)
        qt.layer.cornerRadius = 10
        qt.isEditable = true
        return qt
    }()
    
    let countLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textColor = .darkGray
        l.font =  UIFont.boldSystemFont(ofSize: 15)
        return l
    }()
    
    let toolbar = UIToolbar()
    
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                target: nil,
                                action: nil)
    let done = UIBarButtonItem(title: "完了",
                               style: .done,
                               target: self,//なんかでる(FIXするとビルド時エラー)
                               action: #selector(didTapDoneButton))
    
    
    let moveButton: UIButton = {
        let m = UIButton()
        m.backgroundColor = .white
        m.setTitle("完読書へ移動", for: .normal) // ボタンのタイトル
        m.setTitleColor(UIColor.darkGray, for: .normal) // タイトルの色
        m.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 15)
        m.layer.cornerRadius = 10
        m.addTarget(nil, action: #selector(edit(sender:)), for: .touchUpInside)
        return m
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
        view.backgroundColor = .systemGray4
        navigationItem.title  = titleName
        view.addSubview(collectionView)
        view.addSubview(memoTextView)
        view.addSubview(countLabel)
        view.addSubview(moveButton)
        collectionView.delegate = self
        collectionView.dataSource = self
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        memoTextView.inputAccessoryView = toolbar
        memoTextView.text = memo
        let commentNum = memoTextView.text.count
        countLabel.text = "文字数：\(commentNum)"
        usegeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(taped))
        self.navigationItem.rightBarButtonItem = usegeButton
        self.navigationItem.rightBarButtonItems = [usegeButton]
        if vc == 1{
            moveButton.isHidden = true
        } else if vc == 2{
            moveButton.isHidden = false
        }
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        collectionView.pin.topCenter().width(UIScreen.main.bounds.width).height(UIScreen.main.bounds.height * 0.35)
        memoTextView.pin.below(of: collectionView).center().width(UIScreen.main.bounds.width * 0.85).height(UIScreen.main.bounds.width * 0.70)
        countLabel.pin.below(of: memoTextView, aligned: .right).width(UIScreen.main.bounds.width / 4).height(UIScreen.main.bounds.width / 10)
        moveButton.pin.below(of: memoTextView,aligned: .center).width(UIScreen.main.bounds.width * 0.33).height(UIScreen.main.bounds.width * 0.12).margin(28)
    }
    @objc func didTapDoneButton() {
        memoTextView.resignFirstResponder()
        delegate?.updateText(memo: memoTextView.text,id: id)
        let commentNum = memoTextView.text.count
        countLabel.text = "文字数：\(commentNum)"
    }
    
    
    @objc func taped(sender: UIButton) {
        let alert = UIAlertController(title: .none, message: "本当に削除しますか？", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
                    let screenSize = UIScreen.main.bounds
                    alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        let delete = UIAlertAction(title: "削除する", style: .default) { [self] (action) in
            deleteDelegate?.deleteBook(id: self.id)
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(delete)
        let cancel = UIAlertAction(title: "やめておく", style: .cancel) { (acrion) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func edit(sender: UIButton) {
        let alert = UIAlertController(title: .none, message: "完読書に移動しますか？", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
                    let screenSize = UIScreen.main.bounds
                    alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        let move = UIAlertAction(title: "はい", style: .default) { [self] (action) in
            moveBookDelegate?.moveBook(id: self.id)
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(move)
        let cancel = UIAlertAction(title: "いいえ", style: .cancel) { (acrion) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
extension BookSelectViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? BookSelectCell {
            cell.BookSelectConfigure(imageData: imageData, titleName: titleName,authorName: authorName,saveTime: saveTime)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.85, height: view.frame.size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
    
    
}
