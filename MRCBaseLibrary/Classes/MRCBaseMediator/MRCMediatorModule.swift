//
//  MRCMediatorModule.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/13.
//
//

import Foundation

public protocol MRCMediatorModule {
    
    associatedtype MRCMediatorTarget: RawRepresentable
    
    associatedtype MRCMediatorAction: RawRepresentable
}

