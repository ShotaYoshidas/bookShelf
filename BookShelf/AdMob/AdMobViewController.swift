//
//  AdMobViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/01/07.
//

import UIKit
import GoogleMobileAds

class AdMobViewController: UIViewController {
    var bannerView: GADBannerView!  //追加

      override func viewDidLoad() {
        super.viewDidLoad()
        
        banner()
      }
    
    func banner() {
        //GADBannerViewの作成
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)

        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self

        // 広告読み込み
        bannerView.load(GADRequest())
    }

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
    }
    


