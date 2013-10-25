//
//  VideoPlayerController.h
//  YuMeiOSSDK
//
//  Created by Ratheesh TR on 5/8/13.
//  Copyright (c) 2013 YuMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuMeMPlayerController.h"
#import "YuMeVideoPlayerInterface.h"

@interface VideoPlayerController : UIView <YuMeMPlayerDelegate>
{
    NSInteger                   videoDuration;
    YuMeMPlayerController       *videoAdView;
    YuMeVideoPlayerInterface    *yumeSDKPlayerInterface;
    BOOL                        isPaused;
}

- (void)orientationChange:(CGRect)frame;

- (void) removeSDKRefHandle;

@end
