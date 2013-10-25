//
//  VideoPlayerController.m
//  YuMeiOSSDK
//
//  Created by Ratheesh TR on 5/8/13.
//  Copyright (c) 2013 YuMe. All rights reserved.
//

#import "VideoPlayerController.h"

@implementation VideoPlayerController

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        yumeSDKPlayerInterface = nil;
        videoAdView            = nil;
        videoDuration = 0;
    }
    return self;
}

#pragma mark - Video Player Delegate Methods

- (void)isLoaded:(BOOL)flag
{
    if (yumeSDKPlayerInterface)
        [yumeSDKPlayerInterface yumeSdkVideoPlayerPlaybackStatus:YuMeVideoPlaybackStatusStarted statusInfo:nil errorInfo:nil];
}

- (void)isPlaying:(BOOL)flag
{

}

- (void)isCompleted:(BOOL)flag
{
    if (yumeSDKPlayerInterface)
        [yumeSDKPlayerInterface yumeSdkVideoPlayerPlaybackStatus:YuMeVideoPlaybackStatusCompleted statusInfo:nil errorInfo:nil];
}

- (void)videoDuration:(NSInteger)duration
{
    videoDuration = duration;
    if (yumeSDKPlayerInterface)
        [yumeSDKPlayerInterface yumeSdkVideoPlayerPlaybackStatus:YuMeVideoPlaybackStatusStarted statusInfo:nil errorInfo:nil];
}

- (void)playBackError
{
    if (yumeSDKPlayerInterface)
        [yumeSDKPlayerInterface yumeSdkVideoPlayerPlaybackStatus:YuMeVideoPlaybackStatusFailed statusInfo:nil errorInfo:nil];

    if (videoAdView) {
        [videoAdView removeNotification];
        [videoAdView release]; videoAdView = nil;
    }
}

#pragma mark - SDK Delegate Methods

- (void)play
{
    if (videoAdView) {
        self.hidden = NO;
        isPaused    = NO;
        [videoAdView play];
    }
}

- (void)pause {
    
    if (videoAdView.currentPlaybackTime == 0)
        return;
    
    self.hidden = NO;
    isPaused    = YES;
    [videoAdView pause];
}

- (void)stop
{
    if (videoAdView) {
        [videoAdView stop];
    }
}

- (void)replay    {

    videoAdView.currentPlaybackTime = -1;
    [self play];
}

 // YuMe Interface delegate methods
- (NSMutableArray *)yumeVideoPlayerGetSupportedMimeTypes:(NSError **)ppError
{
    NSMutableArray *mimeTypes = [[[NSMutableArray alloc] init] autorelease];
    [mimeTypes addObject:@"video/mp4"];
    [mimeTypes addObject:@"video/quicktime"];
    return mimeTypes;
}

- (YuMeCallbackStatus)yumeVideoPlayerSetParentView:(UIView*)playerParentView
{
    return YuMeCallbackStatusOK;    
}

- (UIView*)yumeVideoPlayerStart:(NSString*)videoUrl bIsLocalVideo:(BOOL)bIsLocalVideo duration:(int)duration sdkInterface:(YuMeVideoPlayerInterface*)sdkInterface errorInfo:(NSError **)ppError
{
    if (videoAdView) {
        [videoAdView removeNotification];
        videoAdView.delegate = nil;
        [videoAdView release]; videoAdView = nil;
    }
    
    yumeSDKPlayerInterface = sdkInterface;

    videoAdView = [[YuMeMPlayerController alloc] initPlayerContoller:videoUrl bIsLocalVideo:bIsLocalVideo frameSize:self.frame.size delegate:self];
    return videoAdView.view;
}

- (YuMeCallbackStatus)yumeVideoPlayerStop
{
    [self stop];
    return YuMeCallbackStatusOK;
}

- (YuMeCallbackStatus)yumeVideoPlayerPause
{
    [self pause];
    return YuMeCallbackStatusOK;
}

- (YuMeCallbackStatus)yumeVideoPlayerResume
{
    [self play];
    return YuMeCallbackStatusOK;
}

- (YuMeCallbackStatus)yumeVideoPlayerReplay
{
    [self replay];
    return YuMeCallbackStatusOK;
}

- (int)yumeVideoPlayerGetDuration
{
    if (videoAdView)
        return videoDuration;
    return -1;
}

