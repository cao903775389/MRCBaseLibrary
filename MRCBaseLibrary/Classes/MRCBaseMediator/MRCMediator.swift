//
//  MRCMediator.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/12.
//
//

import Foundation

/**
 * !@brief 中介者单例 统一管理模块之间的交互 集中统一管理每个界面对应的Action操作
 * 模块A(ViewController) -> MRCMediator  -> 模块B(ViewController)
 *          |                    |                       |
 *          |                    |                       |
 *          |                    |                       |
 *          |                    |                       |
 *          |            通过Category形式注册不同模块       维护属于自己模块的Target接口 暴露给外界调用
 *          |              对外界可使用的调用接口
 *          |
 * 通过一个对应模块的Target对象
 *
 *
 */


/**
 * !@brief 对于各个模块所对应的Target类和Target类下所维护的Action方法的声明
 *  @note 通过Runtime中的类和方法的字符串映射的形式达到解耦的目的 无需显式的引入对应模块的UIViewController和方法声明
 *  @note 该部分逻辑 需要在模块复杂过多时进行拆分 拆分到各自的Target中 这里暂时没有进行该操作
 */


/**
 * !@brief 对应target模块的所需要维护的action列表
 *  @note 每一个Target_模块名字 都对应各自管理的模块 大多数情况下为对应的UIViewController或者对应的控件
 *  @note 其中对参数params解包的过程包含部分hardCode 需要对照MRCMediatorExtension中的封包过程中参数字符串
 */

public typealias ActionComplete = (Any?) -> Void

public final class  MRCMediator {
    
    //域名
    public var scheme: String?
    
    //单例对象
    private static var __once: () = {
        if mrcMediator == nil {
            mrcMediator = MRCMediator()
        }
    }()
    
    /**
     * !@brief 单例方法 初始化一个中介者控制器
     *  @return MRCMediator 中介者对象
     */
    private static var onceToken:Int = 0
    private static var mrcMediator:MRCMediator?
    public static func sharedMRCMediator() -> MRCMediator {
        _ = MRCMediator.__once
        return mrcMediator!
    }
    
    /**
     * !@brief 远程URL方式调用 执行Target-Action跳转
     *  @param url 远程URL访问本地模块 url的格式统一为 scheme://target/action?params(MRCMediator://ModuleA/Action_nativeFetchPushViewController?id=123))
     *  @return AnyObject 获取到的本地模块对象 大多数情况下为对应的UIViewController
     */
    public func performActionWithUrl(_ url: URL, complete: ActionComplete?) {
        if url.scheme != scheme {
            //打开失败 scheme不匹配
            return
        }
        
        //分离请求参数
        var params = [String: Any]()
        let urlString = url.query
        
        for param in urlString!.components(separatedBy: "&").enumerated() {
            
            let elts = param.element.components(separatedBy: "=")
            if elts.count < 2 {
                continue
            }
            params[elts.last!] = elts.first
            
        }
        
        //参数加密处理
        //。。。省略
        
        //解析action名称
        let  actionName = url.path.replacingOccurrences(of: "/", with: "")
        self.performTarget(url.host!, actionName: actionName, params: params, complete: complete)
    }
    
    
    /**
     * !@brief 本地模块调用 执行Target-Action跳转
     *  @param targetName 模块名称 我们这里将模块的所能调用的Action方法交给各自对应的Target对象管理 例如 TrialDetailViewControll对应一个Target_TrialDetail对象管理着所有TrialDetailViewController所能提供给外界调用的的方法
     *  @param actionName 调用的Action方法 大多数为用来生成指定模块的方法
     *  @param params 调用携带的参数信息 这里我们的参数中可能有Block 字符串 对象 提供模块所需要的数据 例如 TrialDetailViewController所需要一个trialID数据 那么我们可以将此数据通过["trialID": "321"]的方式传递过去
     *  @return AnyObject 获取到的本地模块对象 大多数情况下为对应的UIViewController 少数还可能为alert 分享模块 等自己封装的控件
     *  @note 注意我们统targetName的格式为 Target_（target名字）actionName的格式为 Action_(action名字):params
     *  @note 这里参数传递时需要部分hardCode 就是指定参数名称为“trialID”的操作 但是为了更好的消除模块的耦合引用这里无法避免
     */
    public func performTarget(_ targetName: String, actionName:String, params: [String: Any]?, complete: ActionComplete? = nil) {
        
        let targetClass = NSObject.swiftClassFromString(targetName) as? NSObject.Type
        let action:Selector = NSSelectorFromString(actionName)
        let target = targetClass?.init()
        if target == nil {
            assert(false, "模块不存在")
            complete?(nil)
        }
        if !target!.responds(to: action) {
            assert(false, "方法不存在")
            complete?(nil)
        }
        
        if !target!.MRCMediator_WillCreateModule(target: targetName, action: actionName, params: params, complete: complete) {
            //方法被过滤拦截
            return
        }
        print("执行了\(targetName)的\(actionName)方法")
        let module = target!.perform(action, with: params)
        
        target?.MRCMediator_DidCreateModule(target: target as Any, action: action, param: params, module: module as Any)
        
        guard let result = module else {
            complete?(nil)
            return
        }
        complete?(result.takeUnretainedValue())
    }
}

/**
 * !@brief 公共协议 用来对一些公共类的逻辑进行统一处理 例如 登录逻辑 分享逻辑 所有的Target对象在需要验证公共逻辑时需要准守该协议
 */
public protocol MRCMediatorProtocol: NSObjectProtocol {
    
    //提供一个入口给外部Hook true标识允许执行通过 false标识执行被拦截
    func MRCMediator_WillCreateModule(target: String, action: String, params: [String: Any]?, complete: ActionComplete?) -> Bool
    
    func MRCMediator_DidCreateModule(target: Any, action: Selector, param: [String: Any]?, module: Any?)
}


/**
 * !@brief 所有Target对象都准守该协议
 */
extension NSObject: MRCMediatorProtocol {
    
    open func MRCMediator_WillCreateModule(target: String, action: String, params: [String : Any]?, complete: ActionComplete? = nil) -> Bool {
        return true
    }
    
    open func MRCMediator_DidCreateModule(target: Any, action: Selector, param: [String : Any]?, module: Any?) {
        //for subclass hook
    }
}

