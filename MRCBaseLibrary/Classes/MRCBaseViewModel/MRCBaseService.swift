//
//  MRCBaseService.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation

//Http RequestError
public enum HttpError: Error {
    case success
    case fail(String)
}

open class MRCBaseService {
 
    public override init() { }
    
    deinit {
        self.serviceRelease()
        print("\(self)服务请求已释放")
    }
    
    //MARK: - Service Release
    open func serviceRelease() {
        // for subclass over load
        
    }
}
