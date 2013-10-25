//
//  AboutViewController.h
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
    IBOutlet UILabel *yumeSDKVersion;
    IBOutlet UILabel *yumeBSPVersion;
    IBOutlet UILabel *yumePlayerVersion;
    IBOutlet UILabel *yumeTstAppVersion;
    IBOutlet UILabel *eventKitLabel;
    
    IBOutlet UIButton *btnOK;
    IBOutlet UIScrollView *aboutScrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *aboutScrollView;

- (IBAction)btnOKPressed:(UIButton *)sender;
- (void)orientationChanged;

@end
