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
    
    //tableView
    public weak var tableView: UITableView?
    
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
    open lazy var requestAction: Action<Int, Any, HttpError> = {
        return Action<Int, Any, HttpError> {[unowned self] page in
            
            return self.requestRemoteDataSignalWithPage(page: page)
                       .take(during: self.reactive.lifetime)
                       .map { (value) -> [IndexPath] in
                            guard let result = value as? [Any] else { return [] }
                            self.page = page
                            return self.handleRemoteData(data: result, page: page)
                       }
        }
    }()
    
    //MARK: - init
    public init(tableModel: NIMutableTableViewModel, dataSourceView: UITableView? = nil, params: [String: Any]? = nil) {
        super.init(params: params)
        tableViewModel = tableModel
        tableView = dataSourceView
    }
    
    public required init(params: [String : Any]?) {
        super.init(params: params)
    }
    
    //MARK: - Public Method
    open func requestRemoteDataSignalWithPage(page: Int) -> SignalProducer<Any, HttpError> {
        //for subclass overload
       return SignalProducer<Any, HttpError>.empty
    }
    
    //MARK:Public
    //添加数组数据到某一个分区(分区不止一个)
    @discardableResult open func addData(_ data: [Any], toSection: UInt) -> [Any] {
        
        if self.tableViewModel.sections != nil && self.tableViewModel.sections.count > Int(toSection) {
            var indexPaths: [Any] = []
            for model in data {
                let indexPath = self.tableViewModel.add(model, toSection: toSection)
                indexPaths.append(indexPath)
            }
            return indexPaths
        }
        return []
    }
    
    //移除某一分区的数据
    open func removeDatAtSection(_ section: Int) {
        guard self.tableViewModel.sections != nil && self.tableViewModel.sections.count > section else { return }
        let rows = (self.tableViewModel.sections[section] as! NITableViewModelSection).mutableRows()
        rows?.removeAllObjects()
    }
    
    //移除全部分区的数据(多个分区)
    open func handleRemoteData(data: [Any], page: Int) -> [IndexPath] {
        if page == 1 && self.tableViewModel.sections != nil {
            self.removeAllDataInSection()
        }
        return self.tableViewModel.addObjects(from: data) as! [IndexPath]
    }
    
    
    open func removeAllDataInSection() {
        guard self.tableViewModel.sections != nil else { return }
        for index in 0 ..< self.tableViewModel.sections.count {
                var item = self.tableViewModel.sections[index]
                let rows = (item as! NITableViewModelSection).mutableRows()
                rows?.removeAllObjects()
        }
    }
    
    //返回某一个分区的个数
    open func numberOfRowInSection(_ section: Int) -> [AnyObject]? {
        guard self.tableViewModel.sections != nil && self.tableViewModel.sections.count > section else { return nil }
        let rows = (self.tableViewModel.sections[section] as! NITableViewModelSection).mutableRows()
        return rows as [AnyObject]?
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
    
    open func cellStyle() -> UITableViewCellStyle {
        return .default
    }
}

open class MRCNibCellObject: MRCBaseModel, NINibCellObject {
    
    private var _cellNib: UINib!
    
    public var cellName: String
    
    //MARK: - init
    public init(cellClass: AnyClass) {
        cellName = NSObject.swiftStringFromClass(cellClass.self)
        _cellNib = UINib(nibName: cellName, bundle: nil)
    }
    
    open func cellNib() -> UINib! {
        return _cellNib
    }
}

