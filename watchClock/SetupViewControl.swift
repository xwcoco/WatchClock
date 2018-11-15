//
//  SetupViewControl.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/15.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit

class SetupViewControl: UITableViewController {

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            cell.accessoryType = .none
            if (indexPath.row == WatchSettings.WeekStyle) {
                cell.accessoryType = .checkmark
            }
        }
        if (indexPath.section == 2) {
            if (WatchSettings.WeatherCity == "") {
                cell.textLabel?.text = "(None)"
            } else {
                cell.textLabel?.text = WatchSettings.WeatherCity
            }
        }
        if (indexPath.section == 3) {
            for i in 0...cell.contentView.subviews.count - 1 {
                if let sw = cell.contentView.subviews[i] as? UISwitch {
                    sw.isOn = WatchSettings.WeatherDrawColorAQI
                }
            }
        }
    }

    private var weatherIconSize: CGFloat = 0 {
        didSet {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: 1))
            cell?.textLabel?.text = String.init(format: "%.0f", arguments: [weatherIconSize])
        }
    }

    override func viewDidLoad() {
        self.weatherIconSize = WatchSettings.WeatherIconSize
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            for i in 0...self.tableView.numberOfRows(inSection: 0) - 1 {
                let cell = self.tableView.getCell(at: IndexPath.init(row: i, section: 0))
                cell?.accessoryType = .none
                if (i == indexPath.row) {
                    cell?.accessoryType = .checkmark
                }

            }
            WatchSettings.WeekStyle = indexPath.row

        }
    }

    @IBAction func IconSizeSliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            self.weatherIconSize = CGFloat(slider.value)
            WatchSettings.WeatherIconSize = self.weatherIconSize
        }

    }

    @IBAction func unwindToSetup(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if let nv = sourceViewController as? WeatherLocationViewControl {
            WatchSettings.WeatherLocation = nv.Location
            WatchSettings.WeatherCity = nv.CityName
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: 2))
            cell?.textLabel?.text = nv.CityName
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func ColorAQISwitchValueChanged(_ sender: Any) {
        if let sw = sender as? UISwitch {
            WatchSettings.WeatherDrawColorAQI = sw.isOn
        }
    }
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToWatchManager", sender: self)
    }
    
}
