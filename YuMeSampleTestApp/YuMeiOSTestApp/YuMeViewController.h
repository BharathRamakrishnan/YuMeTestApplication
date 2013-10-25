//
//  YuMeViewController.h
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuMeTypes.h"
#import "VideoView.h"
#import "YuMeInterface.h"
#import "SettingsViewController.h"
#import "LogViewController.h"
#import "DownloadViewController.h"
#import "AboutViewController.h"


typedef enum {
    YuMeBtnTypeNone,
    YuMeBtnTypeInitAd,
    YuMeBtnTypeShowAd,
    YuMeBtnTypeStartAd,
    YuMeBtnTypePlayAd,
    YuMeBtnTypeMenu,
    YuMeBtnTypeAdMenu
} YuMeBtnTypeEnum;

@interface YuMeViewController : UIViewController<UIActionSheetDelegate>
{
    AboutViewController *avc;
    SettingsViewController *svc;
    LogViewController *lvc;
    DownloadViewController *dvc;
    AppSettings *settings;

    IBOutlet UIButton *btnInit;
    IBOutlet UIButton *btnInitAd;
    IBOutlet UIButton *btnShowAd;
    IBOutlet UIButton *btnStartAd;
    IBOutlet UIButton *btnPlayAd;
    IBOutlet UIButton *btnModifyParams;
    IBOutlet UIButton *btnGetParams;
    IBOutlet UIButton *btnDeInit;
    IBOutlet UIButton *btnSettings;
    IBOutlet UIButton *btnAbout;
    IBOutlet UIButton *btnViewLog;
    IBOutlet UIButton *btnYuMeAPIs;
    UIButton *sideBarBtn;
    
    IBOutlet UIScrollView *homeScrollView;

    YuMeBtnTypeEnum menuType;
	YuMeAdType yumeAdType;
    
    int count;
    
	BOOL contentPlaying;
	BOOL isPlayingStartAd;
    BOOL adPlaying;
    
    VideoView *videodisplayView;
    VideoView *adView;	// Ads display video view
	VideoView *commonView;	// Common display video view for both ads and content
	VideoView *contentView;	// Contetnt display video view
    
    UIView *adMaskView;
    
    UIActivityIndicatorView *spinnerView;
}


/* UI Button click handlers */
- (IBAction)btnInitPressed:(UIButton *)sender;
- (IBAction)btnInitAdPressed:(UIButton *)sender;
- (IBAction)btnShowAdPressed:(UIButton *)sender;
- (IBAction)btnStartAdPressed:(UIButton *)sender;
- (IBAction)btnModifyParamsPressed:(UIButton *)sender;
- (IBAction)btnGetParamsPressed:(UIButton *)sender;
- (IBAction)btnDeInitPressed:(UIButton *)sender;
- (IBAction)btnSettingsPressed:(UIButton *)sender;
- (IBAction)btnAboutPressed:(UIButton *)sender;
- (IBAction)btnViewLogPressed:(UIButton *)sender;
- (IBAction)btnPlayAdPressed:(id)sender;
- (IBAction)btnYuMeAPIsPressed:(id)sender;
- (void)playShowAd:(YuMeAdType)eAdType;
- (void)hideVideoView;
- (void)adCompleted;
- (void)addToolBar;

+ (YuMeInterface *) getYuMeInterface;

@end
