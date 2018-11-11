//
//  WatchCustom.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import SpriteKit

var GFaceNameList : [String] = ["Hermes_watch_face_original",
                                "Hermes_watch_face_original_orange",
                                "Hermes_watch_face_classic",
                                "Hermes_watch_face_classic_orange",
                                "Hermes_watch_face_roma",
                                "Hermes_watch_face_roma_orange",
                                "Hermes_watch_face_standard",
                                "Hermes_watch_face_standard_orange",
                                "Nike_watch_face_black",
                                "Nike_watch_face_blue",
                                "Nike_watch_face_green",
                                "Nike_watch_face_greenblue",
                                "Nike_watch_face_grey",
                                "Nike_watch_face_night",
                                "Nike_watch_face_pink",
                                "Nike_watch_face_red",
                                "Rolex_watch_face_black_gold",
                                "Rolex_watch_face_black_silver",
                                "Rolex_watch_face_black_white",
                                "Rolex_watch_face_green",
                                "Rolex_watch_face_luminous",
                                "S4Numbers"]

var GHourImageList : [String] = ["Hermes_hours",
                                 "Hermes_hours_white",
                                 "HermesDoubleclour_H",
                                 "HermesDoubleclour_H_Orange",
                                 "HermesDoubleclour_H_Pink",
                                 "Nike_hours",
                                 "Nike_hours_red",
                                 "Rolex_hours_gold",
                                 "Rolex_hours_luminous",
                         
                                 "Rolex_hours_write"]

var GMinuteImageList : [String] = ["Hermes_minutes",
                                   "Hermes_minutes_white",
                                   "HermesDoubleclour_M_Orange",
                                   "HermesDoubleclour_M_Pink",
                                   "Nike_minutes",
                                   "Nike_minutes_red",
                                   "Rolex_minutes_gold",
                                   "Rolex_minutes_luminous",
                                   "Rolex_minutes_write"]

var GMinutesAnchorFromBottoms : [CGFloat] = [16,16,18,18,17,17,17,17,17]

var GSecondImageList : [String] = ["empty",
                                   "Hermes_seconds",
                                   "Hermes_seconds_orange",
                                   "Nike_seconds",
                                   "Nike_seconds_orange",
                                   "Rolex_seconds_gold",
                                   "Rolex_seconds_luminous",
                                   "Rolex_seconds_write"]

var GSecondsAnchorFromBottoms : [CGFloat] = [0,27,27,26,26,67,67,67]

var GLogoImageList : [String] = ["empty","hermes_logo_white",
                                 "hermes_logo_2",
                                 "rolex_logo_gold",
                                 "hermes_logo_white",
                                 "apple_logo_color"]

var GInfoBackgroud : [String] = ["empty",
                                 "info_back_1",
                                 "info_back_2"
]


enum NumeralStyle: Int {
    case NumeralStyleAll,NumeralStyleCardinal,NumeralStyleNone
}

enum TickmarkStyle: Int {
    case TickmarkStyleAll,TickmarkStyleMajor,TickmarkStyleMinor,TickmarkStyleNone
}

extension UIFont {
    func SmallCaps() -> UIFont {
        let settings =  [UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector]
        return UIFont.init(descriptor: UIFontDescriptor.init(fontAttributes: [UIFontDescriptor.AttributeName.featureSettings: settings,UIFontDescriptor.AttributeName.name: self.fontName]), size: self.pointSize)
    }
}

