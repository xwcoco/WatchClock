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
                self.loadWatchStyleImage(0,1, GFaceNameList[faceIndex])
//            }
            
        }
    }
    var logoIndex : Int = 1 {
        didSet {
            self.loadWatchStyleImage(1,1, GLogoImageList[logoIndex])
        }
    }
    var hourIndex : Int = 0 {
        didSet {
            self.loadWatchStyleImage(2,1, GHourImageList[hourIndex])
        }
    }
    var minuteIndex : Int  = 0 {
        didSet {
            self.loadWatchStyleImage(3,1, GMinuteImageList[minuteIndex])
        }
    }
    
    var SecondIndex : Int = 0 {
        didSet {
            self.loadWatchStyleImage(4,1, GSecondImageList[SecondIndex])
        }
    }
    
//    func setWatchStyleImage(_ index : Int,_ img : UIImage) -> Void {
//        if let cell : UITableViewCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
//            cell.imageView?.image = img
//        }
//    }
    
    func loadWatchStyleImage(_ index : Int,_ section : Int,_ name : String) -> Void {
        if let cell : UITableViewCell = self.tableView.getCell(at: IndexPath(row: index, section: section)) {
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
        if let cell : UITableViewCell = self.tableView.getCell(at: IndexPath(row: 0, section: 0)) {
            if let skview : SKView = cell.contentView.subviews[1] as? SKView {
                let tmpscene : WatchScene = WatchScene.init(fileNamed:"FaceScene")!
                
                tmpscene.initVars(self.watch)
                
                
                tmpscene.camera?.xScale = 1.8 / (184.0/skview.bounds.width)
                tmpscene.camera?.yScale = 1.8 / (184.0/skview.bounds.height)
                
                skview.presentScene(tmpscene)
                
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        print("view DidLoad")
//        <#code#>
//    }
//    override func viewDidAppear(_ animated: Bool) {
    
        self.setDemoWatch()
        self.faceIndex = watch.faceIndex
        self.logoIndex = watch.LogoIndex
        self.hourIndex = watch.hourIndex
        self.minuteIndex = watch.minuteIndex
        self.SecondIndex = watch.secondIndex
        
        self.showTextImage(indexPath: IndexPath.init(row: 0, section: textSection), wText: watch.bottomText)
        self.showTextImage(indexPath: IndexPath.init(row: 1, section: textSection), wText: watch.rightText)
        self.showTextImage(indexPath: IndexPath.init(row: 2, section: textSection), wText: watch.leftText)
        
        
    }
    
    private var textSection : Int = 2

    
    func showTextImage(indexPath : IndexPath,wText : WatchText) -> Void {
//        print(self.tableView.numberOfRows(inSection: indexPath.section))
//        let cell = self.tableView.cellForRow(at: indexPath)
        let cell = self.tableView.getCell(at: indexPath)
        cell?.imageView?.image = wText.toImage()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchStyleViewControl {
            if let cell : UITableViewCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPath(for: cell)
                nv.mode = WatchStyleMode(rawValue: indexPath?.row ?? 0)!
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
        
        if let iv = segue.destination as? InformationViewControl {
            if let cell : UITableViewCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPath(for: cell)
                iv.watchTextIndex = indexPath!.row
                switch (indexPath?.row) {
                    
                case 0:
                    iv.watchText = watch.bottomText
                    break
                case 1:
                    iv.watchText = watch.rightText
                    break
                case 2:
                    iv.watchText = watch.leftText
                default:
                    break
                }
            }
            
        }
        
    }
    
    @IBAction func unwindToDesign(_ unwindSegue: UIStoryboardSegue) {
        print("back to Design")
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
            
        }
        
        if let fv = sourceViewController as? InformationViewControl {
            switch (fv.watchTextIndex) {
            case 0:
                self.showTextImage(indexPath: IndexPath.init(row: 0, section: textSection), wText: watch.bottomText)
                break
            case 1:

                self.showTextImage(indexPath: IndexPath.init(row: 1, section: textSection), wText: watch.rightText)
                break
            case 2:
                self.showTextImage(indexPath: IndexPath.init(row: 2, section: textSection), wText: watch.leftText)
                break
            default:
                break

            }
            
        }
        
        self.setDemoWatch()
    }
    
}


extension UITableView {
    func getCell(at : IndexPath) -> UITableViewCell? {
        //当列表太多时，一行未显示，cellforRow 会返回 nil
        var cell = self.cellForRow(at: at)
        if (cell == nil) {
            cell = self.dataSource?.tableView(self, cellForRowAt: at)
        }
        return cell
    }
}
