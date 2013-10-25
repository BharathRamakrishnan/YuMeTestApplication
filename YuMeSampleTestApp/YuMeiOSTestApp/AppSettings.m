//
//  AppSettings.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "AppSettings.h"
#import "AppUtils.h"
#import "YuMeViewController.h"

#define DEFAULT_AD_SERVER_URL   @"http://shadow01.yumenetworks.com/"
#define DEFAULT_DOMAIN          @"211yCcbVJNQ"

static BOOL isModified = TRUE;
AppSettings *s;

@implementation AppSettings

@synthesize adServerURL;
@synthesize domain;
@synthesize params;
@synthesize adTimeOut;
@synthesize playTimeOut;
@synthesize diskQuto;
@synthesize isAutoSpeedDetect;
@synthesize isHighBitrate;
@synthesize isEnabledControlBar;
@synthesize isOrientationChange;
@synthesize isPrerollEnabled;
@synthesize isMidrollEnabled;
@synthesize isPostrollEnabled;
@synthesize iscachingEnabled;
@synthesize isautoPrefetchEnabled;
@synthesize isSurveyEnabled;
@synthesize useSeparateViews;
@synthesize adRectPortrait;
@synthesize adRectLandscape;
@synthesize logLevel;
@synthesize isVASTAdsEnabled;
@synthesize playTypeEnum;
@synthesize isOverrideOrientation;
@synthesize isParentViewInfo;
@synthesize isPrefetchOnAdExpired;
@synthesize isShowPartialAssets;
@synthesize isStreamingAdsEnabled;
@synthesize isTTCEnable;

- (void)initialize
{
    adServerURL     = nil;
	domain          = nil;
	params          = nil;
	adTimeOut       = nil;
	playTimeOut     = nil;
	diskQuto        = nil;
	logLevel        = nil;
    
	isAutoSpeedDetect       = NO;
	isHighBitrate           = NO;
	isOrientationChange     = NO;
	isEnabledControlBar     = NO;
	isPrerollEnabled        = NO;
	isMidrollEnabled        = NO;
	isPostrollEnabled       = NO;
	iscachingEnabled        = NO;
	isautoPrefetchEnabled   = NO;
    isVASTAdsEnabled        = NO;
    isOverrideOrientation   = NO;
    isParentViewInfo        = NO;
    isPrefetchOnAdExpired   = NO;
	useSeparateViews        = NO;
	
	adRectPortrait  = CGRectZero;
	adRectLandscape = CGRectZero;
    
    playTypeEnum = YuMePlayTypeNone;
}

- (id)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    return self;
}

- (void)deInitialize
{
	[adServerURL release]; adServerURL = nil;
	[domain release]; domain = nil;
	[params release]; params = nil;
	[adTimeOut release]; adTimeOut = nil;
	[playTimeOut release]; playTimeOut = nil;
	[diskQuto release]; diskQuto = nil;
	[logLevel release]; logLevel = nil;
    
    if(s != nil)
        [s release]; s = nil;
}

- (void)dealloc
{
    [self deInitialize];
    [super dealloc];
}

+ (NSString *)boolToString:(BOOL)b
{
	return (b ? @"1" : @"0");
}

+ (NSString *)floatToString:(float)f
{
	return [[NSNumber numberWithFloat:f] stringValue];
}

+ (BOOL)stringToBool:(NSString *)s
{
	s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ([s isEqualToString:@"0"]) {
		return FALSE;
	}
	return TRUE;
}

