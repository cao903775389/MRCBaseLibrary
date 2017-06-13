//
//  MRCBaseModelProtocol.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation

public protocol MRCBaseModelProtocol: class {
    
    //指定ViewModel
    func viewModelForViewController() -> MRCBaseViewModel
    
    //绑定ViewModel
    func bindViewModel()
}

extension MRCBaseViewController: MRCBaseModelProtocol { }
