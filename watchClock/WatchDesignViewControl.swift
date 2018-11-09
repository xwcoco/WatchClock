//
//  WatchDesignViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit

class WatchDesignViewControl : UITableViewController {
    var faceIndex : Int = 0
    var logoIndex : Int = 1
    var hourIndex : Int = 0
    var minuteIndex : Int  = 0 {
        didSet {
            self.loadWatchImage(3, GMinuteImageList[minuteIndex])
        }
    }
    
    func loadWatchImage(_ index : Int,_ name : String) -> Void {
        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.imageView?.image = UIImage.init(named: name)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchStyleViewControl {
            let cell : UITableViewCell? = sender as? UITableViewCell
            nv.mode = WatchStyleMode(rawValue: cell?.tag ?? 0)!

        }
        
    }
    
    @IBAction func unwindToDesign(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let vc = sourceViewController as? WatchStyleViewControl {
            switch (vc.mode) {
                
            case .WatchStyleFace:
                self.faceIndex = vc.index
                break
            case .WatchStyleLogo:
                self.logoIndex = vc.index
                break
            case .WatchStyleHour:
                self.hourIndex = vc.index
                break
            case .WatchStyleMinute:
                self.minuteIndex = vc.index
                break
            }
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("newwatchface"), object: nil, queue: nil) { (msg) in
            self.faceIndex = msg.object as! Int
            if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                cell.imageView?.image = UIImage(named: GFaceNameList[self.faceIndex])
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("newlogo"), object: nil, queue: nil) { (msg) in
            self.logoIndex = msg.object as! Int
            if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {

                cell.imageView?.image = UIImage(named: GLogoImageList[self.logoIndex])
                
                
            }
        }
    }
}
