//
//  MRCBaseTabBarController.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/22.
//
//

import UIKit

open class MRCBaseTabBarController: MRCBaseViewController {

    //tabBarController
    private lazy var _tabBarController: UITabBarController = {
       let tabBarVC = UITabBarController()
        return tabBarVC
    }()
    
    public var tabBarVC: UITabBarController! {
        return _tabBarController
    }
    
    //MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(tabBarVC)
        self.view.addSubview(tabBarVC.view)
    }

    //MARK: - Over load
    //默认不支持旋转
    override open var shouldAutorotate: Bool {
        return self.tabBarVC.selectedViewController?.shouldAutorotate ?? false
    }
    
    //支持旋转的方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.tabBarVC.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    //状态栏偏好设置
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.tabBarVC.selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override var prefersStatusBarHidden: Bool {
        return self.tabBarVC.selectedViewController?.prefersStatusBarHidden ?? true
    }
}
