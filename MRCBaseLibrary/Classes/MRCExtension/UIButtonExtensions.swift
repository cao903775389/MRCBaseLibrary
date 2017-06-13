//
//  UIButtonExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation

extension UIButton {
    
    //创建UIButton
    public class func createButton(_ title: String?, font: UIFont?, image: UIImage?, selectedImage: UIImage?, titleColor: UIColor?, disableTitleColor: UIColor? = UIColor(rgba: "#cccccc"), highlightedTitleColor: UIColor? = UIColor(rgba: "#FD4E4E")) -> UIButton {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(disableTitleColor, for: UIControlState.disabled)
        button.setTitleColor(highlightedTitleColor, for: UIControlState.highlighted)
        button.setImage(image, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        button.setImage(selectedImage, for: UIControlState.highlighted)
        button.titleLabel?.font = font
        button.titleLabel?.textAlignment = NSTextAlignment.right;
        return button
    }
}
