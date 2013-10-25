//
//  LogViewController.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController<UITextViewDelegate>
{
    UITextView *txtLogView;
    UIToolbar *toolbar;
}

@property (nonatomic, retain) IBOutlet UITextView *txtLogView;
@property (nonatomic, retain) UIToolbar *toolbar;

- (void)displayLog;
- (void)orientationChaged;

+ (NSString *)getLogFilePath;
+ (void)createLogFile;
+ (void)writeLog:(NSString *)aString;


@end
