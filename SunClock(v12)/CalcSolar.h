//
//  CalcSolar.h
//  ZPreTest
//
//  Created by 渡辺 隆彦 on 11/01/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  V1.1:BUG FIX

#import <Foundation/Foundation.h>


@interface CalcSolar : NSObject {

//	BOOL  gSunRiseFlag;									// V1.1:BUG FIX
//	BOOL  gSunSetFlag;									// V1.1:BUG FIX
	
	int gSunRiseH;
	int gSunRiseM;
	int gSunSetH;
	int gSunSetM;
}
@property (readonly)int gSunRiseH;
@property (readonly)int gSunRiseM;
@property (readonly)int gSunSetH;
@property (readonly)int gSunSetM;

// COMMON
- (double)sind:(double)d;
- (double)cosd:(double)d;
- (double)tand:(double)d;

// MAIN
- (double)sa:(double)alt solarPos2:(double)ds;
- (double)eandp:(double)alt solarPos2:(double)ds;
- (double)sodr:(double)la sideRealHour:(double)th solarPos3:(double)al solarPos4:(double)dl;
- (double)soal:(double)la sideRealHour:(double)th solarPos3:(double)al solarPos4:(double)dl;
- (double)spdl:(double)t;
- (double)spal:(double)t;
- (double)spls:(double)t;
- (double)spds:(double)t;
- (double)sh:(double)t hour:(int)h minute:(int)m second:(int)s lon:(double)l dif:(int)i;
- (double)jy:(int)yy month:(int)mm day:(int)dd hour:(int)h minute:(int)m second:(int)s dif:(int)i;
- (BOOL)calc:(double)fLat lon:(double)fLon alt:(double)fAlt year:(int)iYear month:(int)iMonth day:(int)iDay dif:(int)iDif;
- (BOOL)testFunc:(float)fLat;

@end
