//
//  WatchStyleViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

enum WatchStyleMode : Int {
    case WatchStyleFace,WatchStyleHour,WatchStyleMinute,WatchStyleSecond,WatchStyleLogo,InfoStyleBack
}

class WatchStyleViewControl: UITableViewController {
    public var mode : WatchStyleMode = .WatchStyleFace
    public var index : Int = 0
    
    private var customChoose : Bool = false
    
    private var imageList : [String]?
    private var itemHeight : CGFloat = 0
    public var customImage : UIImage?
    
    override func viewDidLoad() {
        var title : String = ""
        self.customChoose = false
        switch self.mode {
        case .WatchStyleFace:
            imageList = WatchSettings.GFaceNameList
            title = "Face Style"
            itemHeight = 100
//            customChoose = true
            break
        case .WatchStyleMinute:
            imageList = WatchSettings.GMinuteImageList
            title = "Minute Style"
            itemHeight = 80
            break
        case .WatchStyleLogo:
            imageList = WatchSettings.GLogoImageList
            title = "Logo Style"
            itemHeight = 50
            break
        case .WatchStyleHour:
            imageList = WatchSettings.GHourImageList
            title = "Hour Style"
            itemHeight = 80
            break
        case .WatchStyleSecond:
            imageList = WatchSettings.GSecondImageList
            title = "Second Style"
            itemHeight = 80
        case .InfoStyleBack:
            imageList = WatchSettings.GInfoBackgroud
            title = "Gackgroud"
            itemHeight = 60
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
        
        var tmpStr : String = imageList![indexPath.row]
        
        tmpStr = tmpStr.replacingOccurrences(of: "_", with: " ")
        
        cell.textLabel?.text = tmpStr
        cell.textLabel?.textColor = UIColor.white
        
        if (indexPath.row == self.index) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        cell.selectionStyle = .none
        
//        if (indexPath.row == self.imageList!.count - 1) {
//            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    
    private var oldIndex : Int = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        oldIndex = index
        
        self.index = indexPath.row
        
        if (self.mode == .InfoStyleBack) {
            self.performSegue(withIdentifier: "unwindToInfo", sender: self)
        }
        else {
            
        
        
//        if (self.customChoose && index == imageList!.count - 1) {
//            self.selectFromPhoto()
//        }
//        else
//        {
            self.performSegue(withIdentifier: "unwindToDesign", sender: self)
//        }
        }
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    
//    private func selectFromPhoto(){
//
//        PHPhotoLibrary.requestAuthorization {[unowned self] (status) -> Void in
//            DispatchQueue.main.async {
//                switch status {
//                case .authorized:
//                    self.showLocalPhotoGallery()
//                    break
//                default:
//                    self.showNoPermissionDailog()
//                    break
//                }
//            }
//        }
//    }
//    
//    private func showLocalPhotoGallery(){
//        KiClipperHelper.sharedInstance.nav = self.navigationController
//        KiClipperHelper.sharedInstance.clippedImgSize = CGSize(width: 320, height: 390)
//        KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
//            self?.customImage = img
//            self?.performSegue(withIdentifier: "unwindToDesign", sender: self)
//        }
//        KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary) //直接打开相册选取图片
//    }
//    
//    
//    /**
//     * 用户相册未授权，Dialog提示
//     */
//    private func showNoPermissionDailog(){
//        let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限", preferredStyle: .alert)
//        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
////    /**
////     * 打开本地相册列表
////     */
////    private func showLocalPhotoGallery(){
//////        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//////            //初始化图片控制器
//////            let picker = UIImagePickerController()
//////            //设置代理
//////            picker.delegate = self
//////            //指定图片控制器类型
//////            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
//////            //设置是否允许编辑
//////            picker.allowsEditing = true
//////            //弹出控制器，显示界面
//////            self.present(picker, animated: true, completion: {
//////                () -> Void in
//////            })
//////        }else{
//////            print("读取相册错误")
//////        }
////    }
//    

    
}
