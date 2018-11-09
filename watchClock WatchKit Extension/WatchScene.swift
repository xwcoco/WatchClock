//
//  WatchScene.swift
//  watchClock WatchKit Extension
//
//  Created by 徐卫 on 2018/11/9.
//  Copyright © 2018 徐卫. All rights reserved.
//

import Foundation
import SpriteKit

class  WatchScene : SKScene,SKSceneDelegate {
    public func initVars() -> Void {
        self.refreshWatch();
        self.delegate = self
    }
    
    var currentWatch : WatchInfo?
    
    func LoadWatch() -> WatchInfo {
        let watch = WatchInfo()

        let totalWatch : Int = UserDefaults.standard.integer(forKey: "TotalWatchNum");
        if (totalWatch == 0) {
            return watch
        }
        watch.TotalNum = totalWatch
        
        let watchIndex : Int = UserDefaults.standard.integer(forKey: "CurrentWatch")
        let key : String = "Watch"+String(watchIndex)
        let watchStr : String = UserDefaults.standard.string(forKey: key) ?? ""
        if (watchStr == "") {
            return watch
        }
        let attrs = watchStr.components(separatedBy: ",")
        watch.faceIndex = Int(attrs[0]) ?? watch.faceIndex
        watch.LogoIndex = Int(attrs[1]) ?? watch.LogoIndex
        
        watch.index = watchIndex
        
        return watch
    }
    
    func refreshWatch() -> Void {
        self.currentWatch = self.LoadWatch()
        if (self.currentWatch == nil) {
            return
        }
        
        let existingMarkings: SKNode?
        
        existingMarkings = self.childNode(withName: "Markings")
        
        let existingDualMaskMarkings: SKNode? = self.childNode(withName: "Markings Alternate")
        
        existingMarkings?.removeAllChildren()
        existingMarkings?.removeFromParent()
        
        existingDualMaskMarkings?.removeAllChildren()
        existingDualMaskMarkings?.removeFromParent()
        
        self.setupClock()
        self.setupScene()
//
//        if (self.useMasking) {
//            self.setupMasking()
//        }

    }
    
    var backgroundTexture : SKTexture?
    var hoursHandTexture : SKTexture?
    var minutesHandTexture : SKTexture?
    var secondsHandTexture : SKTexture?
    
    var colorRegionColor : SKColor = SKColor.black
    var faceBackgroundColor : SKColor = SKColor.black
    var majorMarkColor : SKColor = SKColor.init(white: 1, alpha: 0.8)
    var minorMarkColor : SKColor = SKColor.black.withAlphaComponent(1)
    var inlayColor : SKColor = SKColor.black
    var handColor : SKColor = SKColor.white
    var textColor : SKColor = SKColor.white.withAlphaComponent(1)
    var secondHandColor : SKColor = SKColor.init(white: 0.9, alpha: 1)
    
    var alternateMajorMarkColor : SKColor = SKColor.white.withAlphaComponent(1)
    var alternateMinorMarkColor : SKColor = SKColor.black.withAlphaComponent(0.5)
    var alternateTextColor : SKColor = SKColor.init(white: 1, alpha: 0.8)

    var hoursAnchorFromBottom : CGFloat = 18
    var minutesAnchorFromBottom : CGFloat = 0
    var secondsAnchorFromBottom : CGFloat = 0
    
    var useProgrammaticLayout : Bool = false
    
     var faceSize : CGSize = CGSize(width: 184, height: 224)
    
    var numeralStyle : NumeralStyle = NumeralStyle.NumeralStyleNone
    
    var tickmarkStyle : TickmarkStyle = TickmarkStyle.TickmarkStyleNone
    
