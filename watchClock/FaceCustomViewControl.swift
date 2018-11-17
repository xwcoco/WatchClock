//
//  FaceCustomViewControl.swift
//  watchClock
//
//  Created by xwcoco@msn.com on 2018/11/13.
//  Copyright © 2018 xwcoco@msn.com. All rights reserved.
//

import Foundation
import UIKit

class FaceCustomViewControl: UITableViewController,EFColorSelectionViewControllerDelegate {
    @IBOutlet weak var faceSwitch: UISwitch!
    
    @IBOutlet weak var colorRegionSwitch: UISwitch!
    @IBOutlet weak var backColorSwitch: UISwitch!
    public var watch : WatchInfo?
    
    private var section_back : Int = 1
    private var section_facestyle : Int = 2
    private var section_numbers : Int = 3
    private var section_numberStyle : Int = 4
    private var section_tick : Int = 5
    private var section_tickStyle : Int = 6
    private var section_colorregion : Int = 7
    
    @IBAction func FaceSwitchValueChanged(_ sender: Any) {
        for i in 1...self.tableView.numberOfSections - 1 {
            
            let header = self.tableView.headerView(forSection: i)
            if (faceSwitch.isOn) {
                header?.alpha = 1
            } else {
                header?.alpha = 0
            }
            
            for j in 0...self.tableView.numberOfRows(inSection: i) - 1 {
                let cell = self.tableView.getCell(at: IndexPath(row: j, section: i))
                if (faceSwitch.isOn) {
                    cell?.alpha = 1.0
                } else {
                    cell?.alpha = 0.0
                }
            }
            
        }

    }
    
    private var numbers_fontName : String = "" {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: section_numberStyle))
            if (numbers_fontName == "") {
                cell?.detailTextLabel?.text = NSLocalizedString("System Font", comment: "")
            } else {
                cell?.detailTextLabel?.text = numbers_fontName
            }
            
