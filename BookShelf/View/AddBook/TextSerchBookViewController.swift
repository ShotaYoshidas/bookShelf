//
//  ViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/14.
//

import UIKit
import PinLayout
import GoogleMobileAds
import RealmSwift

class TextSerchBookViewController: UIViewController,UISearchBarDelegate,SearchBookModelDelegate {
    
    private let textSearchBookModel: TextSearchBookModel = .init()
    
    lazy var pencilButton: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "pencil.line", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(taped), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    
    lazy var cameraButton: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "camera.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(camera), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    
    var searchBooksField: UISearchBar = {
        let s = UISearchBar()
        s.showsCancelButton = true
        s.backgroundImage = UIImage()
        s.backgroundColor = .mainBackground
        s.layer.cornerRadius = 4
        s.showsCancelButton = true
        s.placeholder = "本を検索"
        return s
    }()
    
    let listcollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "listcell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .mainBackground
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        listcollectionView.backgroundColor = .mainBackground
        searchBooksField.backgroundColor = .mainBackground
        navigationBar15()
        view.addSubview(searchBooksField)
        searchBooksField.delegate = self
        textSearchBookModel.searchBookDelegate = self
        view.addSubview(listcollectionView)
        listcollectionView.delegate = self
        listcollectionView.dataSource = self
        self.navigationItem.rightBarButtonItems = [pencilButton,cameraButton]
        self.navigationController?.navigationBar.tintColor = .naviTintColor
        NotificationCenter.default.addObserver(self, selector: #selector(addBookMsg(_:)), name: .addBookMessage, object: nil)
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        searchBooksField.pin.top(UIScreen.main.bounds.height * 0.12).left(UIScreen.main.bounds.width * 0.01).right(UIScreen.main.bounds.width * 0.01).height(UIScreen.main.bounds.height * 0.05)
        listcollectionView.pin.below(of: searchBooksField).all()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func addBookMsg(_ notification: Notification) {
        let alert1 = UIAlertController(title: "本棚に追加しました！", message: .none, preferredStyle: .alert)
        present(alert1, animated: true, completion: {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                alert1.dismiss(animated: true, completion: nil)
            }
        })
    }
        
    func navigationBar15(){
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .mainBackground
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.naviTintColor]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.title = "本を探す"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let encodedString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        textSearchBookModel.getBooks(encodedString: encodedString ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            textSearchBookModel.bookIsEmpty()
        }
    }
    
    @objc func taped(sender: UIButton) {
        let vc = ManualInputBookViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func camera(sender: UIButton) {
        let brVc = BarCodeReaderViewController()
        brVc.modalPresentationStyle = .automatic
        self.present(brVc, animated: true, completion: nil)
    }
    
    func updateCollectionView() {
        listcollectionView.reloadData()
    }
    
}

extension TextSerchBookViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textSearchBookModel.response?.items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard textSearchBookModel.response?.items?.count ?? 0 > indexPath.row else { return UICollectionViewCell() }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listcell", for: indexPath) as? ListCollectionViewCell {
            cell.searchConfigure(titleName: textSearchBookModel.response?.items![indexPath.row].volumeInfo!.title! ?? "",authorName: textSearchBookModel.response?.items![indexPath.row].volumeInfo!.authors?[0] ?? "",imageUrl:  textSearchBookModel.response?.items![indexPath.row].volumeInfo?.imageLinks?.thumbnail ?? "")
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = self.view
        let screenSize = UIScreen.main.bounds
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        let realm = try! Realm()
        if (realm.objects(BookObject.self).filter({ [self] in $0.title == self.textSearchBookModel.response?.items![indexPath.row].volumeInfo!.title! && $0.author == textSearchBookModel.response?.items![indexPath.row].volumeInfo!.authors?[0]}).first != nil){
            let registered = UIAlertAction(title: "本棚に追加済みです", style: .default) {_ in
            }
            alert.addAction(registered)
        } else {
            let bookShelf = UIAlertAction(title: "完読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": textSearchBookModel.response?.items![indexPath.row]]
                NotificationCenter.default.post(name: .addKandokBookShelf, object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "本棚に追加しました！", message: .none, preferredStyle: .alert)
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
            }
            
            let willBookShelf = UIAlertAction(title: "積読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": textSearchBookModel.response?.items![indexPath.row]]
                NotificationCenter.default.post(name: .addTumidokBookShelf, object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "本棚に追加しました！", message: .none, preferredStyle: .alert)
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
                
            }
            
            alert.addAction(bookShelf)
            alert.addAction(willBookShelf)
            
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (acrion) in
            alert.dismiss(animated: true, completion: nil)
            
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

extension TextSerchBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.95, height: view.frame.size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
}


