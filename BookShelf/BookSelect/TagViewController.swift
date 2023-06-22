
//  TagViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/04/20.
//

import UIKit
import RealmSwift


class TagViewController: UIViewController,UIGestureRecognizerDelegate,tagUpdateDelegate {
    func tagUpdate() {
        addTag()
    }
    let textLabel:UILabel = {
        let tl = UILabel()
        tl.text = "タグ選択"
        tl.backgroundColor = .white
        tl.textColor = .black
        tl.font = UIFont.boldSystemFont(ofSize: 18)
        tl.textAlignment = .center
        return tl
    }()
    let tagEditButton:UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        
        b.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: UIControl.State.normal)
        
        b.imageView?.contentMode = .scaleAspectFill
        b.contentHorizontalAlignment = .fill
        b.contentVerticalAlignment = .fill
        b.addTarget(nil, action: #selector(tagEdit), for: .touchUpInside)
        return b
    }()
    let tagView:UIView = {
        let tv = UIView()
        tv.backgroundColor = .white
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.cornerRadius = 10
        tv.clipsToBounds = true
        return tv
    }()
    var tagsPositionX:CGFloat = 0
    var tagsPositionY:CGFloat = 0
    let closeBtn:UIButton = {
        let cb = UIButton()
        cb.setTitle("閉じる", for: UIControl.State.normal)
        cb.backgroundColor = UIColor.clear
        cb.setTitleColor(.naviTintColor, for: UIControl.State.normal)
        //        cb.addTarget(nil, action: #selector(), for: .touchUpInside)
        return cb
    }()
    let padding: CGFloat = 10
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var isSelected = Array(repeating: false, count: tags.count)


//    let tagList:List<tagObject>
//    init(tagList:List<tagObject>) {
//        self.tagList = tagList
//        super.init(nibName: nil, bundle: nil)
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(textLabel)
    view.addSubview(tagEditButton)
    view.addSubview(tagView)
    addTag()
}
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        textLabel.pin.topCenter().height(35).width(width * 0.2).margin(6)
        tagEditButton.pin.topRight(to: view.anchor.topRight).height(28).width(28).margin(6)
        tagView.pin.below(of: textLabel, aligned: .center).height(height * 0.4).width(width * 0.9)
        
    }
    
    @objc func tagEdit(){
        let vc = tagEditViewController()
        vc.tagDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func addTag() {
        tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
        defaults.set(tags, forKey: "tags")
        var subviews = tagView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        viewDidLayoutSubviews()
        for (index, element) in tags.enumerated() {
            let tagButton = UIButton()
            tagButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            tagButton.backgroundColor = .blue
            tagButton.setTitleColor(.white, for: UIControl.State.normal)
            tagButton.layer.cornerRadius = 15
            tagButton.setTitle(element, for: UIControl.State.normal)
            tagButton.tag = index
            print("tagtest\(tags)")
//            if let savedSelections = UserDefaults.standard.array(forKey: "SelectedTags") as? [Bool] {
//                isSelected = savedSelections
//                if isSelected[index] {
//                    tagButton.backgroundColor = UIColor.blue
//                    tagButton.setTitleColor(UIColor.white, for: .normal)
//                } else {
//                    tagButton.backgroundColor = UIColor.white
//                    tagButton.setTitleColor(UIColor.blue, for: .normal)
//
//                }
//            }
            tagButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
            tagView.addSubview(tagButton)
            if index == 0 {
                tagButton.pin.left(5).top(5).sizeToFit()
                tagButton.frame.size.height += padding * 1.2
                tagButton.frame.size.width += padding * 1.3
                tagButton.titleLabel?.textAlignment = NSTextAlignment.center
            } else {
                let previousLabel = tagView.subviews[index - 1] as! UIButton
                tagButton.pin.right(of: previousLabel, aligned: .top).marginLeft(10).sizeToFit()
                tagButton.frame.size.height += padding * 1.3
                tagButton.frame.size.width += padding * 1.3
                tagButton.titleLabel?.textAlignment = NSTextAlignment.center
                if(tagButton.frame.maxX >= tagView.frame.size.width){
                    tagsPositionY = tagButton.frame.maxY + 7
                    tagButton.frame.origin.y = tagsPositionY
                    tagsPositionX = 0
                    tagButton.frame.origin.x = tagsPositionX + 5
                }
            }
        }
    }
    
    @objc func buttonTap(sender: UIButton){
        let tagIndex = sender.tag
        //true→false,false→true
        isSelected[tagIndex] = !isSelected[tagIndex]
        if isSelected[tagIndex] {
            sender.backgroundColor = UIColor.blue
            sender.setTitleColor(UIColor.white, for: .normal)
        } else {
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(UIColor.blue, for: .normal)
        }
        // UserDefaultsに選択状態を保存する
        UserDefaults.standard.set(isSelected, forKey: "SelectedTags")
    }
    
}
