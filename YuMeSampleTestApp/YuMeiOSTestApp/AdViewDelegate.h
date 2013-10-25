//
//  AdViewDelegate.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/30/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSettings.h"

@protocol AdViewDelegate <NSObject>

- (void)contentCompleted;
- (BOOL)isAdPlaying;
- (BOOL)allowOrientationChange;
- (void)orientationChanged;
- (AppSettings *)getSettings;

@end
