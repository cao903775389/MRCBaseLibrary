//
//  WebViewController.swift
//  MRCBase
//
//  Created by 逢阳曹 on 2017/5/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class WebViewController: MRCBaseWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(requestHttpHeaders ?? [:])
        // Do any additional setup after loading the view.
    }
}
