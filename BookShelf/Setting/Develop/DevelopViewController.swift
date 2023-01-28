//
//  DevelopViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/01/08.
//

import UIKit

class DevelopViewController: UIViewController {
   
    
    let thumbnailView:UIImageView = {
        let i = UIImageView()
        i.isUserInteractionEnabled = true
        i.image = UIImage(named:"F5682CAE-8A2A-4F43-9D9B-82B8664E3850")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return i
    }()
    
    
    let text:UITextView = {
        let t = UITextView()
        t.textColor = .black
        t.text = """
            アプリ「どこでも本棚」は、シンプルでわかりやすい設計を目指しています。

            しかし、みなさんには自分だけの特別な本棚を手に入れて欲しいとも考えています。
            今後のアップデートとしましては
            ー　お気に入り機能
            ー　背景カラー選択機能
            ー　本棚内検索
            ・・・等
            
            これ以外の追加機能、修正等の要望がありましたらお問い合わせ下さい。
            """
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 20)
        t.isEditable = false
        t.backgroundColor = .clear
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(thumbnailView)
         thumbnailView.addSubview(text)
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        thumbnailView.pin.all()
        text.pin.topCenter().size(CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.65 )).margin(UIScreen.main.bounds.height * 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
            navigationController?.navigationBar.scrollEdgeAppearance?.configureWithTransparentBackground()
            navigationController?.navigationBar.compactAppearance?.configureWithTransparentBackground()
            navigationController?.navigationBar.compactScrollEdgeAppearance?.configureWithTransparentBackground()
        }
}
