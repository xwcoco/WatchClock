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



enum WatchTextContent : Int,Codable {
    case WatchTextDate,WatchTextWeekDay,WatchTextWeather
}

enum WeatherTextStyle : Int,Codable {
    case WeatherTextTemp,WeatherTextType,WeatherTextAQI,WeatherTextPM25,WeatherTextPM10
}


class WatchText : Codable {
    
    public var enabled: Bool = true
    public var backImageIndex: Int = 1
    public var textContentIndex: WatchTextContent = .WatchTextWeather
    
    private var textColorHex : String = UIColor.white.toHex()
    
    public var textColor: UIColor {
        get {
            return UIColor.init(hexString: textColorHex) ?? UIColor.white
        }
        set {
            textColorHex = newValue.toHex()
        }
    }
    public var distToCenter: CGFloat = 56

    public var fontName: String = ""
    public var fontSize: CGFloat = 25
    
    public var showWeatchIcon : Bool = false
    public var weatherTextStyle : WeatherTextStyle = .WeatherTextTemp
    
    public var weatherData : CnWeatherData?
    
    private var backupText : String = ""
    
    public func needUpdate() -> Bool {
        if (!self.enabled) {
            return false
        }
        
        let newText = self.getText()
        if (newText != self.backupText) {
            return true
        }
        
        return false
    }
    
    
    public init() {
        
    }

    enum CodingKeys: String, CodingKey {
        case enabled
        case backImageIndex
        case textContentIndex
        case textColorHex
        case distToCenter
        case fontName
        case fontSize
        case showWeatchIcon
        case weatherTextStyle
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(enabled, forKey: .enabled)
//        try container.encode(backImageIndex, forKey: .backImageIndex)
//        try container.encode(textContentIndex.rawValue, forKey: .textContentIndex)
//        try container.encode(MyColor.UIColorToMyColor(textColor), forKey: .textColor)
//        try container.encode(distToCenter, forKey: .distToCenter)
//        try container.encode(fontName, forKey: .fontName)
//        try container.encode(fontSize, forKey: .fontSize)
//        try container.encode(showWeatchIcon, forKey: .showWeatchIcon)
//        try container.encode(weatherTextStyle.rawValue, forKey: .weatherTextStyle)
//    }


    private func getText() -> String {
        let calendar = NSCalendar.current
        let currentDate = Date()
        switch textContentIndex {
        case .WatchTextDate:
            let day: Int = calendar.component(.day, from: currentDate)
            return String(day)

        case .WatchTextWeekDay:
            let weekday = calendar.component(.weekday, from: currentDate)

            if (WatchSettings.WeekStyle == 0) {
                return WatchSettings.WeekStyle1[weekday - 1]
            }
            if (WatchSettings.WeekStyle == 1) {
                return WatchSettings.WeekStyle2[weekday - 1]
            }
            return WatchSettings.WeekStyle3[weekday - 1]
        default:
            if (self.weatherData != nil) {
                switch self.weatherTextStyle {
                case .WeatherTextTemp:
                    return self.weatherData!.Wendu
                case .WeatherTextType:
                    return self.weatherData!.type
                case .WeatherTextAQI:
                    return self.weatherData!.aqi
                case .WeatherTextPM25:
                    return self.weatherData!.pm25
                default:
                    return self.weatherData!.pm10
                    
                }
            }
            return "15"
        }
    }
    
    func getAQIColor(_ aqi : Float) -> UIColor {
        if (aqi < 50) {
            return UIColor.green
        }
        if (aqi < 100) {
            return UIColor.yellow
        }
        if (aqi < 200) {
            return UIColor.orange
        }
        return UIColor.red
        
    }

