//
//  CalcGps.h
//  ZPreTest
//
//  Created by 渡辺 隆彦 on 11/01/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "CalcAction.h"
@class CalcAction;

@interface CalcGps : NSObject <CLLocationManagerDelegate> {
	CalcAction *gParent;

	// LOCATION MANAGER
	CLLocationManager *gLocationManager;
	
	double gLatitude;
	double gLongitude;
	double gAltitude;
	
}
@property (readonly)double gLatitude;
@property (readonly)double gLongitude;
@property (readonly)double gAltitude;

- (BOOL)getGps;
- (id)init:(CalcAction *)mParent;

@end
