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
    public var error: String? {
        switch self {
        case .fail(let reason):
            return reason
        default:
            return nil
        }
    }
}

open class MRCBaseService {
    
    public init() { }
    
    deinit {
        self.serviceRelease()
        print("\(self)服务请求已释放")
    }
    
    //MARK: - Service Release
    open func serviceRelease() {
        // for subclass over load
        
    }
}
