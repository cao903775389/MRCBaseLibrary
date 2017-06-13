//
//  NSObjectExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/12.
//
//

import Foundation

extension NSObject {
    
    // link: http://stackoverflow.com/questions/24030814/swift-language-nsclassfromstring
    // create a static method to get a swift class for a string name
    public class func swiftClassFromString(_ className: String) -> AnyClass?{
        // get the project name
        if  let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = "_TtC\(appName.characters.count)\(appName)\(className.characters.count)\(className)"
            // return the class! _TtC6xingyu13HotController
            return NSClassFromString(classStringName)
        }
        return nil
    }
    
    //XXX(bundleName).ClassName
    public class func swiftStringFromClass(_ classType: AnyClass) -> String {
        return NSStringFromClass(classType).components(separatedBy: ".").last ?? ""
    }
}