    var showDate : Bool = true

    
    func setupClock() -> Void {
        let backgroundImageName = GFaceNameList[currentWatch?.faceIndex ?? 0]
        backgroundTexture = SKTexture.init(imageNamed: backgroundImageName)
        
        let hoursImageName = GHourImageList[currentWatch?.hourIndex ?? 0]
        self.hoursHandTexture = SKTexture.init(imageNamed: hoursImageName)
        
        let minuteImageName = GMinuteImageList[currentWatch?.minuteIndex ?? 0]
        minutesHandTexture = SKTexture.init(imageNamed: minuteImageName)
        
        minutesAnchorFromBottom = GMinutesAnchorFromBottoms[currentWatch?.minuteIndex ?? 0]
        
        if ((currentWatch?.secondIndex)! > 0) {
            let secondImageName = GSecondImageList[currentWatch?.secondIndex ?? 0]
            secondsHandTexture = SKTexture.init(imageNamed: secondImageName)
            secondsAnchorFromBottom = GSecondsAnchorFromBottoms[currentWatch?.secondIndex ?? 0]
        } else {
            secondsHandTexture = nil
        }
        
        
        
    }
    
    
    func setupScene() -> Void {
        let face : SKNode? = self.childNode(withName: "Face")
        
        let hourHand : SKSpriteNode? = face?.childNode(withName: "Hours") as? SKSpriteNode
        
        let minuteHand : SKSpriteNode? = face?.childNode(withName: "Minutes") as? SKSpriteNode
        
        let hourHandInlay : SKSpriteNode? = hourHand?.childNode(withName: "Hours Inlay") as? SKSpriteNode
        
        let minuteHandInlay : SKSpriteNode? = minuteHand?.childNode(withName: "Minutes Inlay") as? SKSpriteNode
        
        let secondHand : SKSpriteNode? = face?.childNode(withName: "Seconds") as? SKSpriteNode
        
        let colorRegion : SKSpriteNode? = face?.childNode(withName: "Color Region") as? SKSpriteNode
        
        let colorRegionReflection : SKSpriteNode? = face?.childNode(withName: "Color Region Reflection") as? SKSpriteNode
        
        let numbers : SKSpriteNode? = face?.childNode(withName: "Numbers") as? SKSpriteNode
        
        hourHand?.color = self.handColor
        hourHand?.colorBlendFactor = 1.0
        hourHand?.texture = self.hoursHandTexture
        hourHand?.size = hourHand?.texture?.size() ?? CGSize(width: 0, height: 0)
        hourHand?.anchorPoint = CGPoint(x: 0.5, y: hoursAnchorFromBottom / hourHand!.size.height)
//
        minuteHand?.color = self.handColor
        minuteHand?.colorBlendFactor = 1.0
        minuteHand?.texture = self.minutesHandTexture
        minuteHand?.size = minuteHand!.texture!.size()
        minuteHand!.anchorPoint = CGPoint(x: 0.5,y: minutesAnchorFromBottom / minuteHand!.size.height)
//
        secondHand?.color = self.secondHandColor
        secondHand?.colorBlendFactor = 1.0
        secondHand?.texture = self.secondsHandTexture
        secondHand?.size = secondHand?.texture?.size() ?? CGSize(width: 0, height: 0)
        secondHand!.anchorPoint = CGPoint(x: 0.5, y: secondsAnchorFromBottom / secondHand!.size.height)
//
        self.backgroundColor = self.faceBackgroundColor
//
        colorRegion?.color = self.colorRegionColor
        colorRegion?.colorBlendFactor = 1.0
//
        numbers?.color = self.textColor
//
        numbers?.colorBlendFactor = 1.0
        numbers?.texture = self.backgroundTexture
        numbers?.size = numbers!.texture!.size()

        hourHandInlay?.color = self.inlayColor
        minuteHandInlay?.color = self.inlayColor


        hourHandInlay?.colorBlendFactor = 1.0


        minuteHandInlay?.colorBlendFactor = 1.0

        let numbersLayer : SKSpriteNode? =  face?.childNode(withName: "Numbers") as? SKSpriteNode

        if (useProgrammaticLayout) {
            numbersLayer?.alpha = 0;

            if ((currentWatch?.useRoundFace)!) {
                self.setupTickmarksForRoundFaceWithLayerName("Markings")
            } else {
                setupTickmarksForRectangularFaceWithLayerName("Markings")
            }
        } else {
            numbersLayer?.alpha = 1;
        }

        colorRegionReflection?.alpha = 0;
        
    }
    
    func setupTickmarksForRoundFaceWithLayerName(_ layerName : String) -> Void {
        let margin : CGFloat = 4.0;
        let labelMargin : CGFloat = 26.0;
        
        let faceMarkings : SKCropNode  = SKCropNode()
        
        //        self.addChild(faceMarkings)
        
        faceMarkings.name = layerName;
        
        /* Hardcoded for 44mm Apple Watch */
        
        for i in 0...12 {
            
            //        for var i : Int = 0; i < 12; i++ {
            let angle : CGFloat = -(2 * CGFloat.pi) / 12.0 * CGFloat(i)
            let workingRadius : CGFloat  = self.faceSize.width / 2
            let longTickHeight : CGFloat  = workingRadius / 15
            
            let tick : SKSpriteNode  = SKSpriteNode(color: majorMarkColor, size: CGSize(width: 2, height: longTickHeight))
            
            tick.position = CGPoint(x: 0, y: 0)
            tick.anchorPoint = CGPoint(x: 0.5, y: (workingRadius-margin)/longTickHeight)
            tick.zRotation = angle
            
            if (self.tickmarkStyle == TickmarkStyle.TickmarkStyleAll || self.tickmarkStyle == TickmarkStyle.TickmarkStyleMajor) {
                faceMarkings.addChild(tick)
            }
            
            let h : CGFloat = 25
            
            var tmpStr : String = ""
            
            if (i == 0) {
                tmpStr = "12"
            } else {
                tmpStr = String(format: "%i", arguments: [i])
            }
            
            
            
            let labelText : NSAttributedString = NSAttributedString(string: tmpStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: h, weight: UIFont.Weight.medium),NSAttributedString.Key.foregroundColor: self.textColor])
            
