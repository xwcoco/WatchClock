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

class WatchInfo {
    public var faceIndex : Int = 0
    public var LogoIndex : Int = 1
    public var hourIndex : Int = 0
    public var minuteIndex : Int = 0
    public var secondIndex : Int = 2
    
    public var useRoundFace : Bool = true
    
    public var TotalNum : Int = 0
    public var index : Int = 0
    
    public func isCustomFace() -> Bool {
        if (faceIndex == GFaceNameList.count - 1) {
            return true
        }
        return false
    }
    public var faceImage : UIImage?
    
    public func getFaceTexture() -> SKTexture {
        if (isCustomFace()) {
            if (faceImage != nil) {
                return  SKTexture.init(image: faceImage!)
            }
            return SKTexture.init(imageNamed: GFaceNameList[0])
            
        }
        return SKTexture.init(imageNamed: GFaceNameList[faceIndex])
    }
    
    public var numeralStyle : NumeralStyle = NumeralStyle.NumeralStyleAll
    
}
