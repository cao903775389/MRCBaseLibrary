//
//  MRCBaseWebViewExtension.swift
//  MRCBase
//
//  Created by 逢阳曹 on 2017/5/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation

//eg: 外部接口Bridge的方式通过Extension进行扩展
extension MRCBaseWebViewControllerProtocol {
    var requestHttpHeaders: [String : String]? {
        return ["123": "333"]
    }
}

extension MRCBaseWebViewController: MRCJavascriptBridgeWrapper {
    //WebBridge
    public var webViewBridge: WKWebViewJavascriptBridge {
        let bridge = WKWebViewJavascriptBridge(for: webView)
        bridge!.setWebViewDelegate(self)
        return bridge!
    }
    
    ///交给子类扩展自定义实现
    //JS回调
    public typealias RegistBridge = BaseRegistBridge
    //调用JS
    public typealias CallHandleBridge = BaseCallHandleBridge
    
    //这里配置需要使用的key
    public enum BaseRegistBridge: String {
        //获取本地用户信息
        case getUserInfo = "getUserInfo"
    }
    //这里配置需要使用的key
    public enum BaseCallHandleBridge: String {
        //传递用户信息给H5
        case setUserInfo = "setUserInfo"
    }
    
    public func setUpBridgeConfiguration() {
        //注册bridge
        registerHandleForJavascript(bridge: .getUserInfo) { (data, callback) in
            
        }
        
        //调用JS
        calltHandleForJavascrip(bridge: .setUserInfo)
    }
}
