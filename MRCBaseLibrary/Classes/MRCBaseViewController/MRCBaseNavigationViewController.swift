//
//  MRCBaseNavigationViewController.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import UIKit
import RTRootNavigationController
//通过基类控制器来控制单个VC的旋转和StatusBarStyle
open class MRCBaseNavigationViewController: RTRootNavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //是否自动旋转
    override open var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    
    //支持旋转的方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    //状态栏偏好设置
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override open func pushViewController(_ viewController: UIViewController?, animated: Bool = true) {
        guard let vc = viewController else { return }
        vc.hidesBottomBarWhenPushed = self.viewControllers.count == 1
        super.pushViewController(vc, animated: animated)
    }
}
