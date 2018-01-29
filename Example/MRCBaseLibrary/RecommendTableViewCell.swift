//
//  RecommendTableViewCell.swift
//  Beauty
//  首页最新推荐列表数据
//  Created by 逢阳曹 on 2016/11/14.
//  Copyright © 2016年 CBSi. All rights reserved.
//

import UIKit

class RecommendTableViewCell: UITableViewCell, NICell {

    //头像
    @IBOutlet weak var avatarView: UIView!
    
    //名称
    @IBOutlet weak var nameLabel: UILabel!
    
    //封面图
    @IBOutlet weak var coverImageView: UIImageView!
    
    //标题
    @IBOutlet weak var contentLabel: UILabel!
    
    //浏览量图片
    @IBOutlet weak var viewCountImageView: UIImageView!
    
    //浏览量
    @IBOutlet weak var viewcountLabel: UILabel!
    
    //视频标识
    @IBOutlet weak var videoIcon: UIImageView!
    
    //视频时长
    @IBOutlet weak var videoTimeLabel: UILabel!
    
    //浏览量
    @IBOutlet weak var viewCountHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: over load
    func shouldUpdate(with object: Any!) -> Bool {
        
        if (object as AnyObject) is RecommendModel {
            self.configureHomePageData(object as! RecommendModel)
        }
        return true
    }
    
    //MARK: - Private
    //最新频道栏目
    func configureHomePageData(_ object: RecommendModel) {
        
        self.nameLabel.text = object.usr
        self.coverImageView.setImageWith(URL(string: object.iu!), options: .setImageWithFadeAnimation)
        
        self.contentLabel.text = object.tt
        self.viewcountLabel.text = object.viewCount ?? "0"
        
        self.videoIcon.isHidden = (object.type != "va" && object.type != "lv")
        self.videoTimeLabel.isHidden = self.videoIcon.isHidden
        self.viewCountHeight.constant = 30
        self.viewcountLabel.isHidden = self.viewCountHeight.constant == 0
        self.viewCountImageView.isHidden = self.viewCountHeight.constant == 0
        
        guard object.stu != nil else { return }
        if object.stu! == "1" {
            self.videoTimeLabel.text = "直播"
            self.viewCountHeight.constant = 0
        }else if object.stu == "2" {
            self.videoTimeLabel.text = "即将直播"
            self.viewCountHeight.constant = 0
            
        }else if object.stu == "3" {
            self.viewCountHeight.constant = 30
            self.videoTimeLabel.text = "\(object.vl != nil ? object.vl! : "")"
        }else if object.stu == "4" {
            self.viewCountHeight.constant = 30
        }
        
        self.viewcountLabel.isHidden = self.viewCountHeight.constant == 0
        self.viewCountImageView.isHidden = self.viewCountHeight.constant == 0
    }
}


class RecommendModel: MRCNibCellObject {
    
    //文章类型 文章 视频 直播 图片视频广告
    var type: String?
    
    //文章或直播id
    var id: String?
    
    //标题
    var tt: String?
    
    //用户信息
    var usr: String?
    
    //用户头像
    var up: String?
    
    //用户身份 1专家 2达人 3编辑
    var role: String?
    
    //专家达人id
    var eid: String?
    
    //图片
    var iu: String?
    
    //链接地址
    var val: String?
    
    //视频时长
    var vl: String?
    
    //点击量
    var viewCount: String?
    
    //直播状态 1进行中 2未开始 3结束
    var stu: String?
    
    //直播观看地址
    var rtmp: String?
    
    //回放地址
    var bu: String?
    
    //是否全屏播放
    var full: String?
    
    //视频广告播放地址
    var mp4: String?
    
    //视频广告图片(扩展字段)
    var videoImage: UIImage?
    
    var iid:String? // 活动id
    
    //广告曝光相关
    //展示曝光
    var trackUrl: String?
    var isTrack: Bool = false
    //点击曝光
    var clickUrl: String?
    var isClick: Bool = false
    
    //over load
    required init(anyObject: JSON) {
        super.init(cellNib: UINib(nibName: "RecommendTableViewCell", bundle: nil))
        type = anyObject["type"].stringValue
        id   = anyObject["id"].stringValue
        tt   = anyObject["tt"].stringValue
        usr  = anyObject["usr"].stringValue
        up   = anyObject["up"].stringValue
        role = anyObject["role"].stringValue
        eid  = anyObject["eid"].stringValue
        iu   = anyObject["iu"].stringValue
        val  = anyObject["val"].stringValue
        vl   = anyObject["vl"].stringValue
        viewCount = anyObject["viewCount"].stringValue
        stu  = anyObject["stu"].stringValue
        rtmp  = anyObject["rtmp"].stringValue
        bu  = anyObject["bu"].stringValue
        full  = anyObject["full"].stringValue
        mp4  = anyObject["mp4"].stringValue
        iid  = anyObject["iid"].stringValue
        trackUrl = anyObject["trackUrl"].stringValue
        clickUrl = anyObject["clickUrl"].stringValue
    }
}




