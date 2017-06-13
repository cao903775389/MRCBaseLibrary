//
//  LoginViewController.swift
//  MRCBaseLibrary
//
//  Created by 逢阳曹 on 2017/6/13.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

//对外部以Target-Action的形式提供入口
class Target_Login: NSObject {
    
    func Action_fetchLoginViewController(_ params: [String: Any]?) -> LoginViewController {
        
        let vc = LoginViewController()
        vc.complete = params?["complete"] as? ActionComplete
        vc.target = params?["target"] as? String
        vc.action = params?["action"] as? String
        return vc
    }
}



class LoginViewController: MRCBaseViewController {

    //登录成功回调
    fileprivate var complete: ActionComplete?
    
    //登录成功后需要执行的Target
    fileprivate var target: String?
    
    //登录成功后需要执行的Action
    fileprivate var action: String?
    
    //登录成功后需要执行的Action传递参数
    fileprivate var params: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginSuccess(_ sender: UIButton) {
        
        guard target != nil && action != nil else {
            complete?(nil)
            return
        }
        
        self.dismiss(animated: true) {[unowned self] in
            UserDefaults.LoginStatus.set(value: "登录了", forKey: .lastLoginTime)
            
            MRCMediator.sharedMRCMediator().performTarget(self.target!, actionName: self.action!, params: self.params) { result in
                //继续需要执行Target-Action
                self.complete?(result)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
