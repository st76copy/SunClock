//
//  CalcGps.m
//  ZPreTest
//
//  Created by 渡辺 隆彦 on 11/01/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalcGps.h"


@implementation CalcGps

@synthesize gLatitude;
@synthesize gLongitude;
@synthesize gAltitude;

- (id)init:(CalcAction *)mParent {
    if (self = [super init]) {
//		NSLog(@"CREATE CalcGps CLASS.");
		gParent = mParent;
		
		gLocationManager = [[CLLocationManager alloc] init];
		
		gLatitude = 0.0;
		gLongitude = 0.0;
		gAltitude = 0.0;
    }
	
    return self;
}

// GET GPS -------------------------------------------- //
- (BOOL)getGps {
	// LOCATION MANAGER
	if (gLocationManager) {
		gLocationManager.delegate = self;
		[gLocationManager startUpdatingLocation];
		
		return YES;
	} else {
		return NO;
	}

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	// CLLocationCoordinate2D coordinate = newLocation.coordinate;
	
	gLatitude = newLocation.coordinate.latitude;
	gLongitude = newLocation.coordinate.longitude;
	gAltitude = newLocation.altitude;
	
//	NSLog(@"COME GPS.");
	
	[gLocationManager stopUpdatingLocation];
	
	[gParent tellStart:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//	NSLog(@"NOT COME GPS.");
	[gLocationManager stopUpdatingLocation];
	
	[gParent tellStart:NO];
}

- (void)dealloc {
	[gLocationManager release];
    
	[super dealloc];
}


@end
