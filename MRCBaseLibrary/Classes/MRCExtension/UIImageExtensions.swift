//
//  UIImageExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation

extension UIImage {
    public class func MRC_bundleImageName(name: String) -> UIImage? {
        return self.MRC_imageNamed(name: name, bundle: Bundle.MRC_LibraryBundle())
    }
    
    public class func MRC_imageNamed(name: String, bundle: Bundle?) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}
