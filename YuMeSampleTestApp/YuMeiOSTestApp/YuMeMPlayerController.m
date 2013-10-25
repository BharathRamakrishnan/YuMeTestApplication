//
//  YuMeMoviePlayerController.m
//  YuMeiOSSDK
//
//  Created by Ratheesh TR on 5/8/13.
//  Copyright (c) 2013 YuMe. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "YuMeMPlayerController.h"

@implementation YuMeMPlayerController

@synthesize delegate;

- (id)initPlayerContoller:(NSString*)videoURL bIsLocalVideo:(BOOL)bIsLocalVideo frameSize:(CGSize)size delegate:(id <YuMeMPlayerDelegate>)_delegate
{
    NSURL *url = nil;
    if (bIsLocalVideo != YES)  {
        url = [NSURL URLWithString:videoURL];
    } else {
        url = [NSURL fileURLWithPath:videoURL];
    }
    
    self = [super initWithContentURL:url];
    if (self) {
        
        delegate                     = _delegate;
        self.view.frame              = CGRectMake(0, 0, size.width, size.height);
        self.controlStyle            = MPMovieControlStyleNone;
        self.scalingMode             = MPMovieScalingModeAspectFit;
        self.view.autoresizingMask   = UIViewAutoresizingNone;
        self.shouldAutoplay          = YES;
        
        [self prepareToPlay];
#if 0 // play audio even silent mode
        NSError *_error = nil;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &_error];
#endif
        // Mediaplayer notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDurationAvailableCallback:)
                                                     name:MPMovieDurationAvailableNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLoadStateDidChangeNotification:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMediaTypesAvailableNotification:)
                                                     name:MPMovieMediaTypesAvailableNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpMovieFinishReason:)
                                                     name:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey object:self];
        
     }
    return self;
}

- (void)movieDurationAvailableCallback:(NSNotification*)aNotification
{
    [delegate videoDuration:self.duration];
    [delegate isLoaded:YES];
}

// handle Orientation
- (void)orientationChange:(CGRect)frame
{
    [self.view setFrame:frame];
}

- (void)myMovieFinishedCallback:(NSNotification*)aNotification
{
	//yume_sdk_log(LOG_LEVEL_INFO, @"Ad finished callback received");
	MPMovieMediaTypeMask mask = self.movieMediaTypes;
    if (mask == MPMovieMediaTypeMaskNone) {
        return;
    } else {
        
        if (mask & MPMovieMediaTypeMaskAudio) {
            
        }
        
        if (mask & MPMovieMediaTypeMaskVideo) {
            
        }
    }
    
	// Make sure that tracker is not hit when play ends prematurely
	if (self.currentPlaybackTime >= self.duration) {
        [delegate isCompleted:YES];
	} else {
	}
}

- (void)myLoadStateDidChangeNotification:(NSNotification*)aNotification
{
	switch (self.loadState) {
		case MPMovieLoadStatePlayable:
            [delegate videoDuration:self.duration];
            [delegate isLoaded:YES];
			break;
		case MPMovieLoadStatePlaythroughOK:
            [delegate isPlaying:YES];
			break;
		case MPMovieLoadStateStalled:
            [delegate playBackError];;
			break;
		case MPMovieLoadStateUnknown:
			break;
		default:
			break;
	}
}

- (void)myMediaTypesAvailableNotification:(NSNotification*)aNotification {
}

- (void)mpMovieFinishReason:(NSNotification*)aNotification {
    
    int reason = [[[aNotification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        //movie finished playin
        [delegate isCompleted:YES];
    }else if (reason == MPMovieFinishReasonUserExited) {
        //user hit the done button
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        //error
        [delegate playBackError];
    }
}

- (void)removeNotification
{
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

