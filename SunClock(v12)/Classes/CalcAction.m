//
//  CalcAction.m
//  ZPreTest
//
//  Created by 渡辺 隆彦 on 11/01/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalcAction.h"


@implementation CalcAction

@synthesize gParent;

- (id)init {
    if (self = [super init]) {
		
		// INIT --------------------------------------- //
		
		// SET CALENDAR ------------------------------- //
//		[self setCalendar];
		
		// CREATE CALC SOLAR -------------------------- //
		gCalcSolar = [[CalcSolar alloc] init];
		
		// CREATE CALC GPS ---------------------------- //
		gCalcGps = [[CalcGps alloc] init:self];

/*		if ([gCalcGps getGps]) {
			NSLog(@"OK CalcGps");
		} else {
			NSLog(@"NOT CalcGps");
		}*/
		
    }
	
    return self;
}

// REQUEST SUN RISE SET ------------------------------- //
- (BOOL)requestSunRiseSet {
	// SET CALENDAR
	[self setCalendar];
	
	if ([gCalcGps getGps]) {
		return YES;
	}
	return NO;
}

// SET CALENDAR --------------------------------------- //
- (void)setCalendar {
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
	NSDateComponents *todayComponents = [calendar components:flags fromDate:today];
	
	gYear = [todayComponents year];
	gMonth = [todayComponents month];
	gDay = [todayComponents day];
	int localHour = [todayComponents hour];
	
	// GMT
	NSTimeZone *worldZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[calendar setTimeZone:worldZone];
	NSDateComponents *worldComponents = [calendar components:flags fromDate:today];
	int worldHour = [worldComponents hour];
	
	gDiff = localHour - worldHour;
	if (gDiff < 0) {
		gDiff += 24;
	}
}

// CALC GPS END --------------------------------------- //
- (void)tellStart:(BOOL)flag {
	if (flag) {
		double tLat = gCalcGps.gLatitude;				//Tokyo: 35.6544
		double tLon = gCalcGps.gLongitude;				//Tokyo: 139.7447
		double tAlt = gCalcGps.gAltitude;

		BOOL iRet = [gCalcSolar calc:tLat lon:tLon alt:tAlt year:gYear month:gMonth day:gDay dif:gDiff];	// Prod
		if (iRet) {
			[gParent tellStart];
		}
		
	}
}

// FUNCTION ------------------------------------------- //
- (int)getSunRizeHour {
	return gCalcSolar.gSunRiseH;
}
- (int)getSunRizeMinute {
	return gCalcSolar.gSunRiseM;
}
- (int)getSunSetHour {
	return gCalcSolar.gSunSetH;
}
- (int)getSunSetMinute {
	return gCalcSolar.gSunSetM;
}

- (void)dealloc {
    [gCalcSolar release];
	[gCalcGps release];
    
	[super dealloc];
}

@end
