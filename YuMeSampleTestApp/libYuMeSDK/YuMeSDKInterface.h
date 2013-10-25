//
//  YuMeSDKInterface.h
//  YuMeiOSSDK
//
//  Created by Senthil on 05/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuMeTypes.h"


/* Forward declarations */
@class YuMeSDKInternal;

///////////////////////////////////////////////////////////////////////////////////////////
/*     INTERFACES TO BE IMPLEMENTED BY THE PUBLISHER APPLICATION FOR USE BY YUME SDK     */
///////////////////////////////////////////////////////////////////////////////////////////

@protocol YuMeAppDelegate <NSObject>

/**
 * Listener that receives various ad events from YuMe SDK.
 * Used by the SDK to notify the application that the indicated ad event has occurred.
 * @param eAdType Ad type requested by the application that the event is related to.
 * @param eAdEvent The Ad event notified to the application.
 * @param pEventInfo The Ad event info (or) nil.
 * @return None.
 */
-  (void) yumeEventListener:(YuMeAdType)eAdType adEvent:(YuMeAdEvent)eAdEvent eventInfo:(NSString *)pEventInfo;

/**
 * Gets the parent view info.
 * Used by the SDK to get the parent view info from the application.
 * @param None.
 * @return The parent view info object.
 */
- (YuMeParentViewInfo *) yumeGetParentViewInfo;

@end //@protocol YuMeAppDelegate


///////////////////////////////////////////////////////////////////////////////////////////
/*      API INTERFACES IMPLEMENTED BY THE YUME SDK FOR USE BY PUBLISHER APPLICATION      */
///////////////////////////////////////////////////////////////////////////////////////////


@interface YuMeSDKInterface : NSObject {
@private
    YuMeSDKInternal *pYuMeSDKInternal;
}


/**
 * Gets the YuMe SDK Handle.
 * @param None.
 * @return The YuMe SDK handle or nil if an error occurs..
 */
+ (YuMeSDKInterface *) getYuMeSdkHandle;

/**
 * Gets the YuMe SDK Version.
 * @param None.
 * @return The YuMe SDK version.
 */
+ (NSString *) getYuMeSdkVersion;

/**
 * Initializes the YuMe SDK with ad params and app interface handle.
 * NOTE: This API needs to be used by Publishers who needs to utilize YuMe Player for playing video and non-video ad components.
 * @param pAdParams The Ad Param object prefilled with the values to be initialized.
 * NOTE: The attributes yumeAdServerURL, domain are mandatory. The attribute storageSize must be > 0 for Ad pre-fetch to work.
 * @param pAppDelegate Handle of an object that implements YuMeAppDelegate protocol.
 * @param ppError A double pointer to an NSError object where a newly created error object will be returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE.
 */
- (BOOL) yumeSdkInit:(YuMeAdParams *)pAdParams appDelegate:(id<YuMeAppDelegate>)pAppDelegate errorInfo:(NSError **)ppError;

/**
 * Initializes the YuMe SDK with ad params, app interface handle & video player interface handle
 * NOTE: This API needs to be used by Publishers who needs to utilize their own Video Player for playing ad videos and
 * YuMe Player for playing non-video ad components.
 * @param pAdParams The Ad Param object prefilled with the values to be initialized.
 * NOTE: The attributes yumeAdServerURL, domain are mandatory. The attribute storageSize must be > 0 for Ad pre-fetch to work.
 * @param pAppDelegate Handle of an object that implements YuMeAppDelegate protocol.
 * @param videoPlayerDelegate Handle of an object that implements the protocol YuMeVideoPlayerDelegate.
 * @param ppError A double pointer to an NSError object where a newly created error object will be returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE.
 */
- (BOOL) yumeSdkInit:(YuMeAdParams *)pAdParams appDelegate:(id<YuMeAppDelegate>)pAppDelegate videoPlayerDelegate:(id)videoPlayerDelegate errorInfo:(NSError **)ppError;

