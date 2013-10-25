//
//  YuMeInterface.m
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeInterface.h"
#import "AppUtils.h"
#import "LogViewController.h"
#import "YuMeViewController.h"
#import "VideoPlayerController.h"

@implementation YuMeInterface

@synthesize delegate;
@synthesize settings;
@synthesize adPlaying;
@synthesize currentAdStaus;

- (id)init {
    if (self = [super init]) {
        NSLog(@"Creating YuMe SDK Instance...");
        pYuMeSDK = [YuMeSDKInterface getYuMeSdkHandle];
        videoController = nil;
        bUseOwnVideoPlayer = NO;
        currentAdStaus = nil;
      }
    return self;
}

- (void)dealloc {
    
    if (pYuMeSDK)
        [pYuMeSDK release]; pYuMeSDK = nil;
    
    if (videoController)
        [videoController release]; videoController = nil;

    if(settings != nil)
        [settings release]; settings = nil;
    
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
/*   INTERFACE (YuMeAppDelegate) TO BE IMPLEMENTED BY THE PUBLISHER APPLICATION FOR USE BY YUME SDK     */
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Listener that receives various ad events from YuMe SDK.
 * Used by the SDK to notify the application that the indicated ad event has occurred.
 * @param eAdType Ad type requested by the application that the event is related to.
 * @param eAdEvent The Ad event notified to the application.
 * @param pEventInfo The Ad event info (or) nil.
 * @return None.
 */
-  (void) yumeEventListener:(YuMeAdType)eAdType adEvent:(YuMeAdEvent)eAdEvent eventInfo:(NSString *)pEventInfo {
    switch (eAdEvent) {
        case YuMeAdEventAdReady:
        {
            NSString* text = @"";
            if(eAdType == YuMeAdTypePreroll) {
                text = @"AD READY (Preroll)";
            } else if(eAdType == YuMeAdTypeMidroll) {
                text = @"AD READY (Midroll)";
            } else if(eAdType == YuMeAdTypePostroll) {
                text = @"AD READY (Postroll)";
            }
            if(![text isEqualToString:@""]) {
                //[AppUtils displayToast:text];
                 if (!kUSE_AUTOMATION)
                     [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:text waitUntilDone:NO];
            }
            currentAdStaus = @"YuMeAdEventAdReady";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdReady"];
        }
            break;
            
        case YuMeAdEventPartialAssetsReady:
        {
            NSString* text = @"";
            if(eAdType == YuMeAdTypePreroll) {
                text = @"AD & PARTIAL ASSETS READY (Preroll)";
            } else if(eAdType == YuMeAdTypeMidroll) {
                text = @"AD & PARTIAL ASSETS READY (Midroll)";
            } else if(eAdType == YuMeAdTypePostroll) {
                text = @"AD & PARTIAL ASSETS READY (Postroll)";
            }
            if(![text isEqualToString:@""]) {
                //[AppUtils displayToast:text];
                 if (!kUSE_AUTOMATION)
                     [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:text waitUntilDone:NO];
            }
            AppSettings *appSettings = [AppSettings readSettings];
            if(appSettings.isShowPartialAssets) {
                [self performSelectorOnMainThread:@selector(showAdOnPartialAssetsReady:) withObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:eAdType]] waitUntilDone:NO];
            }
            currentAdStaus = @"YuMeAdEventPartialAssetsReady";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventPartialAssetsReady"];
        }
            break;
            
        case YuMeAdEventAdAndAssetsReady:
        {
            NSString* text = @"";
            if(eAdType == YuMeAdTypePreroll) {
                text = @"AD & ASSETS READY (Preroll)";
            } else if(eAdType == YuMeAdTypeMidroll) {
                text = @"AD & ASSETS READY (Midroll)";
            } else if(eAdType == YuMeAdTypePostroll) {
                text = @"AD & ASSETS READY (Postroll)";
            }
            if(![text isEqualToString:@""]) {
                //[AppUtils displayToast:text];
                 if (!kUSE_AUTOMATION)
                     [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:text waitUntilDone:NO];
            }
            currentAdStaus = @"YuMeAdEventAdAndAssetsReady";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdAndAssetsReady"];
        }
            break;
        case YuMeAdEventAdNotReady:
        {
            NSString* text = @"";
            if(eAdType == YuMeAdTypePreroll) {
                text = @"AD NOT READY (Preroll)";
            } else if(eAdType == YuMeAdTypeMidroll) {
                text = @"AD NOT READY (Midroll)";
            } else if(eAdType == YuMeAdTypePostroll) {
                text = @"AD NOT READY (Postroll)";
            }
            adPlaying = FALSE;
            if(![text isEqualToString:@""]) {
                //[AppUtils displayToast:text];
                if (!kUSE_AUTOMATION)
                    [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:text waitUntilDone:NO];
            }
            currentAdStaus = @"YuMeAdEventAdNotReady";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdNotReady"];
        }
            break;
        case YuMeAdEventAdPresent:
            //[AppUtils displayToast:@"AD PRESENT"];
             if (!kUSE_AUTOMATION)
                 [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:@"AD PRESENT" waitUntilDone:NO];
            adPlaying = TRUE;
            currentAdStaus = @"YuMeAdEventAdPresent";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdPresent"];
            break;
        case YuMeAdEventAdPlaying:
            //[AppUtils displayToast:@"AD PLAYING"];
            //[delegate addToolBar];
             if (!kUSE_AUTOMATION)
                 [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:@"AD PLAYING" waitUntilDone:NO];
            adPlaying = TRUE;
            currentAdStaus = @"YuMeAdEventAdPlaying";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdPlaying"];            
            break;
        case YuMeAdEventAdAbsent:
            //[AppUtils displayToast:@"AD ABSENT"];
             if (!kUSE_AUTOMATION)
                 [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:@"AD ABSENT" waitUntilDone:NO];
            adPlaying = FALSE;
            currentAdStaus = @"YuMeAdEventAdAbsent";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdAbsent"];
            break;
        case YuMeAdEventAdCompleted:
             if (!kUSE_AUTOMATION)
                 [AppUtils displayToast:[@"AD COMPLETED, Event Info: " stringByAppendingString:(!pEventInfo ? @"NONE" : pEventInfo)]];
            //NSLog(@"%@", [@"AD COMPLETED, Event Info: " stringByAppendingString:(!pEventInfo ? @"NONE" : pEventInfo)]);
            //[AppUtils displayToast:@"AD COMPLETED"];
            adPlaying = FALSE;
            [delegate adCompleted];
            currentAdStaus = @"YuMeAdEventAdCompleted";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdCompleted"];
            break;
        case YuMeAdEventAdError:
            //[AppUtils displayToast:[@"AD ERROR, Event Info: " stringByAppendingString:(!pEventInfo ? @"NONE" : pEventInfo)]];
            NSLog(@"%@", [@"AD ERROR, Event Info: " stringByAppendingString:(!pEventInfo ? @"NONE" : pEventInfo)]);
            //[AppUtils displayToast:@"AD ERROR"];
             if (!kUSE_AUTOMATION)
                 [self performSelectorOnMainThread:@selector(displayToastMessage:) withObject:@"AD ERROR" waitUntilDone:NO];
            adPlaying = FALSE;
            currentAdStaus = @"YuMeAdEventAdError";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdError"];
            break;
        case YuMeAdEventAdExpired:
             if (!kUSE_AUTOMATION)
                 [AppUtils displayToast:@"AD EXPIRED"];
            AppSettings *appSettings = [AppSettings readSettings];
            if(appSettings.isPrefetchOnAdExpired) {
                [self performSelectorOnMainThread:@selector(initAdOnExpired:) withObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:eAdType]] waitUntilDone:NO];
            }
            adPlaying = FALSE;
            currentAdStaus = @"YuMeAdEventAdExpired";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yumeEventListener" object:@"YuMeAdEventAdExpired"];
            break;
        default:
            break;
    }
}

