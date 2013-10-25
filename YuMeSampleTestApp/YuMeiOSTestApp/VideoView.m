//
//  VideoView.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "VideoView.h"
#import "LogViewController.h"

@implementation VideoView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        thePlayer  = nil;
        videoTimer = nil;
        delegate   = nil;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) play:(NSURL *)url
{
	thePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
	thePlayer.scalingMode = MPMovieScalingModeAspectFit;
	thePlayer.view.frame = self.bounds;
	thePlayer.fullscreen = NO;
	thePlayer.view.autoresizingMask = UIViewAutoresizingNone;
	[self addSubview:thePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification object:thePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myLoadStateDidChangeNotification:)
												 name:MPMoviePlayerLoadStateDidChangeNotification object:thePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMediaTypesAvailableNotification:)
												 name:MPMovieMediaTypesAvailableNotification object:thePlayer];
	[thePlayer play];
}

- (void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification object:thePlayer];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerLoadStateDidChangeNotification object:thePlayer];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMovieMediaTypesAvailableNotification object:thePlayer];
    
	[LogViewController writeLog:@"Content completed"];
    thePlayer.fullscreen = FALSE;
	[thePlayer.view removeFromSuperview];
    [thePlayer release]; thePlayer = nil;
	[delegate contentCompleted];
}

- (void)myLoadStateDidChangeNotification:(NSNotification*)aNotification
{
	//	[self writeLog:@"Content load state notification"];
}

- (void)myMediaTypesAvailableNotification:(NSNotification*)aNotification
{
	//	[self writeLog:@"Content media type available notification"];
}

- (void)contentCompleted
{
    // do nothing
}

- (BOOL)isAdPlaying
{
	return TRUE;
}

- (BOOL)allowOrientationChange
{
	return TRUE;
}

- (void)orientationChanged
{
	if (thePlayer) {
		//thePlayer.view.frame = self.bounds;
        AppSettings *settings = [AppSettings readSettings];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIDeviceOrientationIsPortrait(orientation)) {
            thePlayer.view.frame = settings.adRectPortrait;
        } else {
            thePlayer.view.frame = settings.adRectLandscape;
        }
	}
}

- (AppSettings *)getSettings
{
	return nil;
}

@end
