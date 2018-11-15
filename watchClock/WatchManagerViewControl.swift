//
//  WatchManagerViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/15.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchManagerViewControl: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchDesignViewControl {
            if (sender as? UIButton) != nil {
                nv.editWatchIndex = -1
            } else {
                if let cell = sender as? UITableViewCell {
                    if let index = self.tableView.indexPath(for: cell) {
                        nv.editWatchIndex = index.row
                        nv.setEditWatch(data: self.WatchList[index.row])
                    }
                    
                }
            }
        }
    }

    @IBAction func unwindToWatchManager(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let nv = sourceViewController as? WatchDesignViewControl {
            if (nv.editWatchIndex == -1) {
                let jsonData = nv.watch.toJSON()
                print(jsonData)
                self.addWatch(watchData: jsonData)
            } else {
                let jsonData = nv.watch.toJSON()
                self.WatchList[nv.editWatchIndex] = jsonData
                self.saveWatchToFile()
                self.updateWatch(index: nv.editWatchIndex)
            }
        }
        
        if let nv = sourceViewController as? SetupViewControl {
            let num = self.tableView.numberOfRows(inSection: 0)
            if (num == 0) {
                return
            }
            
            for i in 000...num - 1 {
                self.updateWatch(index: i)
            }
        }

    }
    
    private func updateWatch(index : Int) {
        if let cell = self.tableView.getCell(at: IndexPath.init(row: index, section: 0)) {
            if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                if let tmpscene = skview.scene as? WatchScene {
                    if let watch = WatchInfo.fromJSON(data: self.WatchList[index]) {
                        tmpscene.initVars(watch)
//                        tmpscene?.refreshWatch()
                    }
                    
                }
                
            }
        }
        
    }

//    private var WatchNum: Int = 0
    private var WatchList: [String] = []

    override func viewDidLoad() {
        self.loadWatchFromFiles()
    }

    func loadWatchFromFiles() {
        let watchNum = UserDefaults.standard.integer(forKey: "WatchNum")
        print("watch Num is ", watchNum)
        self.WatchList.removeAll()
        if (watchNum > 0) {
            for i in 0...watchNum - 1 {
                if let str = UserDefaults.standard.string(forKey: "WatchData" + String(i)) {
                    if (str != "") {
                        self.WatchList.append(str)
                    }
                }
            }
        }
    }

    func saveWatchToFile() {
        UserDefaults.standard.set(self.WatchList.count, forKey: "WatchNum")
        if (self.WatchList.count > 0) {
            for i in 0...WatchList.count - 1 {
                UserDefaults.standard.set(WatchList[i], forKey: "WatchData" + String(i))
            }
        }
    }

    func addWatch(watchData: String) -> Void {
        let watchNum = self.WatchList.count
        self.WatchList.append(watchData)
        UserDefaults.standard.setValue(watchData, forKey: "WatchData" + String(watchNum))
        UserDefaults.standard.setValue(self.WatchList.count, forKey: "WatchNum")
        self.tableView.insertRows(at: [IndexPath.init(row: watchNum, section: 0)], with: .automatic)
    }

    func deleteWatch(index: Int) {
        if (index < 0 || index >= self.WatchList.count) {
            return
        }

        self.WatchList.remove(at: index)
        self.saveWatchToFile()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return self.WatchList.count
        }
        if (section == 1) {
            return 2
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        }
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "watchListCell") {
                if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                    let tmpscene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!
                    if let watch = WatchInfo.fromJSON(data: self.WatchList[indexPath.row]) {
                        tmpscene.initVars(watch)
                    }
//                    tmpscene.initVars(self.watch)
                    tmpscene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                    tmpscene.camera?.yScale = 1.8 / (184.0 / skview.bounds.height)

                    skview.presentScene(tmpscene)
                }

                return cell
            }
            return UITableViewCell()
        }
        if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "setupCell")
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "Setup"
            } else {
                cell?.textLabel?.text = "About"
            }
            return cell!
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Watch List"
        }
        return "Settings"
    }
    @IBOutlet weak var EditButton: UIBarButtonItem!

    @IBOutlet weak var AddButton: UIBarButtonItem!
    @IBAction func EditButtonClick(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            self.EditButton.title = "Edit"
            self.AddButton.isEnabled = true
        } else {
            self.tableView.setEditing(true, animated: true)
            self.EditButton.title = "Done"
            self.AddButton.isEnabled = false
        }

    }


    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (indexPath.section == 0) {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (editingStyle == .delete) {
                self.deleteWatch(index: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 1) {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.performSegue(withIdentifier: "showSetup", sender: self)
            }
            if (indexPath.row == 1) {
                self.performSegue(withIdentifier: "showAbout", sender: self)
            }
        }
    }

}