/**
 * Modifies the Ad Parameters set in YuMe SDK.
 * @param pAdParams The Ad Param object prefilled with the values to be modified.
 * NOTE: The attributes yumeAdServerURL, domain are mandatory. The attribute storageSize must be > 0 for Ad pre-fetch to work. 
 * @param ppError A double pointer to an NSError object where a newly created error object will be returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE.
 */
- (BOOL) yumeSdkModifyAdParams:(YuMeAdParams *)pAdParams errorInfo:(NSError **)ppError;

/**
 * Gets the Ad Parameters set in YuMe SDK.
 * @param ppError A double pointer to an NSError object where a newly created error object will be returned in case an error occurs.
 * @return The ad param object if present, else nil.
 */
- (YuMeAdParams *) yumeSdkGetAdParams:(NSError **)ppError;

/**
 * De-initializes the YuMe SDK.
 * @param ppError A double pointer to an NSError object where a newly created error object will be returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE.
 */
- (BOOL) yumeSdkDeInit:(NSError **)ppError;

/**
 * Sets the view in which the ad should be displayed.
 * The Ad will be placed above this view. The Ad will occupy the full frame of the parent view.
 * Application should make sure that the parent view is visible during Ad playback.
 * @param pAdView The UIView inside which the Ad will be played.
 * @param pAdViewController The UIViewController inside which the Ad will be played.
 * @param ppError A double pointer to an NSError object where a newly created error object will be returned in case an error occurs. 
 * @return TRUE, if operation is successful, else FALSE.
 */
- (BOOL) yumeSdkSetParentView:(UIView *)pAdView viewController:(UIViewController *)pAdViewController errorInfo:(NSError **)ppError;

/**
 * Prefetches a preroll, midroll (or) postroll ad as requested and
 * also caches all the assets required.
 * The yumeSdkShowAd API should be called in order to play the Ad.
 * If caching is enabled, then ad creatives will also be downloaded.
 * NOTE: It will take some time (based upon the network speed) for downloading the ad creatives.
 * If yumeSdkShowAd() is called before download is completed, Ad won't be displayed.
 * Calling yumeSdkInitAd() more than once with the same set of parameters
 * (like adServerUrl, domainId, additional params, etc) has no effect.
 * But if any of the additional parameter changes, a new Ad request will be made.
 * @param eAdType The type of ad to be prefetched.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkInitAd:(YuMeAdType)eAdType errorInfo:(NSError **)ppError;

/**
 * Displays a preroll, midroll (or) postroll ad that is already prefetched
 * by calling yumeSdkInitAd().
 * If no Ad is available when this API is called FALSE will be returned.
 * If auto prefetching is enabled, another Ad request will be made automatically
 * after Ad play is completed.
 * @param eAdType The type of prefetched ad to be played.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkShowAd:(YuMeAdType)eAdType errorInfo:(NSError **)ppError;

/**
 * Fetches a preroll, midroll (or) postroll ad (Streaming mode) and
 * plays the ad immediately after fetching, when
 * YuMeAdParams.bAutoPlayStreamingAds is set to "TRUE".
 * Else, the fetched ad would get played only when yumeSdkPlayAd() is called.
 * @param eAdType The type of ad to be played.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkStartAd:(YuMeAdType)eAdType errorInfo:(NSError **)ppError;

/**
 * Initiates the playback of a preroll, midroll (or) postroll ad (Streaming mode),
 * that is already fetched using yumeSdkStartAd() call.
 * @param eAdType The type of ad to be played.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkPlayAd:(YuMeAdType)eAdType errorInfo:(NSError **)ppError;

/**
 * Stops the playback of currently playing ad.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkStopAd:(NSError **)ppError;

/**
 * Enables / disables caching support.
 * If disabled, assets will NOT be cached.
 * This setting has no effect on prefetching a playlist.
 * @param bEnableCache Flag indicating if caching support should be enabled or not.
 * If TRUE, when yumeSdkInitAd() is called all required ad assets will be cached locally.
 * If FALSE, when yumeSdkInitAd() is called only playlist will be cached. Assets will
 * be streamed when yumeSdkShowAd() is called.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkSetCacheEnabled:(BOOL)bEnableCache errorInfo:(NSError **)ppError;

/**
 * Checks whether asset caching is enabled.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if caching is enabled, else FALSE.
 * NOTE: In case of errors, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkIsCacheEnabled:(NSError **)ppError;

/**
 * Pauses the currently active downloads.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkPauseDownload:(NSError **)ppError;

/**
 * Resumes the paused downloads.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkResumeDownload:(NSError **)ppError;

/**
 * Aborts the currently active/paused downloads.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkAbortDownload:(NSError **)ppError;

/**
 * Gets the current download status.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return The current download status.
 * NOTE: In case of errors, the ppError object will contain appropriate error info.
 */
