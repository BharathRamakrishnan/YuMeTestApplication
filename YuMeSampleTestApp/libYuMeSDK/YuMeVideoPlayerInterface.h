//
//  YuMeVideoPlayerInterface.h
//  YuMeiOSSDK
//
//  Created by Ratheesh TR on 5/8/13.
//  Copyright (c) 2013 YuMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YuMeTypes.h"
///////////////////////////////////////////////////////////////////////////////////////////
/*                                  YuMe VIDEO PLAYER ENUMERATIONS                       */
///////////////////////////////////////////////////////////////////////////////////////////

/**
 * Enumerations specifying various API callback status'.
 */
typedef enum {

	/** Default Value. */
	YuMeCallbackStatusNone,

	/** Method call Successful. */
	YuMeCallbackStatusOK,

	/** Method call Failed. */
	YuMeCallbackStatusError,

	/** Method not implemented. */
	YuMeCallbackStatusNotImplemented

} YuMeCallbackStatus;

/**
 * Enumerations specifying various video ad playback status'.
 */
typedef enum {

	/** Default Value. */
	YuMeVideoPlaybackStatusNone,

	/** Video ad playback started. */
	YuMeVideoPlaybackStatusStarted,

	/** Video ad playback failed for some reason - before (or) after play started. */
	YuMeVideoPlaybackStatusFailed,

	/** Video ad playback completed. */
    YuMeVideoPlaybackStatusCompleted

} YuMeVideoPlaybackStatus;
///////////////////////////////////////////////////////////////////////////////////////////
/*                                  YuMe VIDEO PLAYER DATA STRUCTURES                    */
///////////////////////////////////////////////////////////////////////////////////////////
/**
 * Container for passing a video creative info to the video player.
 */
@interface YuMeCreativeInfo : NSObject {
    
    /** The creative url.
     Default Value: nil. */
    NSString *pUrl;
	
    /** The creative duration in seconds.
     Default Value: 0. */
    NSInteger duration;
	
    /** Flag indicating if the creative play will be conditional or not.
     If TRUE, playing of this creative will be based on some conditions like
     user interaction with ads etc.,
     Default Value: TRUE. */
    BOOL bIsPlayConditional;
}
@property (nonatomic, retain) NSString *pUrl;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL bIsPlayConditional;
@end //@interface YuMeCreativeInfo

@class YuMeVideoPlayerInterface;
///////////////////////////////////////////////////////////////////////////////////////////
/*       INTERFACES TO BE IMPLEMENTED BY THE PUBLISHER VIDEO PLAYER FOR USE BY YUME SDK  */
///////////////////////////////////////////////////////////////////////////////////////////

/**
 * Interface that defines the APIs to be implemented
 * by the 3rd party Video Player module for use by YuMe SDK.
 * The 3rd party Video Player using YuMe SDK should implement this
 * interface.
 */
@protocol YuMeVideoPlayerDelegate

/**
 * Gets the list of supported MIME types supported by the video player.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return The list of supported video MIME types, else nil.
 * If the Player returns 'nil' when this API is called, the SDK will never send
 * any ads to the Player. If more than one format needs to be supported by the Player,
 * then the Player should populate this list with appropriate mime types
 * in the order of preference (e.g., video/mp4, video/mov etc.,).
 */
- (NSMutableArray *)yumeVideoPlayerGetSupportedMimeTypes:(NSError **)ppError;

/**
 * Sets the Parent View within which the Video Player should render the video ad.
 * NOTE: It is the same View that gets passed from the application to the SDK
 * in yumeSdkSetParentView() call.
 * The Video Player can ignore this view handle, if it gets the same handle from the application itself.
 * The YuMe SDK will use this view to render all the non-video ad components.
 * @param playerParentView The view within which the ad video needs to be played.
 * @return The status of the function call.
 */
- (YuMeCallbackStatus)yumeVideoPlayerSetParentView:(UIView *)playerParentView;

/**
 * Initiates playing of the specified ad video.
 * @param videoUrl The video url to be played - can be a http url (or) local file url.
 * @param bIsLocalVideo Flag indicating if the video pointed by the videoUrl is a local video (or) a streaming video.
 * @param duration The ad video duration (in seconds).
 * @param sdkInterface Instance of the SDK class that has implemented YuMeSDKVideoPlayerInterface - required for
 * the 3rd party Video Player to notify the video playback status to the SDK.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 * @return The handle to a view that holds the video playing component which is required for the SDK to show the Flip transition effect in case of Flip ad unit -
 * The SDK expects the video player to create a Container (say L1), place the video rendering component as a child of L1 and
 * then attach L1 to the UIView given as the ParentView via yumeSdkSetParentView().
 */
