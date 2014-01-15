//
//  CalcAction.h
//  ZPreTest
//
//  Created by 渡辺 隆彦 on 11/01/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// CALC SOLAR CLASS
#import "CalcSolar.h"

// CALC GPS CLASS
#import "CalcGps.h"
@class CalcGps;

// PARENT
#import "SunClockViewController.h"
@class SunClockViewController;

@interface CalcAction : NSObject {

	// CALC SOLAR CLASS
	CalcSolar *gCalcSolar;
	
	// LOCATION MANAGER
	CalcGps *gCalcGps;
	
	// CALENDAR
	int gYear;
	int gMonth;
	int gDay;
	int gDiff;
	
	// PARENT
	SunClockViewController *gParent;
	
}
@property (assign)SunClockViewController *gParent;

- (BOOL)requestSunRiseSet;
- (void)setCalendar;
- (void)tellStart:(BOOL)flag;
- (int)getSunRizeHour;
- (int)getSunRizeMinute;
- (int)getSunSetHour;
- (int)getSunSetMinute;

@end