/**
 * Gets the parent view info.
 * Used by the SDK to get the parent view info from the application.
 * @param None.
 * @return The parent view info object.
 */
- (YuMeParentViewInfo *) yumeGetParentViewInfo {
    if(!settings.isParentViewInfo)
        return nil;
    
    CGRect adView;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        adView = settings.adRectPortrait;
    else
        adView = settings.adRectLandscape;
    
    YuMeParentViewInfo *parentView = [[[YuMeParentViewInfo alloc] init] autorelease];
    parentView.width    = adView.size.width;
    parentView.height   = adView.size.height;
    parentView.left     = adView.origin.x;
    parentView.top      = adView.origin.y;
    
    return parentView;
}

/** Internal functions that interfaces with YuMe SDK APIs */
/**
 * Initializes the YuMe SDK.
 */
- (BOOL) yumeInit:(YuMeAdParams *)pAdParams {
    if(bUseOwnVideoPlayer) {
        if(videoController == nil)
            videoController = [[VideoPlayerController alloc] init];
    }

    if (pYuMeSDK) {
        BOOL bResult = FALSE;
        NSError *pError = nil;
        @try {
            if(!bUseOwnVideoPlayer) {
                bResult = [pYuMeSDK yumeSdkInit:pAdParams appDelegate:self errorInfo:&pError];
            } else {
                bResult = [pYuMeSDK yumeSdkInit:pAdParams appDelegate:self videoPlayerDelegate:videoController errorInfo:&pError];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"<Exception>: %@", exception.description);
            return FALSE;
        }
        if (!bResult) {
            if(pError)
                [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        } else {
            [AppUtils displayToast:@"Initialization Successful."];
        }
        return bResult;
    }
    return FALSE;
}


/**
 * Modifies the Ad Parameters set in YuMe SDK.
 */
- (BOOL) yumeModifyParams:(YuMeAdParams *)pAdParams {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkModifyAdParams:pAdParams errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:@"Modify Params Successful."];
            return bResult;
    }
    return FALSE;
}

