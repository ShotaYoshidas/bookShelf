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

struct TopTier : Codable {
    var kind: String?
    var totalItems: Int?  // " " (ダブルクォート)で囲われていない数値なので Int
    var items: [Item]?    // JSON 上で [ ] (ブラケット)で囲われているので配列にする
}
struct Item: Codable {
    var volumeInfo: VolumeInfo?   // 上記 Item と同じく構造体で入れ子になっているので別途定義
    
}
struct VolumeInfo: Codable {
    var title: String?
    var subtitle: String?    // 検索によってそもそも値が存在しない可能性がある場合、nil はオプショナル
    var authors: [String]?   // 配列&文字列なので Array ついでに検索によって無い場合があるのでオプショナル
    var imageLinks: ImageLinks?
    var int:Int?
}
struct ImageLinks: Codable {
    var thumbnail:String?
    // 中略
}

class SerchBookViewController: UIViewController,UISearchBarDelegate {
    private let searchmodel: SearchBookModel = .init()
    var bannerView: GADBannerView!
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
    
    var searchBooksField: UISearchBar = {
        let s = UISearchBar()
        s.showsCancelButton = true
        s.backgroundImage = UIImage()
        s.backgroundColor = .systemGray6
        s.layer.cornerRadius = 4
        s.showsCancelButton = true
        s.placeholder = "本を検索"
        return s
    }()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = UIColor.systemGray6
        return cv
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationBar15()
        let image1 = UIImage(systemName: "camera.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let image2 = UIImage(systemName: "pencil.line")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        usegeButton = UIBarButtonItem(image: image1, style: .plain, target: self, action: #selector(camera))
        usegeButton2 = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(taped))
        self.navigationItem.rightBarButtonItems = [usegeButton2,usegeButton]
        view.addSubview(searchBooksField)
        searchBooksField.delegate = self
        searchmodel.delegate = self
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        //GADBannerViewの作成
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
//        テスト：ca-app-pub-3940256099942544/6300978111
//        本番：ca-app-pub-1273760422540329/1826776892
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
        
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        searchBooksField.pin.top(UIScreen.main.bounds.height * 0.12).left(UIScreen.main.bounds.width * 0.01).right(UIScreen.main.bounds.width * 0.01).height(UIScreen.main.bounds.height * 0.05)
        collectionView.pin.below(of: searchBooksField).all()
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    //    15以外の設定してない
    func navigationBar15(){
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemGray6
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.title = "本を探す"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let encodedString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        searchmodel.getBooks(encodedString: encodedString ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchmodel.bookIsEmpty()
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
}

extension SerchBookViewController: SearchBookModelDelegate {
    func updateCollectionView() {
        collectionView.reloadData()
    }
}

extension SerchBookViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchmodel.response?.items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard searchmodel.response?.items?.count ?? 0 > indexPath.row else { return UICollectionViewCell() }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            cell.searchConfigure(titleName: searchmodel.response?.items![indexPath.row].volumeInfo!.title! ?? "",authorName: searchmodel.response?.items![indexPath.row].volumeInfo!.authors?[0] ?? "",imageUrl:  searchmodel.response?.items![indexPath.row].volumeInfo?.imageLinks?.thumbnail ?? "")
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
       
        alert.popoverPresentationController?.sourceView = self.view
                    let screenSize = UIScreen.main.bounds
                    alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        
        let realm = try! Realm()
        if (realm.objects(BookObject.self).filter({ [self] in $0.title == self.searchmodel.response?.items![indexPath.row].volumeInfo!.title! && $0.author == searchmodel.response?.items![indexPath.row].volumeInfo!.authors?[0]}).first != nil){
            let registered = UIAlertAction(title: "本棚に追加済みです", style: .default) {_ in
            }
            alert.addAction(registered)
        } else {
            let bookShelf = UIAlertAction(title: "完読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": searchmodel.response?.items![indexPath.row]]
                NotificationCenter.default.post(name: Notification.Name("SerchKandokuUpdate"), object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
            }
            let willBookShelf = UIAlertAction(title: "積読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": searchmodel.response?.items![indexPath.row]]
                NotificationCenter.default.post(name: Notification.Name("SerchTumidokuUpdate"), object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
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

extension SerchBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.85, height: view.frame.size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
}


