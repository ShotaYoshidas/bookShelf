//
//  GridCollectionViewCell.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/09/10.
//

import UIKit

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
        self.backgroundColor = .mainBackground
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
        backgroundColor = .mainBackground
        
    }
}
