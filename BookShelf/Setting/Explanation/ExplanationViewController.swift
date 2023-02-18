//
//  ExplanationViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/01/07.
//

import UIKit
import PinLayout


class ExplanationViewController: UIViewController {
    
    let thumbnailView:UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .white
        i.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        i.isUserInteractionEnabled = true
        i.layer.shadowColor = UIColor.black.cgColor
        i.layer.masksToBounds = false
        i.layer.shadowOpacity = 0.8
        i.layer.shadowRadius = 0.9
        i.layer.cornerRadius = 0.9
        i.image = UIImage(named:"F5682CAE-8A2A-4F43-9D9B-82B8664E3850")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return i
    }()
    
    let text:UITextView = {
        let t = UITextView()
        t.textColor = .black
        t.text = """
            アプリ「どこでも本棚」ダウンロードありがとうございます。

            趣味で開発したアプリで至らない点も多々ありますが、みなさんが楽しんで読書が出来るよう開発を進めてきました。

            アプリ開発の経緯としては、外出中ふと自分の本棚に触れたくなったことです。
            それが「どこでも本棚」になります。

            読書は人生を変えます。
            「どこでも本棚」もみなさんの人生を良い方向へと変えれるようにこれからも努力していきたいと思います。

            読書好きなみなさんの人生に幸あれ。
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
        self.navigationController?.navigationBar.tintColor = .naviTintColor()
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
