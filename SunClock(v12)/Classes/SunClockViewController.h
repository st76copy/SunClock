//
//  SunClockViewController.h
//  SunClock
//
//  Created by 渡辺 隆彦 on 11/02/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

// CALC ACTION
#import "CalcAction.h"
@class CalcAction;

/** Config */
#import "Config.h"

@interface SunClockViewController : UIViewController {
	// CALC ACTION
	CalcAction *currentAction;
	
	// UI
	IBOutlet UIImageView *Sun;
	IBOutlet UIImageView *Hand;
	IBOutlet UIImageView *secondHand;
	IBOutlet UILabel	*displayTime;					// FINE HOUR
	IBOutlet UILabel	*dispSunRise;
	IBOutlet UILabel	*dispSunSet;
	IBOutlet UIImageView *graduatedPanel;
	IBOutlet UIImageView *blackPanel;
	IBOutlet UIImageView *iconPanel;
	
	// VAL
	BOOL gDayFlag;
	float gSunRise;
	float gSunSet;
	float gDayRPH;
	float gNightRPH;
	float gSecondRPH;
	
	BOOL gShowFlag;
	SystemSoundID		clearSoundID;
	
	int gHour;
	int gMin;
	int gSec;
	float gFineHour;
	
	BOOL requestSRS;
	
	// Event ------------------------------------------ //
	BOOL touchDown;
	float reserveXpos;
	float reserveYpos;
}

// INIT ----------------------------------------------- //
- (void)setFineHour;
- (BOOL)checkDayFlag;
- (void)preSet:(BOOL)dayFlag;
- (void)calkRPH:(float)sunRise SunSet:(float)sunSet;
- (void)setDegital;
- (void)preDriveClock;
- (void)activateAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)preMoveTrans:(float)rad;

// XML READ END --------------------------------------- //
- (void)tellStart;
- (void)setIdleTimerDisabled:(BOOL)flag;
- (void)startRequestSunRiseSet;
- (void)stopRequestSunRiseSet;

// TIMER ---------------------------------------------- //
- (void)driveClock:(NSTimer *)timer;
- (void)moveTrans:(float)rad;
- (void)showDegital;

// EVENT ---------------------------------------------- //
- (BOOL)isTouchDown;
- (IBAction)touchDown:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)moveHand:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)touchUp:(UIButton *)sender forEvent:(UIEvent *)event;

@end

