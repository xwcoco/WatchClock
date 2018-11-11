//
//  WatchDesignViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchDesignViewControl : UITableViewController {
    public var watch : WatchInfo = WatchInfo()
    
    var faceIndex : Int = 0 {
        didSet {
//            if (faceIndex == GFaceNameList.count - 1) {
//                self.setWatchStyleImage(1, watch.faceImage!)
//            } else {
                self.loadWatchStyleImage(1, GFaceNameList[faceIndex])
//            }
            
        }
    }
    var logoIndex : Int = 1 {
        didSet {
            self.loadWatchStyleImage(2, GLogoImageList[logoIndex])
        }
    }
    var hourIndex : Int = 0 {
        didSet {
            self.loadWatchStyleImage(3, GHourImageList[hourIndex])
        }
    }
    var minuteIndex : Int  = 0 {
        didSet {
            self.loadWatchStyleImage(4, GMinuteImageList[minuteIndex])
        }
    }
    
    var SecondIndex : Int = 0 {
        didSet {
            self.loadWatchStyleImage(5, GSecondImageList[SecondIndex])
        }
    }
    
    func setWatchStyleImage(_ index : Int,_ img : UIImage) -> Void {
        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.imageView?.image = img
        }
    }
    
    func loadWatchStyleImage(_ index : Int,_ name : String) -> Void {
        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
            cell.imageView?.image = UIImage.init(named: name)
        }
    }
    
//    func setWatchImage() -> Void {
//        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
//            print("get cell")
//            print(cell.subviews.count)
//            if let img : UIImageView = cell.contentView.subviews[0] as? UIImageView {
//                img.image = self.watch.buildImage()
//            }
//
//        }
//    }
    
    func setDemoWatch() -> Void {
        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            if let skview : SKView = cell.contentView.subviews[1] as? SKView {
                let tmpscene : WatchScene = WatchScene.init(fileNamed:"FaceScene")!
                
                tmpscene.initVars(self.watch)
                
                
                tmpscene.camera?.xScale = 1.8 / (184.0/skview.bounds.width)
                tmpscene.camera?.yScale = 1.8 / (184.0/skview.bounds.height)
                
                skview.presentScene(tmpscene)
                
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        self.setDemoWatch()
        self.faceIndex = watch.faceIndex
        self.logoIndex = watch.LogoIndex
        self.hourIndex = watch.hourIndex
        self.minuteIndex = watch.minuteIndex
        self.SecondIndex = watch.secondIndex
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchStyleViewControl {
            let cell : UITableViewCell? = sender as? UITableViewCell
            nv.mode = WatchStyleMode(rawValue: cell?.tag ?? 0)!
            switch (nv.mode) {
                
            case .WatchStyleFace:
                nv.index = self.faceIndex
                break
            case .WatchStyleLogo:
                nv.index = self.logoIndex
                break
            case .WatchStyleHour:
                nv.index = self.hourIndex
                break
            case .WatchStyleMinute:
                nv.index = self.minuteIndex
                break
            case .WatchStyleSecond:
                nv.index = self.SecondIndex
                break
            default:
                break;
            }

        }
        
    }
    
    @IBAction func unwindToDesign(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let vc = sourceViewController as? WatchStyleViewControl {
            switch (vc.mode) {
                
            case .WatchStyleFace:
                watch.faceIndex = vc.index
//                if (watch.isCustomFace()) {
//                    watch.faceImage = vc.customImage
//                }
                self.faceIndex = vc.index
                
                break
            case .WatchStyleLogo:
                self.logoIndex = vc.index
                watch.LogoIndex = logoIndex
                break
            case .WatchStyleHour:
                self.hourIndex = vc.index
                watch.hourIndex = hourIndex
                break
            case .WatchStyleMinute:
                self.minuteIndex = vc.index
                watch.minuteIndex = minuteIndex
                break
            case .WatchStyleSecond:
                self.SecondIndex = vc.index
                watch.secondIndex = SecondIndex
            default:
                break
            }
            self.setDemoWatch()
        }
    }
    
}
