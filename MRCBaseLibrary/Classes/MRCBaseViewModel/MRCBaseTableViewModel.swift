//
//  MRCBaseTableViewModel.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/1.
//
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Nimbus
import Result

open class MRCBaseTableViewModel: MRCBaseViewModel {

    //tableModel
    public var tableViewModel: NIMutableTableViewModel!
    
    //The data source of table view
    public var dataSource:  MutableProperty<Any> = MutableProperty([])
    
    //当前分页数
    public var page: Int = 1
    
    //单页数据个数 默认10条
    public var perPage: Int = 10
    
    //是否允许下拉刷新
    public var pulldownToRefresh: Bool = true
    
    //是否允许上拉加载
    public var pullupToLoadingMore: Bool = true
    
    //是否还有更多数据
    public var hasMoreData: MutableProperty<Bool> = MutableProperty(false)
    
    //是否显示无数据占位图
    public var enableEmptyDataSet: Bool = true
    
    //RequestSignal
    open lazy var requestAction: Action<Int, Any, NoError> = {
        return Action<Int, Any, NoError> {[unowned self] page in
            return self.requestRemoteDataSignalWithPage(page: page)
                       .take(until: self.reactive.lifetime.ended)
                       .map { (value) -> [IndexPath] in
                            guard let result = value as? [Any] else { return [] }
                            self.page = page
                            if page == 1 && self.tableViewModel.sections != nil {
                                self.tableViewModel.removeSection(at: 0)
                            }
                            return self.tableViewModel.addObjects(from: result) as! [IndexPath]
                       }
        }
    }()
    
    //MARK: - init
    public required  init(tableModel: NIMutableTableViewModel, params: [String: Any]? = nil) {
        super.init(params: params)
        tableViewModel = tableModel
    }
    
    public required init(params: [String : Any]?) {
        super.init(params: params)
    }
    
    //MARK: - Public Method
    open func requestRemoteDataSignalWithPage(page: Int) -> SignalProducer<Any, NoError> {
        //for subclass overload
       return SignalProducer<Any, NoError>.empty
    }
}

//用于创建可以被NICellFactory使用的Object
open class MRCCellObject: MRCBaseModel, NICellObjectProtocol {
    
    private var _cellClass: AnyClass
    
    //MARK: - init
    public init(cellClass: AnyClass) {
        _cellClass = cellClass
    }

    open func cellClass() -> AnyClass! {
        return _cellClass
    }
}

open class MRCNibCellObject: MRCBaseModel, NINibCellObject {
    
    private var _cellNib: UINib
    
    //MARK: - init
    public init(cellNib: UINib) {
        _cellNib = cellNib
    }
    
    open func cellNib() -> UINib! {
        return _cellNib
    }
}