+ (void)saveSettings:(AppSettings *)s
{
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:20];
    
	[d setObject:(s.adServerURL ? s.adServerURL : @"") forKey:@"adServerURL"];
	[d setObject:(s.domain ? s.domain : @"") forKey:@"domain"];
	[d setObject:(s.params ? s.params : @"") forKey:@"params"];
	[d setObject:(s.adTimeOut ? s.adTimeOut : @"") forKey:@"adTimeOut"];
	[d setObject:(s.playTimeOut ? s.playTimeOut : @"") forKey:@"playTimeOut"];
	[d setObject:(s.diskQuto ? s.diskQuto : @"") forKey:@"diskQuto"];
	[d setObject:(s.logLevel ? s.logLevel : @"") forKey:@"logLevel"];
	[d setObject:[self boolToString:s.isAutoSpeedDetect] forKey:@"isAutoSpeedDetect"];
	[d setObject:[self boolToString:s.isHighBitrate] forKey:@"isHighBitrate"];
	[d setObject:[self boolToString:s.isOrientationChange] forKey:@"isOrientationChange"];
	[d setObject:[self boolToString:s.isPrerollEnabled] forKey:@"isPrerollEnabled"];
	[d setObject:[self boolToString:s.isMidrollEnabled] forKey:@"isMidrollEnabled"];
	[d setObject:[self boolToString:s.isPostrollEnabled] forKey:@"isPostrollEnabled"];
	[d setObject:[self boolToString:s.iscachingEnabled] forKey:@"iscachingEnabled"];
	[d setObject:[self boolToString:s.isautoPrefetchEnabled] forKey:@"isautoPrefetchEnabled"];
	[d setObject:[self boolToString:s.isEnabledControlBar] forKey:@"isEnabledControlBar"];
	[d setObject:[self boolToString:s.useSeparateViews] forKey:@"useSeparateViews"];
	[d setObject:[self boolToString:s.isVASTAdsEnabled] forKey:@"isVASTAdsEnabled"];
    [d setObject:[self boolToString:s.isOverrideOrientation] forKey:@"isOverrideOrientation"];
    [d setObject:[self boolToString:s.isParentViewInfo] forKey:@"isParentViewInfo"];
    [d setObject:[self boolToString:s.isPrefetchOnAdExpired] forKey:@"isPrefetchOnAdExpired"];
    [d setObject:[self boolToString:s.isSurveyEnabled] forKey:@"isSurveyEnabled"];
    [d setObject:[self boolToString:s.isTTCEnable] forKey:@"isTTCEnable"];
    [d setObject:[self boolToString:s.isShowPartialAssets] forKey:@"isShowPartialAssets"];
    [d setObject:[self boolToString:s.isStreamingAdsEnabled] forKey:@"isStreamingAdsEnabled"];
    [d setObject:[self floatToString:s.adRectPortrait.origin.x] forKey:@"adRectPortraitX"];
	[d setObject:[self floatToString:s.adRectPortrait.origin.y] forKey:@"adRectPortraitY"];
	[d setObject:[self floatToString:s.adRectPortrait.size.width] forKey:@"adRectPortraitWidth"];
	[d setObject:[self floatToString:s.adRectPortrait.size.height] forKey:@"adRectPortraitHeight"];
	[d setObject:[self floatToString:s.adRectLandscape.origin.x] forKey:@"adRectLandscapeX"];
	[d setObject:[self floatToString:s.adRectLandscape.origin.y] forKey:@"adRectLandscapeY"];
	[d setObject:[self floatToString:s.adRectLandscape.size.width] forKey:@"adRectLandscapeWidth"];
	[d setObject:[self floatToString:s.adRectLandscape.size.height] forKey:@"adRectLandscapeHeight"];
	[d setObject:[NSNumber numberWithInteger:s.playTypeEnum] forKey:@"playTypeEnum"];
    
	[d writeToFile:[self getConfigFilePath] atomically:YES];
	isModified = YES;
    
	YuMeInterface *yumeInterface = [YuMeViewController getYuMeInterface];
    if (yumeInterface) {
        [yumeInterface yumeSetLogLevel:[s.logLevel intValue]];
    }
}

