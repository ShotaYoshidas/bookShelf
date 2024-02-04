//
//  BarCodeReaderViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/16.
//
import UIKit
import PinLayout
import AVFoundation
import RealmSwift

class BarCodeReaderViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    private let barCodeReaderModel: BarCodeReaderModel = .init()
    public enum HUDContentType {
        case labeledSuccess(title: String?, subtitle: String?)
    }
    
    //そのセッションにどのようなInputがあってどのようにOutputするのかを設定するやつ
    private let session = AVCaptureSession()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .mainBackground
        return collectionView
    }()
    
    let barcodeText: UILabel = {
        let barcodeText = UILabel()
        barcodeText.text = "'978'から始まるバーコードを読み取って下さい"
        barcodeText.textColor = .naviTintColor
        barcodeText.font = UIFont.systemFont(ofSize: 15)
        barcodeText.textAlignment = NSTextAlignment.center
        barcodeText.backgroundColor = .clear
        return barcodeText
    }()
    
    let aboveOverlay:UIView = {
        let aboveOverlay = UIView()
        aboveOverlay.backgroundColor = .mainBackground
        return aboveOverlay
    }()
    
    lazy var detectionArea: UIView = {
        let detectionArea = UIView()
        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        detectionArea.layer.borderColor = UIColor.white.cgColor
        detectionArea.layer.borderWidth = 3
        detectionArea.layer.cornerRadius = 15
        return detectionArea
    }()
    
    let x: CGFloat = 0.05
    let y: CGFloat = 0.3
    let width: CGFloat = 0.9
    let height: CGFloat = 0.2
    
    lazy var closeBtn: UIBarButtonItem = {
        let u = UIButton()
        u.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        u.setImage(UIImage.init(systemName: "xmark.circle", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: .normal)
        u.addTarget(self, action: #selector(closeTaped), for: UIControl.Event.touchUpInside)
        u.imageView?.contentMode = .scaleAspectFit
        u.contentHorizontalAlignment = .fill
        u.contentVerticalAlignment = .fill
        return UIBarButtonItem(customView: u)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "バーコード検索"
        self.navigationItem.rightBarButtonItems = [closeBtn]
        barCodeReaderModel.barCodeReaderModelDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        setupAVCapture()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        aboveOverlay.pin.top().above(of: detectionArea).marginBottom(15).width(100%)
        collectionView.pin.below(of:  detectionArea).marginTop(15).width(100%).bottom()
        barcodeText.pin.above(of: detectionArea).margin(17).width(90%).height(5%).center()
    }
    
    func setupAVCapture() {
        //入力（背面カメラ）カメラデバイスの管理を行うクラスを初期化
        //スマホの背面カメラを見つけるよ！
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        let devices = discoverySession.devices
        if let backCamera = devices.first {
            do {
                // 入力デバイスの接続(入力とAVCaptureSessionの仲介役)
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                //AVCaptureSessionに入力デバイスを追加できるかどうかをチェック
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    // 出力（メタデータ)を作成
                    let metadataOutput = AVCaptureMetadataOutput()
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        // メタデータを検出した際のデリゲート設定
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        // EAN-13コードの認識を設定(.ean13は本の書籍などに使用されるバーコード)
                        metadataOutput.metadataObjectTypes = [.ean13]
                        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                        // 背面カメラの映像を画面に表示するためのレイヤーを生成
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                        previewLayer.frame = self.view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        
                        self.view.layer.addSublayer(previewLayer)
                        
                        view.addSubview(detectionArea)
                        view.addSubview(aboveOverlay)
                        view.addSubview(collectionView)
                        view.addSubview(barcodeText)
                        print(Thread.current.isMainThread)
                        // 読み取り開始
                        DispatchQueue.global(qos: .userInitiated).async {
                          self.session.startRunning()
                        }
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
   
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadata.stringValue == nil { continue }
            if metadata.stringValue!.starts(with: "978") {
                let api = APIProvider(isbn: metadata.stringValue!)
                Task {
                    let book = try await api.getBookData()
                    barCodeReaderModel.addNewBook(newBook: book)
                }
                self.session.stopRunning()
            }
        }
    }
    @objc func closeTaped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension BarCodeReaderViewController: BarCodeReaderModelDelegate {
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
}
extension BarCodeReaderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barCodeReaderModel.books.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard barCodeReaderModel.books.count > indexPath.row else { return UICollectionViewCell() }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ListCollectionViewCell {
            cell.barCodeConfigure(image: barCodeReaderModel.books[indexPath.row].thumbnail, titleName: barCodeReaderModel.books[indexPath.row].title,authorName: barCodeReaderModel.books[indexPath.row].author)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        let realm = try! Realm()
        if (realm.objects(BookObject.self).filter({ [self] in $0.title == self.barCodeReaderModel.books[indexPath.row].title && $0.author == barCodeReaderModel.books[indexPath.row].author}).first != nil){
            let registered = UIAlertAction(title: "本棚に追加済みです", style: .default) {_ in
            }
            alert.addAction(registered)
        } else {
            let bookShelf = UIAlertAction(title: "本棚に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": barCodeReaderModel.books[indexPath.row]]
                NotificationCenter.default.post(name:.addBarcodeKandokBookShelf, object: nil, userInfo: userInfo)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .addBookMessage, object: nil, userInfo: .none)
            }
            let willBookShelf = UIAlertAction(title: "積読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": barCodeReaderModel.books[indexPath.row]]
                NotificationCenter.default.post(name: .addBarcodeTumidokBookShelf, object: nil, userInfo: userInfo as [AnyHashable : Any])
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .addBookMessage, object: nil, userInfo: .none)
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

extension BarCodeReaderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.85, height: view.frame.size.height * 0.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
}
