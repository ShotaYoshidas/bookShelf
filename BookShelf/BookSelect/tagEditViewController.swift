//
//  tagEditViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/05/01.
//

import UIKit

//var tags: [String] = []
let defaults = UserDefaults()
var tags = [String]()
protocol tagUpdateDelegate: AnyObject {
    func tagUpdate()
}

class tagEditViewController: UIViewController,UITextFieldDelegate {
    weak var tagDelegate: tagUpdateDelegate? = nil
    let textField:UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "タグ入力(10文字以内)"
        return tf
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
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var tagsPositionX:CGFloat = 0
    var tagsPositionY:CGFloat = 0
    let padding: CGFloat = 10
    let spacing: CGFloat = 4
    let maxLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(tagView)
        textField.delegate = self
        tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
        defaults.set(tags, forKey: "tags")
        addTag()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        textField.pin.top(20).horizontally(20).height(40)
        tagView.pin.below(of: textField, aligned: .center).height(height * 0.4).width(width * 0.9)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text {
            if textField.markedTextRange == nil && text.count > maxLength {
                textField.text = text.prefix(maxLength).description
                
            }
            if textField.text!.isEmpty {
               
            } else {
                tags = UserDefaults.standard.stringArray(forKey: "tags") ?? [String]()
                tags.append(text)
                defaults.set(tags, forKey: "tags")
                addTag()
                textField.text = ""
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addTag() {
        var subviews = tagView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        viewDidLayoutSubviews()
        for (index, element) in tags.enumerated() {
            let tagButton = UIButton()
            tagButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            tagButton.backgroundColor = .clear
            tagButton.setTitleColor(.white, for: UIControl.State.normal)
            tagButton.setTitle(element, for: UIControl.State.normal)
            
            let deleteButton = UIButton()
            deleteButton.setImage(UIImage(systemName: "delete.left.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors:[.naviTintColor])), for: UIControl.State.normal)
            deleteButton.backgroundColor = .clear
            deleteButton.layer.cornerRadius = 15
            deleteButton.addTarget(self, action: #selector(test), for: .touchUpInside)
            deleteButton.tag = index + 1
            
            let canvasView = UIView()
            canvasView.backgroundColor = .blue
            
            canvasView.addSubview(tagButton)
            canvasView.addSubview(deleteButton)
            canvasView.clipsToBounds = true
            tagButton.pin.left().top().bottom().sizeToFit()
            deleteButton.pin.after(of: tagButton, aligned: .center).marginLeft(spacing).sizeToFit()
            tagView.addSubview(canvasView)
            
            if index == 0 {
                canvasView.pin.wrapContent(padding: 5).top(5).left(5)
                canvasView.layer.cornerRadius = canvasView.frame.height / 2
            } else {
                let previousLabel = tagView.subviews[index - 1] as! UIView
                canvasView.pin.wrapContent(padding: 5).right(of: previousLabel, aligned: .top).marginLeft(10)
                canvasView.layer.cornerRadius = canvasView.frame.height / 2
                if(canvasView.frame.maxX >= tagView.frame.size.width){
                    tagsPositionY = canvasView.frame.maxY + 7
                    //y(縦軸座標)
                    canvasView.frame.origin.y = tagsPositionY
                    //x(横軸座標)
                    tagsPositionX = 0
                    canvasView.frame.origin.x = tagsPositionX + 5
                }
            }
        }
    
        tagDelegate?.tagUpdate()
    }
    
    @objc func test(sender: UIButton){
        let alert = UIAlertController(title: "タグ削除", message: "\(tags[sender.tag - 1])", preferredStyle: .alert)
        let can = UIAlertAction(title: "いいえ", style: .default) { action in
        }
        let del = UIAlertAction(title: "削除", style: .destructive) { action in
            tags.remove(at: sender.tag - 1)
            defaults.set(tags, forKey: "tags")
            self.addTag()
        }
        alert.addAction(can)
        alert.addAction(del)
        self.present(alert, animated: true, completion: nil)
        tagDelegate?.tagUpdate()
    }
}