            let numberLabel : SKLabelNode  = SKLabelNode(attributedText: labelText)
            numberLabel.position = CGPoint(x: (workingRadius-labelMargin) * -sin(angle), y: (workingRadius-labelMargin) * cos(angle) - 9);
            
            if (self.numeralStyle == NumeralStyle.NumeralStyleAll || ((self.numeralStyle == NumeralStyle.NumeralStyleCardinal) && (i % 3 == 0))) {
                faceMarkings.addChild(numberLabel)
            }
        }
        
        for i in 0...60 {
            //        for (int i = 0; i < 60; i++)
            let angle : CGFloat  = -(2 * CGFloat.pi) / 60.0 * CGFloat(i);
            let workingRadius :CGFloat  = self.faceSize.width/2;
            let shortTickHeight : CGFloat  = workingRadius / 20;
            let tick : SKSpriteNode = SKSpriteNode(color: self.minorMarkColor, size: CGSize(width: 1, height: shortTickHeight))
            
            tick.position = CGPoint(x: 0, y: 0);
            tick.anchorPoint = CGPoint(x : 0.5, y: (workingRadius-margin)/shortTickHeight);
            tick.zRotation = angle;
            
            if (self.tickmarkStyle == TickmarkStyle.TickmarkStyleAll || self.tickmarkStyle == TickmarkStyle.TickmarkStyleMinor)
            {
                if (i % 5 != 0) {
                    faceMarkings.addChild(tick)
                }
            }
        }
        
        if (self.showDate) {
            let calendar = NSCalendar.current
            let currentDate = Date()
            let day : Int = calendar.component(.day, from: currentDate)
            
            
            let h : CGFloat  = 24
            var numeralDelta : CGFloat = 0.0
            
            let labelText : NSAttributedString = NSAttributedString(string: String(day), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: h, weight: UIFont.Weight.light).SmallCaps(),NSAttributedString.Key.foregroundColor : alternateMajorMarkColor ])
            
            
            let numberLabel : SKLabelNode = SKLabelNode(attributedText: labelText)
            
            if (self.numeralStyle == NumeralStyle.NumeralStyleNone) {
                numeralDelta = 10.0
            }
            
            
            numberLabel.position = CGPoint(x : -10 + numeralDelta, y: -64);
            
            faceMarkings.addChild(numberLabel)
        }
        
        self.addChild(faceMarkings)
        
    }


    func setupTickmarksForRectangularFaceWithLayerName(_ layerName : String) -> Void {
        let margin : CGFloat  = 5.0
        let labelYMargin : CGFloat  = 30.0
        let labelXMargin : CGFloat  = 24.0
        
        let faceMarkings : SKCropNode = SKCropNode()
        faceMarkings.name = layerName
        
        /* Major */
        for i in 0...12 {
            let angle : CGFloat  = -(2 * CGFloat.pi) / 12.0 * CGFloat(i)
            let workingRadius : CGFloat  = workingRadiusForFaceOfSizeWithAngle(self.faceSize, angle)
            let longTickHeight : CGFloat  = workingRadius / 10.0
            
            let tick : SKSpriteNode = SKSpriteNode(color: majorMarkColor, size: CGSize(width: 2, height: longTickHeight))
            
            tick.position = CGPoint(x: 0, y: 0)
            tick.anchorPoint = CGPoint(x: 0.5, y: (workingRadius-margin)/longTickHeight)
            tick.zRotation = angle
            
            tick.zPosition = 0;
            
            if (self.tickmarkStyle == TickmarkStyle.TickmarkStyleAll || self.tickmarkStyle == TickmarkStyle.TickmarkStyleMajor) {
                faceMarkings.addChild(tick)
            }
        }
        
        /* Minor */
        for i in 0...60 {
            let angle : CGFloat  =  (2*CGFloat.pi)/60.0 * CGFloat(i)
            var workingRadius : CGFloat  = workingRadiusForFaceOfSizeWithAngle(self.faceSize, angle)
            let shortTickHeight : CGFloat  = workingRadius/20
            let tick : SKSpriteNode = SKSpriteNode(color: self.minorMarkColor, size: CGSize(width: 1, height: shortTickHeight))
            
            /* Super hacky hack to inset the tickmarks at the four corners of a curved display instead of doing math */
            if (i == 6 || i == 7  || i == 23 || i == 24 || i == 36 || i == 37 || i == 53 || i == 54)
            {
                workingRadius -= 8
            }
            
            tick.position = CGPoint(x: 0, y: 0)
            tick.anchorPoint = CGPoint(x: 0.5, y : (workingRadius-margin)/shortTickHeight)
            tick.zRotation = angle
            
            tick.zPosition = 0
            
            if (self.tickmarkStyle == TickmarkStyle.TickmarkStyleAll || self.tickmarkStyle == TickmarkStyle.TickmarkStyleMinor)
            {
                if (i % 5 != 0)
                {
                    faceMarkings.addChild(tick)
                }
            }
        }
        
        /* Numerals */
        
        for i in 1...12
        {
            let fontSize : CGFloat  = 25
            
            let labelNode : SKSpriteNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: fontSize, height: fontSize))
            labelNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            if (i == 1 || i == 11 || i == 12) {
                
                let tmpx : CGFloat = labelXMargin - self.faceSize.width / 2 + CGFloat(((i + 1) % 3)) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelXMargin * 2) / 6.0
                
                labelNode.position = CGPoint(x: tmpx, y: self.faceSize.height / 2 - labelYMargin)
            }
                
            else if (i == 5 || i == 6 || i == 7) {
                let tmpx : CGFloat = labelXMargin - self.faceSize.width / 2 + (2 - CGFloat(((i + 1) % 3))) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelXMargin * 2) / 6.0
                labelNode.position = CGPoint(x:tmpx ,y: -self.faceSize.height / 2 + labelYMargin)
                
            }
            else if (i == 2 || i == 3 || i == 4) {
                let tmpy : CGFloat = -(self.faceSize.width - labelXMargin * 2) / 2 + (2 - CGFloat(((i + 1) % 3))) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelYMargin * 2) / 6.0
                labelNode.position = CGPoint(x:self.faceSize.height / 2 - fontSize - labelXMargin,y: tmpy)
                
            }
            else if (i == 8 || i == 9 || i == 10) {
                let tmpy : CGFloat = -(self.faceSize.width - labelXMargin * 2) / 2 + CGFloat(((i + 1) % 3)) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelYMargin * 2) / 6.0
                labelNode.position = CGPoint(x: -self.faceSize.height / 2 + fontSize + labelXMargin,y: tmpy)
            }
            
            faceMarkings.addChild(labelNode)
            
            let tmpStr : String = String(i)
            
            let labelText : NSAttributedString = NSAttributedString(string: tmpStr, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Futura-Medium", size: fontSize / 2) ?? UIFont.systemFont(ofSize: fontSize / 2),NSAttributedString.Key.foregroundColor: self.textColor])
            
            let numberLabel : SKLabelNode  = SKLabelNode(attributedText: labelText)
            
            numberLabel.position = CGPoint(x: 0,y: -9)
            
            if (self.numeralStyle == NumeralStyle.NumeralStyleAll || ((self.numeralStyle == NumeralStyle.NumeralStyleCardinal) && (i % 3 == 0))) {
                labelNode.addChild(numberLabel)
            }
        }
        
        if (self.showDate)
        {
            
            let calendar = NSCalendar.current
            let currentDate = Date()
            let day : Int = calendar.component(.day, from: currentDate)
            
            let h : CGFloat = 30
            
            let labelText : NSAttributedString = NSAttributedString(string: String(day), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: h, weight: UIFont.Weight.medium).SmallCaps(),NSAttributedString.Key.foregroundColor : textColor])
            
            let numberLabel : SKLabelNode = SKLabelNode(attributedText: labelText)
            var numeralDelta : CGFloat = 0.0
            
            if (self.numeralStyle == NumeralStyle.NumeralStyleNone) {
                numeralDelta = 10.0
            }
            
            
            numberLabel.position = CGPoint(x: 32+numeralDelta,y: -4)
            
            faceMarkings.addChild(numberLabel)
        }
        self.addChild(faceMarkings)

    }

    func workingRadiusForFaceOfSizeWithAngle(_ faceSize : CGSize , _ angle : CGFloat ) -> CGFloat {
        let faceHeight : CGFloat  = faceSize.height
        let faceWidth : CGFloat  = faceSize.width
        
        var workingRadius : CGFloat  = 0
        
        let vx : CGFloat  = cos(angle)
        let vy : CGFloat  = sin(angle)
        
        let x1 : CGFloat  = 0
        let y1 : CGFloat  = 0
        let x2 : CGFloat  = faceHeight
        let y2 : CGFloat = faceWidth
        let px : CGFloat = faceHeight / 2
        let py : CGFloat  = faceWidth / 2
        
        var t : [CGFloat] = [0,0,0,0]
        var smallestT : CGFloat  = 1000
        
        t[0] = (x1 - px) / vx
        t[1]=(x2 - px) / vx
        t[2]=(y1 - py) / vy
        t[3]=(y2 - py) / vy
        
        for m in 0...3
            //        for (int m = 0; m < 4; m++)
        {
            let currentT : CGFloat  = t[m]
            
            if (currentT > 0 && currentT < smallestT) {
                smallestT = currentT;
            }
            
        }
        
        workingRadius = smallestT;
        
        return workingRadius;
        
    }

    func setupMasking() -> Void {
        let faceMarkings : SKCropNode? = self.childNode(withName: "Markings") as? SKCropNode
        let face : SKNode?  = self.childNode(withName: "Face")
        
        let colorRegion : SKNode? = face?.childNode(withName: "Color Region")
        let colorRegionReflection : SKNode? = face?.childNode(withName: "Color Region Reflection")
        
        faceMarkings?.maskNode = colorRegion;
        
        self.textColor = self.alternateTextColor
        self.minorMarkColor = self.alternateMinorMarkColor
        self.majorMarkColor = self.alternateMajorMarkColor
        
        
        if (currentWatch!.useRoundFace)
        {
            self.setupTickmarksForRoundFaceWithLayerName("Markings Alternate")
        }
        else
        {
            self.setupTickmarksForRectangularFaceWithLayerName("Markings Alternate")
        }
        
        let alternateFaceMarkings : SKCropNode?  =  self.childNode(withName: "Markings Alternate") as? SKCropNode
        colorRegionReflection?.alpha = 1
        alternateFaceMarkings?.maskNode = colorRegionReflection
        
    }
    
    public func update(_ currentTime: TimeInterval, for scene: SKScene) {
        self.updateHands()
    }
    
    func updateHands() -> Void {
        let calendar = NSCalendar.current
        let currentDate = Date()
        let _ : Int = calendar.component(.day, from: currentDate)
        
        let face : SKNode?  = self.childNode(withName: "Face")
        
        let hourHand : SKNode? = face?.childNode(withName: "Hours")
        let minuteHand : SKNode? = face?.childNode(withName: "Minutes")
        let secondHand : SKNode? = face?.childNode(withName: "Seconds")
        
        let colorRegion : SKNode? = face?.childNode(withName: "Color Region")
        let colorRegionReflection : SKNode? = face?.childNode(withName: "Color Region Reflection")
        
        let hour : Int = calendar.component(.hour, from: currentDate)
        let minute : Int = calendar.component(.minute, from: currentDate)
        let second : Int = calendar.component(.second, from: currentDate)
        
        var tmpv : CGFloat = CGFloat(hour % 12) + 1.0 / 60.0 * CGFloat(minute)
        hourHand?.zRotation = -(2 * CGFloat.pi) / 12.0 * tmpv
        
        tmpv = CGFloat(minute) + 1.0 / 60.0 * CGFloat(second)
        minuteHand?.zRotation =  -(2 * CGFloat.pi) / 60.0 * tmpv
        
        let nanosecond = calendar.component(.nanosecond, from: currentDate)
        tmpv = CGFloat(second) + 1.0 / 1000000000.0 * CGFloat(nanosecond)
        secondHand?.zRotation = -(2 * CGFloat.pi) / 60 * tmpv
        
        
        tmpv = CGFloat(minute) + 1.0 / 60.0 * CGFloat(second)
        colorRegion?.zRotation =  CGFloat.pi / 2 - (2 * CGFloat.pi) / 60.0 * tmpv
        
        tmpv = CGFloat(minute) + 1.0 / 60.0 * CGFloat(second)
        colorRegionReflection?.zRotation =  CGFloat.pi / 2 - (2 * CGFloat.pi) / 60.0 * tmpv
        
    }

}
