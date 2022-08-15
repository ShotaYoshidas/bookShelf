//
//  SecondViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/15.
//

import UIKit

class SecondViewController: UIViewController {
    
    let centerLabel: UILabel = {
            let label = UILabel()
            label.text = "Second"
            label.font = UIFont.boldSystemFont(ofSize: 70.0)
            label.textColor = UIColor.black
            return label
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(centerLabel)
        centerLabel.pin.hCenter().vCenter().width(UIScreen.main.bounds.height*0.4).height(UIScreen.main.bounds.height*0.4)
    }
}
