//
//  MRCBaseViewController.swift
//  Pods
//  UIViewController基类控制器
//  Created by 逢阳曹 on 2017/5/27.
//
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

open class MRCBaseViewController: UIViewController {
    
    //ViewModel
    public var viewModel: MRCBaseViewModel {
        set {
            _viewModel = newValue
        }
        get {
            return _viewModel
        }
    }
    private var _viewModel: MRCBaseViewModel!
    
    //MARK: - Life Cycle
    deinit {
        print("\(self)界面内存已释放")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        //初始化配置
        setUpConfiguration()
        //生成ViewModel
        _viewModel = viewModelForViewController()
        //绑定ViewModel
        bindViewModel()
   }
    
    //MARK: - Private Method
    //初始化Base配置
    fileprivate func setUpConfiguration() {
        if enableShare {
            let shareItem = setUpShareAction(target: self, action: #selector(MRCBaseViewController.setUpShareHandle))
            self.navigationItem.addRightBarButtonItems([shareItem])
        }
        let viewControllers = self.rt_navigationController?.viewControllers
        guard viewControllers != nil && viewControllers!.count > 1 else { return }
        let backItem = UIBarButtonItem.createImageBarButtonItem(UIImage.MRC_bundleImageName(name: "mrc_nav_back")!, selectedImage: UIImage.MRC_bundleImageName(name: "mrc_navback_select")!, target: self, action: #selector(MRCBaseViewController.popViewController))
        self.navigationItem.addLeftBarButtonItems([backItem])
    }
    
    //MARK: - MRCBaseViewControllerProtocol
    //分享Action回调统一处理
    open func setUpShareHandle() {
        //for subclass over load
    }
    
    //指定viewModel
    open func viewModelForViewController() -> MRCBaseViewModel {
        //for subclass over load
        return MRCBaseViewModel()
    }
    //绑定ViewModel属性
    open func bindViewModel() {
        self.navigationItem.reactive.title <~ viewModel.title
    }
    
    //MARK: - Over load
    //默认不支持旋转
    override open var shouldAutorotate: Bool {
        return false
    }
    
    //支持旋转的方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    //状态栏偏好设置
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override var prefersStatusBarHidden: Bool {
        return false
    }
}


public protocol MRCBaseViewControllerProtocol {
    
    //是否允许分享
    var enableShare: Bool { get }
    
    //设置分享操作
    func setUpShareAction(target: Any, action: Selector?) -> UIBarButtonItem
    
    //设置分享回调
    func setUpShareHandle()
    
    //Pop
    func popViewController()
    
    //绑定ViewModel
    func viewModelForViewController() -> MRCBaseViewModel
    func bindViewModel()
    
    
    //获取当前ViewController
    var baseViewController: MRCBaseViewController { get }
}

extension MRCBaseViewControllerProtocol {
    public func setUpShareAction(target: Any, action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem.createImageBarButtonItem(UIImage.MRC_bundleImageName(name: "mrc_nav_share")!, selectedImage: nil, target: target, action: action)
    }
}

//默认配置
extension MRCBaseViewController: MRCBaseViewControllerProtocol {
    
    public func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    open var enableShare: Bool { return false }
    
    public var baseViewController: MRCBaseViewController { return self }
}
