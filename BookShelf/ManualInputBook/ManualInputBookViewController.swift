//
//  ManualInputBookViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/11/08.
//

import UIKit
import PinLayout
import XLPagerTabStrip
import IQKeyboardManagerSwift

class ManualInputBookViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    var usegeButton: UIBarButtonItem = {
        let u = UIBarButtonItem()
        u.title = "保存"
        u.tintColor = UIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        return u
    }()
    
    let thumbnailView:UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .white
        i.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        i.isUserInteractionEnabled = true
        i.layer.shadowColor = UIColor.black.cgColor
        i.layer.masksToBounds = false
        i.layer.shadowOpacity = 0.4
        i.layer.shadowRadius = 0.9
        i.layer.cornerRadius = 0.9
        i.image = UIImage(named:"bookImage")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return i
    }()
    
    lazy var scrollView:UIScrollView = {
        let sc = UIScrollView()
        sc.backgroundColor = .mainBackground
        return sc
    }()
    
    let titleLabel:UILabel = {
        let t = UILabel()
        t.text = "タイトル(必須)"
        t.textColor = UIColor.lightGray
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.backgroundColor = .mainBackground
        return t
    }()
    
    let authorLabel:UILabel = {
        let t = UILabel()
        t.text = "著者(任意)"
        t.textColor = UIColor.lightGray
        t.font = UIFont.systemFont(ofSize: 15)
        t.textAlignment = .left
        t.backgroundColor = .mainBackground
        return t
    }()
    
    let titleTextView: UITextField = {
        let qt =  UITextField()
        qt.layer.borderColor = UIColor.black.cgColor
        qt.layer.borderWidth = 0
        qt.textColor = .black
        qt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/20)
        qt.layer.cornerRadius = 10
        qt.backgroundColor = .cellColor
        return qt
    }()
    
    let authorTextView: UITextField = {
        let qt =  UITextField()
        qt.layer.borderColor = UIColor.black.cgColor
        qt.layer.borderWidth = 0
        qt.textColor = .black
        qt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/20)
        qt.layer.cornerRadius = 10
        qt.backgroundColor = .cellColor
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        self.view.addSubview(scrollView)
        view.addSubview(thumbnailView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleTextView)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(authorTextView)
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        titleTextView.inputAccessoryView = toolbar
        authorTextView.inputAccessoryView = toolbar
        titleTextView.delegate  = self
        authorTextView.delegate  = self
        thumbnailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        usegeButton = UIBarButtonItem(title: "保存", style: .done, target: self, action:  #selector(saveTaped))
        self.navigationItem.rightBarButtonItem = usegeButton
        self.navigationItem.rightBarButtonItems = [usegeButton]
        navigationItem.title = "入力画面"
        self.navigationController?.navigationBar.tintColor = .naviTintColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = view.frame.size.width
        let height = view.frame.size.height
        scrollView.frame = CGRect(x: 0, y: width * 0.9, width: width, height: height * 0.5)
        scrollView.contentSize = CGSize(width: width, height: height * 0.55)
        titleTextView.pin.topCenter().size(CGSize(width: width * 0.85, height: height * 0.058)).marginTop(50)
        titleLabel.pin.above(of: titleTextView,aligned: .left).size(CGSize(width: width * 0.3, height: height * 0.03))
        authorLabel.pin.below(of: titleTextView,aligned: .left).size(of: titleLabel).marginVertical(30)
        authorTextView.pin.below(of: authorLabel,aligned: .left).size(of: titleTextView)
        thumbnailView.pin.above(of: scrollView,aligned: .center).size(CGSize(width: width * 0.3, height: height * 0.2)).margin(10)
        
    }
    
    @objc func saveTaped(sender: UIButton) {
        if titleTextView.text == "" {
            let alert = UIAlertController(title: .none, message: "タイトルが未記入です", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
        } else {
            let bookInfo = ["title": titleTextView.text ?? "nil","author": authorTextView.text ?? "nil","thumnail": thumbnailView.image ?? UIImage()] as [String : Any]
            NotificationCenter.default.post(name: Notification.Name("ManualInput"), object: nil, userInfo: bookInfo as [AnyHashable : Any])
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func didTapDoneButton() {
        titleTextView.resignFirstResponder()//textViewを破棄(resignは辞任とか)
        authorTextView.resignFirstResponder()
    }
    
    @objc func imageViewTapped() {
        let alert = UIAlertController(title: .none, message: "画像を追加する", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "カメラで撮影", style: .default) { [self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
        
        let album = UIAlertAction(title: "アルバムから取得", style: .default) { [self] (action) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "いいえ", style: .cancel) { (acrion) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension ManualInputBookViewController {
    //    Use Photoを押したときに呼ばれる関数
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            //データ圧縮コピペした
            let resizedImage = pickedImage.resized(withPercentage: 0.1)
            thumbnailView.image = resizedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ManualInputBookViewController:UITextFieldDelegate {
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}

extension UIImage {
    //データサイズを変更する
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

