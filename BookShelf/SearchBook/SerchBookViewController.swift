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
    var totalItems: Int?
    var items: [Item]?
}

struct Item: Codable {
    var volumeInfo: VolumeInfo?
    
}

struct VolumeInfo: Codable {
    var title: String?
    //    var subtitle: String?
    var authors: [String]?
    var imageLinks: ImageLinks?
    //    var int:Int?
}
struct ImageLinks: Codable {
    var thumbnail:String?
    // 中略
}

class SerchBookViewController: UIViewController,UISearchBarDelegate {
    private let searchmodel: SearchBookModel = .init()
    var bannerView: GADBannerView!
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
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .mainBackground
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        collectionView.backgroundColor = .mainBackground
        searchBooksField.backgroundColor = .mainBackground
        navigationBar15()
        view.addSubview(searchBooksField)
        searchBooksField.delegate = self
        searchmodel.delegate = self
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationItem.rightBarButtonItems = [pencilButton,cameraButton]
        self.navigationController?.navigationBar.tintColor = .naviTintColor
//        GoogleMobile()
        NotificationCenter.default.addObserver(self, selector: #selector(call(_:)), name: Notification.Name("call"), object: nil)
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        searchBooksField.pin.top(UIScreen.main.bounds.height * 0.12).left(UIScreen.main.bounds.width * 0.01).right(UIScreen.main.bounds.width * 0.01).height(UIScreen.main.bounds.height * 0.05)
        collectionView.pin.below(of: searchBooksField).all()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func call(_ notification: Notification) {
        let alert1 = UIAlertController(title: "本棚に追加しました！", message: .none, preferredStyle: .alert)
        present(alert1, animated: true, completion: {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                alert1.dismiss(animated: true, completion: nil)
            }
        })
    }
//    広告
//    func GoogleMobile(){
//        bannerView = GADBannerView(adSize: GADAdSizeBanner)
//        addBannerViewToView(bannerView)
//      bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
////        bannerView.adUnitID = "ca-app-pub-1273760422540329/4032757853"
//        //        テスト：ca-app-pub-3940256099942544/6300978111
//        //        本番：ca-app-pub-1273760422540329/4032757853
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//    }
    
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
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        let realm = try! Realm()
        if (realm.objects(BookObject.self).filter({ [self] in $0.title == self.searchmodel.response?.items![indexPath.row].volumeInfo!.title! && $0.author == searchmodel.response?.items![indexPath.row].volumeInfo!.authors?[0]}).first != nil){
            let registered = UIAlertAction(title: "本棚に追加済みです", style: .default) {_ in
            }
            alert.addAction(registered)
        } else {
            let bookShelf = UIAlertAction(title: "完読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": searchmodel.response?.items![indexPath.row]]
                NotificationCenter.default.post(name: .addKandokBookShelf, object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "本棚に追加しました！", message: .none, preferredStyle: .alert)
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
                
            }
            let willBookShelf = UIAlertAction(title: "積読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": searchmodel.response?.items![indexPath.row]]
                NotificationCenter.default.post(name: .addTumidokBookShelf, object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "本棚に追加しました！", message: .none, preferredStyle: .alert)
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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

extension SerchBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.95, height: view.frame.size.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
}


