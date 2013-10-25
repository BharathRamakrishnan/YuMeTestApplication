//
//  AppSettings.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YuMeTypes.h"

@interface AppSettings : NSObject
{
    NSString *adServerURL;
	NSString *domain;
	NSString *params;
	NSString *adTimeOut;
	NSString *playTimeOut;
	NSString *diskQuto;
	NSString *logLevel;
    
	BOOL isAutoSpeedDetect;
	BOOL isHighBitrate;
	BOOL isOrientationChange;
	BOOL isEnabledControlBar;
	BOOL isPrerollEnabled;
	BOOL isMidrollEnabled;
	BOOL isPostrollEnabled;
	BOOL iscachingEnabled;
	BOOL isautoPrefetchEnabled;
    BOOL isVASTAdsEnabled;
    BOOL isOverrideOrientation;
    BOOL isParentViewInfo;
    BOOL isPrefetchOnAdExpired;
    BOOL isSurveyEnabled;
    BOOL isTTCEnable;
    BOOL isStreamingAdsEnabled;
    BOOL isShowPartialAssets;
 	BOOL useSeparateViews;	// Specifies whether to use same or different views for content and ad display
    
	CGRect adRectPortrait;
	CGRect adRectLandscape;
    
    YuMePlayType playTypeEnum;
}
@property (nonatomic, retain) NSString *adServerURL;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *params;
@property (nonatomic, retain) NSString *adTimeOut;
@property (nonatomic, retain) NSString *playTimeOut;
@property (nonatomic, retain) NSString *diskQuto;
@property (nonatomic, retain) NSString *logLevel;
@property (nonatomic, assign) YuMePlayType playTypeEnum;
@property (nonatomic) BOOL isAutoSpeedDetect;
@property (nonatomic) BOOL isHighBitrate;
@property (nonatomic) BOOL isOrientationChange;
@property (nonatomic) BOOL isPrerollEnabled;
@property (nonatomic) BOOL isMidrollEnabled;
@property (nonatomic) BOOL isPostrollEnabled;
@property (nonatomic) BOOL iscachingEnabled;
@property (nonatomic) BOOL isautoPrefetchEnabled;
@property (nonatomic) BOOL useSeparateViews;
@property (nonatomic) BOOL isEnabledControlBar;
@property (nonatomic) BOOL isVASTAdsEnabled;
@property (nonatomic) BOOL isOverrideOrientation;
@property (nonatomic) BOOL isParentViewInfo;
@property (nonatomic) BOOL isPrefetchOnAdExpired;
@property (nonatomic) BOOL isSurveyEnabled;
@property (nonatomic) BOOL isTTCEnable;
@property (nonatomic) BOOL isShowPartialAssets;
@property (nonatomic) BOOL isStreamingAdsEnabled;
@property (nonatomic) CGRect adRectPortrait;
@property (nonatomic) CGRect adRectLandscape;

+ (NSString *)boolToString:(BOOL)b;

+ (NSString *)floatToString:(float)f;

+ (AppSettings *)readSettings;

+ (void)saveSettings:(AppSettings *)s;

+ (BOOL)stringToBool:(NSString *)s;


@end