/**
 * Gets the Ad Parameters set in YuMe SDK.
 */
- (YuMeAdParams *) yumeGetAdParams {
    if (pYuMeSDK) {
        NSError *pError = nil;
        YuMeAdParams *adParams = [pYuMeSDK yumeSdkGetAdParams:&pError];
        if( (!adParams) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        return adParams;
    }
    return nil;
}

/**
 * De-Initializes the YuMe SDK.
 */
- (BOOL) yumeDeInit {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkDeInit:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:@"De-Initialization Successful."];
        if(videoController)
            [videoController removeSDKRefHandle];
        return bResult;
    }
    return FALSE;
}

/**
 * Sets the view in which the ad should be displayed.
 */
- (BOOL) yumeSetParentView:(UIView *)pAdView viewController:(UIViewController *)pAdViewController {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkSetParentView:pAdView viewController:pAdViewController errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        //else
            //[AppUtils displayToast:@"Set Parent View Successful."];
        return bResult;
    }
    return FALSE;
}

/**
 * Prefetches a pre-roll, mid-roll (or) post-roll ad as requested and
 * also prefetch all the assets required.
 */
- (BOOL) yumeInitAd:(YuMeAdType)eAdType {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkInitAd:eAdType errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        return bResult;
    }
    return FALSE;
}

/*
 * Displays a prefetched ad that was fetched as a result of calling the initAd API.
 */
- (BOOL) yumeShowAd:(YuMeAdType)eAdType {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkShowAd:eAdType errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        return bResult;
    }
    return FALSE;
}

/**
 * Fetches and plays a non-prefetched (streaming) ad.
 */
- (BOOL) yumeStartAd:(YuMeAdType)eAdType {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkStartAd:eAdType errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        return bResult;
    }
    return FALSE;
}

