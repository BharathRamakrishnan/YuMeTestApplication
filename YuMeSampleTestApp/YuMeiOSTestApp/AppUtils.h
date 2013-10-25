//
//  AppUtils.h
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppUtils : NSObject {

}

/* static functions */
+ (NSBundle *)getIPhoneBundle;
+ (NSBundle *)getIPadBundle;
+ (NSBundle *)getNSBundle;
+ (BOOL)isIPad;
+ (CGSize)getMaxAdViewBoundsInPortrait;
+ (CGSize)getMaxAdViewBoundsInLandscape;
+ (BOOL)isPortrait:(CGRect)rect;
+ (BOOL)isViewControllerPortrait:(UIViewController *)vc;
+ (void)displayToast:(UIViewController *)vc toastMsg:(NSString *)toastMsg;
+ (void)displayToast:(NSString *)toastMsg;
+ (NSString *)getErrDesc:(NSError *)pError;
+ (CGRect)getCurrentScreenBoundsDependOnOrientation;

@end
