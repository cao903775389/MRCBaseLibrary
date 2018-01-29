//
//  MRCBaseTableViewController.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/1.
//
//

import UIKit
import DZNEmptyDataSet
import Nimbus
import MJRefresh
import ReactiveSwift
import ReactiveCocoa
import UITableView_FDTemplateLayoutCell
import SVProgressHUD

open class MRCBaseTableViewController: MRCBaseViewController, UITableViewDelegate, NIMutableTableViewModelDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    //contentInset
    open var contentInset: UIEdgeInsets {
        return UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    //没有更多数据
    public var MJFooterNoMoreDataText: String = "没有更多内容"
    
    //上拉刷新
    public var MJFooterIdleText: String = "上拉加载"

    //加载中
    public var MJFooterRefreshingText: String = "正在加载..."
    
    //tableView
    private lazy var _tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        return table
    }()
        
    public var tableView: UITableView {
        return _tableView
    }
    
    //cellFactory
    public lazy var cellFactory: MRCCellFactory = {
       return MRCCellFactory()
    }()
    
    //MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        //初始化配置
        setUp()
        //注册cell
        registerCellForReusable()
    }
    
    //MARK: - Public Method
    open func beiginRefresh() {
        //for subclass over load
       (viewModel as! MRCBaseTableViewModel).requestAction.apply(1)
                                                .start {[weak self] (event) in
                                                    guard self != nil else { return }
                                                    switch event {
                                                    case .completed, .interrupted:
                                                        break
                                                    case .failed(let error):
                                                        self!.tableView.mj_header?.endRefreshing()
                                                        switch error {
                                                        case .producerFailed(let httpError):
                                                            SVProgressHUD.showError(withStatus: httpError.error!)
                                                        default:
                                                            break
                                                        }
                                                        break
                                                    case .value(let value):
                                                        guard self != nil, let _ = value as? [IndexPath] else { return }
                                                        self!.tableView.mj_header?.endRefreshing()
                                                        self!.tableView.reloadData()
                                                        break
                                                    }
                                                }
    }
    
    open func beginLoadingMore() {
        //for subclass over load
        let page = (self.viewModel as! MRCBaseTableViewModel).page + 1
        (viewModel as! MRCBaseTableViewModel).requestAction.apply(page)
                                            .start {[weak self] (event) in
                                                guard self != nil else { return }
                                                switch event {
                                                case .completed, .interrupted:
                                                    break
                                                case .failed(let error):
                                                    
                                                    self!.tableView.mj_footer?.endRefreshing()
                                                    switch error {
                                                    case .producerFailed(let httpError):
                                                        SVProgressHUD.showError(withStatus: httpError.error!)
                                                    default:
                                                        break
                                                    }
                                                    break
                                                case .value(let value):
                                                    guard let result = value as? [IndexPath] else { return }
                                                    self!.tableView.mj_footer?.endRefreshing()
                                                    if result.count == 0 {
                                                        self!.tableView.mj_footer?.endRefreshingWithNoMoreData()
                                                    }
                                                    self!.tableView.beginUpdates()
                                                    self!.tableView.insertRows(at: result, with: .fade)
                                                    self!.tableView.endUpdates()
                                                    break
                                                }
                                            }
    }
    
    //MARK: - Private Method
    fileprivate func setUp() {
    
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
    
        tableView.dataSource = (viewModel as! MRCBaseTableViewModel).tableViewModel
        tableView.delegate = self
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset

        //配置刷新控件
        if (viewModel as! MRCBaseTableViewModel).pulldownToRefresh {
            tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MRCBaseTableViewController.beiginRefresh))
            tableView.mj_header.beginRefreshing()
        }
        if (viewModel as! MRCBaseTableViewModel).pullupToLoadingMore {
            let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MRCBaseTableViewController.beginLoadingMore))!
            footer.isAutomaticallyHidden = true
            
            footer.setTitle(MJFooterRefreshingText, for: MJRefreshState.refreshing)
            footer.setTitle(MJFooterNoMoreDataText, for: MJRefreshState.noMoreData)
            
            footer.setTitle(MJFooterIdleText, for: MJRefreshState.idle)
            footer.stateLabel.font = UIFont.systemFont(ofSize: 15)
            footer.stateLabel.textColor = UIColor(rgba: "#999")
            tableView.mj_footer = footer
        }
        
        //配置占位图
        if (viewModel as! MRCBaseTableViewModel).enableEmptyDataSet {
            tableView.emptyDataSetSource = self
            tableView.emptyDataSetDelegate = self
        }
    }
    
    //MARK: - over load
    open override func viewModelForViewController() -> MRCBaseViewModel {
        return MRCBaseTableViewModel(tableModel: NIMutableTableViewModel(delegate: self))
    }
    
    open override func bindViewModel() {
        super.bindViewModel()
    }
    
    //需要注册的cell
    open func registerCellForReusable() {
        //for subclass over load
    }
    
    //MARK: - NIMutableTableViewModelDelegate
    open func tableViewModel(_ tableViewModel: NITableViewModel!, cellFor tableView: UITableView!, at indexPath: IndexPath!, with object: Any!) -> UITableViewCell! {
        
        let cell = cellFactory.tableViewModel(tableViewModel, cellFor: tableView, at: indexPath, with: object)
        if (nil == cell) {
            // Custom cell creation here.
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let object = (viewModel as! MRCBaseTableViewModel).tableViewModel.object(at: indexPath)
        let identifier: String = cellFactory.cellIdentifierFromObject(object: object!)
        
        return tableView.fd_heightForCell(withIdentifier: identifier, cacheBy: indexPath) { (cell) in
            (cell as! NICell).shouldUpdate(with: object)
        }
    }
    
    //MARK: - DZNEmptyDataSetSource
    // 设置背景图片
    open func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    // 设置背景色
    open func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        
        return UIColor.white
    }
    // 设置文字
    open func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "没有数据"
        var attributes = [String : AnyObject]()
        attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: 15)
        attributes[NSForegroundColorAttributeName] = UIColor(rgba: "#666")
        return NSAttributedString(string: text, attributes: attributes)
    }
    ///设置按钮图片
    open func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        
        return nil
    }
    
    //MARK: - DZNEmptyDataSetDelegate
    open func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        // 没网情况下轻拍手势
    }
    open func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return ((viewModel as! MRCBaseTableViewModel).dataSource.value as AnyObject).count <= 0
    }
    
    open func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


public protocol MRCBaseTableViewControllerProtocol: class {
    
    //控制内容便宜量来实现导航栏半透明效果
    var contentInset: UIEdgeInsets { get }
    
    //配置tableView
    var tableView: UITableView { get }
    
    //注册cell
    func registerCellForReusable()
}

extension MRCBaseTableViewController: MRCBaseTableViewControllerProtocol { }
