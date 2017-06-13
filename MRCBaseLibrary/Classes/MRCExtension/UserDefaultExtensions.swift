//
//  UserDefaultExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation

extension UserDefaults {
    //eg: 用户存储
    public struct Account: MRCUserDefaultWrapper {
        public enum UserDefaultKey: String {
            case name
            case age
            case birth
        }
    }
    
    //登录存储
    public struct LoginStatus: MRCUserDefaultWrapper {
        public enum UserDefaultKey: String {
            case lastLoginTime
            case sessionTime
        }
    }
}