- (int)yumeVideoPlayerGetCurrentPosition
{
    if (videoAdView)
        return videoAdView.currentPlaybackTime;
    return -1;
}

- (CGRect)yumeVideoPlayerGetVideoResolution
{
    if (videoAdView) {
        CGRect frame = videoAdView.view.frame;
        frame.size = videoAdView.naturalSize;
        return frame;
    }
    return CGRectZero;
}

/**
 * Handles the specified event that occurred in the application and got notified to SDK.
 * The VideoPlayer can ignore this call, if it already received this event directly from the application.
 * @param eEventType The enum value representing the event that occurred.
 */
- (void)yumeVideoPlayerHandleEvent:(YuMeEventType)eEventType errorInfo:(NSError **)ppError {
    NSLog(@"yumeVideoPlayerHandleEvent: Invoked.");
    if(eEventType == YuMeEventTypeParentViewResized) {
        NSLog(@"Handling SDK Event in Video Player, Event: PARENT_VIEW_RESIZED.");
    }
    NSLog(@"yumeVideoPlayerHandleEvent: Successful.");
}

/**
 * Sets the information relevant to all ad video creatives that belongs to a particular ad slot.
 * creativesInfoList[0] will be an NSMutableArray containing the list of video creatives' info related to ad 1,
 * creativesInfoList[1] will be an NSMutableArray containing the list of video creatives' info related to ad 2 etc.,
 * NOTE: The Video Player can pre-buffer the ad video creatives, if required.
 * It should never play any of the creatives automatically.
 * Also, there is no guarantee that the SDK will play all of the provided video creatives,
 * as some videos may be conditionally played based on user interaction etc.,
 * @param creativesInfoList1 Two dimensional array representing information relevant to all
 * ad video creatives that belongs to a particular ad slot.
 * Format: NSMutableArray<NSMutableArray<YuMeCreativeInfo>> creativesInfoList. */
- (void)yumeVideoPlayerSetCreativesInfo:(NSMutableArray *)creativesInfoList1 errorInfo:(NSError **)ppError {
    NSLog(@"yumeVideoPlayerSetCreativesInfo: Invoked.");
    
    if(creativesInfoList1 == nil) {
        NSLog(@"yumeVideoPlayerSetCreativesInfo(): Invalid Video Creative Url List.");
        return;
    }
    
    NSMutableArray *creativesInfoList = nil;
    creativesInfoList = [creativesInfoList1 copy];
    if(creativesInfoList != nil) {
        int noOfAds = creativesInfoList.count;
        NSLog(@"**********************************************************************");
        NSLog(@"yumeVideoPlayerSetCreativesInfo(): Video Creatives Info received:");
        NSLog(@"No. Of Ads with Video creatives: %d", noOfAds);
        NSMutableArray *adCreativesList = nil;
        for (int i = 0; i < noOfAds; i++) {
            adCreativesList = [creativesInfoList objectAtIndex:i];
            if(adCreativesList != nil) {
                YuMeCreativeInfo *creativeInfo = nil;
                int noOfCreatives = adCreativesList.count;
                NSLog(@"No. Of Video creatives in Ad (%d): %d", (i + 1), noOfCreatives);
                for (int j = 0; j < noOfCreatives; j++) {
                    NSLog(@"** Creative (%d) Info in Ad (%d): ", (j + 1), (i + 1));
                    creativeInfo = [adCreativesList objectAtIndex:j];
                    if(creativeInfo) {
                        NSLog(@"***** Url: %@", creativeInfo.pUrl);
                        NSLog(@"***** Duration: %d", creativeInfo.duration);
                        NSLog(@"***** bIsPlayConditional: %@", ((creativeInfo.bIsPlayConditional) ? @"TRUE" : @"FALSE"));
                    }
                }
            }
        }
        NSLog(@"**********************************************************************");
        [creativesInfoList release];
        creativesInfoList = nil;
    }
    NSLog(@"yumeVideoPlayerSetCreativesInfo: Successful.");
}


#pragma mark - Orientation change

- (void)orientationChange:(CGRect)frame
{
    [self setFrame:frame];
    
    if (videoAdView)
        [videoAdView.view setFrame:frame];
}

- (void)dealloc
{
    [videoAdView release]; videoAdView = nil;
    yumeSDKPlayerInterface = nil;
    [super dealloc];
}

- (void) removeSDKRefHandle {
    yumeSDKPlayerInterface = nil;
}

@end

