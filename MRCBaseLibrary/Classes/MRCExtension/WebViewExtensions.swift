//
//  WebViewExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation
import WebKit

//WebView设置请求头信息
extension WKWebView {
    
    public func loadRequest(_ request: URL, requestHeaders: [String: String]? = nil) {
        
        var muRequest = URLRequest(url: request)
        
        guard requestHeaders != nil else {
            self.load(muRequest)
            return
        }
        for (key, value) in requestHeaders! {
            muRequest.addValue(value, forHTTPHeaderField: key)
        }
        self.load(muRequest)
    }
}


extension UIWebView {
    
    public func loadRequest(_ request: URL, requestHeaders: [String: String]?) {
        
        var muRequest = URLRequest(url: request)
        guard requestHeaders != nil else {
            self.loadRequest(muRequest)
            return
        }
        for (key, value) in requestHeaders! {
            muRequest.addValue(value, forHTTPHeaderField: key)
        }
        self.loadRequest(muRequest)
    }
}
