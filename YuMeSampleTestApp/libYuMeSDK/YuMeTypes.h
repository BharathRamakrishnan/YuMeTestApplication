//
//  YuMeTypes.h
//  YuMeiOSSDK
//
//  Created by Senthil on 05/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//


///////////////////////////////////////////////////////////////////////////////////////////
/*                                  YuMe SDK ENUMERATIONS                                */
///////////////////////////////////////////////////////////////////////////////////////////
/**
 * Enumerations specifying various YuMe ad block types available.
 */
typedef enum {
    
    /** Default Value. */
	YuMeAdTypeNone,
    
	/** Preroll slot ad. */
    YuMeAdTypePreroll,
    
    /** Midroll slot ad. */
	YuMeAdTypeMidroll,
    
    /** Postroll slot ad. */
	YuMeAdTypePostroll
    
} YuMeAdType;

/**
 * Enumerations specifying the ad events
 * that can be notified to the application from SDK.
 */
typedef enum {
    		
    /** Default Value. */
	YuMeAdEventNone,
    
    /** When a playlist is prefetched (when asset caching is enabled (or) disabled). */
	YuMeAdEventAdReady,
    
    /** When the assets associated with the 1st valid ad in a prefetched playlist are downloaded (when asset caching is enabled). */
	YuMeAdEventPartialAssetsReady,
    
    /** When all the assets associated with a prefetched playlist are
    downloaded (when asset caching is enabled). */
	YuMeAdEventAdAndAssetsReady,
    
	/** When a playlist is prefetched and
	a) the playlist is empty (or)
	b) no appropriate video url is present in the playlist. */
    YuMeAdEventAdNotReady,
    
    /** When a non-prefetched ad is present and ready for rendering. */
	YuMeAdEventAdPresent,
    
    /** When a non-prefetched ad is requested and cannot be served. */
    YuMeAdEventAdAbsent,
    
    /** When a non-prefetched (or) prefetched ad is being rendered. */
    YuMeAdEventAdPlaying,
    
	/** When a prefetched ad playback is completed (or)
	When a non-prefetched ad playback is completed (or) 
	Followed by an "AD_ABSENT" event, in case of non-prefetched ad requests. */    
    YuMeAdEventAdCompleted,
    
    /** When a playlist is prefetched and any of the required asset downloads (for all the ads in the playlist) fails for some reason. */
    YuMeAdEventAdError,
    
    /** When a prefetched ad expires. */
    YuMeAdEventAdExpired
    
} YuMeAdEvent;

/**
 * Enumerations specifying assets' download status.
 */
typedef enum {
	
	/** Default Value. */
	YuMeDownloadStatusNone,
	
	/** Assets downloads In Progress. */
	YuMeDownloadStatusDownloadsInProgress,
    
	/** Assets downloads Not In Progress. */
	YuMeDownloadStatusDownloadsNotInProgress,
    
	/** Assets downloads Paused. */
	YuMeDownloadStatusDownloadsPaused
    
} YuMeDownloadStatus;

/**
 * Enumerations specifying various play types that can be set by the application.
 */
typedef enum {
	
	/** Default Value. */
	YuMePlayTypeNone,
	
	/** Play type - Click to Play. */
	YuMePlayTypeClickToPlay,
	
	/** Play type - Auto Play. */
	YuMePlayTypeAutoPlay
    
} YuMePlayType;

/**
 * Enumerations specifying various error codes that SDK can send to the application.
 */
typedef enum {
	
	/** Default Value - No Error. */
	YuMeErrorNone,
    
	/** SDK is not initialized. */
	YuMeErrorSDKNotInitialized,
	
	/** SDK is already initialized. */
	YuMeErrorSDKAlreadyInitialized,
    
    /** Invalid handle. */
	YuMeErrorInvalidHandle,
    
    /** Invalid ad server url. */
	YuMeErrorInvalidURL,
    
    /** Invalid ad server domain. */
	YuMeErrorInvalidDomain,
    
    /** Invalid ad request timeout value. */
	YuMeErrorInvalidAdTimeout,
    
    /** Invalid video timeout (streaming) value. */
	YuMeErrorInvalidVideoTimeout,
    
    /** Invalid ad type. */
	YuMeErrorInvalidAdType,
    
    /** Ad request failed. */
	YuMeErrorAdRequestFailed,
    
    /** Ad Play failed. */
	YuMeErrorAdPlayFailed,
    
    /** Invalid Parent View. */
	YuMeErrorInvalidParentView,
    
    /** No Network Connection. */
	YuMeErrorNoNetworkConnection,
    
    /** Ad request already in progress. */
	YuMeErrorPreviousAdRequestInProgress,
    
    /** Ad play in progress. */
	YuMeErrorPreviousAdPlayInProgress,
    
    /** Invalid operation. */
	YuMeErrorInvalidOperation,
    
    /** Operation not allowed now. */
    YuMeErrorNotAllowedNow,
    
	/** Unknown Error. */
	YuMeErrorUnknown
    
} YuMeError;

/**
 * Enumerations specifying various events that can be notified from application/Player to SDK.
 */
