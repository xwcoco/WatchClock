//
//  InformationViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/11.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit

class InformationViewControl: UITableViewController {
    public var backIndex : Int = 1 {
        didSet {
            self.loadStyleImage(1, GInfoBackgroud[backIndex])
        }
    }
    @IBOutlet weak var customSwitch: UISwitch!
    @IBAction func switchValueChanged(_ sender: Any) {
        for i in 1...self.tableView.subviews.count-1 {
            if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) {
                if (customSwitch.isOn) {
                    cell.alpha = 1.0
                } else {
                    cell.alpha = 0
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchStyleViewControl {
            nv.mode = WatchStyleMode.InfoStyleBack
            nv.index = backIndex
        }
    }
    
    @IBAction func unwindToInfo(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? WatchStyleViewControl {
            self.backIndex = nv.index
        }
    }
    
    func loadStyleImage(_ index : Int,_ name : String) -> Void {
        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            if let imgView = cell.contentView.subviews[0] as? UIImageView {
                imgView.image = UIImage.init(named: name)
            }
        }
    }
    
}
