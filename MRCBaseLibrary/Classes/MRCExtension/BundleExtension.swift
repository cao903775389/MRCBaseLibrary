//
//  BundleExtension.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation

//提供接口用于访问Framework中的资源图片
extension Bundle {
    
    public class func MRC_LibraryBundle() -> Bundle? {
        return Bundle(url: self.MRC_LibraryBundleURL() ?? URL(string: "")!)
    }
    
    public class func MRC_LibraryBundleURL() -> URL? {
        let bundle = Bundle(for: MRCBaseViewModel.self)
        
        return bundle.url(forResource: "MRCBaseLibrary", withExtension: "bundle")
    }
}