typedef enum {
	
	/** Default Value. */
	YuMeEventTypeNone,
	
	/** The ad parent view has been resized by the application / Player.
	 * The SDK will automatically detect the updated width and height of the Parent View
	 * using the Parent View handle set using yumeSdkSetParentView(). */
	YuMeEventTypeParentViewResized
	
} YuMeEventType;


///////////////////////////////////////////////////////////////////////////////////////////
/*                                  YuMe SDK DATA STRUCTURES                             */
///////////////////////////////////////////////////////////////////////////////////////////
/**
 * Container for the ad parameters that can be set by the application.
 */
@interface YuMeAdParams : NSObject {
    
	/** Ad Server Url to be used for playlist requests.
     Default Value: nil. */
	NSString *pAdServerUrl;
    
	/** Ad Server Domain Identifier for playlist requests.
     Default Value: nil. */
	NSString *pDomainId;
    
    /** Optional. Additional QS Parameters to be added in the playlist request
     on behalf of the application. 
     Default Value: nil. */
	NSString *pAdditionalParams;
	
	/** The playlist response timeout value (in seconds).
     Valid value is between 4 and 60 including.
     Default value is 5 (if timeOut < 4 default will be used).
     If timeOut is > 60 error will be returned. */
	NSInteger adTimeout;
	
	/** Timeout value for interruption during ad streaming (in seconds).
     Valid value is between 3 and 60 including.
     Default value is 6 (if value < 3, default will be used).
     If value is > 60 error will be returned. */
	NSInteger videoTimeout;
    
    /** Flag to indicate support for high bitrate mp4 ad videos. 
     Default Value: TRUE. */
    BOOL bSupportHighBitRate;
    
	/** Flag to indicate if the SDK should automatically detect
     the current network and play the appropriate video based on the network identified. 
     Default Value: FALSE. */
	BOOL bSupportAutoNetworkDetect;
	
	/** Flag to indicate if playlist assets needs to be cached in case of prefetched playlists. 
     Default Value: TRUE. */
	BOOL bEnableCaching;
	
	/** Flag to indicate if SDK can prefetch a playlist/assets automatically, 
     after first prefetch is initiated by the application.
     Default Value: TRUE. */
	BOOL bEnableAutoPrefetch;
	
	/** Disk quota in MB for storing the prefetched assets.
    This should have a reasonable value for Ad pre-fetch to function properly.
    The minimum recommended value is 3 MB. If this value is <= 0 caching cannot be done even if bEnableCaching is set to TRUE. 
     Default Value: 0.0f. */
	float storageSize;
	
	/** Flag to indicate if the control bar toggle should be enabled when displaying video ads. 
     Default Value: TRUE. */
	BOOL bEnableCBToggle;
	
	/** The play type. 
     Default Value: YuMePlayTypeNone. */
	YuMePlayType ePlayType;
    
    /** Flag to indicate if ad activity orientation set by the application
     can be overridden by the SDK during ad play (or) not. If TRUE, the SDK will reset the
     ad activity orientation back to its original value on ad completion.
     Default Value: TRUE. */
    BOOL bOverrideOrientation;
    
    /** Flag to indicate if Survey is supported or not.
     Default Value: TRUE. */
    BOOL bSupportSurvey;
   
    /** Flag to enable tap to Calendar 
     Default value: TRUE */
    BOOL bEnableTTC;
    
    /** Flag to indicate if the SDK needs to play the streaming ads automatically
     (or) not. If "TRUE", the ad will be played automatically when yumeSdkStartAd() is called.
     If FALSE, the ad will be fetched when YuMeSDK_StartAd() is called and
     it will be played when yumeSdkPlayAd() is called.
     Default Value: TRUE. */
	BOOL bAutoPlayStreamingAds;
}

@property (nonatomic, retain) NSString *pAdServerUrl;
@property (nonatomic, retain) NSString *pDomainId;
@property (nonatomic, retain) NSString *pAdditionalParams;
@property (nonatomic, assign) NSInteger adTimeout;
@property (nonatomic, assign) NSInteger videoTimeout;
@property (nonatomic, assign) float storageSize;
@property (nonatomic, assign) BOOL bSupportHighBitRate;
@property (nonatomic, assign) BOOL bSupportAutoNetworkDetect;
@property (nonatomic, assign) BOOL bEnableCaching;
@property (nonatomic, assign) BOOL bEnableAutoPrefetch;
@property (nonatomic, assign) BOOL bSupportSurvey;
@property (nonatomic, assign) BOOL bAutoPlayStreamingAds;
@property (nonatomic, assign) BOOL bEnableCBToggle;
@property (nonatomic, assign) BOOL bOverrideOrientation;
@property (nonatomic, assign) BOOL bEnableTTC;
@property (nonatomic, assign) YuMePlayType ePlayType;

@end //@interface YuMeAdParams

/**
 * Container for getting the ParentView information from the application.
 */
@interface YuMeParentViewInfo : NSObject {
    
	/** Width of the Parent View. */
	NSInteger width;
	
	/** Height of the Parent View. */
	NSInteger height;
	
	/** X Coordinate of the Parent View. */
	NSInteger left;
	
	/** Y Coordinate of the Parent View. */
	NSInteger top;

}
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) NSInteger top;

@end //@interface YuMeParentViewInfo