    public func toImage() -> UIImage? {
        if (!self.enabled) {
            return UIImage.init(named: "none")
        }

        var img: UIImage?

        var size: CGSize?

        if (backImageIndex > 0) {
            img = UIImage.init(named: WatchSettings.GInfoBackgroud[backImageIndex])
            size = img?.size ?? nil
        }
        
        var weatherImg : UIImage?
        
        if (self.showWeatchIcon && self.textContentIndex == .WatchTextWeather && self.weatherData != nil) {
            let weatherIconName = "white_" + weatherData!.getWeatherCode()
            weatherImg = UIImage.init(named: weatherIconName)
        }
        
        self.backupText = self.getText()
        let text = NSString(string: backupText)

        var font: UIFont

        if (self.fontName == "") {
            font = UIFont.systemFont(ofSize: self.fontSize)
        } else {
            font = UIFont.init(name: self.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }

        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center
        
        var tmpTextColor = textColor
        
        if (self.textContentIndex == .WatchTextWeather && (weatherData != nil)) {
            switch self.weatherTextStyle {
            case .WeatherTextAQI:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.aqi)?.floatValue ?? 0)
                break
            case .WeatherTextPM25:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.pm25)?.floatValue ?? 0)
                break
            case .WeatherTextPM10:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.pm10)?.floatValue ?? 0)
                break
            default:
                break
            }
        }
        
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: text_style, NSAttributedString.Key.foregroundColor: tmpTextColor]

        let rect = text.boundingRect(with: CGSize(width: 500, height: 500), options: [], attributes: attributes, context: nil)
        if (size == nil) {
            size = CGSize(width: rect.width, height: rect.height)
            
            if (weatherImg != nil) {
                size!.width = size!.width + WatchSettings.WeatherIconSize
                
                if (size!.height < WatchSettings.WeatherIconSize) {
                    size!.height = WatchSettings.WeatherIconSize
                }
            }
        } else if (weatherImg != nil) {
            if (size!.width < WatchSettings.WeatherIconSize + rect.width) {
                size!.width = WatchSettings.WeatherIconSize + rect.width
            }
            if (size!.height < max(WatchSettings.WeatherIconSize,rect.height)) {
                size!.height = max(WatchSettings.WeatherIconSize,rect.height)
            }
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
        var text_rect = CGRect(x: 0, y: text_y, width: size!.width, height: text_h)

        if (weatherImg != nil) {
            let tmpy = (size!.height - WatchSettings.WeatherIconSize) / 2
            let tmpx = (size!.width - WatchSettings.WeatherIconSize - rect.width) / 2
            let weatherRect = CGRect(x: tmpx, y: tmpy, width: WatchSettings.WeatherIconSize, height: WatchSettings.WeatherIconSize)
            weatherImg?.draw(in: weatherRect)
            text_rect = CGRect(x: tmpx + WatchSettings.WeatherIconSize, y: text_y, width: size!.width - WatchSettings.WeatherIconSize - 2 * tmpx, height: text_h)
        }

        text.draw(in: text_rect.integral, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

protocol WatchInfoUpdate {
    func UpdateWatchInfo() -> Void
}

class WatchInfo: Codable {
    public var faceIndex: Int = 0

    public var LogoIndex: Int = 1
    public var LogoToCenter: CGFloat = 32

    public var hourIndex: Int = 0
    public var minuteIndex: Int = 0
    public var secondIndex: Int = 2

    public var bottomText: WatchText = WatchText()
    public var leftText: WatchText = WatchText()
    public var rightText: WatchText = WatchText()
    
    public var delegate : WatchInfoUpdate?
    


    public var TotalNum: Int = 0
    public var index: Int = 0
    
    
    private var timer : Timer?

    public init() {
        leftText.enabled = false
        rightText.enabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(CheckUpdate),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    public func setWeatherData(data : CnWeatherData) {
        self.bottomText.weatherData = data
        self.leftText.weatherData = data
        self.rightText.weatherData = data
        self.delegate?.UpdateWatchInfo()
    }
    
    @objc func CheckUpdate() {
        if (self.bottomText.needUpdate() || self.rightText.needUpdate() || self.leftText.needUpdate()) {
            self.delegate?.UpdateWatchInfo()
        }
    }
    
    public var useCustomFace: Bool = true
    
    public var customFace_draw_back: Bool = false
    
    private var customFace_back_colorHex : String = UIColor.black.toHex()
    
    public var customFace_back_color: UIColor {
        get {
            return UIColor.init(hexString: customFace_back_colorHex) ?? UIColor.black
        }
        
        set {
            customFace_back_colorHex = newValue.toHex()
        }
    }
    
    public var customFace_showColorRegion: Bool = true
    
    private var customFace_ColorRegion_Color1Hex : String = UIColor.init(red: 0.067, green: 0.471, blue: 0.651, alpha: 1.000).toHex()
    
    public var customFace_ColorRegion_Color1: UIColor {
        get {
            return UIColor.init(hexString: self.customFace_ColorRegion_Color1Hex) ?? UIColor.black
        }
        set {
            self.customFace_ColorRegion_Color1Hex = newValue.toHex()
        }
    }
    
    private var customFace_ColorRegion_Color2Hex : String = UIColor.init(red: 0.118, green: 0.188, blue: 0.239, alpha: 1.000).toHex()
    public var customFace_ColorRegion_Color2: UIColor {
        get {
            return UIColor.init(hexString: self.customFace_ColorRegion_Color2Hex) ?? UIColor.black
        }
        set {
            self.customFace_ColorRegion_Color2Hex = newValue.toHex()
        }
    }
    
    private var customFace_ColorRegion_AlternateTextColorHex : String = UIColor.init(white: 1, alpha: 0.8).toHex()
    public var customFace_ColorRegion_AlternateTextColor: UIColor {
        get {
            return UIColor.init(hexString: self.customFace_ColorRegion_AlternateTextColorHex) ?? UIColor.white
        }
        set {
            self.customFace_ColorRegion_AlternateTextColorHex = newValue.toHex()
        }
    }
    
    private var customFace_ColorRegion_AlternateMajorColorHex : String = UIColor.init(red: 1.000, green: 0.506, blue: 0.000, alpha: 1.000).toHex()
    public var customFace_ColorRegion_AlternateMajorColor: UIColor  {
        get {
            return UIColor.init(hexString: customFace_ColorRegion_AlternateMajorColorHex) ?? UIColor.white
        }
        set {
            customFace_ColorRegion_AlternateMajorColorHex = newValue.toHex()
        }
    }
    
    private var customFace_ColorRegion_AlternateMinorColorHex : String = UIColor.black.withAlphaComponent(0.5).toHex()
    public var customFace_ColorRegion_AlternateMinorColor: UIColor {
        get {
            return UIColor.init(hexString: customFace_ColorRegion_AlternateMinorColorHex) ?? UIColor.black
        }
        set {
            customFace_ColorRegion_AlternateMinorColorHex = newValue.toHex()
        }
    }
    
    public var numeralStyle: NumeralStyle = NumeralStyle.NumeralStyleAll
    public var tickmarkStyle: TickmarkStyle = .TickmarkStyleAll
    public var faceStyle: WatchFaceStyle = .WatchFaceStyleRectangle
    
    public var numbers_fontName: String = ""
    public var numbers_fontSize: CGFloat = 20
    
    private var numbers_colorHex : String = UIColor.white.toHex()
    public var numbers_color: UIColor {
        get {
            return UIColor.init(hexString: numbers_colorHex) ?? UIColor.white
        }
        set {
            numbers_colorHex = newValue.toHex()
        }
    }
    
    private var tick_majorColorHex : String = UIColor.white.toHex()
    public var tick_majorColor: UIColor {
        get {
            return UIColor.init(hexString: tick_majorColorHex) ?? UIColor.white
        }
        set {
            tick_majorColorHex = newValue.toHex()
        }
    }
    
    private var tick_minorColorHex : String = UIColor.gray.toHex()
    
    public var tick_minorColor: UIColor {
        get {
            return UIColor.init(hexString: tick_minorColorHex) ?? UIColor.gray
        }
        
        set {
            tick_minorColorHex = newValue.toHex()
        }
    }


    enum CodingKeys: String, CodingKey {
        case faceIndex
        case LogoIndex
        case LogoToCenter
        case hourIndex
        case minuteIndex
        case secondIndex
        case useCustomFace
        case customFace_draw_back
        case customFace_back_colorHex
        case customFace_showColorRegion
        case customFace_ColorRegion_Color1Hex
        case customFace_ColorRegion_Color2Hex
        case customFace_ColorRegion_AlternateTextColorHex
        case customFace_ColorRegion_AlternateMajorColorHex
        case customFace_ColorRegion_AlternateMinorColorHex
        case numeralStyle
        case tickmarkStyle
        case faceStyle
        case numbers_fontName
        case numbers_fontSize
        case numbers_colorHex
        case tick_majorColorHex
        case tick_minorColorHex
        case bottomText
        case leftText
        case rightText
    }
    
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(faceIndex, forKey: .faceIndex)
//        try container.encode(LogoIndex, forKey: .LogoIndex)
//        try container.encode(LogoToCenter, forKey: .LogoToCenter)
//        try container.encode(hourIndex, forKey: .hourIndex)
//        try container.encode(minuteIndex, forKey: .minuteIndex)
//        try container.encode(secondIndex, forKey: .secondIndex)
//        try container.encode(useCustomFace, forKey: .useCustomFace)
//        try container.encode(customFace_draw_back, forKey: .customFace_draw_back)
//        try container.encode(MyColor.UIColorToMyColor(self.customFace_back_color), forKey: .customFace_back_color)
//        try container.encode(customFace_showColorRegion, forKey: .customFace_showColorRegion)
//        try container.encode(MyColor.UIColorToMyColor(customFace_ColorRegion_Color1), forKey: .customFace_ColorRegion_Color1)
//        try container.encode(MyColor.UIColorToMyColor(customFace_ColorRegion_Color2), forKey: .customFace_ColorRegion_Color2)
//        try container.encode(MyColor.UIColorToMyColor(customFace_ColorRegion_AlternateTextColor), forKey: .customFace_ColorRegion_AlternateTextColor)
//        try container.encode(MyColor.UIColorToMyColor(customFace_ColorRegion_AlternateMajorColor), forKey: .customFace_ColorRegion_AlternateMajorColor)
//        try container.encode(MyColor.UIColorToMyColor(customFace_ColorRegion_AlternateMinorColor), forKey: .customFace_ColorRegion_AlternateMinorColor)
//
//        try container.encode(self.numeralStyle.rawValue, forKey: .numeralStyle)
//        try container.encode(tickmarkStyle.rawValue, forKey: .tickmarkStyle)
//        try container.encode(faceStyle.rawValue, forKey: .faceStyle)
//
//        try container.encode(numbers_fontName, forKey: .numbers_fontName)
//        try container.encode(numbers_fontSize, forKey: .numbers_fontSize)
//        try container.encode(MyColor.UIColorToMyColor(numbers_color), forKey: .numbers_color)
//        try container.encode(MyColor.UIColorToMyColor(tick_majorColor), forKey: .tick_majorColor)
//        try container.encode(MyColor.UIColorToMyColor(tick_minorColor), forKey: .tick_minorColor)
//
//        try container.encode(bottomText, forKey: .bottomText)
//        try container.encode(leftText, forKey: .leftText)
//        try container.encode(rightText, forKey: .rightText)
//
//
//    }
//
//    required public convenience init(from decoder: Decoder) {
//        self.init()
//
//    }
//

    public func toJSON() -> String {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        catch {
            print(error)
        }
        return ""

    }
    
    public static func fromJSON(data : String) -> WatchInfo? {
        let jsonDecoder = JSONDecoder()
        if let jsonData : Data = data.data(using: .utf8) {
            do {
                let watch = try jsonDecoder.decode(WatchInfo.self, from: jsonData)
                return watch
            }
            catch {
                print(error)
            }
        }
        return nil
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


}

//struct MyColor : Codable {
//    let red, green, blue, alpha : CGFloat
//
//    static func UIColorToMyColor(_ color : UIColor) -> MyColor {
//        var red1 : CGFloat = 0.0, green1: CGFloat = 0.0, blue1: CGFloat = 0.0, alpha1: CGFloat = 0.0
//        color.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
//        return MyColor(red: red1, green: green1, blue: blue1, alpha: alpha1)
//    }
//}



extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    public func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        guard r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1 else {
            return ""
        }
        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
}
