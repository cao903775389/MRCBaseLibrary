//
//  ViewController.swift
//  MRCBase
//
//  Created by cao903775389 on 05/27/2017.
//  Copyright (c) 2017 cao903775389. All rights reserved.
//

import UIKit
//对外部以Target-Action的形式提供入口
class Target_View: NSObject {
    
    func Action_fetchViewController(_ params: [String: Any]?) -> UIViewController {
        return ViewController()
    }
}


class ViewController: MRCBaseViewController, MRCNotifierWrapper {

    //MRCNotifierWrapper
    enum Notification: String {
        case fail
        case success
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.view.addSubview(btn)
        btn.backgroundColor = .red
        
        btn.addTarget(self, action: #selector(self.pushAction(_:)), for: .touchUpInside)

        //注册通知
        ViewController.addObserver(observer: self, selector: #selector(ViewController.receivedNotification(notification:)), notification: .success)
        
        
        //userDefault
        let r = UserDefaults.Account.value(forKey: .age)
        print(r ?? 0)
    }
    
     func pushAction(_ sender: UIButton) {
                
//        let vc = MRCMediator.sharedMRCMediator().MRCMediator_viewControllerForTableView()
//        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        MRCMediator.sharedMRCMediator().MRCMediator_showAlert { alert in
            
            guard let alertVC = alert as? UIAlertController else { return }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //通知回调
    func receivedNotification(notification: NSNotification) {
        
        ViewController.removerObserver(observer: self, notification: .success)
    }
    
    override func setUpShareHandle() {
        
    }
}


