//
//  SunClockViewController.m
//  SunClock
//
//  Created by 渡辺 隆彦 on 11/02/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SunClockViewController.h"

@implementation SunClockViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	/** Set font */
	dispSunRise.font = [UIFont fontWithName:@"Crystal" size:14.0];
	dispSunSet.font = [UIFont fontWithName:@"Crystal" size:14.0];
	displayTime.font = [UIFont fontWithName:@"Crystal" size:28.0];
//	displayTime.font = [UIFont fontWithName:@"SF Digital Readout" size:24.0];
//	displayTime.font = [UIFont fontWithName:@"WW Digital" size:24.0];
	
	// RPH
	gSunRise = 6.0;
	dispSunRise.text = [NSString stringWithFormat:@"%02d:%02d", 6, 0];
	gSunSet = 18.0;
	dispSunSet.text = [NSString stringWithFormat:@"%02d:%02d", 18, 0];
	gSecondRPH = M_PI * 2 / 60.0;
	gDayFlag = [self checkDayFlag];
	[self preSet:gDayFlag];
	
	[self calkRPH:gSunRise SunSet:gSunSet];
	
	// CALC ACTION
	currentAction = [[CalcAction alloc] init];			// [[CalcAction alloc] init:self];
	currentAction.gParent = self;
	
	// DEGITAL PANEL
	gShowFlag = NO;

	// SOUND
	NSString *clearPath = [[NSBundle mainBundle] pathForResource:@"Clear" ofType:@"caf"];
	NSURL *clearUrl = [NSURL fileURLWithPath:clearPath];
	AudioServicesCreateSystemSoundID((CFURLRef)clearUrl, &clearSoundID);
	
	// PRE DRIVE CLOCK
	[self preDriveClock];
	
	requestSRS = NO;
//	[self startRequestSunRiseSet];						// It is no need because it is called by [Did Become Active] later
	
	// Touch event ------------------------------------ //
	touchDown = false;
	
}

- (void)setFineHour {
	// MAKE DATE COMPONENTS FROM DATE AND CALENDAR ---- //
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents *todayComponents = [calendar components:flags fromDate:today];
	
	gHour = [todayComponents hour];
	gMin = [todayComponents minute];
	gSec = [todayComponents second];
	
	gFineHour = gHour + gMin / 60.0;					// (hour % 12) + min / 60.0;
	
}
- (BOOL)checkDayFlag {
	[self setFineHour];
	
	if ((gSunRise < gFineHour) && (gFineHour < gSunSet)) {
		return YES;
	}
	
	return NO;
}	

- (void)preSet:(BOOL)dayFlag {
	if (dayFlag) {
		Hand.transform = CGAffineTransformMakeRotation(M_PI);
		Sun.center = CGPointMake(160.0, 225.0);
	}
}

// CALK RPH
- (void)calkRPH:(float)sunRise SunSet:(float)sunSet{
	gDayRPH = M_PI / (sunSet - sunRise);
	gNightRPH = M_PI / (24.0 - (sunSet - sunRise));
}

- (void)setDegital {
	displayTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d", gHour, gMin, gSec];
	secondHand.transform = CGAffineTransformMakeRotation(gSec * gSecondRPH);
}

- (void)preDriveClock {
	[self setDegital];
	
	if (gDayFlag) {
		float dayHour = gFineHour - gSunRise;
		[self preMoveTrans:(dayHour * gDayRPH - M_PI / 2)];
	} else {
		float nightHour = gFineHour - gSunSet;
		if (nightHour < 0.0) {
			nightHour += 24.0;
		}
		[self preMoveTrans:(nightHour * gNightRPH + M_PI / 2)];
	}
}

/** Is disable the timer */
- (void)setIdleTimerDisabled:(BOOL)flag {
	/** Check settings bundle */
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	BOOL isDisable = [defaults boolForKey:@"enabled_preference"];
	
	UIApplication *application = [UIApplication sharedApplication];
	application.idleTimerDisabled = isDisable;
}
// START REQUEST SUN RISE SET
- (void)startRequestSunRiseSet {
	[self setIdleTimerDisabled:false];

	if (!requestSRS) {
		if (currentAction) {
			[currentAction requestSunRiseSet];
			requestSRS = YES;
		}
	}
}
// STOP REQUEST SUN RISE SET
- (void)stopRequestSunRiseSet {
	if (requestSRS) {
		requestSRS = NO;
	}
}

- (void)activateAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//	NSLog(@"Start timer at once.");
	// TIMER
	[NSTimer scheduledTimerWithTimeInterval:1.0
									 target:self
								   selector:@selector(driveClock:)
								   userInfo:nil
									repeats:YES];
}

