//
//  MRCBaseViewModel.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation
import ReactiveSwift
//所有ViewModel的基类

open class MRCBaseViewModel: NSObject {
    
    public required init(params: [String: Any]? = nil) {
        param = params
        title = Property(value: (params?["title"] as? String) ?? "")
    }
    
    //导航栏标题
    public var title: Property<String>
    
    //界面将要消失
    deinit {
        print("\(self)已销毁")
    }
    
    //参数
    private var param: [String: Any]?
}

public protocol MRCViewModel: class {
    
    //导航栏标题
    var title: Property<String> { set get }
    
    //初始化方法
    init(params: [String: Any]?)
}

extension MRCBaseViewModel: MRCViewModel { }

extension SignalProducer {
    public static func pipe() -> (SignalProducer, ProducedSignal.Observer) {
        let (signal, observer) = ProducedSignal.pipe()
        let producer = SignalProducer(signal)
        return (producer, observer)
    }
}
