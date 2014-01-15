//
//  SunClockAppDelegate.h
//  SunClock
//
//  Created by 渡辺 隆彦 on 11/02/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SunClockViewController;

@interface SunClockAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SunClockViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SunClockViewController *viewController;

@end

