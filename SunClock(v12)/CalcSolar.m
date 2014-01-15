//
//  CalcSolar.m
//  ZPreTest
//
//  Created by 渡辺 隆彦 on 11/01/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalcSolar.h"


@implementation CalcSolar

@synthesize gSunRiseH;
@synthesize gSunRiseM;
@synthesize gSunSetH;
@synthesize gSunSetM;

- (id)init {
    if (self = [super init]) {
//		NSLog(@"CREATE CalcSolar CLASS.");
//		gSunRiseFlag = NO;								// V1.1:BUG FIX
//		gSunSetFlag = NO;								// V1.1:BUG FIX
		gSunRiseH = 6;
		gSunRiseM = 0;
		gSunSetH = 18;
		gSunSetM = 0;
    }
	
    return self;
}

// COMMON
- (double)sind:(double)d {
	return sin(d * M_PI / 180.0);
}
- (double)cosd:(double)d {
	return cos(d * M_PI / 180.0);
}
- (double)tand:(double)d {
	return tan(d * M_PI / 180.0);
}

// MAIN
- (double)sa:(double)alt solarPos2:(double)ds {
	double s = 0.266994444 / ds;
	double r = 0.585555555;
	double k = [self eandp:alt solarPos2:ds] - s - r;
	
	return k;
}
- (double)eandp:(double)alt solarPos2:(double)ds {
	double e = 0.035333333 * sqrt(alt);
	double p = 0.002442818 / ds;
	
	return p - e;
}
- (double)sodr:(double)la sideRealHour:(double)th solarPos3:(double)al solarPos4:(double)dl {
	double t = th - al;
	double dc = - [self cosd:dl] * [self sind:t];
	double dm = [self sind:dl] * [self sind:la] - [self cosd:dl] * [self cosd:la] * [self cosd:(t)];
	double dr = 0.0;
	if (dm == 0.0) {
		double st = [self sind:t];
		if (st > 0.0) {
			dr = -90.0;
		}
		if (st == 0.0) {
			dr = 9999.0;
		}
		if (st < 0.0) {
			dr = 90.0;
		}
	} else {
		dr = atan(dc / dm) * 180.0 / M_PI;
		if (dm < 0.0) {
			dr += 180.0;
		}
	}
	if (dr < 0.0) {
		dr += 360.0;
	}
	
	return dr;
}
- (double)soal:(double)la sideRealHour:(double)th solarPos3:(double)al solarPos4:(double)dl {
	double h = [self sind:dl] * [self sind:la] + [self cosd:dl] * [self cosd:la] * [self cosd:(th - al)];
	h = asin(h) * 180.0 / M_PI;
	
	return h;
}
- (double)spdl:(double)t {
	double ls = [self spls:t];
	double eq = 23.439291 - 0.000130042 * t;
	double dl = asin([self sind:ls] * [self sind:eq]) * 180.0 / M_PI;
	
	return dl;
}
- (double)spal:(double)t {
	double ls = [self spls:t];
	double eq = 23.439291 - 0.000130042 * t;
	double al = atan([self tand:ls] * [self cosd:eq]) * 180.0 / M_PI;
	if ((ls >= 0.0)&&(ls < 180.0)) {
		while (al < 0.0) {
			al += 180.0;
		}
		while (al >= 180.0) {
			al -= 180.0;
		}
	} else {
		while (al < 180.0) {
			al += 180.0;
		}
		while (al >= 360.0) {
			al -= 180.0;
		}
	}
	
	return al;
}
- (double)spls:(double)t {
	double l = 280.4603 + 360.00769 * t
	+ (1.9146 - 0.00005 * t) * [self sind:(357.538 + 359.991 * t)]
	+ 0.0200 * [self sind:(355.05 +  719.981 * t)]
	+ 0.0048 * [self sind:(234.95 +   19.341 * t)]
	+ 0.0020 * [self sind:(247.1  +  329.640 * t)]
	+ 0.0018 * [self sind:(297.8  + 4452.67  * t)]
	+ 0.0018 * [self sind:(251.3  +    0.20  * t)]
	+ 0.0015 * [self sind:(343.2  +  450.37  * t)]
	+ 0.0013 * [self sind:( 81.4  +  225.18  * t)]
	+ 0.0008 * [self sind:(132.5  +  659.29  * t)]
	+ 0.0007 * [self sind:(153.3  +   90.38  * t)]
	+ 0.0007 * [self sind:(206.8  +   30.35  * t)]
	+ 0.0006 * [self sind:( 29.8  +  337.18  * t)]
	+ 0.0005 * [self sind:(207.4  +    1.50  * t)]
	+ 0.0005 * [self sind:(291.2  +   22.81  * t)]
	+ 0.0004 * [self sind:(234.9  +  315.56  * t)]
	+ 0.0004 * [self sind:(157.3  +  299.30  * t)]
	+ 0.0004 * [self sind:( 21.1  +  720.02  * t)]
	+ 0.0003 * [self sind:(352.5  + 1079.97  * t)]
	+ 0.0003 * [self sind:(329.7  +   44.43  * t)];
	while (l >= 360.0) {
		l -= 360.0;
	}
	while (l < 0.0) {
		l += 360.0;
	}
	return l;
}
- (double)spds:(double)t {
	double r = (0.007256 - 0.0000002 * t) * [self sind:(267.54 + 359.991 * t)]
	+ 0.000091 * [self sind:(265.1 +  719.98 * t)]
	+ 0.000030 * [self sind:( 90.0)]
	+ 0.000013 * [self sind:( 27.8  +  4452.67 * t)]
	+ 0.000007 * [self sind:(254.0  +   450.4  * t)]
	+ 0.000007 * [self sind:(156.0  +   329.6  * t)];
	r = pow(10.0, r);
	
	return r;
}
- (double)sh:(double)t hour:(int)h minute:(int)m second:(int)s lon:(double)l dif:(int)i {
	double d = ((s / 60.0 + m) / 60.0 + h) / 24.0;
	double th = 100.4606 + 360.007700536 * t + 0.00000003879 * t * t - 15.0 * i;
	th += l + 360.0 * d;
	while (th >= 360.0) {
		th -= 360.0;
	}
	while (th < 0.0) {
		th += 360.0;
	}
	return th;
}
- (double)jy:(int)yy month:(int)mm day:(int)dd hour:(int)h minute:(int)m second:(int)s dif:(int)i {
	yy -= 2000;
	if (mm <= 2) {
		mm += 12;
		yy--;
	}
	
	double k = 365.0 * yy + 30.0 * mm + dd - 33.5 - i / 24.0 + floor(3 * (mm + 1) / 5)
	+ floor(yy / 4) - floor(yy / 100) + floor(yy / 400);
	
	k += ((s / 60.0 + m) / 60.0 + h) / 24.0;
	k += (65.0 + yy) / 86400.0;
	
	return k / 365.25;
}

