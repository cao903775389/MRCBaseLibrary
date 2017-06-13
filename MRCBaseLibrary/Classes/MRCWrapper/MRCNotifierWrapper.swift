//
//  MRCNotifierWrapper.swift
//  Pods
//  通知命名包装
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation

//NotificationCenter.defaultCenter()
//.postNotificationName("coffeeMadNotfication")
//通过这种方式进行传值可能很容易出现字符串打错的情况 为了避免此类调用进行包装

public protocol MRCNotifierWrapper {
    
    //所有要发送通知的对象或者结构体都要实现Notifier这个协议,然后提供一个RawRepresentable协议的类型，其实就是一个字符串枚举
    
    //eg: 
//    class Barista : MRCNotifierWrapper {
//        enum Notification : String {
//            case makingCoffee
//            case coffeeMade
//        }
//    let coffeeMade = Barista.Notification.coffeeMade.rawValue
//    NotificationCenter.defaultCenter().postNotificationName(coffeeMade)
//    }
    associatedtype Notification: RawRepresentable
    
}

//为了避免通知名称冲突 我们为通知添加一个唯一的命名空间
extension MRCNotifierWrapper where Notification.RawValue == String {
    //object名称
    //eg: let baristaNotification = "\(Barista).\(Barista.Notification.coffeeMade.rawValue)"
    // baristaNotification: Barista.coffeeMade
    private static func nameFor(notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    //注册通知
    public static func addObserver(observer: Any, selector: Selector, notification: Notification, object: Any? = nil) {
        let name = nameFor(notification: notification)
        print("注册通知:\(name)")
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    //发送通知
    public static func postNotification(notification: Notification, object: Any? = nil, userInfo: [String: Any]? = nil) {
        let name = nameFor(notification: notification)
        print("发送通知:\(name)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
    }
    
    //移除通知
    public static func removerObserver(observer: Any, notification: Notification, object: Any? = nil) {
        let name = nameFor(notification: notification)
        print("移除通知:\(name)")
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
}
