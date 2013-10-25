//
//  AppUtils.m
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "AppUtils.h"
#import "Toast.h"
#import "YuMeAppDelegate.h"
#import "LogViewController.h"
#import "AppSettings.h"


@implementation AppUtils

+ (NSBundle *)getIPhoneBundle
{
	NSString *s = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], @"Resources-iPhone"];
	return [NSBundle bundleWithPath:s];
}

+ (NSBundle *)getIPadBundle
{
	NSString *s = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], @"Resources-iPad"];
	return [NSBundle bundleWithPath:s];
}

+ (NSBundle *)getNSBundle
{
	return [NSBundle mainBundle];
}

+ (NSBundle *)getNSBundle2
{
#ifdef __IPHONE_4_0
	return [self getIPhoneBundle];
#else
	return [self getIPadBundle];
#endif
}

+ (BOOL)isIPad {
	UIDevice *d = [UIDevice currentDevice];
	NSRange range = [d.model rangeOfString:@"ipad" options:NSCaseInsensitiveSearch];
	return (range.length > 0);
}

+ (CGSize)getMaxAdViewBoundsInPortrait
{
    CGFloat width;
    CGFloat height;
    if([UIApplication sharedApplication].statusBarHidden == NO) {
        CGRect screen = [[UIScreen mainScreen] applicationFrame];
        width = CGRectGetWidth(screen);
        height = CGRectGetHeight(screen);
        
        return CGSizeMake(width, height);
    } else {
        CGRect screen = [[UIScreen mainScreen] bounds];
        width = CGRectGetWidth(screen);
        height = CGRectGetHeight(screen);
        
        return CGSizeMake(width, height);
    }
}

+ (CGSize)getMaxAdViewBoundsInLandscape
{
    CGFloat width;
    CGFloat height;
    int statusBar = 20;
    
    if([UIApplication sharedApplication].statusBarHidden == NO) {
        CGRect screen = [[UIScreen mainScreen] applicationFrame];
        width  = CGRectGetWidth(screen);
        height = CGRectGetHeight(screen);
        height = height + statusBar;
        width  = width - statusBar;
        
        return CGSizeMake(height,width);
    } else {
        CGRect screen = [[UIScreen mainScreen] bounds];
        width  = CGRectGetWidth(screen);
        height = CGRectGetHeight(screen);
        
        return CGSizeMake( height,width);
    }
}

+ (CGRect)getCurrentScreenBoundsDependOnOrientation {
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        screenBounds.size = CGSizeMake(width, height);
    } else if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        screenBounds.size = CGSizeMake(height, width);
    }
    return screenBounds;
}

+ (BOOL)isPortrait:(CGRect)rect {
	UIDeviceOrientation currOrientation = [[UIDevice currentDevice] orientation];
	switch (currOrientation) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
			return TRUE;
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			return FALSE;
		default:
			return (rect.size.height >= rect.size.width);
	}
}


+ (BOOL)isViewControllerPortrait:(UIViewController *)vc {
	return UIInterfaceOrientationIsPortrait(vc.interfaceOrientation);
}

+ (void)displayToast:(UIViewController *)vc toastMsg:(NSString *)toastMsg {
    /* get the current view controller */
    if(vc)
    {
        Toast *tview = [[Toast alloc] initWithText:toastMsg];
        [vc.view addSubview:tview];
        [tview release]; tview = nil;
    }
    //[vc.view addSubview:[[[Toast alloc] autorelease] initWithText:toastMsg]];
}

+ (void)displayToast:(NSString *)toastMsg {
    NSLog(@"%@", toastMsg);
    [LogViewController writeLog:toastMsg];
    
    /* get the current view controller and add the toast as a subview */
    YuMeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    int colonIndex = [toastMsg rangeOfString:@": " options:NSBackwardsSearch].location;
    colonIndex = (colonIndex != NSNotFound) ? (colonIndex + 2) : 0;
    
    Toast *tView = [[Toast alloc] initWithText:[toastMsg substringFromIndex:colonIndex]];
    [((UIViewController *)appDelegate.viewController).view addSubview:tView];
    [tView release]; tView = nil;
}


+ (NSString *)getErrDesc:(NSError *)pError {
	NSString *errStr = [[pError userInfo] valueForKey:NSLocalizedDescriptionKey];
	return [[errStr copy] autorelease];
}

@end