//
//  WatchInfo.swift
//  watchClock
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchText {
    public var enabled: Bool = true
    public var backImageIndex: Int = 1
    public var textContentIndex: Int = 0
    public var textColor: UIColor = UIColor.white

    public var fontName: String = ""
    public var fontSize: CGFloat = 25


    private func getText() -> String {
        let calendar = NSCalendar.current
        let currentDate = Date()
        switch textContentIndex {
        case 0:
            let day: Int = calendar.component(.day, from: currentDate)
            return String(day)

        case 1:
            let weekday = calendar.component(.weekday, from: currentDate)

            if (WeekStyle == 0) {
                return WeekStyle1[weekday - 1]
            }
            if (WeekStyle == 1) {
                return WeekStyle2[weekday - 1]
            }
            return WeekStyle3[weekday - 1]
        default:
            return "15"
        }
    }

    public func toImage() -> UIImage? {
        if (!self.enabled) {
            return UIImage.init(named: "none")
        }

        var img: UIImage?

        var size: CGSize?

        if (backImageIndex > 0) {
            img = UIImage.init(named: GInfoBackgroud[backImageIndex])
            size = img?.size ?? nil
//            img?.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }

        let text = NSString(string: self.getText())

        var font: UIFont

        if (self.fontName == "") {
            font = UIFont.systemFont(ofSize: self.fontSize)
        } else {
            font = UIFont.init(name: self.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }

        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: text_style, NSAttributedString.Key.foregroundColor: textColor]

        if (size == nil) {
            let rect = text.boundingRect(with: CGSize(width: 500, height: 500), options: [], attributes: attributes, context: nil)
            print("font rect is ", rect)
            size = CGSize(width: rect.width, height: rect.height)
        }

        UIGraphicsBeginImageContext(size!)

        let context = UIGraphicsGetCurrentContext()

        if (backImageIndex > 0) {
            img?.draw(in: CGRect(origin: CGPoint.zero, size: size!))
        } else {
            context?.setFillColor(UIColor.clear.cgColor)
            context?.fill(CGRect.init(x: 0, y: 0, width: size!.width, height: size!.height))
        }


        //vertically center (depending on font)
        let text_h = font.lineHeight
        let text_y = (size!.height - text_h) / 2
        let text_rect = CGRect(x: 0, y: text_y, width: size!.width, height: text_h)
        text.draw(in: text_rect.integral, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class WatchInfo {
    public var faceIndex: Int = 0
    public var LogoIndex: Int = 1
    public var hourIndex: Int = 0
    public var minuteIndex: Int = 0
    public var secondIndex: Int = 2

    public var useRoundFace: Bool = true

    public var bottomText: WatchText = WatchText()
    public var leftText: WatchText = WatchText()
    public var rightText: WatchText = WatchText()


    public var TotalNum: Int = 0
    public var index: Int = 0

    required init() {
        leftText.enabled = false
        rightText.enabled = false
    }



//    public func isCustomFace() -> Bool {
//        if (faceIndex == GFaceNameList.count - 1) {
//            return true
//        }
//        return false
//    }
//    public var faceImage : UIImage?
//
//    public func getFaceTexture() -> SKTexture {
//        if (isCustomFace()) {
//            if (faceImage != nil) {
//                return  SKTexture.init(image: faceImage!)
//            }
//            return SKTexture.init(imageNamed: GFaceNameList[0])
//
//        }
//        return SKTexture.init(imageNamed: GFaceNameList[faceIndex])
//    }

    public var numeralStyle: NumeralStyle = NumeralStyle.NumeralStyleAll

}
