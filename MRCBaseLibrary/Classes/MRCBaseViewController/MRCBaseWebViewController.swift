//
//  MRCBaseWebViewController.swift
//  Pods
//  BaseWebView浏览器
//  Created by 逢阳曹 on 2017/5/31.
//
//

import UIKit
import NJKWebViewProgress
import WebKit
import SVProgressHUD
import WebViewJavascriptBridge

//页面加载进度
private let KLoadingEstimatedProgressKVO = "estimatedProgress"

open class MRCBaseWebViewController: MRCBaseViewController, WKNavigationDelegate, WKUIDelegate {

    //默认支持旋转
    open override var shouldAutorotate: Bool {
        return true
    }
    
    //加载类型
    open var requestType: WebRequestType {
        return .url
    }
    
    //是否禁用复制粘贴
    open var enableInteraction: Bool {
        return false
    }
    
    //默认支持分享
    open override var enableShare: Bool {
        return true
    }
    
    //请求地址
    private var _requestUrl: String?
    open var requestUrl: String? {
        set {
            _requestUrl = newValue
        }
        
        get {
           return _requestUrl
        }
    }
    
    //WKWebView
    public var webView: WKWebView {
        return _webView
    }
    private lazy var _webView: WKWebView = {
        let web = WKWebView(frame: CGRect.zero)
        web.isOpaque = false
        web.backgroundColor = UIColor.clear
        web.allowsBackForwardNavigationGestures = true
        web.uiDelegate = self
        return web
    }()
    
    //WebProgressView
    public var webProgressView: NJKWebViewProgressView {
        return _webProgressView
    }
    private lazy var _webProgressView: NJKWebViewProgressView = {
        
        let webProgress = NJKWebViewProgressView(frame: CGRect.zero)
        webProgress.progressBarView.backgroundColor = UIColor(rgba: "#FD4E4E")
        webProgress.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        return webProgress
    }()
    
    //progressView高度
    private var _progressBarHeight: CGFloat = 2.0
    open var progressBarHeight: CGFloat {
        
        set {
            _progressBarHeight = newValue
           var frame = _webProgressView.frame
            frame.origin.y += newValue
            _webProgressView.frame = frame
        }
        
        get {
            return _progressBarHeight
        }
    }
    
    //WebViewJavascriptBridge
    public lazy var _webViewBridge: WKWebViewJavascriptBridge = {
        let bridge = WKWebViewJavascriptBridge(for: self.webView)
        bridge!.setWebViewDelegate(self)
        return bridge!
    }()
    
    //MARK: - Life Cycle
    deinit {
        //移除KVO通知
        webView.removeObserver(self, forKeyPath: KLoadingEstimatedProgressKVO)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //添加进度条
        addProgressView()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //移除进度条
        webProgressView.removeFromSuperview()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //初始化界面
        self.setUp()
        //加载webView
        self.webViewDidBeiginLoding()
    }
    
    //MARK: - Public Method
    //屏幕旋转监听
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        var frame = webView.frame
        frame.size = size
        webView.frame = frame
        
        var progressViewFrame  = webProgressView.frame
        progressViewFrame.size.width = size.width
        webProgressView.frame = progressViewFrame
    }
    
    //MARK: - MRCBaseWebViewControllerProtocol
    open func webViewDidBeiginLoding() {
        //提供一个hook方法以供扩展
        guard let urlstr = requestUrl else {
            SVProgressHUD.showError(withStatus: "请求地址为空!")
            return
        }
        switch requestType {
        case .url:
            guard let url = URL(string: urlstr.stringWithoutWhiteSpaceAndLineBreak()) else {
                SVProgressHUD.showError(withStatus: "请求地址为空!")
                return
            }
            webView.loadRequest(url, requestHeaders: requestHttpHeaders)
        case .html:
            webView.loadHTMLString(urlstr, baseURL: nil)
        }
    }
    
    //MARK: - MRCBaseViewControllerProtocol
    open override func popViewController() {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        super.popViewController()
    }
    
    // MARK: - WKWebViewNavigationDelegate
    // 页面加载完成
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //页面加载完成
    }
    // 页面加载失败
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //页面加载失败
        SVProgressHUD.showError(withStatus: "加载失败!")
    }
    
    // MARK: - KVO监听实现方法
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard object as? NSObject == webView && keyPath == KLoadingEstimatedProgressKVO else { return }
        webProgressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
    }
    
    //MARK: Private
    //初始化
    fileprivate func setUp() {
        self.automaticallyAdjustsScrollViewInsets = true
        webView.frame = self.view.bounds
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.backgroundColor = .clear
        self.view.addSubview(webView)
        
        //注册通知监听加载进度
        webView.addObserver(self, forKeyPath: KLoadingEstimatedProgressKVO, options: .new, context: nil)
        
        //userInterface
        guard !self.enableInteraction else { return }
        //禁用交互行为
        self.disableUserInterface()
        
    }
    
    //添加进度条
    fileprivate func addProgressView() {
        //当导航栏隐藏时不添加进度条
        let hidden = self.navigationController?.isNavigationBarHidden ?? true
        
        let navigationBarSize = self.navigationController?.navigationBar.bounds.size ?? CGSize(width: self.view.frame.width, height: 64)
        let progressViewFrame  = CGRect(x: 0, y: hidden ? 0 : (navigationBarSize.height - progressBarHeight), width: navigationBarSize.width, height: progressBarHeight)
        webProgressView.frame = progressViewFrame
        webProgressView.progress = 0.0
        self.navigationController?.navigationBar.addSubview(webProgressView)
    }
    
    //添加长按手势 覆盖系统交互行为 屏蔽复制粘贴功能
    fileprivate func disableUserInterface() {
        let longPress = UILongPressGestureRecognizer(target: self, action: nil)
        longPress.minimumPressDuration = 0.4; //这里为什么要设置0.4，因为只要大于0.5就无效，我像大概是因为默认的跳出放大镜的手势的长按时间是0.5秒，
        //如果我们自定义的手势大于或小于0.5秒的话就来不及替换他的默认手势了，这是只是我的猜测。但是最好大于0.2秒，因为有的pdf有一些书签跳转功能，这个值太小的话可能会使这些功能失效。
        webView.addGestureRecognizer(longPress)
    }
}


//webView加载方式
public enum WebRequestType {
    //url
    case url
    //html
    case html
}

public protocol MRCBaseWebViewControllerProtocol: class {
    //配置webView加载方式
    var requestType: WebRequestType { get }
    
    //配置webView请求地址
    var requestUrl: String? { set get }
    
    //配置请求头
    var requestHttpHeaders: [String: String]? { get }
    
    //配置是否允许赋值粘贴
    var enableInteraction: Bool { get }
    
    //配置WebView
    var webView: WKWebView { get }
    
    //配置进度条
    var webProgressView: NJKWebViewProgressView { get }
    
    //获取ViewController
    var webViewController: MRCBaseWebViewController { get }
    
    //Hook WebView将要加载 加载
    func webViewDidBeiginLoding()
}

extension MRCBaseWebViewControllerProtocol {
    
    public var requestHttpHeaders: [String: String]? { return nil }
}

//默认配置
//外部通过Extension的方式进行扩展添加自定义参数
extension MRCBaseWebViewController: MRCBaseWebViewControllerProtocol {
    
    public var webViewController: MRCBaseWebViewController {
        return self
    }
}
