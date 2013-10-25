//
//  VideoView.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdViewDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoView : UIView<AdViewDelegate>
{
    MPMoviePlayerController *thePlayer;
    
	// The timer used for timing out struck Videos.
	NSTimer *videoTimer;
    
	id delegate;

}

@property (nonatomic, assign) id delegate;

- (void)play:(NSURL *)url;
- (void)orientationChanged;

@end