//            cell?.detailTextLabel?.setNeedsDisplay()
        }
    }
    
    private var numbers_Color : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: self.section_numberStyle))
            cell?.imageView?.image = UIImage.imageWithColor(color: numbers_Color, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var numbers_fontSize : CGFloat = 0 {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 2, section: self.section_numberStyle))
            let label = cell?.contentView.subviews[0] as? UILabel
            label?.text = NSLocalizedString("Size", comment: "") + String.init(format: " %.0f", arguments: [numbers_fontSize])
            
        }
    }
    
    
    
    private var backColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: self.section_back))
            cell?.imageView?.image = UIImage.imageWithColor(color: backColor, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var ColorRegion_Color1 : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: self.section_colorregion))
            cell?.imageView?.image = UIImage.imageWithColor(color: ColorRegion_Color1, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var ColorRegion_Color2 : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 2, section: section_colorregion))
            cell?.imageView?.image = UIImage.imageWithColor(color: ColorRegion_Color2, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var ColorRegion_AlternateTextColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 3, section: section_colorregion))
            cell?.imageView?.image = UIImage.imageWithColor(color: ColorRegion_AlternateTextColor, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var ColorRegion_AlternateMajorColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 4, section: section_colorregion))
            cell?.imageView?.image = UIImage.imageWithColor(color: ColorRegion_AlternateMajorColor, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var ColorRegion_AlternateMinorColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 5, section: section_colorregion))
            cell?.imageView?.image = UIImage.imageWithColor(color: ColorRegion_AlternateMinorColor, size: CGSize(width: 40, height: 40))
        }
    }


    private var tick_majorColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: section_tickStyle))
            cell?.imageView?.image = UIImage.imageWithColor(color: tick_majorColor, size: CGSize(width: 40, height: 40))
        }
    }
    
    private var tick_minorColor : UIColor = UIColor.white {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: section_tickStyle))
            cell?.imageView?.image = UIImage.imageWithColor(color: tick_minorColor, size: CGSize(width: 40, height: 40))
        }
    }

    private func setSwitchOn(indexPath : IndexPath,isOn : Bool) {
        let cell = self.tableView.getCell(at: indexPath)
        for i in 0...(cell?.contentView.subviews.count)! - 1 {
            if let view = cell?.contentView.subviews[i] as? UISwitch {
                view.isOn = isOn
                return;
            }
        }
    }
    
    private func setRowCheckState(section : Int,check : Int) -> Void {
        for i in 0...self.tableView.numberOfRows(inSection: section) - 1 {
            let cell = self.tableView.getCell(at: IndexPath(row: i, section: section))
            cell?.accessoryType = .none
            if (i == check) {
                cell?.accessoryType = .checkmark
            }
        }
    }
    
    override func viewDidLoad() {
        if (self.watch != nil) {
            self.setSwitchOn(indexPath: IndexPath.init(row: 0, section: 0), isOn: watch!.useCustomFace)
//            faceSwitch.isOn = watch!.useCustomFace
            self.setSwitchOn(indexPath: IndexPath.init(row: 0, section: self.section_back), isOn: watch!.customFace_draw_back)
//            backColorSwitch.isOn = watch!.customFace_draw_back
            self.setSwitchOn(indexPath: IndexPath.init(row: 0, section: self.section_colorregion), isOn: watch!.customFace_showColorRegion)
//            colorRegionSwitch.isOn = watch!.customFace_showColorRegion
            backColor = watch!.customFace_back_color
            ColorRegion_Color1 = watch!.customFace_ColorRegion_Color1
            ColorRegion_Color2 = watch!.customFace_ColorRegion_Color2
            ColorRegion_AlternateTextColor = watch!.customFace_ColorRegion_AlternateTextColor
            ColorRegion_AlternateMajorColor = watch!.customFace_ColorRegion_AlternateMajorColor
            ColorRegion_AlternateMinorColor = watch!.customFace_ColorRegion_AlternateMinorColor
            
            self.setRowCheckState(section: section_numbers, check: watch!.numeralStyle.rawValue)
            setRowCheckState(section: section_tick, check: watch!.tickmarkStyle.rawValue)
            setRowCheckState(section: section_facestyle, check: watch!.faceStyle.rawValue)
            
            self.numbers_fontName = watch!.numbers_fontName
            self.numbers_fontSize = watch!.numbers_fontSize
            self.numbers_Color = watch!.numbers_color
            
            
            self.tick_majorColor = watch!.tick_majorColor
            self.tick_minorColor = watch!.tick_minorColor

        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == section_numberStyle && indexPath.row == 2) {
            for i in 0...cell.contentView.subviews.count - 1 {
                if let view = cell.contentView.subviews[i] as? UISlider {
                    view.value = Float(self.numbers_fontSize)
                }
                
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        FaceSwitchValueChanged(self.faceSwitch)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? FontSelectViewControl {
            nv.backToSegueName = "unwindToFace"
            nv.selectedFontName = self.numbers_fontName
        }
    }
    
    @IBAction func unwindToFace(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let nv = sourceViewController as? FontSelectViewControl {
            self.numbers_fontName = nv.selectedFontName
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    private var colorMode : Int = 0
    
    private func getEditColor() -> UIColor {
        switch colorMode {
        case 0:
            return self.backColor
        case 1:
            return self.ColorRegion_Color1
        case 2:
            return self.ColorRegion_Color2
        case 3:
            return self.ColorRegion_AlternateTextColor
        case 4:
            return self.ColorRegion_AlternateMajorColor
        case 5:
            return self.ColorRegion_AlternateMinorColor
        case 6:
            return self.numbers_Color
        case 7:
            return self.tick_majorColor
        default:
            return self.tick_minorColor
            
        }
    }
    
    private func setEditColor(_ color : UIColor) -> Void {
        switch colorMode {
        case 0:
            self.backColor = color
            break;
        case 1:
            self.ColorRegion_Color1 = color
            break
        case 2:
            self.ColorRegion_Color2 = color
            break
        case 3:
            self.ColorRegion_AlternateTextColor = color
            break
        case 4:
            self.ColorRegion_AlternateMajorColor = color
            break
        case 5:
            self.ColorRegion_AlternateMinorColor = color
            break
        case 6:
            self.numbers_Color = color
            break
        case 7:
            self.tick_majorColor = color
            break
        default:
            self.tick_minorColor = color
            break
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == section_back && indexPath.row == 1) {
            self.colorMode = 0
            self.showColorPicker(indexPath: indexPath)
        }
        if (indexPath.section == section_numbers) {
            self.setRowCheckState(section: section_numbers, check: indexPath.row)
        }
        
        if (indexPath.section == section_tick) {
            self.setRowCheckState(section: section_tick, check: indexPath.row)
        }
        
        if (indexPath.section == section_facestyle) {
            self.setRowCheckState(section: section_facestyle, check: indexPath.row)
        }
        
        if (indexPath.section == section_colorregion) {
            if (indexPath.row >= 1) {
                self.colorMode = indexPath.row
                self.showColorPicker(indexPath: indexPath)
            }
//
//            if (indexPath.row == 1) {
//                self.colorMode = 1
//                self.showColorPicker(indexPath: indexPath)
//            }
//            else if (indexPath.row == 2) {
//                self.colorMode = 2
//                self.showColorPicker(indexPath: indexPath)
//            }
        }
        
        if (indexPath.section == section_numberStyle) {
            if (indexPath.row == 1) {
                self.colorMode = 6
                self.showColorPicker(indexPath: indexPath)
            }
        }
        
        if (indexPath.section == section_tickStyle) {
            self.colorMode = 7 + indexPath.row
            self.showColorPicker(indexPath: indexPath)
        }
    }
    
    func showColorPicker(indexPath : IndexPath) -> Void {
        //        let cell = self.tableView.cellForRow(at: indexPath)
        
        let colorSelectionController = EFColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = UIColor.white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        
        colorSelectionController.delegate = self
        colorSelectionController.color = self.getEditColor()
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
        self.setEditColor(color)
    }
    
    @objc func ef_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            [weak self] in
            if let _ = self {
            }
        }
    }
    
    
    private func getCheckRawValue(_ section : Int) -> Int {
        for i in 0...self.tableView.numberOfRows(inSection: section) - 1 {
            let cell = self.tableView.getCell(at: IndexPath.init(row: i, section: section))
            if (cell?.accessoryType == .checkmark) {
                return i
            }
        }
        return 0
    }
    
    private func getSwitchIsOn(indexPath : IndexPath) -> Bool {
        let cell = self.tableView.getCell(at: indexPath)
        for i in 0...(cell?.contentView.subviews.count)! - 1 {
            if let view = cell?.contentView.subviews[i] as? UISwitch {

                return view.isOn;
            }
        }

        return false
    }
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        if (self.watch != nil) {
            watch?.useCustomFace = self.getSwitchIsOn(indexPath: IndexPath(row: 0, section: 0)) // self.faceSwitch.isOn
            watch?.customFace_draw_back = self.getSwitchIsOn(indexPath: IndexPath(row: 0, section: section_back)) //self.backColorSwitch.isOn
            watch?.customFace_back_color = self.backColor

            watch?.numeralStyle = NumeralStyle(rawValue: self.getCheckRawValue(section_numbers))!
            watch?.tickmarkStyle = TickmarkStyle(rawValue: self.getCheckRawValue(section_tick))!
            watch?.faceStyle = WatchFaceStyle(rawValue: self.getCheckRawValue(section_facestyle))!

            watch?.customFace_showColorRegion = self.getSwitchIsOn(indexPath: IndexPath(row: 0, section: section_colorregion)) //self.colorRegionSwitch.isOn
            watch?.customFace_ColorRegion_Color1 = self.ColorRegion_Color1
            watch?.customFace_ColorRegion_Color2 = self.ColorRegion_Color2
            
            watch?.numbers_fontName = self.numbers_fontName
            watch?.numbers_fontSize = self.numbers_fontSize
            watch?.numbers_color = self.numbers_Color
            
            watch?.tick_majorColor = self.tick_majorColor
            watch?.tick_minorColor = self.tick_minorColor
            
            watch?.customFace_ColorRegion_AlternateTextColor = self.ColorRegion_AlternateTextColor
            watch?.customFace_ColorRegion_AlternateMajorColor = self.ColorRegion_AlternateMajorColor
            watch?.customFace_ColorRegion_AlternateMinorColor = self.ColorRegion_AlternateMinorColor

        }
        
        self.performSegue(withIdentifier: "unwindToDesign", sender: self)
    }
    
    @IBOutlet weak var numbers_fontSizeSlider: UISlider!
    @IBAction func fontSizeChanged(_ sender: Any) {
        self.numbers_fontSize = CGFloat(self.numbers_fontSizeSlider.value)
    }
    
    
}