- (BOOL)calc:(double)fLat lon:(double)fLon alt:(double)fAlt year:(int)iYear month:(int)iMonth day:(int)iDay dif:(int)iDif {
	BOOL  gSunRiseFlag = NO;							// V1.1:BUG FIX
	BOOL  gSunSetFlag = NO;								// V1.1:BUG FIX
	
	int yy = iYear;
	int mm = iMonth;
	int dd = iDay;
	int i = iDif;										// TIME DIFFERENCE
														//
	double la = fLat;									// LATITUDE
	double lo = fLon;									// LONGITUDE
	double alt = fAlt;									// SEA LEVEL
	
	double t = [self jy:yy month:mm day:dd - 1 hour:23 minute:59 second:0 dif:i];
	double th = [self sh:t hour:23 minute:59 second:0 lon:lo dif:i];
	double ds = [self spds:t];
	double ls = [self spls:t];
	double alp = [self spal:t];
	double dlt = [self spdl:t];
	double pht = [self soal:la sideRealHour:th solarPos3:alp solarPos4:dlt];
	double pdr = [self sodr:la sideRealHour:th solarPos3:alp solarPos4:dlt];
	
	for (int hh = 0; hh < 24; hh++) {
		for (int m = 0; m < 60; m++) {
			t = [self jy:yy month:mm day:dd hour:hh minute:m second:0 dif:i];
			th = [self sh:t hour:hh minute:m second:0 lon:lo dif:i];
			ds = [self spds:t];
			ls = [self spls:t];
			alp = [self spal:t];
			dlt = [self spdl:t];
			double ht = [self soal:la sideRealHour:th solarPos3:alp solarPos4:dlt];
			double dr = [self sodr:la sideRealHour:th solarPos3:alp solarPos4:dlt];
			double tt = [self eandp:alt solarPos2:ds];
			double t1 = tt - 18.0;
			double t2 = tt - 12.0;
			double t3 = tt - 6.0;
			double t4 = [self sa:alt solarPos2:ds];
			
			if ((pht < t4) && (ht > t4)) {
				gSunRiseFlag = YES;
				gSunRiseH = hh;
				gSunRiseM = m;
			}
			if ((pht > t4) && (ht < t4)) {
				gSunSetFlag = YES;
				gSunSetH = hh;
				gSunSetM = m;
			}
			pht = ht;
			pdr = dr;
			if (gSunRiseFlag && gSunSetFlag) {
				return YES;
			}
		}
	}
	
	return NO;
}
- (BOOL)testFunc:(float)fLat {
	for (int hh = 0; hh < 24; hh++) {
		for (int m = 0; m < 60; m++) {
			if (m > 10) {
				return YES;
			}
		}
	}
	return YES;
}

@end
