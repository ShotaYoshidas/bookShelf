//
//  CollectionViewCell.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/04.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    let canvas:UILabel = {
        let t  = UILabel()
        t.numberOfLines = 4
        return t
    }()
    
    let thumnailImage:UIImageView = {
        let cv = UIImageView()
        cv.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.masksToBounds = false
        cv.layer.shadowOpacity = 0.3
        cv.layer.shadowRadius = 0.5
        cv.layer.cornerRadius = 0.9
        cv.isUserInteractionEnabled = true
        cv.contentMode = .scaleAspectFit
        return cv
    }()
    
    let title:UILabel = {
        let t  = UILabel()
        t.textColor = .black
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.numberOfLines = 0
        return t
    }()
    
    let author: UILabel = {
        let l = UILabel()
        l.textColor = .gray
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    let saveTimeLabel: UILabel = {
        let t = UILabel()
        t.textColor = .black
        t.font = UIFont.systemFont(ofSize: 10)
        return t
    }()
    
    let nillImage: UIImage = UIImage(named:"bookImage")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        addSubview(thumnailImage)
        addSubview(title)
        addSubview(author)
        addSubview(saveTimeLabel)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        thumnailImage.pin.top().left().bottom().margin(15).width(UIScreen.main.bounds.width * 0.2)
        title.pin.right(of: thumnailImage).topLeft().topRight().margin(25).width(UIScreen.main.bounds.width * 0.5).sizeToFit(.width)
        author.pin.below(of: title,aligned: .center).width(UIScreen.main.bounds.width * 0.5).sizeToFit(.width)
    }
    
    func configure(imageData: Data, titleName: String, authorName: String, saveTime: String ) {//realm保存仕様の為、imageをデータ型に
        title.text = titleName
        author.text = authorName
        guard let image = UIImage(data: imageData)
        else {
            thumnailImage.image = nillImage
            return
        }
        thumnailImage.image = image
        
    }
   
    
    
    func barCodeConfigure(image: UIImage, titleName: String, authorName: String) {
        title.text = titleName
        author.text = authorName
        thumnailImage.image = image
    }
    
    func searchConfigure(titleName: String,authorName: String,imageUrl: String) {
        title.text = titleName
        author.text = authorName
        thumnailImage.loadImage(with: imageUrl)
    }
    
    
}

class GridCollectionViewCell: UICollectionViewCell {
    let thumnailImage:UIImageView = {
        let cv = UIImageView()
        cv.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.masksToBounds = false
        cv.layer.shadowOpacity = 0.3
        cv.layer.shadowRadius = 0.5
        cv.layer.cornerRadius = 0.9
        cv.isUserInteractionEnabled = true
        cv.contentMode = .scaleAspectFit
        return cv
    }()
    let nillImage: UIImage = UIImage(named:"bookImage")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray6
       addSubview(thumnailImage)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        thumnailImage.pin.all()
     
    }
    
    func gridConfigure(imageData: Data) {//realm保存仕様の為、imageをデータ型に
        
        guard let image = UIImage(data: imageData)
                
        else {
            thumnailImage.image = nillImage
            return
        }
        thumnailImage.image = image
        
    }
}
class BookSelectCell: UICollectionViewCell {
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    let canvas:UILabel = {
        let t  = UILabel()
        t.numberOfLines = 4
        return t
    }()
    
    let thumnailImage:UIImageView = {
        let cv = UIImageView()
        cv.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.masksToBounds = false
        cv.layer.shadowOpacity = 0.3
        cv.layer.shadowRadius = 0.5
        cv.layer.cornerRadius = 0.9
        cv.isUserInteractionEnabled = true
        cv.contentMode = .scaleAspectFit
        
        return cv
    }()
    
    let title:UILabel = {
        let t  = UILabel()
        t.textColor = .black
        t.font = UIFont.boldSystemFont(ofSize: 15)
        t.numberOfLines = 4
        return t
    }()
    
    let author: UILabel = {
        let l = UILabel()
        l.textColor = .gray
        l.font = UIFont.systemFont(ofSize: 12)
        
        return l
    }()
    
    let saveTimeLabel: UILabel = {
        let t = UILabel()
        t.textColor = .black
        
        t.font = UIFont.systemFont(ofSize: 10)
        
        return t
    }()
    
    let nillImage: UIImage = UIImage(named:"bookImage")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        addSubview(thumnailImage)
        addSubview(title)
        addSubview(author)
        addSubview(saveTimeLabel)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        thumnailImage.pin.top().left().bottom().margin(15).width(UIScreen.main.bounds.width * 0.2)
        title.pin.right(of: thumnailImage).topLeft().topRight().margin(25).width(UIScreen.main.bounds.width * 0.5).sizeToFit(.width)
        author.pin.below(of: title,aligned: .center).width(UIScreen.main.bounds.width * 0.5).sizeToFit(.width)
        saveTimeLabel.pin.below(of: author,aligned: .center).width(UIScreen.main.bounds.width * 0.5).sizeToFit(.width)
    }
   
    func BookSelectConfigure(imageData: Data, titleName: String, authorName: String, saveTime: String ){
        title.text = titleName
        author.text = authorName
        let prefixStr: Substring = saveTime.prefix(10)
        saveTimeLabel.text = "登録日:\(prefixStr)"
        guard let image = UIImage(data: imageData)
        else {
            thumnailImage.image = nillImage
            return
        }
        thumnailImage.image = image
    }
    
}