/**
 * Fetches and plays a Auto Play streaming ads.
 */
- (BOOL) yumePlayAd:(YuMeAdType)eAdType {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkPlayAd:eAdType errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        return bResult;
    }
    return FALSE;
}

/**
 * Stops the playback of currently playing ad.
 */
- (BOOL) yumeStopAd {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkStopAd:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        return bResult;
    }
    return FALSE;
}

/**
 * Gets the YuMe SDK Version.
 */
- (NSString *) yumeGetVersion {
    NSString *sdkVersion = [YuMeSDKInterface getYuMeSdkVersion];
    return sdkVersion;
}

/**
 * Enables / disables caching support.
 */
- (BOOL) yumeSetCacheEnabled:(BOOL)bEnableCache {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkSetCacheEnabled:bEnableCache errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:[@"" stringByAppendingString:(bEnableCache ? @"Enable Caching Successful." : @"Disable Caching Successful.")]];
        return bResult;
    }
    return FALSE;
}

/**
 * Checks whether asset caching is enabled.
 */
- (BOOL) yumeIsCacheEnabled {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bCacheEnabled = [pYuMeSDK yumeSdkIsCacheEnabled:&pError];
        if(pError)
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:[@"" stringByAppendingString:(bCacheEnabled ? @"Caching enabled." : @"Caching disabled.")]];
        return bCacheEnabled;
    }
    return FALSE;
}

/**
 * Pauses the currently active downloads.
 */
- (BOOL) yumePauseDownload {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkPauseDownload:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        //else
            //[AppUtils displayToast:@"Pause Download Successful."];
        return bResult;
    }
    return FALSE;
}

/**
 * Resumes the paused downloads.
 */
- (BOOL) yumeResumeDownload {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkResumeDownload:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        //else
            //[AppUtils displayToast:@"Resume Download Successful."];
        return bResult;
    }
    return FALSE;
}

/**
 * Aborts the currently active / paused downloads.
 */
- (BOOL) yumeAbortDownload {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkAbortDownload:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        //else
            //[AppUtils displayToast:@"Abort Download Successful."];
        return bResult;
    }
    return FALSE;
}

/**
 * Gets the current download status.
 */
- (NSString *) yumeGetDownloadStatus {
    if (pYuMeSDK) {
        NSError *pError = nil;
        YuMeDownloadStatus eDownloadStatus = [pYuMeSDK yumeSdkGetDownloadStatus:&pError];
        if (pError) {
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        } else {
            return [self getYuMeDownloadStatusStr:eDownloadStatus];
        }
    }
    return @"NONE";
}

/**
 * Enables / disables auto prefetch mode.
 */
- (BOOL) yumeSetAutoPrefetch:(BOOL)bAutoPrefetch {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkSetAutoPrefetch:bAutoPrefetch errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:[@"" stringByAppendingString:(bAutoPrefetch ? @"Enable Auto Prefetching Successful." : @"Disable Auto Prefetching Successful.")]];
        return bResult;
    }
    return FALSE;
}

/**
 * Checks whether auto prefetch is enabled.
 */
- (BOOL) yumeIsAutoPrefetchEnabled {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bAutoPrefetchEnabled = [pYuMeSDK yumeSdkIsAutoPrefetchEnabled:&pError];
        if (pError)
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:[@"" stringByAppendingString:(bAutoPrefetchEnabled ? @"Auto Prefetch enabled." : @"Auto Prefetch disabled.")]];
        return bAutoPrefetchEnabled;
    }
    return FALSE;
}

/**
 * Clears the asset cache.
 */
- (BOOL) yumeClearCache {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkClearCache:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:@"Clear Cache Successful."];
        return bResult;
    }
    return FALSE;
}

/**
 * Gets the download percentage completed so far, for the currently active Ad.
 */
- (float) yumeGetDownloadedPercentage {
    if (pYuMeSDK) {
        NSError *pError = nil;
        float downloadedPercent = [pYuMeSDK yumeSdkGetDownloadedPercentage:&pError];
        if (pError) {
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
            return -0.1f;
        }
        return downloadedPercent;
    }
    return 0.0f;
}

