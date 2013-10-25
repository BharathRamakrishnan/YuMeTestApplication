//
//  AboutViewController.m
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "AboutViewController.h"
#import "AppUtils.h"
#import "YuMeViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize aboutScrollView;

- (void)dealloc
{
    [aboutScrollView release]; aboutScrollView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aboutScrollView.contentSize = aboutScrollView.frame.size;
    aboutScrollView.frame = self.view.frame;
    [self.view addSubview:aboutScrollView];

    
    YuMeInterface *yumeInterface = [YuMeViewController getYuMeInterface];
    yumeSDKVersion.text = [[yumeSDKVersion text] stringByAppendingString:[yumeInterface yumeGetVersion]] ;
    //yumePlayerVersion.text = [[yumePlayerVersion text] stringByAppendingString:@"NA"] ;
    //yumeBSPVersion.text = [[yumeBSPVersion text] stringByAppendingString:@"NA"] ;
    
    NSString *s = [NSString stringWithFormat:@"YuMe Test Application Version: %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	yumeTstAppVersion.text = s;
	
	// checks for EventKit Framework added or not (Tap to Calendar)
    Class eventClass = NSClassFromString(@"EKEvent");
	if (!eventClass)
		eventKitLabel.text = @"Tap to Calendar: OFF";
    else
        eventKitLabel.text = @"Tap to Calendar: ON";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOKPressed:(UIButton *)sender
{
    [self.view removeFromSuperview];
}

- (void)orientationChanged
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect mainView;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        self.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
        self.aboutScrollView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height - 20);
    } else {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        self.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
        self.aboutScrollView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height -20);
    }
}


@end