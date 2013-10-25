//
//  YuMeMoviePlayerController.h
//  YuMeiOSSDK
//
//  Created by Ratheesh TR on 5/8/13.
//  Copyright (c) 2013 YuMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol YuMeMPlayerDelegate <NSObject>

@optional
- (void)isLoaded:(BOOL)flag;
- (void)isPlaying:(BOOL)flag;
- (void)isCompleted:(BOOL)flag;
- (void)videoDuration:(NSInteger)duration;
- (void)playBackError;

@end


@interface YuMeMPlayerController : MPMoviePlayerController
{
    id <YuMeMPlayerDelegate>    delegate;
}

@property(nonatomic, assign)id <YuMeMPlayerDelegate>    delegate;

- (id)initPlayerContoller:(NSString*)videoURL bIsLocalVideo:(BOOL)bIsLocalVideo frameSize:(CGSize)size delegate:(id <YuMeMPlayerDelegate>)_delegate;

- (void)orientationChange:(CGRect)frame;

- (void)removeNotification;

@end
