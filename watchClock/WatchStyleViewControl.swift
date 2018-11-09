//
//  WatchStyleViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit

enum WatchStyleMode : Int {
    case WatchStyleFace,WatchStyleLogo,WatchStyleHour,WatchStyleMinute
}

class WatchStyleViewControl: UITableViewController {
    public var mode : WatchStyleMode = .WatchStyleFace
    public var index : Int = 0
    
    private var imageList : [String]?
    private var itemHeight : CGFloat = 0
    
    override func viewDidLoad() {
        var title : String = ""
        switch self.mode {
        case .WatchStyleMinute:
            imageList = GMinuteImageList
            title = "Minute Style"
            itemHeight = 80
            break
        default:
            imageList = nil
        }
        self.navigationItem.title = title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cell.imageView?.image = UIImage.init(named: imageList![indexPath.row])
        cell.backgroundColor = UIColor.black
        
        cell.textLabel?.text = imageList![indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        
        self.performSegue(withIdentifier: "unwindToDesign", sender: self)
//        self.navigationController?.popViewController(animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? WatchDesignViewControl {
//            print("begin to back...")
//            switch (self.mode) {
//
//            case .WatchStyleFace:
//                vc.faceIndex = index
//                break
//            case .WatchStyleLogo:
//                vc.logoIndex = index
//                break
//            case .WatchStyleHour:
//                vc.hourIndex = self.index
//                break
//            case .WatchStyleMinute:
//                vc.minuteIndex = self.index
//            }
//        }
//    }
    
}
