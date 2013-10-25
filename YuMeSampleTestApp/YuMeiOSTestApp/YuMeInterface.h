//
//  YuMeInterface.h
//  YuMeiOSTestApp
//
//  Created by Senthil on 3/12/13.
//
//


#import <Foundation/Foundation.h>
#import "YuMeSDKInterface.h"
#import "YuMeTypes.h"
#import "AppSettings.h"
#import "VideoPlayerController.h"

#define kUSE_AUTOMATION 1

@protocol YuMeInterfaceDelegate

- (void)addToolBar;
- (void)adCompleted;

@end


@interface YuMeInterface : NSObject <YuMeAppDelegate> {
    /** Own video player handle */
    VideoPlayerController *videoController;
    
    /** Flag indicating if the app needs to use its own video player */
    BOOL bUseOwnVideoPlayer;

    /** YuMe SDK Instance */
    YuMeSDKInterface *pYuMeSDK;

    BOOL adPlaying;
    
    AppSettings *settings;
    
    id delegate;
    
    NSString *currentAdStaus;
}

@property (nonatomic , assign)id delegate;
@property (nonatomic , retain)AppSettings *settings;
@property (nonatomic , assign)BOOL adPlaying;
@property (nonatomic , assign)NSString *currentAdStaus;

/** Internal functions that interfaces with YuMe SDK APIs */
/**
 * Initializes the YuMe SDK.
 */
- (BOOL) yumeInit:(YuMeAdParams *)pAdParams;

/**
 * Modifies the Ad Parameters set in YuMe SDK.
 */
- (BOOL) yumeModifyParams:(YuMeAdParams *)pAdParams;

/**
 * Gets the Ad Parameters set in YuMe SDK.
 */
- (YuMeAdParams *) yumeGetAdParams;

/**
 * De-Initializes the YuMe SDK.
 */
- (BOOL) yumeDeInit;

/**
 * Sets the view in which the ad should be displayed.
 */
- (BOOL) yumeSetParentView:(UIView *)pAdView viewController:(UIViewController *)pAdViewController;

/**
 * Prefetches a pre-roll, mid-roll (or) post-roll ad as requested and
 * also prefetch all the assets required.
 */
- (BOOL) yumeInitAd:(YuMeAdType)eAdType;

/*
 * Displays a prefetched ad that was fetched as a result of calling the initAd API.
 */
- (BOOL) yumeShowAd:(YuMeAdType)eAdType;

/**
 * Fetches and plays a non-prefetched (streaming) ad.
 */
- (BOOL) yumeStartAd:(YuMeAdType)eAdType;

/**
 * Fetches and plays a Auto Play streaming ads.
 */
- (BOOL) yumePlayAd:(YuMeAdType)eAdType;

/**
 * Stops the playback of currently playing ad.
 */
- (BOOL) yumeStopAd;

/**
 * Gets the YuMe SDK Version.
 */
- (NSString *) yumeGetVersion;

/**
 * Enables / disables caching support.
 */
- (BOOL) yumeSetCacheEnabled:(BOOL)bEnableCache;

/**
 * Checks whether asset caching is enabled.
 */
- (BOOL) yumeIsCacheEnabled;

/**
 * Pauses the currently active downloads.
 */
- (BOOL) yumePauseDownload;

/**
 * Resumes the paused downloads.
 */
- (BOOL) yumeResumeDownload;

/**
 * Aborts the currently active / paused downloads.
 */
- (BOOL) yumeAbortDownload;

/**
 * Gets the current download status.
 */
- (NSString *) yumeGetDownloadStatus;

/**
 * Enables / disables auto prefetch mode.
 */
- (BOOL) yumeSetAutoPrefetch:(BOOL)bAutoPrefetch;

/**
 * Checks whether auto prefetch is enabled.
 */
- (BOOL) yumeIsAutoPrefetchEnabled;

/**
 * Clears the asset cache.
 */
- (BOOL) yumeClearCache;

/**
 * Gets the download percentage completed so far, for the currently active Ad.
 */
- (float) yumeGetDownloadedPercentage;

/**
 * Clears the cookies created by YuMe SDK.
 */
- (BOOL) yumeClearCookies;

/**
 * Enables / disables Control Bar toggle for next gen ads.
 */
- (BOOL) yumeSetControlBarToggle:(BOOL)bEnableCBToggle;

/**
 * Notifies events like PARENT_VIEW_RESIZED event to SDK.
 * @param eEventType The event type.
 */
- (void) yumeHandleEvent:(YuMeEventType)eEventType;


//Internal functions
- (YuMeSDKInterface *)getYuMeSDKHandle;

- (NSString *) getYuMeDownloadStatusStr:(YuMeDownloadStatus) eDownloadStatus;

- (void) yumeSetLogLevel:(NSInteger)logLevel;

- (void) initAdOnExpired:(NSString *)pAdType;

- (void) showAdOnPartialAssetsReady:(NSString *)pAdType;

- (void) displayToastMessage:(NSString *)displayMessage;

- (void)orientationChange:(CGRect)frame;


@end //@interface YuMeInterface
