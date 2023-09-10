//
//  BookSelectViewCell.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/09/10.
//

import UIKit

class ContentsCollectionViewCell: UICollectionViewCell {
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
        t.textColor = .naviTintColor
        t.font = UIFont.boldSystemFont(ofSize: 15)
        t.numberOfLines = 4
        return t
    }()
    
    let author: UILabel = {
        let l = UILabel()
        l.textColor = .gray
        l.font = UIFont.systemFont(ofSize: 14)
        
        return l
    }()
    
    let saveTimeLabel: UILabel = {
        let t = UILabel()
        t.textColor = .gray
        t.font = UIFont.systemFont(ofSize: 13)
        
        return t
    }()
    
    let memoCountLabel: UILabel = {
        let a = UILabel()
        a.textColor = .gray
        a.font = UIFont.systemFont(ofSize: 13)
        return a
    }()
   
  
    
    let nillImage: UIImage = UIImage(named:"bookImage")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cellColor
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        addSubview(thumnailImage)
        addSubview(title)
        addSubview(author)
        addSubview(saveTimeLabel)
        addSubview(memoCountLabel)
        
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
        memoCountLabel.pin.below(of: saveTimeLabel,aligned: .center).width(UIScreen.main.bounds.width * 0.5).sizeToFit(.width)
    }
   
    func BookSelectConfigure(imageData: Data, titleName: String, authorName: String, saveTime: String, memoCount: Int){
        title.text = titleName
        author.text = authorName
        memoCountLabel.text = "文字数:\(memoCount)"
        let prefixStr: Substring = saveTime.prefix(10)
        saveTimeLabel.text = "登録日:\(prefixStr)"
        guard let image = UIImage(data: imageData)
        else {
            thumnailImage.image = nillImage
            return
        }
        thumnailImage.image = image
        backgroundColor = .cellColor
    }
    
}


