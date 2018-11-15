//
//  InformationViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/11.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit

class InformationViewControl: UITableViewController,EFColorSelectionViewControllerDelegate {

    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!
    public var backIndex : Int = 1 {
        didSet {
            self.loadStyleImage(0, 1, WatchSettings.GInfoBackgroud[backIndex])
        }
    }
    
    private var distToCenter : CGFloat = 0 {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: 1))
            let num = cell?.contentView.subviews.count ?? 0
            for i in 0...num - 1 {
                if let label = cell?.contentView.subviews[i] as? UILabel {
                    label.text = "Distance To Center " + String.init(format: "%.0f", arguments: [distToCenter])
                    return;
                }
            }
        }
    }

    
    public var textContentIndex : Int = 0 {
        didSet {
            self.setTextContentCheck()
        }
    }
    
    public var textColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: textColorSection))
            cell?.imageView?.image = UIImage.imageWithColor(color: textColor, size: CGSize(width: 40, height: 40))
        }
    }
    
    public var watchText : WatchText?
    
    public var fontName : String = "" {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath(row: 0, section: 4))
            cell?.textLabel?.text = "Name : " + fontName
        }
    }
    
    public var fontSize : CGFloat = 0
    
    public var watchTextIndex : Int = 0 {
        didSet {
            switch watchTextIndex {
            case 0:
                self.navigationItem.title = "Bottom Text"
                break
            case 1:
                self.navigationItem.title = "Right Text"
                break
            case 2:
                self.navigationItem.title = "Left Text"
                break
            default:
                break
            }
            
        }
    }
    
    
    @IBOutlet weak var customSwitch: UISwitch!
    @IBAction func switchValueChanged(_ sender: Any) {
        for i in 1...self.tableView.numberOfSections - 1 {
            
            let header = self.tableView.headerView(forSection: i)
            if (customSwitch.isOn) {
                header?.alpha = 1
            } else {
                header?.alpha = 0
            }
            
            for j in 0...self.tableView.numberOfRows(inSection: i) - 1 {
                let cell = self.tableView.getCell(at: IndexPath(row: j, section: i))
                if (customSwitch.isOn) {
                    cell?.alpha = 1.0
                } else {
                    cell?.alpha = 0.0
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        if (watchText != nil) {
            self.customSwitch.isOn = watchText!.enabled
            self.backIndex = watchText!.backImageIndex
            self.textContentIndex = watchText!.textContentIndex.rawValue
            self.textColor = watchText!.textColor
            
            self.fontName = watchText!.fontName
            self.setFontSize(setSlider: true, newSize: watchText!.fontSize)
            
            self.distToCenter = watchText!.distToCenter
            
            self.WeatherTextIndex = watchText!.weatherTextStyle.rawValue
            
//            self.switchValueChanged(self.customSwitch)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.switchValueChanged(self.customSwitch)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchStyleViewControl {
            nv.mode = WatchStyleMode.InfoStyleBack
            nv.index = backIndex
        } else if let nv = segue.destination as? FontSelectViewControl {
            nv.selectedFontName = self.fontName
        }
        
    }
    
    @IBAction func unwindToInfo(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? WatchStyleViewControl {
            self.backIndex = nv.index
        } else if let nv = unwindSegue.source as? FontSelectViewControl {
            self.fontName = nv.selectedFontName
        }
        
        
    }
    
    func loadStyleImage(_ index : Int,_ section : Int,_ name : String) -> Void {
        if let cell : UITableViewCell = self.tableView.getCell(at: IndexPath(row: index, section: section)) {
            if let imgView = cell.contentView.subviews[0] as? UIImageView {
                imgView.image = UIImage.init(named: name)
            }
        }
    }
    
    
    
    func setTextContentCheck() -> Void {
        for i in 0...self.tableView.numberOfRows(inSection: textIndexSection) - 1 {
            let cell = self.tableView.getCell(at: IndexPath(row: i, section: textIndexSection))
            if (i == self.textContentIndex) {
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
    }
    
    private var WeatherIndexSection : Int = 5
    
    private var WeatherTextIndex : Int = 0 {
        didSet {
            self.setWeatherTextCheck()
        }
    }
    
    func setWeatherTextCheck() -> Void {
        for i in 1...self.tableView.numberOfRows(inSection: WeatherIndexSection) - 1 {
            let cell = self.tableView.getCell(at: IndexPath(row: i, section: WeatherIndexSection))
            if (i == self.WeatherTextIndex + 1) {
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
    }

    
    private var textIndexSection : Int = 2
    private var textColorSection : Int = 3
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == textIndexSection) {
            self.textContentIndex = indexPath.row
        }
        if (indexPath.section == textColorSection) {
            self.showColorPicker(indexPath: indexPath)
        }
        if (indexPath.section == WeatherIndexSection) {
            self.WeatherTextIndex = indexPath.row - 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 && indexPath.row == 1) {
            for i in 0...cell.contentView.subviews.count - 1 {
                if let slider = cell.contentView.subviews[i] as? UISlider {
                    slider.value = Float(self.distToCenter)
                }
            }
        } else if (indexPath.section == WeatherIndexSection && indexPath.row == 0) {
            for i in 0...cell.contentView.subviews.count - 1 {
                if let sw = cell.contentView.subviews[i] as? UISwitch {
                    sw.isOn = watchText!.showWeatchIcon
                }
            }
        }
        
    }

    
    func showColorPicker(indexPath : IndexPath) -> Void {
//        let cell = self.tableView.cellForRow(at: indexPath)
        
        let colorSelectionController = EFColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = UIColor.white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
//        navCtrl.popoverPresentationController?.delegate = self
//        navCtrl.popoverPresentationController?.sourceView = cell?.imageView
//        navCtrl.popoverPresentationController?.sourceRect = cell?.imageView?.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        
        colorSelectionController.delegate = self
        colorSelectionController.color = self.textColor
//
        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl, animated: true, completion: nil)
    }
    
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        self.textColor = color
    }
    
    @objc func ef_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            [weak self] in
            if let _ = self {
                // TODO: You can do something here when EFColorPicker close.
                print("EFColorPicker closed.")
            }
        }
    }
    
    @IBAction func fontSizeChanged(_ sender: Any) {
        self.setFontSize(setSlider: false, newSize: CGFloat(self.fontSizeSlider.value))
    }
    
    func setFontSize(setSlider : Bool,newSize : CGFloat) -> Void {
        self.fontSize = newSize
        self.fontSizeLabel.text = "Size : " + String.init(format: "%.0f", arguments: [newSize])
        if (setSlider) {
            self.fontSizeSlider.value = Float(newSize)
        }
    }

    
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        watchText?.enabled = self.customSwitch.isOn
        watchText?.backImageIndex = self.backIndex
        watchText?.textContentIndex = WatchTextContent(rawValue: self.textContentIndex) ?? .WatchTextDate
        watchText?.textColor = self.textColor
        watchText?.fontName = self.fontName
        watchText?.fontSize = self.fontSize
        
        watchText?.distToCenter = self.distToCenter
        
        watchText?.weatherTextStyle = WeatherTextStyle(rawValue: self.WeatherTextIndex)!
        watchText?.showWeatchIcon = self.getSwitchState(at: IndexPath.init(row: 0, section: WeatherIndexSection), defaultValue: watchText?.showWeatchIcon ?? false)
        
        self.performSegue(withIdentifier: "unwindToDesign", sender: self)
    }
    
    @IBOutlet weak var textToCenterSlider: UISlider!
    @IBAction func textToCenterSliderValueChanged(_ sender: Any) {
        self.distToCenter = CGFloat(self.textToCenterSlider.value)
    }
    
    func getSwitchState(at: IndexPath,defaultValue : Bool) -> Bool {
        let cell = self.tableView.cellForRow(at: at)
        var num = cell?.contentView.subviews.count ?? 0
        num = num - 1
        if (num < 0) {
            return defaultValue
        }
        
        for i in 0...num {
            if let sw = cell?.contentView.subviews[i] as? UISwitch {
                return sw.isOn
            }
        }
        return defaultValue
    }
    
}
