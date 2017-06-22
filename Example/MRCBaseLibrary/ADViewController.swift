//
//  ADViewController.swift
//  MRCBaseLibrary
//
//  Created by 逢阳曹 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class ADViewController: MRCBaseViewController {

    lazy var adImageView: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "750x480")
        return img
    }()
    
    lazy var logo: UIButton = {
       let label = UIButton(type: .system)
        label.setTitleColor(.black, for: .normal)
        label.setTitle("跳过", for: .normal)
        label.backgroundColor = .red
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.addTarget(self, action: #selector(ADViewController.jumpButtonClick), for: .touchUpInside)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        adImageView.frame = self.view.bounds
        logo.frame = CGRect(x: 30, y: 30, width: 60, height: 40)
        self.view.addSubview(adImageView)
        self.view.addSubview(logo)
    }

    func jumpButtonClick() {
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: -self.view.frame.width, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
}
