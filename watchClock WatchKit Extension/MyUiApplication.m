//
//  MyUiApplication.m
//  watchClock WatchKit Extension
//
//  Created by 徐卫 on 2018/11/8.
//  Copyright © 2018 徐卫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyUIApplication.h"
@import ObjectiveC.runtime;
@import SpriteKit;

@interface NSObject (fs_override)
+(id)sharedApplication;
-(id)keyWindow;
-(id)rootViewController;
-(NSArray *)viewControllers;
-(id)view;
-(NSArray *)subviews;
-(id)timeLabel;
-(id)layer;
@end

@implementation MyUIApplication
-(void)hideOSClock {
    NSArray *views = [[[[[[[NSClassFromString(@"UIApplication") sharedApplication] keyWindow] rootViewController] viewControllers] firstObject] view] subviews];
    
    for (NSObject *view in views)
    {
        if ([view isKindOfClass:NSClassFromString(@"SPFullScreenView")])
            [[[view timeLabel] layer] setOpacity:0];
    }

}
@end