- (YuMeDownloadStatus) yumeSdkGetDownloadStatus:(NSError **)ppError;

/**
 * Enables/Disables auto prefetch mode.
 * If enabled, a new Ad will be prefetched automatically after Ad play is complete (or) aborted.
 * @param bAutoPrefetch Flag indicating if auto-prefetch should be enabled or not.
 * If TRUE, when the Ad play initiated by yumeSdkShowAd() is completed,
 * another Ad request will be sent automatically.
 * If FALSE, when the Ad play initiated by yumeSdkShowAd() is completed,
 * another Ad request will NOT be sent automatically.
 * If auto prefetch is disabled, application should call yumeSdkInitAd() every time
 * an ad needs to be pre-fetched.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkSetAutoPrefetch:(BOOL)bAutoPrefetch errorInfo:(NSError **)ppError;

/**
 * Checks whether auto prefetch is enabled.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if auto prefetch is enabled, else, FALSE.
 * NOTE: In case of errors, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkIsAutoPrefetchEnabled:(NSError **)ppError;

/**
 * Clears the asset cache.
 * It will clear all the playlists and creatives that were cached already. 
 * If no ad is downloading and auto prefetch is enabled and prefetch operation was attempted before,
 * a new ad request will be made immediately after clearing the assets cache.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkClearCache:(NSError **)ppError;

/**
 * Gets the download percentage completed so far, for the currently active Ad.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return The percentage downloaded so far, for the active Ad. If no Ad is active, 0.0f will be returned.
 * NOTE: In case of errors, the ppError object will contain appropriate error info.
 */
- (float) yumeSdkGetDownloadedPercentage:(NSError **)ppError;

/**
 * Clears the cookies created by YuMe SDK.
 * This will not delete cookies created as a result of user interaction with the Ad (like launching WebView).
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkClearCookies:(NSError **)ppError;

/**
 * Enables / disables Control Bar toggle for next gen ads.
 * If disabled, control bar will be displayed through out for video (or) image slates.
 * Else, will be shown for 'x' seconds and then hidden after that, until the user taps the video / image again.
 * @param bEnableCBToggle Flag indicating if control bar toggling should be enabled or not.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkSetControlBarToggle:(BOOL)bEnableCBToggle errorInfo:(NSError **)ppError;

/**
 * Sets the handle of the Publisher Video Player in the SDK.
 * This API can be called, if the player handle passed during initialization needs to be updated.
 * The YuMe SDK will use this player for playing videos.
 * If the SDK is using its own player for playing videos, calling this API has no effect
 * and an error will be thrown.
 * @param videoPlayerDelegate The instance of a class that implements the protocol YuMeVideoPlayerDelegate.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info.
 */
- (BOOL) yumeSdkSetVideoPlayerHandle:(id)videoPlayerDelegate errorInfo:(NSError **)ppError;

/**
 * Handles the specified event that occurred in the application.
 * @param eEventType The enum value representing the app event that occurred.
 * NOTE: If eEventType is YuMeEventTypeParentViewResized, then the application should ensure that
 * the Parent View is resized before calling this API.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return TRUE, if operation is successful, else FALSE. If FALSE is returned, the ppError object will contain appropriate error info. 
 */
- (BOOL) yumeSdkHandleEvent:(YuMeEventType)eEventType errorInfo:(NSError **)ppError;

@end //@interface YuMeSDKInterface
