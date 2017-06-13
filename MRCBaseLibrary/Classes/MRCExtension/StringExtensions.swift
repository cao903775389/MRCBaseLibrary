//
//  StringExtensions.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/5/31.
//
//

import Foundation

extension String {
    
    //去除字符串中的空格和换行
    public func stringWithoutWhiteSpaceAndLineBreak() -> String {
        //1. 去除掉首尾的空白字符和换行字符
        let str1 = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //2. 去除掉其它位置的空白字符和换行字符
        let str2 = str1.replacingOccurrences(of: "\r", with: "")
        return str2.replacingOccurrences(of: "\n", with:"")
    }
}
