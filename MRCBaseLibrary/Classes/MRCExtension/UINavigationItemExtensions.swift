//
//  UINavigationItemExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/27.
//
//

import Foundation

extension UINavigationItem {
    
    /**
     * !@brief 设置左侧BarButtonItems setLeftBarButtonItems
     */
    public func addLeftBarButtonItems(_ items: [UIBarButtonItem], animated: Bool = false) {
        
        var leftItems = items
        
        //标记是否插入了一个UIBarButtonItem修复间距问题
        var isInsert = false
        for item in items.enumerated() {
            if isInsert == false {
                let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
                //设置为负值 表示向左偏移16像素
                negativeSeperator.width = -13
                isInsert = true
                leftItems.insert(negativeSeperator, at: item.offset == 0 ? 0 : item.offset - 1)
            }else {
                isInsert = false
            }
        }
        self.setLeftBarButtonItems(leftItems, animated: animated)
    }
    
    /**
     * !@brief 设置右侧BarButtonItems setRightBarButtonItems
     */
    public func addRightBarButtonItems(_ items: [UIBarButtonItem], animated: Bool = false) {
        
        var rightItems = items
        
        //标记是否插入了一个UIBarButtonItem修复间距问题
        var isInsert = false
        for item in items.enumerated() {
            if isInsert == false {
                let negativeSeperator = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
                //设置为负值 表示向左偏移16像素
                negativeSeperator.width = -11
                isInsert = true
                rightItems.insert(negativeSeperator, at: item.offset == 0 ? 0 : item.offset - 1)
            }else {
                isInsert = false
            }
            self.setRightBarButtonItems(rightItems, animated: animated)
        }
    }
}
