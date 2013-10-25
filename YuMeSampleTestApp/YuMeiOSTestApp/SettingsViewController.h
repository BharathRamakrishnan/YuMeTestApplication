//
//  SettingsViewController.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/28/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdSizeViewController.h"

@interface SettingsViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *settingScrollView;
    
    IBOutlet UITextField *txtAdServerURL;
	IBOutlet UITextField *txtDomain;
	IBOutlet UITextField *txtParams;
	IBOutlet UITextField *txtAdTimeout;
	IBOutlet UITextField *txtPlayTimeout;
    IBOutlet UITextField *txtdiskQuto;
	
	IBOutlet UISwitch *switchAutoSpeedDetect;
	IBOutlet UISwitch *switchHighBitRate;
	IBOutlet UISwitch *switchOrientationChange;
    IBOutlet UISwitch *switchPreroll;
	IBOutlet UISwitch *switchMidroll;
	IBOutlet UISwitch *switchPostroll;
    IBOutlet UISwitch *switchCaching;
	IBOutlet UISwitch *switchPrefetch;
	IBOutlet UISwitch *switchControlBar;
    IBOutlet UISwitch *switchVAST;
    IBOutlet UISwitch *switchOverrideOrientation;
    IBOutlet UISwitch *switchParentViewInfo;
    IBOutlet UISwitch *switchPrefetchExpired;
    IBOutlet UISwitch *switchSurvey;
    IBOutlet UISwitch *switchTTC;
    IBOutlet UISwitch *switchStreamingAds;
    IBOutlet UISwitch *switchPartialAssets;
    
    IBOutlet UISegmentedControl *switchPlayType;
    
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnCancel;
    
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UILabel *label5;
    IBOutlet UILabel *label6;
    IBOutlet UILabel *label7;
    IBOutlet UILabel *label8;
    
    float scrollHeight;
    
    AdSizeViewController *adSizeViewController;
}

@property (nonatomic, retain) IBOutlet UITextField *txtAdServerURL;
@property (nonatomic, retain) IBOutlet UITextField *txtDomain;
@property (nonatomic, retain) IBOutlet UITextField *txtParams;
@property (nonatomic, retain) IBOutlet UITextField *txtAdTimeout;
@property (nonatomic, retain) IBOutlet UITextField *txtPlayTimeout;
@property (nonatomic, retain) IBOutlet UITextField *txtdiskQuto;
@property (nonatomic, retain) IBOutlet UITextField *txtLogLevel;
@property (nonatomic, retain) IBOutlet UISwitch *switchAutoSpeedDetect;
@property (nonatomic, retain) IBOutlet UISwitch *switchHighBitRate;
@property (nonatomic, retain) IBOutlet UISwitch *switchOrientationChange;
@property (nonatomic, retain) IBOutlet UISwitch *switchPreroll;
@property (nonatomic, retain) IBOutlet UISwitch *switchMidroll;
@property (nonatomic, retain) IBOutlet UISwitch *switchPostroll;
@property (nonatomic, retain) IBOutlet UISwitch *switchCaching;
@property (nonatomic, retain) IBOutlet UISwitch *switchPrefetch;
@property (nonatomic, retain) IBOutlet UISwitch *switchViewOption;
@property (nonatomic, retain) IBOutlet UISwitch *switchControlBar;
@property (nonatomic, retain) IBOutlet UISwitch *switchVAST;
@property (nonatomic, retain) IBOutlet UISwitch *switchOverrideOrientation;
@property (nonatomic, retain) IBOutlet UISwitch *switchParentViewInfo;
@property (nonatomic, retain) IBOutlet UISwitch *switchPrefetchExpired;
@property (nonatomic, retain) IBOutlet UISwitch *switchSurvey;
@property (nonatomic, retain) IBOutlet UISwitch *switchTTC;
@property (nonatomic, retain) IBOutlet UISwitch *switchStreamingAds;
@property (nonatomic, retain) IBOutlet UISwitch *switchPartialAssets;
@property (nonatomic, retain) IBOutlet UISegmentedControl *switchPlayType;
@property (nonatomic, retain) IBOutlet UIButton *btnSave;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UIScrollView *settingScrollView;
@property (nonatomic) float scrollHeight;

- (void)refreshValues;
- (IBAction)saveAction:(id)sender;
- (IBAction)sizeAction:(id)sender;
- (void)handleOrientation;
- (void)orientationChanged;

@end
