//
//  UIBarButtonItemExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation
extension UIBarButtonItem {
    
    /**
     * !@brief 创建纯图片按钮的BarButtonItem
     *  @param image 默认正常状态下图片
     *  @param selectedImage 选中图片
     */
    public class func createImageBarButtonItem(_ image: UIImage, selectedImage: UIImage?, target: Any?, action: Selector?) -> UIBarButtonItem {
        
        return self.createBarButtonItem(nil, font: nil, image: image, selectedImage: selectedImage, titleColor: nil, target: target, action: action)
    }
    
    /**
     * !@brief 创建纯文字按钮的BarButtonItem
     *  @param title 文字
     *  @param font 文字大小
     *  @param titleColor 文字颜色
     */
    public class func createTitleBarButtonItem(_ title: String, font: UIFont = UIFont.systemFont(ofSize: 13), titleColor: UIColor = UIColor(rgba: "#323232"), target: Any?, action: Selector?) -> UIBarButtonItem {
        
        return self.createBarButtonItem(title, font: font, image: nil, selectedImage: nil, titleColor: titleColor, target: target, action: action)
    }
    
    
    /**
     * !@brief 创建UIBarButtonItem
     */
    public class func createBarButtonItem(_ title: String?, font: UIFont?, image: UIImage?, selectedImage: UIImage?, titleColor: UIColor?, target: Any?, action: Selector?) -> UIBarButtonItem {
        
        let button = UIButton.createButton(title, font: font, image: image, selectedImage: selectedImage, titleColor: titleColor)
        //绑定方法
        if target != nil && action != nil {
            button.addTarget(target!, action: action!, for: UIControlEvents.touchUpInside)
        }
        
        //纯文字 或者 纯图片
        if title != nil && font != nil {
            let size = (title! as NSString).size(attributes: [NSFontAttributeName: font!])
            button.frame = CGRect(x: 0, y: 0, width: size.width < 52 ? 52 : size.width + 10, height: 44)
        }else if image != nil {
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        }
        return UIBarButtonItem(customView: button)
    }
    
}
