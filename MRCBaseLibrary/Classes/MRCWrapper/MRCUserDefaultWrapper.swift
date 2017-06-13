//
//  MRCUserDefaultWrapper.swift
//  Pods
//  UserDefault存储命名包装
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation

public protocol MRCUserDefaultNameSpace { }
extension MRCUserDefaultNameSpace {
    static func namespace<T>(_ key: T) -> String where T: RawRepresentable {
        return "\(Self.self).\(key.rawValue) "
    }
}

public protocol MRCUserDefaultWrapper: MRCUserDefaultNameSpace {
    associatedtype UserDefaultKey: RawRepresentable
}

extension MRCUserDefaultWrapper where UserDefaultKey.RawValue == String { }

extension MRCUserDefaultWrapper {
    /// 关于 any 类型存储
    public static func set(value:Any, forKey key:UserDefaultKey){
        let key = namespace(key)
        print("UserDefault存储Key:\(key)")
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// 关于 any 类型读取
    public static func value(forKey key:UserDefaultKey) -> Any? {
        let key = namespace(key)
        print("UserDefault读取Key:\(key)")
        return UserDefaults.standard.value(forKey: key)
    }
    
    ///移除数据
    public static func removeValue(forKey key: UserDefaultKey) {
        let key = namespace(key)
        print("UserDefault移除Key:\(key)")
        UserDefaults.standard.removeObject(forKey: key)
    }
}