/**
 * Clears the cookies created by YuMe SDK.
 */
- (BOOL) yumeClearCookies {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkClearCookies:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:@"Clear Cookies Successful."];
        return bResult;
    }
    return FALSE;
}

/**
 * Enables / disables Control Bar toggle for next gen ads.
 */
- (BOOL) yumeSetControlBarToggle:(BOOL)bEnableCBToggle {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkSetControlBarToggle:bEnableCBToggle errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
        else
            [AppUtils displayToast:[@"" stringByAppendingString:(bEnableCBToggle ? @"Enable Control Bar Toggle Successful." : @"Disable Control Bar Toggle Successful.")]];
        return bResult;
    }
    return FALSE;
}

/**
 * Notifies events like PARENT_VIEW_RESIZED event to SDK.
 */
- (void) yumeHandleEvent:(YuMeEventType)eEventType {
    if (pYuMeSDK) {
        NSError *pError = nil;
        BOOL bResult = [pYuMeSDK yumeSdkHandleEvent:eEventType errorInfo:&pError];
        if ( (!bResult) && (pError) )
            [AppUtils displayToast:[AppUtils getErrDesc:pError]];
    }
}

- (void) yumeSetLogLevel:(NSInteger)logLevel
{
    if (pYuMeSDK) {
        [pYuMeSDK yumeSdkSetLogLevel:logLevel];
    }
}

- (void)orientationChange:(CGRect)frame
{
    if(videoController)
        [videoController orientationChange:frame];
}

- (YuMeSDKInterface *)getYuMeSDKHandle {
    return pYuMeSDK;
}

- (NSString *) getYuMeDownloadStatusStr:(YuMeDownloadStatus)eDownloadStatus {
    switch (eDownloadStatus) {
        case YuMeDownloadStatusDownloadsInProgress:
            return @"DOWNLOADS_IN_PROGRESS";
        case YuMeDownloadStatusDownloadsNotInProgress:
            return @"DOWNLOADS_NOT_IN_PROGRESS";
        case YuMeDownloadStatusDownloadsPaused:
            return @"DOWNLOADS_PAUSED";
        case YuMeDownloadStatusNone:
        default:
            return @"NONE";
    }
}

- (void) initAdOnExpired:(NSString *)pAdType {
    YuMeAdType eAdType = YuMeAdTypeNone;
    if ([pAdType isEqualToString:@"0"]) {
        eAdType = YuMeAdTypeNone;
    } else if ([pAdType isEqualToString:@"1"]) {
        eAdType = YuMeAdTypePreroll;
    } else if ([pAdType isEqualToString:@"2"]) {
        eAdType = YuMeAdTypeMidroll;
    } else if ([pAdType isEqualToString:@"3"]) {
        eAdType = YuMeAdTypePostroll;
    }
    [self yumeInitAd:eAdType];
}

- (void) showAdOnPartialAssetsReady:(NSString *)pAdType {
    YuMeAdType eAdType = YuMeAdTypeNone;
    if ([pAdType isEqualToString:@"0"]) {
        eAdType = YuMeAdTypeNone;
    } else if ([pAdType isEqualToString:@"1"]) {
        eAdType = YuMeAdTypePreroll;
    } else if ([pAdType isEqualToString:@"2"]) {
        eAdType = YuMeAdTypeMidroll;
    } else if ([pAdType isEqualToString:@"3"]) {
        eAdType = YuMeAdTypePostroll;
    }
    [delegate playShowAd:eAdType];
}

- (void) displayToastMessage:(NSString *)displayMessage {
    // Display toast message
    [AppUtils displayToast:displayMessage];
    
    // To display info button
    if ([displayMessage isEqualToString:@"AD PLAYING"]) {
        [delegate addToolBar];
    }
}

@end //@implementation YuMeInterface
