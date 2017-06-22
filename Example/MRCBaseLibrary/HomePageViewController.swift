//
//  HomePageViewController.swift
//  MRCBaseLibrary
//
//  Created by 逢阳曹 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class HomePageViewController: MRCBaseTabBarController {

    var edgeGes: UIScreenEdgePanGestureRecognizer!
    
    //广告
    lazy var ad: ADViewController = {
        return ADViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nav1 = MRCBaseNavigationViewController(rootViewController: TableViewController())
        nav1.tabBarItem = UITabBarItem(title: "首页1", image: UIImage(named: "home_normal"), selectedImage: UIImage(named: "home_selected"))

        let nav2 = MRCBaseNavigationViewController(rootViewController: WebViewController())
        nav2.tabBarItem = UITabBarItem(title: "首页2", image: UIImage(named: "bbs_normal"), selectedImage: UIImage(named: "bbs_selected"))

        let nav3 = MRCBaseNavigationViewController(rootViewController: TableViewController())
        nav3.tabBarItem = UITabBarItem(title: "首页3", image: UIImage(named: "listMenu_normal"), selectedImage: UIImage(named: "listMenu_selected"))

        let nav4 = MRCBaseNavigationViewController(rootViewController: WebViewController())
        nav4.tabBarItem = UITabBarItem(title: "首页4", image: UIImage(named: "mine_normal"), selectedImage: UIImage(named: "mine_selected"))

        self.tabBarVC.viewControllers = [nav1, nav2, nav3, nav4]
        
        //开屏广告
        self.addChildViewController(ad)
        self.view.addSubview(ad.view)
        ad.didMove(toParentViewController: self)
        
        edgeGes = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(HomePageViewController.edgeGestureAction(ges:)))
        edgeGes.edges = .left
        nav1.view.addGestureRecognizer(edgeGes)
    }
    
    func edgeGestureAction(ges: UIScreenEdgePanGestureRecognizer) {
        
        guard let nav = tabBarVC.viewControllers?.first as? MRCBaseNavigationViewController else { return }
        let point = ges.location(in: nav.view)
        print(point)
        var frame = ad.view.frame
        //更改adView的x值 手指的位置-屏幕宽度
        frame.origin.x = point.x - UIScreen.main.bounds.width
        ad.view.frame = frame
        if ges.state == .ended || ges.state == .cancelled {
            //判断当前广告视图在频幕上显示是否超过一般
            if self.view.frame.contains(ad.view.center) {
                //如果超过一半，那么完全显示出来
                frame.origin.x = 0
            }else {
                //如果没有，隐藏
                frame.origin.x = -UIScreen.main.bounds.width
            }
            
            UIView.animate(withDuration: 0.25) {
                self.ad.view.frame = frame
            }
        }
    }
    
}
