//
//  ViewController.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/08/14.
//

import UIKit

class FirstViewController: UIViewController {

    let centerLabel: UILabel = {
            let label = UILabel()
            label.text = "First"
            label.font = UIFont.boldSystemFont(ofSize: 70.0)
            label.textColor = .black
            return label
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(centerLabel)
        centerLabel.pin.hCenter().vCenter().width(UIScreen.main.bounds.height*0.4).height(UIScreen.main.bounds.height*0.4)
        
    }


}