+ (AppSettings *)readSettings
{
    if (s == nil)
        s = [[AppSettings alloc] init];
    
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[self getConfigFilePath]];
	if (d != nil) {
        NSString *a = [d valueForKey:@"adServerURL"];
		if (a) {
			s.adServerURL = a;
		} else {
			s.adServerURL = DEFAULT_AD_SERVER_URL;
		}
        
		a = [d valueForKey:@"domain"];
		if (a) {
			s.domain = a;
		} else {
			s.domain = DEFAULT_DOMAIN;
		}
        
		a = [d valueForKey:@"params"];
		if (a) {
			s.params = a;
		} else {
			s.params = ([AppUtils isIPad] ? @"device=iPad" : @"device=iPhone");
		}
        
		a = [d valueForKey:@"adTimeOut"];
		if (a) {
			s.adTimeOut = a;
		} else {
			s.adTimeOut = @"8";
		}
        
		a = [d valueForKey:@"playTimeOut"];
		if (a) {
			s.playTimeOut = a;
		} else {
			s.playTimeOut = @"8";
		}
        
		a = [d valueForKey:@"isAutoSpeedDetect"];
		if (a) {
			s.isAutoSpeedDetect = [self stringToBool:a];
		} else {
			s.isAutoSpeedDetect = TRUE;
		}
		
		a = [d valueForKey:@"diskQuto"];
		if (a) {
			s.diskQuto = a;
		} else {
			s.diskQuto = @"10.0";
		}
		
		a = [d valueForKey:@"logLevel"];
		if (a) {
			s.logLevel = a;
		} else {
			s.logLevel = @"1";
		}
		
        a = [d valueForKey:@"isOverrideOrientation"];
        if (a) {
            s.isOverrideOrientation = [self stringToBool:a];
        } else {
            s.isOverrideOrientation = TRUE;
        }
        
		a = [d valueForKey:@"isHighBitrate"];
		if (a) {
			s.isHighBitrate = [self stringToBool:a];
		} else {
			s.isHighBitrate = TRUE;
		}
        
		a = [d valueForKey:@"isOrientationChange"];
		if (a) {
			s.isOrientationChange = [self stringToBool:a];
		} else {
			s.isOrientationChange = FALSE;
		}
        
		a = [d valueForKey:@"isPrerollEnabled"];
		if (a) {
			s.isPrerollEnabled = [self stringToBool:a];
		} else {
			s.isPrerollEnabled = TRUE;
		}
		
		a = [d valueForKey:@"isMidrollEnabled"];
		if (a) {
			s.isMidrollEnabled = [self stringToBool:a];
		} else {
			s.isMidrollEnabled = TRUE;
		}
		
		a = [d valueForKey:@"isPostrollEnabled"];
		if (a) {
			s.isPostrollEnabled = [self stringToBool:a];
		} else {
			s.isPostrollEnabled = TRUE;
		}
		
		a = [d valueForKey:@"iscachingEnabled"];
		if (a) {
			s.iscachingEnabled = [self stringToBool:a];
		} else {
			s.iscachingEnabled = TRUE;
		}
		
		a = [d valueForKey:@"isautoPrefetchEnabled"];
		if (a) {
			s.isautoPrefetchEnabled = [self stringToBool:a];
		} else {
			s.isautoPrefetchEnabled = TRUE;
		}
        
        a = [d valueForKey:@"isSurveyEnabled"];
		if (a) {
			s.isSurveyEnabled = [self stringToBool:a];
		} else {
			s.isSurveyEnabled = TRUE;
		}
		
        a = [d valueForKey:@"isShowPartialAssets"];
        if (a) {
            s.isShowPartialAssets = [self stringToBool:a];
        } else {
            s.isShowPartialAssets = TRUE;
        }
        
        a = [d valueForKey:@"isStreamingAdsEnabled"];
        if (a) {
            s.isStreamingAdsEnabled = [self stringToBool:a];
        } else {
            s.isStreamingAdsEnabled = TRUE;
        }
        
        a = [d valueForKey:@"isTTCEnable"];
        if (a) {
            s.isTTCEnable = [self stringToBool:a];
        } else {
            s.isTTCEnable = TRUE;
        }
		a = [d valueForKey:@"useSeparateViews"];
		if (a) {
			s.useSeparateViews = [self stringToBool:a];
		} else {
			s.useSeparateViews = TRUE;
		}

		a = [d valueForKey:@"isEnabledControlBar"];
		if (a) {
			s.isEnabledControlBar = [self stringToBool:a];
		} else {
			s.isEnabledControlBar = TRUE;
		}
		
        a = [d valueForKey:@"isVASTAdsEnabled"];
        if (a) {
            s.isVASTAdsEnabled = [self stringToBool:a];
        } else {
            s.isVASTAdsEnabled = FALSE;
        }
        
        a = [d valueForKey:@"isParentViewInfo"];
        if (a) {
            s.isParentViewInfo = [self stringToBool:a];
        } else {
            s.isParentViewInfo = FALSE;
        }
        
        a = [d valueForKey:@"isPrefetchOnAdExpired"];
        if (a) {
            s.isPrefetchOnAdExpired = [self stringToBool:a];
        } else {
            s.isPrefetchOnAdExpired = FALSE;
        }
        
        YuMePlayType aType = [[d valueForKey:@"playTypeEnum"] intValue];
		if (aType) {
			s.playTypeEnum = aType; // [Settings getPlayType: a1];
		} else {
			s.playTypeEnum = YuMePlayTypeNone;
		}
        
        float x = 0;
		a = [d valueForKey:@"adRectPortraitX"];
		if (a) {
			x = [a floatValue];
		} else {
			x = 0;
		}
        
		float y = 0;
		a = [d valueForKey:@"adRectPortraitY"];
		if (a) {
			y = [a floatValue];
		} else {
			y = 0;
		}
        
		CGSize maxValues = [AppUtils getMaxAdViewBoundsInPortrait];
		float width = 0;
		a = [d valueForKey:@"adRectPortraitWidth"];
		if (a) {
			width = [a floatValue];
		} else {
			width = maxValues.width;
		}
		
		float height = 0;
		a = [d valueForKey:@"adRectPortraitHeight"];
		if (a) {
			height = [a floatValue];
		} else {
			height = maxValues.height;
		}
		
		s.adRectPortrait = CGRectMake(x, y, width, height);
		a = [d valueForKey:@"adRectLandscapeX"];
		if (a) {
			x = [a floatValue];
		} else {
			x = 0;
		}
		
		a = [d valueForKey:@"adRectLandscapeY"];
		if (a) {
			y = [a floatValue];
		} else {
			y = 0;
		}
		
		maxValues = [AppUtils getMaxAdViewBoundsInLandscape];
		a = [d valueForKey:@"adRectLandscapeWidth"];
		if (a) {
			width = [a floatValue];
		} else {
			width = maxValues.width;
		}
		
		a = [d valueForKey:@"adRectLandscapeHeight"];
		if (a) {
			height = [a floatValue];
		} else {
			height = maxValues.height;
		}
		s.adRectLandscape = CGRectMake(x, y, width, height);
	}
	else {
		s.adServerURL = DEFAULT_AD_SERVER_URL;
		s.domain = DEFAULT_DOMAIN;
		s.params = ([AppUtils isIPad] ? @"device=iPad" : @"device=iPhone");
		s.adTimeOut = @"8";
		s.playTimeOut = @"8";
		s.diskQuto =@"10.0";
		s.logLevel =@"4";
		s.isAutoSpeedDetect = TRUE;
		s.isHighBitrate = TRUE;
		s.isOrientationChange = FALSE;
		s.isPrerollEnabled = TRUE;
		s.iscachingEnabled = TRUE;
		s.isautoPrefetchEnabled = TRUE;
		s.isMidrollEnabled = TRUE;
		s.isPostrollEnabled = TRUE;
		s.useSeparateViews = TRUE;
		s.isEnabledControlBar = TRUE;
        s.isPrefetchOnAdExpired = TRUE;
        //s.isVASTAdsEnabled = TRUE;
        s.isSurveyEnabled = TRUE;
        s.isTTCEnable = TRUE;
        s.isOverrideOrientation = TRUE; // default Settings
        s.isParentViewInfo = FALSE;
        s.isStreamingAdsEnabled = TRUE;
        s.isShowPartialAssets = FALSE;
        s.playTypeEnum = YuMePlayTypeNone;
        
		CGSize maxValues = [AppUtils getMaxAdViewBoundsInPortrait];
		s.adRectPortrait = CGRectMake(0, 0, maxValues.width, maxValues.height);
        
		maxValues = [AppUtils getMaxAdViewBoundsInLandscape];
		s.adRectLandscape = CGRectMake(0, 0, maxValues.width, maxValues.height);
    }
    
    //return [s autorelease];
    return s;
}

+ (NSString *)getConfigFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		NSLog(@"Documents directory not found!");
		return nil;
	}
	return [documentsDirectory stringByAppendingPathComponent:@"yume_config.txt"];
}

@end
