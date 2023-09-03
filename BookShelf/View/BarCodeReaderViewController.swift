//
//  BarCodeReaderViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/16.
//
import UIKit
import PinLayout
import AVFoundation
//import SwiftyJSON
import RealmSwift

struct Book {
    let title:String
    let publishDate:String
    let author:String
    let thumbnail:UIImage
}

class BarCodeReaderViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    private let model: BarCodeReaderModel = .init()
    public enum HUDContentType {
        case labeledSuccess(title: String?, subtitle: String?)
    }
    
    private let session = AVCaptureSession()
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.alwaysBounceVertical = true
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .mainBackground
        return cv
    }()
    let aboveOverlay:UIView = {
        let ol = UIView()
        ol.backgroundColor = .mainBackground
        return ol
    }()
    let closeBtn:UIButton = {
        let cb = UIButton()
        cb.setTitle("閉じる", for: UIControl.State.normal)
        cb.backgroundColor = UIColor.clear
        cb.setTitleColor(.naviTintColor, for: UIControl.State.normal)
        cb.addTarget(nil, action: #selector(closeTaped(sender:)), for: .touchUpInside)
        return cb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self //トラックの配送先
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        let devices = discoverySession.devices
        if let backCamera = devices.first {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    let metadataOutput = AVCaptureMetadataOutput()
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.ean13]
                        let x: CGFloat = 0.05
                        let y: CGFloat = 0.3
                        let width: CGFloat = 0.9
                        let height: CGFloat = 0.2
                        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                        previewLayer.frame = self.view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        self.view.layer.addSublayer(previewLayer)
                        let detectionArea = UIView()
                        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
                        detectionArea.layer.borderColor = UIColor.white.cgColor
                        detectionArea.layer.borderWidth = 3
                        detectionArea.layer.cornerRadius = 15
                        view.addSubview(detectionArea)
                        view.addSubview(aboveOverlay)
                        view.addSubview(collectionView)
                        aboveOverlay.pin.top().above(of: detectionArea).marginBottom(15).width(100%)
                        collectionView.pin.below(of:  detectionArea).marginTop(15).width(100%).bottom()
                        collectionView.delegate = self
                        collectionView.dataSource = self
                        self.view.addSubview(closeBtn)
                        self.session.startRunning()
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        let width = view.frame.size.width
        let height = view.frame.size.height
        closeBtn.pin.topLeft().size(CGSize(width: width * 0.3, height: height * 0.2))
    }
   
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadata.stringValue == nil { continue }
            if metadata.stringValue!.starts(with: "978") {
                let api = APIProvider(isbn: metadata.stringValue!)
                Task {
                    let book = try await api.getBookData()
                    model.addNewBook(newBook: book)
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
        return model.books.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard model.books.count > indexPath.row else { return UICollectionViewCell() }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            cell.barCodeConfigure(image: model.books[indexPath.row].thumbnail, titleName: model.books[indexPath.row].title,authorName: model.books[indexPath.row].author)
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
        if (realm.objects(BookObject.self).filter({ [self] in $0.title == self.model.books[indexPath.row].title && $0.author == model.books[indexPath.row].author}).first != nil){
            let registered = UIAlertAction(title: "本棚に追加済みです", style: .default) {_ in
            }
            alert.addAction(registered)
        } else {
            let bookShelf = UIAlertAction(title: "本棚に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": model.books[indexPath.row]]
                NotificationCenter.default.post(name:.addBarcodeKandokBookShelf, object: nil, userInfo: userInfo)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name("call"), object: nil, userInfo: .none)
                
            }
            let willBookShelf = UIAlertAction(title: "積読書に追加", style: .default) { [self] (action) in
                let userInfo = ["serchBook": model.books[indexPath.row]]
                NotificationCenter.default.post(name: .addBarcodeTumidokBookShelf, object: nil, userInfo: userInfo as [AnyHashable : Any])
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
extension BarCodeReaderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.85, height: view.frame.size.height * 0.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width/2 - 80, bottom: 0, right: UIScreen.main.bounds.width/2 - 80)
    }
}
