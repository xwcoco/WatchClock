//
//  InterfaceController.swift
//  watchClock WatchKit Extension
//
//  Created by 徐卫 on 2018/11/8.
//  Copyright © 2018 徐卫. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController,WKCrownDelegate {

    @IBOutlet weak var scene: WKInterfaceSKScene!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let tmpscene : WatchScene = WatchScene.init(fileNamed:"FaceScene")!
        
        tmpscene.initVars()
        
        let currentDeviceSize : CGSize = WKInterfaceDevice.current().screenBounds.size

        tmpscene.camera?.xScale = (184.0/currentDeviceSize.width);
        tmpscene.camera?.yScale = (184.0/currentDeviceSize.width);
        
        scene.presentScene(tmpscene)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func didAppear() {
        let myApp = MyUIApplication()
        myApp.hideOSClock()
        
        self.crownSequencer.delegate = self
        self.crownSequencer.focus()
        
    }
    
    private var totalRotation : Double = 0
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
//        var direction : Int = 1
//        totalRotation += fabs(rotationalDelta);
//
//        if (rotationalDelta < 0) {
//            direction = -1;
//        }
//
//        if (totalRotation > (Double.pi / 4 / 2)) {
//            let tmpScene : FaceScene  = self.scene.scene as! FaceScene;
//
//            if ((tmpScene.theme.rawValue+direction > 0) && (tmpScene.theme.rawValue+direction < Theme.ThemeMAX.rawValue)) {
//                tmpScene.theme = Theme(rawValue: tmpScene.theme.rawValue + direction)!
//            }
//            else {
//                tmpScene.theme = Theme(rawValue: 0)!;
//            }
//
//            tmpScene.refreshTheme()
//
//            totalRotation = 0;
//        }
        
    }

}
