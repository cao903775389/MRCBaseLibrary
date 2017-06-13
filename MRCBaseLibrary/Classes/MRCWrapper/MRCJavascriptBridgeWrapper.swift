//
//  MRCJavascriptBridgeWrapper.swift
//  Pods
//  WebViewJavascriptBridge交互方法命名包装
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation
import WebViewJavascriptBridge

public protocol MRCJavascriptBridgeWrapper {
    //参考MRCNotifierWrapper
    //注册Bridge方法提供给JS调用
    associatedtype RegistBridge: RawRepresentable
    
    //native调用JS方法
    associatedtype CallHandleBridge: RawRepresentable
    
    //WebBridge
    var webViewBridge: WKWebViewJavascriptBridge { get }
    
    //初始化配置
    func setUpBridgeConfiguration()
}

extension MRCJavascriptBridgeWrapper where RegistBridge.RawValue == String, CallHandleBridge.RawValue == String {

    //注册Bridge方法提供给JS调用
    public func registerHandleForJavascript(bridge: RegistBridge, handle: WVJBHandler? = nil) {
        self.webViewBridge.registerHandler(bridge.rawValue, handler: handle)
    }
    
    //native调用JS方法
    public func calltHandleForJavascrip(bridge: CallHandleBridge, data: Any? = nil, responseeCallback: WVJBResponseCallback? = nil) {
        self.webViewBridge.callHandler(bridge.rawValue, data: data, responseCallback: responseeCallback)
    }
}
