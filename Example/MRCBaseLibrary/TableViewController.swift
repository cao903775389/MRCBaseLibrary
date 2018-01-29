//
//  TableViewController.swift
//  MRCBase
//
//  Created by 逢阳曹 on 2017/6/2.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

//对外部以Target-Action的形式提供入口
class Target_TableView: NSObject {
    
    //登录状态
    var loginStatus: Bool {
        return UserDefaults.LoginStatus.value(forKey: .lastLoginTime) != nil
    }
    
    func Action_fetchViewController(_ params: [String: Any]?) -> UIViewController {
        return TableViewController()
    }
    
    func Action_showAlert() -> UIAlertController {
        
        let yesAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        let alert = UIAlertController(title: "注意", message: "确定取消么?", preferredStyle: .alert)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        return alert
    }

    override func MRCMediator_WillCreateModule(target: String, action: String, params: [String : Any]?, complete: ActionComplete?) -> Bool {
        
        guard !loginStatus else { return true }
        //登录验证
        if NSSelectorFromString(action) == #selector(Target_TableView.Action_showAlert) || NSSelectorFromString(action) == #selector(Target_TableView.Action_fetchViewController(_:))  {
            MRCMediator.sharedMRCMediator().MRCMediator_viewControllerForLogin(target: target, action: action, actionParams: params, actionComplete: complete)
            return false
        }
        return true
    }
    
}


class TableViewController: MRCBaseTableViewController {

    override var enableShare: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewModelForViewController() -> MRCBaseViewModel {
        return TestTableViewModel(tableModel: NIMutableTableViewModel(delegate: self), params: ["title": "列表"])
    }
    
    override func setUpShareHandle() {
        //分享回调
        //测试跳转ViewController 需要验证登录
        MRCMediator.sharedMRCMediator().MRCMediator_viewControllerForTableView { nextPage in
            guard let next = nextPage as? UIViewController else { return }
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        MRCMediator.sharedMRCMediator().MRCMediator_viewControllerForView { (view) in
            guard let view = view as? UIViewController else { return }
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
}

class TestTableViewModel: MRCBaseTableViewModel {

    lazy var service: TestService = {
        return TestService()
    }()
    
    override func requestRemoteDataSignalWithPage(page: Int) -> SignalProducer<Any, HttpError> {
        
        return service.requestRemoteData(page: page)
    }
}

class TestService: MRCBaseService, OLHttpRequestDelegate {
    
    private var innerObserver: Observer<Any, HttpError>?
    
    
    
    func requestRemoteData(page: Int) -> SignalProducer<Any, HttpError> {
        let (signalProducer, observer) = SignalProducer<Any, HttpError>.pipe()
        self.innerObserver = observer
        self.networkRequest(page: page)
        return signalProducer
    }
    
    private func networkRequest(page: Int) {
        let param: [String: Any] = ["rd": OLCode.OL_TrialList.rawValue, "ie": page]
        
        let trialListRequest = BeautyMAPIHttpRequest(delegate: self, requestMethod: OLHttpMethod.GET, requestUrl: MAPIURL.V130.rawValue, requestArgument: param, OL_CODE: OLCode.OL_TrialList)
        
        OLHttpRequestManager.sharedOLHttpRequestManager.sendHttpRequest(request: trialListRequest)
        
    }
    
    func ol_requestFinished(request: OLHttpRequest) {
        
        let trialJSON = JSON(request.responseObject!)["data"]["trylist"].arrayValue
        var trialModelList: [Any] = trialJSON.map { TrialListItemModel(anyObject: $0) }
        
        trialModelList.append(TestModel())
        
        self.innerObserver?.send(value: trialModelList)
        self.innerObserver?.sendCompleted()
    }
    
    func ol_requestFailed(request: OLHttpRequest) {
        
    }
    
}

class TestModel: MRCCellObject {
    
    //固定cell类型
    override init(cellClass: AnyClass = CodeTableViewCell.classForCoder()) {
        super.init(cellClass: cellClass)
    }
}


class TrialListItemModel: MRCNibCellObject {
    /// 试用ID
    var tryid:Int!
    /// 试用标题
    var tt:String!
    /// 试用数量
    var tnum:Int!
    /// 试用人气
    var wnum:Int!
    /// 开始时间
    var stat:Int!
    /// 结束时间
    var end:Int!
    /// 图片地址
    var iu:String!
    /// 使用介绍
    var des:String!
    /// 申请状态
    var stu:Int!
    /// 试用规格 0正装 1小样 2中样
    var type: Int!
    /// 试用状态
    var tstu:Int!
    
    required init(anyObject: JSON) {
        super.init(cellClass: UINib(nibName: "TestTableViewCell", bundle: nil))
        tryid = anyObject["tryid"].intValue
        tt = anyObject["tt"].stringValue
        tnum = anyObject["tnum"].intValue
        wnum = anyObject["wnum"].intValue
        stat = anyObject["stat"].intValue
        end = anyObject["end"].intValue
        iu = anyObject["iu"].stringValue
        des = anyObject["des"].stringValue
        stu = anyObject["stu"].intValue
        type = anyObject["type"].intValue
        tstu = anyObject["tstu"].intValue
    }
}


