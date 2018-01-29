//
//  MRCCellFactory.swift
//  Pods
//
//  Created by 逢阳曹 on 2017/6/28.
//
//

import Foundation
import Nimbus
open class MRCCellFactory: NSObject, NITableViewModelDelegate {
    
    public typealias MRCCellFactoryFinishCreateCellForIndexPathBlock = (UITableView, IndexPath, UITableViewCell, Any) -> Void
    
    public var finishCreateCellBlock: MRCCellFactoryFinishCreateCellForIndexPathBlock?
    
    //MARK:  - NITableViewModelDelegate
    public func tableViewModel(_ tableViewModel: NITableViewModel!, cellFor tableView: UITableView!, at indexPath: IndexPath!, with object: Any!) -> UITableViewCell! {
        
        var cell: UITableViewCell?
        if let nibCell = object as? MRCNibCellObject {
            //nib cell
            let identifier = nibCell.cellName
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            
        }else if let codeCell = object as? MRCCellObject {
            //code cell
            let identifier = NSObject.swiftStringFromClass(codeCell.cellClass())
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }

        if cell != nil && cell!.responds(to: #selector(NICell.shouldUpdate(with:))) {
            (cell as! NICell).shouldUpdate(with: object)
        }
        finishCreateCellBlock?(tableView, indexPath, cell!, object)
        return cell!
    }
    
    //MARK: - Private
    public func cellIdentifierFromObject(object: Any) -> String {
        
        if let nibCell = object as? MRCNibCellObject {
            //nib cell
            return nibCell.cellName
            
        }else if let codeCell = object as? MRCCellObject {
            //code cell
            return NSObject.swiftStringFromClass(codeCell.cellClass())
        }
        return ""
    }
}
