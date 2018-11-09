//
//  HourViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit

class HourViewControl: UITableViewController {
    public var hourIndex : Int = 0
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        //        let nsn : Notification = NSNotification(name: NSNotification.Name.init("newwatchface") , object: indexPath.row)
        
        NotificationCenter.default.post(name: NSNotification.Name.init("newwatchhour"), object: indexPath.row)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
