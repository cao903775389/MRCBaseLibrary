//
//  MediatorExtension.swift
//  MRCBaseLibrary
//
//  Created by 逢阳曹 on 2017/6/13.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation

//模块扩展

extension MRCMediator: MRCMediatorModule {
    
    //在这里注册所有的模块Target
    public struct MRCMediatorTarget: RawRepresentable {
        public typealias RawValue = String
        public var rawValue: String
        public init?(rawValue: MRCMediatorTarget.RawValue) {
            self.rawValue = rawValue
        }
        
        public static let target_tableView = MRCMediatorTarget(rawValue: NSObject.swiftStringFromClass(Target_TableView.self))
        
        public static let target_login = MRCMediatorTarget(rawValue: NSObject.swiftStringFromClass(Target_Login.self))
        
        public static let target_view = MRCMediatorTarget(rawValue: NSObject.swiftStringFromClass(Target_View.self))


    }
    
    //在这里注册所有的模块Action
    public struct MRCMediatorAction: RawRepresentable {
        public typealias RawValue = String
        public var rawValue: String
        public init?(rawValue: MRCMediatorTarget.RawValue) {
            self.rawValue = rawValue
        }
        
        public static let action_tableView_getDetail = MRCMediatorTarget(rawValue: NSStringFromSelector(#selector(Target_TableView.Action_fetchViewController(_:))))
        public static let action_tableView_showAlert = MRCMediatorTarget(rawValue: NSStringFromSelector(#selector(Target_TableView.Action_showAlert)))
        
        
        public static let action_login_getLoginVC = MRCMediatorTarget(rawValue: NSStringFromSelector(#selector(Target_Login.Action_fetchLoginViewController(_:))))
        
        
        public static let action_view_getDetail = MRCMediatorTarget(rawValue: NSStringFromSelector(#selector(Target_View.Action_fetchViewController(_:))))


        
    }
    
    //获取tableView界面
    func MRCMediator_viewControllerForTableView(complete: @escaping ActionComplete) {
        
        self.performTarget(MRCMediatorTarget.target_tableView!.rawValue, actionName: MRCMediatorAction.action_tableView_getDetail!.rawValue, params: nil, complete: complete)
    }
    
    //弹框
    func MRCMediator_showAlert(complete: @escaping ActionComplete) {
        
        self.performTarget(MRCMediatorTarget.target_tableView!.rawValue, actionName: MRCMediatorAction.action_tableView_showAlert!.rawValue, params: nil, complete: complete)
    }
    
    
    //获取登录界面
    func MRCMediator_viewControllerForLogin(target: String?, action: String?, actionParams: [String: Any]?, actionComplete: ActionComplete?) {
        
        var params: [String: Any] = [:]
        if actionComplete != nil {
            params["complete"] = actionComplete!
        }
        if target != nil && action != nil {
            params["target"] = target
            params["action"] = action
            params["params"] = actionParams
        }
        
        self.performTarget(MRCMediatorTarget.target_login!.rawValue, actionName: MRCMediatorAction.action_login_getLoginVC!.rawValue, params: params) { loginVC in
            
            guard let login = loginVC as? LoginViewController else { return }
            
            let loginNav = MRCBaseNavigationViewController(rootViewController: login)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(loginNav, animated: true, completion: nil)
        }
    }
    
    //获取View界面
    func MRCMediator_viewControllerForView(complete: @escaping ActionComplete) {
         self.performTarget(MRCMediatorTarget.target_view!.rawValue, actionName: MRCMediatorAction.action_view_getDetail!.rawValue, params: nil, complete: complete)
    }
    
}
