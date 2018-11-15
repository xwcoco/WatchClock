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

class WatchDesignViewControl: UITableViewController {
    
    public var editWatchIndex : Int = -1
    
    public func setEditWatch(data : String) {
        if let tmpWatch = WatchInfo.fromJSON(data: data) {
            self.watch = tmpWatch
        }
    }
    
    public var watch: WatchInfo = WatchInfo()

    var faceIndex: Int = 0 {
        didSet {
            self.loadWatchStyleImage(1, 1, WatchSettings.GFaceNameList[faceIndex])

        }
    }
    var logoIndex: Int = 1 {
        didSet {
            self.loadWatchStyleImage(0, 2, WatchSettings.GLogoImageList[logoIndex])
        }
    }
    var hourIndex: Int = 0 {
        didSet {
            self.loadWatchStyleImage(2, 1, WatchSettings.GHourImageList[hourIndex])
        }
    }
    var minuteIndex: Int = 0 {
        didSet {
            self.loadWatchStyleImage(3, 1, WatchSettings.GMinuteImageList[minuteIndex])
        }
    }

    var SecondIndex: Int = 0 {
        didSet {
            self.loadWatchStyleImage(4, 1, WatchSettings.GSecondImageList[SecondIndex])
        }
    }
    
    private var logoToCenter : CGFloat = 0 {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: 2))
            let nums = cell?.contentView.subviews.count ?? 0
            for i in 0...nums - 1 {
                if let label = cell?.contentView.subviews[i] as? UILabel {
                    label.text = "Dist To Center " + String.init(format: "%.0f", arguments: [logoToCenter])
                    return
                }
            }
        }
    }


    func loadWatchStyleImage(_ index: Int, _ section: Int, _ name: String) -> Void {
        if let cell: UITableViewCell = self.tableView.getCell(at: IndexPath(row: index, section: section)) {
            cell.imageView?.image = UIImage.init(named: name)
        }
    }

    func setDemoWatch() -> Void {
        if let cell: UITableViewCell = self.tableView.getCell(at: IndexPath(row: 0, section: 0)) {
            if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                
                if (skview.scene == nil) {
                    let tmpscene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!
                    
                    tmpscene.initVars(self.watch)
                    
                    tmpscene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                    tmpscene.camera?.yScale = 1.8 / (184.0 / skview.bounds.height)
                    
                    skview.presentScene(tmpscene)
                } else {
                    let tmpscene = skview.scene as? WatchScene
                    tmpscene?.refreshWatch()
                }
                

            }
        }
    }



    override func viewDidLoad() {

        self.setDemoWatch()
        self.faceIndex = watch.faceIndex
        self.logoIndex = watch.LogoIndex
        self.hourIndex = watch.hourIndex
        self.minuteIndex = watch.minuteIndex
        self.SecondIndex = watch.secondIndex

        self.showTextImage(indexPath: IndexPath.init(row: 0, section: textSection), wText: watch.bottomText)
        self.showTextImage(indexPath: IndexPath.init(row: 1, section: textSection), wText: watch.rightText)
        self.showTextImage(indexPath: IndexPath.init(row: 2, section: textSection), wText: watch.leftText)
        
        self.logoToCenter = watch.LogoToCenter

    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 2 && indexPath.row == 1) {
            for i in 0...cell.contentView.subviews.count - 1 {
                if let slider = cell.contentView.subviews[i] as? UISlider {
                    slider.value = Float(self.logoToCenter)
                    return;
                }
            }
        }
    }

    private var textSection: Int = 3


    func showTextImage(indexPath: IndexPath, wText: WatchText) -> Void {
        let cell = self.tableView.getCell(at: indexPath)
        cell?.imageView?.image = wText.toImage()
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchStyleViewControl {
            if let cell: UITableViewCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPath(for: cell)
                var mode : Int = indexPath?.row ?? 1
                mode = mode - 1
                if (indexPath?.section == 2) {
                    mode = WatchStyleMode.WatchStyleLogo.rawValue
                }
                nv.mode = WatchStyleMode(rawValue: mode)!
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

        else if let iv = segue.destination as? InformationViewControl {
            if let cell: UITableViewCell = sender as? UITableViewCell {
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

        else if let fv = segue.destination as? FaceCustomViewControl {
            fv.watch = self.watch
        }

    }

    @IBAction func unwindToDesign(_ unwindSegue: UIStoryboardSegue) {
        print("back to Design")
        let sourceViewController = unwindSegue.source
        if let vc = sourceViewController as? WatchStyleViewControl {
            switch (vc.mode) {

            case .WatchStyleFace:
                watch.faceIndex = vc.index
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

        else if let fv = sourceViewController as? InformationViewControl {
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
    
    @IBOutlet weak var logoDistToCenterSlider: UISlider!
    @IBAction func LogoDistToCenterValueChanged(_ sender: Any) {
        self.logoToCenter = CGFloat(self.logoDistToCenterSlider.value)
        self.watch.LogoToCenter = self.logoToCenter
        self.setDemoWatch()
    }
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToWatchManager", sender: self)
    }
    
    
}


extension UITableView {
    func getCell(at: IndexPath) -> UITableViewCell? {
        //当列表太多时，一行未显示，cellforRow 会返回 nil
        var cell = self.cellForRow(at: at)
        if (cell == nil) {
            cell = self.dataSource?.tableView(self, cellForRowAt: at)
        }
        return cell
    }
}