- (UIView *)yumeVideoPlayerStart:(NSString *)videoUrl bIsLocalVideo:(BOOL)bIsLocalVideo duration:(int)duration sdkInterface:(YuMeVideoPlayerInterface *)sdkInterface errorInfo:(NSError **)ppError;

/**
 * Stops the currently playing ad video.
 * @return The status of the function call.
 */
- (YuMeCallbackStatus)yumeVideoPlayerStop;

/**
 * Pauses the currently playing ad video.
 * NOTE: When the SDK calls this API, the Player should pause the video and
 * book-keep the current play-head position, to facilitate resuming later.
 * @return The status of the function call.
 */
- (YuMeCallbackStatus)yumeVideoPlayerPause;

/**
 * Resumes the currently paused ad video.
 * @return The status of the function call.
 */
- (YuMeCallbackStatus)yumeVideoPlayerResume;

/**
 * Replays the currently playing/paused ad video by seeking to position 0.
 * @return The status of the function call.
 */
- (YuMeCallbackStatus)yumeVideoPlayerReplay;

/**
 * Gets the ad video duration.
 * @return The ad video duration (in seconds), if playback has started, else -1.
 */
- (int)yumeVideoPlayerGetDuration;

/**
 * Gets the current position of the ad video.
 * @return The ad video playhead's current position (in seconds), if playback has started, else -1.
 */
- (int)yumeVideoPlayerGetCurrentPosition;

/**
 * Gets the resolution (width and height) of the ad video.
 * NOTE: The SDK expects the player to return the width and height of the Video frame
 * and not that of the Parent View.
 * The Video Player can get these values from Media Player when "OnVideoSizeChangedListener"
 * gets called after play start.
 * The SDK needs these values for positioning of ad overlays.
 * @return The CGRect object populated with the video resolution.
 */
- (CGRect)yumeVideoPlayerGetVideoResolution;

/**
 * Handles the specified event that occurred in the application and got notified to SDK.
 * The VideoPlayer can ignore this call, if it already received this event directly from the application.
 * @param eEventType The enum value representing the event that occurred.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 */
- (void)yumeVideoPlayerHandleEvent:(YuMeEventType)eEventType errorInfo:(NSError **)ppError;

/**
 * Sets the information relevant to all ad video creatives that belongs to a particular ad slot.
 * creativesInfoList[0] will be an NSMutableArray containing the list of video creatives' info related to ad 1,
 * creativesInfoList[1] will be an NSMutableArray containing the list of video creatives' info related to ad 2 etc.,
 * NOTE: The Video Player can pre-buffer the ad video creatives, if required.
 * It should never play any of the creatives automatically.
 * Also, there is no guarantee that the SDK will play all of the provided video creatives,
 * as some videos may be conditionally played based on user interaction etc.,
 * @param creativesInfoList Two dimensional array representing information relevant to all
 * ad video creatives that belongs to a particular ad slot.
 * Format: NSMutableArray<NSMutableArray<YuMeCreativeInfo>> creativesInfoList.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 */
- (void)yumeVideoPlayerSetCreativesInfo:(NSMutableArray *)creativesInfoList errorInfo:(NSError **)ppError;

@end //@protocol YuMeVideoPlayerDelegate

///////////////////////////////////////////////////////////////////////////////////////////
/*         API INTERFACES IMPLEMENTED BY THE YUME SDK FOR USE BY PUBLISHER VIDEO PLAYER  */
///////////////////////////////////////////////////////////////////////////////////////////

@class YuMeVideoPlayerDelegate;

@interface YuMeVideoPlayerInterface : NSObject

/**
 * Notifies the video ad playback status.
 * Used by the Video Player to notify the video ad playback status (STARTED / FAILED / COMPLETED) to the SDK.
 * @param ePlaybackStatus The video ad playback status.
 * @param statusInfo Any information associated with the playback status value, else nil.
 * @param ppError A double pointer to an NSError object where a newly created error object will returned in case an error occurs.
 */
- (void)yumeSdkVideoPlayerPlaybackStatus:(YuMeVideoPlaybackStatus)ePlaybackStatus statusInfo:(NSString *)statusInfo errorInfo:(NSError **)ppError;

@end //@interface YuMeVideoPlayerInterface