- (void)preMoveTrans:(float)rad {
	double sunY = 225.0 + (-160.0 * sin(rad + M_PI * 0.50));
	if (sunY > 225.0) {
		sunY = 225.0;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(activateAnimationDidStop: finished: context:)];
	Hand.transform = CGAffineTransformMakeRotation(rad);
	Sun.center = CGPointMake(160.0, sunY);
	[UIView commitAnimations];
}

// XML READ END --------------------------------------- //
- (void)tellStart {
	int sunRizeH = [currentAction getSunRizeHour];
	int sunRizeM = [currentAction getSunRizeMinute];
	int sunSetH = [currentAction getSunSetHour];
	int sunSetM = [currentAction getSunSetMinute];
	
	gSunRise = sunRizeH + sunRizeM / 60.0;
	dispSunRise.text = [NSString stringWithFormat:@"%02d:%02d", sunRizeH, sunRizeM];
	gSunSet = sunSetH + sunSetM / 60.0;
	dispSunSet.text = [NSString stringWithFormat:@"%02d:%02d", sunSetH, sunSetM];
	
	[self calkRPH:gSunRise SunSet:gSunSet];
}

- (void)driveClock:(NSTimer *)timer {
	if ([self isTouchDown]) {
		return;
	}
	
	[self setFineHour];
	
	[self setDegital];
	
	if ((gSunRise < gFineHour) && (gFineHour < gSunSet)) {
		gDayFlag = YES;
		float dayHour = gFineHour - gSunRise;
		[self moveTrans:(dayHour * gDayRPH - M_PI / 2)];
	} else {
		gDayFlag = NO;
		float nightHour = gFineHour - gSunSet;
		if (nightHour < 0.0) {
			nightHour += 24.0;
		}
		[self moveTrans:(nightHour * gNightRPH + M_PI / 2)];
	}
}	

- (void)moveTrans:(float)rad {
	double sunY = 225.0 + (-160.0 * sin(rad + M_PI * 0.50));
	if (sunY > 225.0) {
		sunY = 225.0;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	Hand.transform = CGAffineTransformMakeRotation(rad);
	Sun.center = CGPointMake(160.0, sunY);
	[UIView commitAnimations];
}

// Touch event ---------------------------------------- //
- (BOOL)isTouchDown {
	return touchDown;
}
- (IBAction)touchUp:(UIButton *)sender forEvent:(UIEvent *)event {
	touchDown = false;

	NSSet *touches = [event touchesForView:sender];
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:sender];
	
	float dest = ((reserveXpos - touchPoint.x) * (reserveXpos - touchPoint.x) +
				  (reserveYpos - touchPoint.y) * (reserveYpos - touchPoint.y));
	 

	if (dest < TOUCH_DEST) {
		[self showDegital];
	}
}
- (IBAction)moveHand:(UIButton *)sender forEvent:(UIEvent *)event {
	NSSet *touches = [event touchesForView:sender];
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:sender];

	float rad = -atan2(325.0 - touchPoint.y, touchPoint.x - 160.0);
	[self moveTrans:rad + M_PI * 0.50];
}
- (IBAction)touchDown:(UIButton *)sender forEvent:(UIEvent *)event {
	touchDown = true;

	NSSet *touches = [event touchesForView:sender];
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:sender];
	
	reserveXpos = touchPoint.x;
	reserveYpos = touchPoint.y;
}
- (void)showDegital {
	
	AudioServicesPlayAlertSound(clearSoundID);
	if (gShowFlag) {
		gShowFlag = NO;
		graduatedPanel.alpha = 1.0;
		dispSunRise.alpha = 1.0;
		dispSunSet.alpha = 1.0;
		displayTime.alpha = 1.0;
		secondHand.alpha = 1.0;
		blackPanel.alpha = 0.7;
		iconPanel.alpha = 0.0;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		graduatedPanel.alpha = 0.0;
		dispSunRise.alpha = 0.0;
		dispSunSet.alpha = 0.0;
		displayTime.alpha = 0.0;
		secondHand.alpha = 0.0;
		blackPanel.alpha = 0.0;
		iconPanel.alpha = 0.7;
		[UIView commitAnimations];
	}else {
		gShowFlag = YES;
		graduatedPanel.alpha = 0.0;
		dispSunRise.alpha = 0.0;
		dispSunSet.alpha = 0.0;
		displayTime.alpha = 0.0;
		secondHand.alpha = 0.0;
		blackPanel.alpha = 0.0;
		iconPanel.alpha = 0.7;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		graduatedPanel.alpha = 1.0;
		dispSunRise.alpha = 1.0;
		dispSunSet.alpha = 1.0;
		displayTime.alpha = 1.0;
		secondHand.alpha = 1.0;
		blackPanel.alpha = 0.7;
		iconPanel.alpha = 0.0;
		[UIView commitAnimations];
	}
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[currentAction release];
    
	[super dealloc];
}

@end
