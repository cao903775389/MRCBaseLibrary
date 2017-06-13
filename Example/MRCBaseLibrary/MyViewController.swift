//
//  MyViewController.swift
//  MRCBase
//
//  Created by 逢阳曹 on 2017/5/27.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class MyViewController: MRCBaseViewController {
    
    typealias MRCViewModel = MyViewModel
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.cyan
        
        //发送通知
        ViewController.postNotification(notification: .success, userInfo: ["test": 123])
        
        //移除userDefault
        UserDefaults.Account.removeValue(forKey: .age)
    }
    @IBAction func pushAction(_ sender: UIButton) {
        
        let web = WebViewController()
        web.requestUrl = "https://www.baidu.com"
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    //MARK: - Over load
    override func viewModelForViewController() -> MRCBaseViewModel {
        return MyViewModel(params: ["title": "我的主页"])
    }
}
