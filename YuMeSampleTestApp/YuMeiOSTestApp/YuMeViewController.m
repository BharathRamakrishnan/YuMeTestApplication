//
//  YuMeViewController.m
//  YuMeiOSTestApp
//
//  Created by Senthil on 01/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "AppUtils.h"
#import "YuMeViewController.h"
#import "Toast.h"
#import "YuMeAppDelegate.h"

@interface YuMeViewController ()

@end

@implementation YuMeViewController

static YuMeInterface *pYuMeInterface = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 		[LogViewController createLogFile];
        
        adView = [[VideoView alloc] initWithFrame:CGRectZero];
		adView.delegate = self;
		
		contentView = [[VideoView alloc] initWithFrame:CGRectZero];
		contentView.delegate = self;
		
        commonView = [[VideoView alloc] initWithFrame:CGRectZero];
		commonView.delegate = self;
        
        adMaskView = [[UIView alloc] initWithFrame:CGRectZero];
		
        commonView.backgroundColor  = [UIColor blackColor];
		adView.backgroundColor      = [UIColor blackColor];
		contentView.backgroundColor = [UIColor clearColor];
        adMaskView.backgroundColor  = [UIColor blackColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice]setProximityMonitoringEnabled:NO];
	[[UIApplication sharedApplication]setStatusBarHidden:YES];

    pYuMeInterface = [[YuMeInterface alloc] init];
    pYuMeInterface.delegate = self;
    
    homeScrollView.contentSize = homeScrollView.frame.size;
    homeScrollView.frame = self.view.frame;
    [self.view addSubview:homeScrollView];
    
    [self performSelectorOnMainThread:@selector(initAppSetup) withObject:nil waitUntilDone:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown; //supported orientations
}

- (BOOL)shouldAutorotate
{
    if (settings == nil) {
        return YES;
    }
    
    if (settings.isOrientationChange)
        return YES;
    else
        return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES; //Default YES
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES; //Default YES
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (settings.isOrientationChange)
        return YES;
    else
        return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self resizeControls];
    
    CGRect mainView;
    //change sub view of scrollview accordingly to orientation
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        homeScrollView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height - 20);
        homeScrollView.contentSize = CGSizeMake(mainView.size.width,mainView.size.height - 20);
    } else {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        homeScrollView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height -20);
        homeScrollView.contentSize = CGSizeMake(mainView.size.width,mainView.size.width- 20);
    }
    
    if (!pYuMeInterface.adPlaying)
		[videodisplayView orientationChanged];
    
    if (avc)
        [avc orientationChanged];
    
    if (lvc)
        [lvc orientationChaged];
    
    if (svc)
        [svc orientationChanged];
}

- (void) dealloc {
    if (avc != nil) {
        [avc release]; avc = nil;
    }
    
    if (svc != nil) {
        [svc release]; svc = nil;
    }
    
    if (lvc != nil) {
        [lvc release]; lvc = nil;
    }
    
    if (dvc != nil) {
        [dvc release]; dvc = nil;
    }
    
    if(adView != nil) {
        [adView release]; adView = nil;
    }
        
    if(contentView != nil) {
        [contentView release]; contentView = nil;
    }
    
    if(commonView != nil) {
        [commonView release]; commonView = nil;
    }
    
    if (adMaskView != nil) {
        [adMaskView release]; adMaskView = nil;
    }
    
    [super dealloc];
}

#pragma App Internal functions
#pragma mark -

- (void)initAppSetup
{
    if (settings == nil) {
        settings = [AppSettings readSettings];
        pYuMeInterface.settings = settings;
        [settings retain];
    }
}

- (IBAction)btnInitPressed:(UIButton *)sender {
    if(pYuMeInterface) {
        YuMeAdParams *params = [[YuMeAdParams alloc] init];
        params.pAdServerUrl                 = settings.adServerURL;
  		params.pDomainId                    = settings.domain;
		params.pAdditionalParams            = settings.params;
		params.adTimeout                    = [settings.adTimeOut intValue];
		params.videoTimeout                 = [settings.playTimeOut intValue];
		params.storageSize                  = [settings.diskQuto floatValue];
        params.bEnableAutoPrefetch          = settings.isautoPrefetchEnabled;
        params.bEnableCaching               = settings.iscachingEnabled;
        params.bEnableCBToggle              = settings.isEnabledControlBar;
        params.bSupportAutoNetworkDetect    = settings.isAutoSpeedDetect;
        params.bSupportHighBitRate          = settings.isHighBitrate;
        params.bOverrideOrientation         = settings.isOverrideOrientation;
        params.ePlayType                    = settings.playTypeEnum;
        params.bSupportSurvey               = settings.isSurveyEnabled;
        params.bEnableTTC                   = settings.isTTCEnable;
        params.bAutoPlayStreamingAds        = YES; //settings.isStreamingAdsEnabled;
        
        // plain video
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=7585";
        
        // plain image
        //http://qa-web-001.sjc1.yumenetworks.com/ 7LypsvFpV
        //params.pAdditionalParams = @"placement_id=10576&advertisement_id=10295";
        
        // 1st Gen Mobile Connect
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=4293";
        
        // 2nd Gen Mobile Connect
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=5418";
        
        // 1st Gen Mobile BillBoard
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=4294";
        
        // 2nd Gen Mobile BillBoard
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=7813";
        
        // Mobile Tap
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=7183";
        
        // Mobile Swipe
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=7223";
        
        // Wrapper
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=5479";
        
        // Click 2 Video
        //http://qa-web-001.sjc1.yumenetworks.com 7LypsvFpV
        //params.pAdditionalParams = @"placement_id=10576&advertisement_id=10296";
        
        // Server side vast traslation
        //params.pAdServerUrl = @"http://172.18.4.144/~prakash/mobile/svast/";
        
        // Ad Coverage domain Id
        //params.pDomainId = @"1463xHTGXBBE";
        
        //params.pAdServerUrl = @"http://shadow01.yumenetworks.com/";
        // params.pDomainId =  @"211yCcbVJNQ";
        //params.pAdditionalParams = @"placement_id=2222";*/

        //params.pAdServerUrl = @"http://172.18.4.139/~ratheeshtr/psd/2/";
        //params.pAdServerUrl = @"http://172.18.4.144/~prakash/utest/rev/";
        //params.pAdServerUrl = @"http://172.18.4.50/~senthil/";
        
        //params.pDomainId = @"211FklAwnKZ";
        //params.pAdditionalParams = @"placement_id=5571&advertisement_id=7183";
        
        //params.pAdServerUrl = @"http://172.18.4.144/~prakash/utest/orientation/3";
        //params.pAdServerUrl = @"http://172.18.4.144/~prakash/utest/zindex/";
        //params.pAdServerUrl = @"http://172.18.4.34/~senthil/9.0.0.6/ad_coverage/";
        
        BOOL bResult = [pYuMeInterface yumeInit:params];
        if (bResult) {
            [pYuMeInterface yumeSetLogLevel:[settings.logLevel intValue]];
            
            // Update the Auto Play Streaming tag
            AppSettings *s = [AppSettings readSettings];
            s.isStreamingAdsEnabled = params.bAutoPlayStreamingAds;
            [AppSettings saveSettings:s];
        }
        
        [params release]; params = nil;
    }
}

- (IBAction)btnInitAdPressed:(UIButton *)sender
{
    [self showAdOptions:YuMeBtnTypeInitAd title:@"Select Ad Type"];
}

- (IBAction)btnShowAdPressed:(UIButton *)sender
{
    [self showAdOptions:YuMeBtnTypeShowAd title:@"Select Ad Type"];
}

- (IBAction)btnStartAdPressed:(UIButton *)sender
{
    if (settings.isStreamingAdsEnabled) {
        [self startPlay];
    } else {
        [self showAdOptions:YuMeBtnTypeStartAd title:@"Select Ad Type"];
    }
}

- (IBAction)btnPlayAdPressed:(id)sender
{
    [self showAdOptions:YuMeBtnTypePlayAd title:@"Select Ad Type"];
    //[self playAd];
}

- (IBAction)btnModifyParamsPressed:(UIButton *)sender
{
    if(pYuMeInterface) {
        //TODO: get the ad params stored in the settings screen
        YuMeAdParams *params = [[YuMeAdParams alloc] init];
        /*params.pAdServerUrl = @"http://shadow01.yumenetworks.com/";
         params.pDomainId =  @"704oIaHzpGu";
         params.storageSize = 3;*/
    
        params.pAdServerUrl                 = settings.adServerURL;
		params.pDomainId                    = settings.domain;
		params.pAdditionalParams            = settings.params;
		params.adTimeout                    = [settings.adTimeOut intValue];
		params.videoTimeout                 = [settings.playTimeOut intValue];
		params.storageSize                  = [settings.diskQuto floatValue];
        params.bEnableAutoPrefetch          = settings.isautoPrefetchEnabled;
        params.bEnableCaching               = settings.iscachingEnabled;
        params.bEnableCBToggle              = settings.isEnabledControlBar;
        params.bSupportAutoNetworkDetect    = settings.isAutoSpeedDetect;
        params.bSupportHighBitRate          = settings.isHighBitrate;
        params.ePlayType                    = settings.playTypeEnum;
        params.bOverrideOrientation         = settings.isOverrideOrientation;
        params.ePlayType                    = settings.playTypeEnum;
        params.bSupportSurvey               = settings.isSurveyEnabled;
        params.bEnableTTC                   = settings.isTTCEnable;
        params.bAutoPlayStreamingAds        = settings.isStreamingAdsEnabled;

        BOOL b = [pYuMeInterface yumeModifyParams:params];
        if (b) {
            // Update the Auto Play Streaming tag
            AppSettings *s = [AppSettings readSettings];
            s.isStreamingAdsEnabled = params.bAutoPlayStreamingAds;
            [AppSettings saveSettings:s];
        }
        
        //[pYuMeInterface yumeSetCacheEnabled:settings.iscachingEnabled];
        //[pYuMeInterface yumeSetAutoPrefetch:settings.isautoPrefetchEnabled];
        //[pYuMeInterface yumeSetControlBarToggle:settings.isEnabledControlBar];

        [params release]; params = nil;
    }
}

- (IBAction)btnGetParamsPressed:(UIButton *)sender
{
    if(pYuMeInterface) {
        YuMeAdParams *adParams = [pYuMeInterface yumeGetAdParams];
        
        if (!adParams)
            return;
        
        NSString *paramText = nil;
        @try {
            
            paramText = [NSString stringWithFormat:@"adServerUrl: %@ \ndomainId: %@ \nqsParams: %@ \nadTimeout: %d \nvideoTimeout: %d \nbSupportAutoNetworkDetect: %d \nbEnableCaching: %d \nbEnableAutoPrefetch: %d \nstorageSize: %f \nbEnableCBToggle: %d \nbSurvey: %d \nbOverrideOrientation: %d \nePlayType: %d  \nbEnableTTC: %d \nbAutoPlayStreamingAds: %d", adParams.pAdServerUrl, adParams.pDomainId, adParams.pAdditionalParams , adParams.adTimeout , adParams.videoTimeout , adParams.bSupportAutoNetworkDetect, adParams.bEnableCaching, adParams.bEnableAutoPrefetch, adParams.storageSize, adParams.bEnableCBToggle, adParams.bSupportSurvey , adParams.bOverrideOrientation, adParams.ePlayType, adParams.bEnableTTC, adParams.bAutoPlayStreamingAds];
        }
        @catch (NSException *exception) {
            // do nothing
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YuMe Ad Params" message:paramText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release]; alertView = nil;
    }
}

- (IBAction)btnDeInitPressed:(UIButton *)sender
{
    if(pYuMeInterface)
        [pYuMeInterface yumeDeInit];
}

- (IBAction)btnSettingsPressed:(UIButton *)sender
{
    if (!svc)
        svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[AppUtils getNSBundle]];
    [self.view addSubview:svc.view];
    
    if (svc) {
        CGRect mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        svc.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
        [svc refreshValues];
        [svc handleOrientation];
    }
}

- (IBAction)btnAboutPressed:(UIButton *)sender
{
    if(!avc)
        avc = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:[AppUtils getNSBundle]];
    [self.view addSubview:avc.view];
    
    if (avc) {
        CGRect mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        avc.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
    }
}

- (IBAction)btnViewLogPressed:(UIButton *)sender
{
    if(!lvc)
        lvc = [[LogViewController alloc] initWithNibName:@"LogViewController" bundle:[AppUtils getNSBundle]];
    [self.view addSubview:lvc.view];
    
    if (lvc) {
        CGRect mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        lvc.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
        [lvc displayLog];
    }
}

- (void)showAdOptions:(YuMeBtnTypeEnum)type title:(NSString *)title
{
	menuType = type;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel"
													otherButtonTitles:@"Preroll",
								  @"Midroll",
								  @"Postroll",
								  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:self.view];
	[actionSheet release]; actionSheet = nil;
}

- (IBAction)btnYuMeAPIsPressed:(id)sender
{
    menuType = YuMeBtnTypeMenu;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"YuMe SDK APIs"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"PauseDownload",
                                  @"ResumeDownload",
                                  @"AbortDownload",
                                  @"GetDownloadPercentage",
                                  @"ClearCache",
                                  @"ClearCookies",
                                  @"GetDownloadStatus",
                                  @"SetCacheEnabled",
                                  @"ResetCacheEnabled",
                                  @"IsCacheEnabled",
                                  @"SetAutoPrefetch",
                                  @"ResetAutoPrefetch",
                                  @"IsAutoPrefetchEnabled",
                                  @"SetControlBarToggle",
                                  @"ResetControlBarToggle",
                                  @"SetParentView",
                                  @"StopAd",
                                  @"HandleEvent(Resize)",
                                  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet release]; actionSheet = nil;
}

- (void)startPlay
{
	if (!contentPlaying) {
		[LogViewController writeLog:@"Requesting a Preroll Ad..."];
		count = 0;
		if ([self requestAdForType:YuMeAdTypePreroll prefetch:NO]) {
			isPlayingStartAd = TRUE;
		} else {
			[LogViewController writeLog:@"Ad request failed"];
		}
	} else {
		NSString *errString = @"Content is playing.";
        [AppUtils displayToast:errString];
	}
}

- (BOOL)requestAdForType:(YuMeAdType)type prefetch:(BOOL)prefetch
{
	//NSError *err = nil;
	YuMeAdType modifiedType = type;
    
    [self setAdView];
	[self showAdVideoView];
	
    switch (type) {
		case YuMeAdTypePreroll:
			if (!settings.isPrerollEnabled) {
				modifiedType = YuMeAdTypeNone;
			} 
			break;
		case YuMeAdTypeMidroll:
			if (!settings.isMidrollEnabled) {
				modifiedType = YuMeAdTypeNone;
			}
			break;
		case YuMeAdTypePostroll:
			if (!settings.isPostrollEnabled) {
				modifiedType = YuMeAdTypeNone;
			}
			break;
		default:
			break;
	}
	
	pYuMeInterface = [YuMeViewController getYuMeInterface];
    
    yumeAdType = modifiedType;

    BOOL b = FALSE;
	if (!prefetch) {
        b = [pYuMeInterface yumeStartAd:modifiedType];
		if (!b) {
            if (!pYuMeInterface.adPlaying) {
                [self hideVideoView];
            }
        }
	}
	return b;
}

- (void)resizeControls
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect mainView;
    
    //change sub view of scrollview accordingly to orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (UIDeviceOrientationIsPortrait(orientation)) {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        if (adMaskView)
            adMaskView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height);
        
        if (videodisplayView)
            videodisplayView.frame = settings.adRectPortrait;
        
        if (sideBarBtn)
            sideBarBtn.frame = CGRectMake(appFrame.origin.x, (appFrame.size.height/2) - (sideBarBtn.frame.size.height/2), 30, 30);
    } else {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        if (adMaskView)
            adMaskView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height);
        
        if (videodisplayView)
            videodisplayView.frame = settings.adRectLandscape;
        
        if (sideBarBtn)
            sideBarBtn.frame = CGRectMake((appFrame.size.width/2)-(sideBarBtn.frame.size.height/2) , 0, 30, 30);
    }
}


#pragma Ad and Content View
#pragma mark -

- (void)setAdView
{
	if (settings.useSeparateViews)
		videodisplayView = adView;
	else
		videodisplayView = commonView;
    
    [self resizeControls];
    [pYuMeInterface yumeSetParentView:videodisplayView viewController:self];
}

- (void)addToolBar
{
    [self hideLoading];
    
    UIImage *buttonImage = [UIImage imageNamed:@"info.png"];
    sideBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sideBarBtn setImage:buttonImage forState:UIControlStateNormal];
    [sideBarBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    YuMeAppDelegate *delegate = (YuMeAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate window] addSubview:sideBarBtn];
    [[delegate window] bringSubviewToFront:sideBarBtn];

    [self resizeControls];
}

- (void)menuAction:(id)sender
{
    menuType = YuMeBtnTypeAdMenu;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"YuMe SDK APIs"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"StopAd",
                                  @"SetParentView",
                                  @"StartAd",
                                  @"InitAd",
                                  @"ShowAd",
                                  @"PlayAd",
                                  @"ClearCache",
                                  @"Full Screen Mode",
                                  @"PauseDownload",
                                  nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet release]; actionSheet = nil;
}


- (void)addMaskView
{
    if (adMaskView == nil) {
        adMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        adMaskView.backgroundColor  = [UIColor blackColor];
    }
    [self.view addSubview:adMaskView];
}

- (void)showAdVideoView
{
    [self addMaskView];
    [self resizeControls];
    [self.view addSubview:videodisplayView];
    [self showLoading];
}

- (void)showContentVideoView
{
    if (settings.useSeparateViews)
		videodisplayView = adView;
	else
		videodisplayView = commonView;
    
    [self addMaskView];
    [self resizeControls];
    [self.view addSubview:videodisplayView];
}

- (void)hideVideoView
{
	if(videodisplayView) {
        [self hideLoading];
        
        if (sideBarBtn != nil) {
            [sideBarBtn removeFromSuperview];
            sideBarBtn = nil;
        }
        
        if (adMaskView != nil) {
            [adMaskView removeFromSuperview];
            [adMaskView release];  adMaskView = nil;
        }
 
		[videodisplayView removeFromSuperview];
		//videodisplayView = nil;
	}
}

- (void)adCompleted
{
    [self hideVideoView];
    
    if (isPlayingStartAd) {
        //[self playContent];
        [self performSelectorOnMainThread:@selector(playContent) withObject:nil waitUntilDone:NO];
    }
}

#pragma ActionSheet Delegate
#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (menuType)
    {
        case YuMeBtnTypeInitAd :
            if (buttonIndex == 1) {
                if(pYuMeInterface)
                    [pYuMeInterface yumeInitAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 2) {
                if(pYuMeInterface)
                    [pYuMeInterface yumeInitAd:YuMeAdTypeMidroll];
            } else if (buttonIndex == 3) {
                if(pYuMeInterface)
                    [pYuMeInterface yumeInitAd:YuMeAdTypePostroll];
            }
            break;
            
        case YuMeBtnTypeShowAd :
            if (buttonIndex == 1) {
                [self playShowAd:YuMeAdTypePreroll];
            } else if(buttonIndex == 2) {
                [self playShowAd:YuMeAdTypeMidroll];
            } else if (buttonIndex == 3) {
                [self playShowAd:YuMeAdTypePostroll];
            }
            break;

        case YuMeBtnTypeStartAd :
            if (buttonIndex == 1) {
                if(pYuMeInterface)
                    [pYuMeInterface yumeStartAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 2) {
                if(pYuMeInterface)
                    [pYuMeInterface yumeStartAd:YuMeAdTypeMidroll];
            } else if (buttonIndex == 3) {
                if(pYuMeInterface)
                    [pYuMeInterface yumeStartAd:YuMeAdTypePostroll];
            }
            
            break;
            
        case YuMeBtnTypePlayAd :
            if (buttonIndex > 0) {
                [self setAdView];
                [self showAdVideoView];
            }
            BOOL b = FALSE;
            if (buttonIndex == 1) {
                if(pYuMeInterface)
                    b = [pYuMeInterface yumePlayAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 2) {
                if(pYuMeInterface)
                    b = [pYuMeInterface yumePlayAd:YuMeAdTypeMidroll];
            } else if (buttonIndex == 3) {
                if(pYuMeInterface)
                    b = [pYuMeInterface yumePlayAd:YuMeAdTypePostroll];
            }
            if (!b) {
                [self hideVideoView];
            }
            break;
            
        case YuMeBtnTypeMenu :
            if (buttonIndex == 1) {
                [pYuMeInterface yumePauseDownload];
                //[LogViewController writeLog:@"PauseDownload is called."];
            } else if (buttonIndex == 2) {
                [pYuMeInterface yumeResumeDownload];
                //[LogViewController writeLog:@"ResumeDownload is called."];
            } else if (buttonIndex == 3) {
                [pYuMeInterface yumeAbortDownload];
                //[LogViewController writeLog:@"AbortDownload is called."];
            } else if (buttonIndex == 4) {
                [pYuMeInterface yumeGetDownloadedPercentage];
                //[LogViewController writeLog:@"GetDownload is called."];
                if (!dvc)
                    dvc = [[DownloadViewController alloc] initWithNibName:@"DownloadViewController" bundle:[AppUtils getNSBundle]];
                dvc.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
                [self presentModalViewController:dvc animated:YES];
                [dvc startDownloadTimer];
            } else if (buttonIndex == 5) {
                [pYuMeInterface yumeClearCache];
                //[LogViewController writeLog:@"ClearCache is called."];
            }  else if (buttonIndex == 6) {
                [pYuMeInterface yumeClearCookies];
                //[LogViewController writeLog:@"ClearCookies is called."];
            } else if (buttonIndex == 7) {
                NSString *downString = [NSString stringWithFormat:@"Current Download state: %@", [pYuMeInterface yumeGetDownloadStatus]];
                [AppUtils displayToast: downString];
            } else if (buttonIndex == 8) {
                [pYuMeInterface yumeSetCacheEnabled:TRUE];
                AppSettings *a = [AppSettings readSettings];
                a.iscachingEnabled = TRUE;
                [AppSettings saveSettings:a];
            } else if (buttonIndex == 9) {
                [pYuMeInterface yumeSetCacheEnabled:FALSE];
                AppSettings *a = [AppSettings readSettings];
                a.iscachingEnabled = FALSE;
                [AppSettings saveSettings:a];
            } else if (buttonIndex == 10) {
                [pYuMeInterface yumeIsCacheEnabled];
            } else if (buttonIndex == 11) {
                [pYuMeInterface yumeSetAutoPrefetch:YES];
                AppSettings *a = [AppSettings readSettings];
                a.isautoPrefetchEnabled = TRUE;
                [AppSettings saveSettings:a];
            } else if (buttonIndex == 12) {
                [pYuMeInterface yumeSetAutoPrefetch:FALSE];
                AppSettings *a = [AppSettings readSettings];
                a.isautoPrefetchEnabled = FALSE;
                [AppSettings saveSettings:a];
            } else if (buttonIndex == 13) {
                [pYuMeInterface yumeIsAutoPrefetchEnabled];
            }  else if (buttonIndex == 14) {
                [pYuMeInterface yumeSetControlBarToggle:TRUE];
                AppSettings *a = [AppSettings readSettings];
                a.isEnabledControlBar = TRUE;
                [AppSettings saveSettings:a];
            } else if (buttonIndex == 15) {
                [pYuMeInterface yumeSetControlBarToggle:FALSE];
                AppSettings *a = [AppSettings readSettings];
                a.isEnabledControlBar = FALSE;
                [AppSettings saveSettings:a];
            } else if (buttonIndex == 16) {
                //if (pYuMeInterface)
                [pYuMeInterface yumeSetParentView:nil viewController:nil];
            } else if (buttonIndex == 17) {
                [pYuMeInterface yumeStopAd];
                pYuMeInterface.adPlaying = FALSE;
                [self adCompleted];
            } else if (buttonIndex == 18) {
                [pYuMeInterface yumeHandleEvent:YuMeEventTypeParentViewResized];
            }
            break;
            
        case YuMeBtnTypeAdMenu:
            if (buttonIndex == 1) {
                [pYuMeInterface yumeStopAd];
                pYuMeInterface.adPlaying = FALSE;
                [self adCompleted];
            } else if (buttonIndex == 2) {
                [pYuMeInterface yumeSetParentView:adView viewController:self];
            } else if (buttonIndex == 3) {
                [pYuMeInterface yumeStartAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 4) {
                [pYuMeInterface yumeInitAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 5) {
                [pYuMeInterface yumeShowAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 6) {
                [pYuMeInterface yumePlayAd:YuMeAdTypePreroll];
            } else if (buttonIndex == 7) {
                [pYuMeInterface yumeClearCache];
            } else if (buttonIndex == 8) {
                [self resizeAParentAdViewSize];
                [pYuMeInterface yumeHandleEvent:YuMeEventTypeParentViewResized];
            } else if (buttonIndex == 9) {
                [pYuMeInterface yumePauseDownload];
            }
            break;

        case YuMeBtnTypeNone:
            break;
    }
}

- (void)resizeAParentAdViewSize {
    if(videodisplayView) {
        if(videodisplayView) {
            AppSettings *s = [AppSettings readSettings];
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (UIDeviceOrientationIsPortrait(orientation)) {
                if(CGRectEqualToRect(videodisplayView.frame,s.adRectPortrait)) {
                    CGRect adView1 = s.adRectPortrait;
                    adView1.origin.x += 20;
                    adView1.origin.y += 20;
                    adView1.size.width -= 100;
                    adView1.size.height -= 100;
                    videodisplayView.frame = adView1;
                } else {
                    videodisplayView.frame = s.adRectPortrait;
                }
            } else {
                if(CGRectEqualToRect(videodisplayView.frame,s.adRectLandscape)) {
                    CGRect adView1 = settings.adRectLandscape;
                    adView1.origin.x += 20;
                    adView1.origin.y += 20;
                    adView1.size.width -= 100;
                    adView1.size.height -= 100;
                    videodisplayView.frame = adView1;
                } else {
                    videodisplayView.frame = s.adRectLandscape;
                }
            }
        }
    }
}

+ (YuMeInterface *) getYuMeInterface
{
    return pYuMeInterface;
}

- (void)playShowAd:(YuMeAdType)eAdType
{
    [self setAdView];
    [self showAdVideoView];
    if(pYuMeInterface) {
        BOOL b = [pYuMeInterface yumeShowAd:eAdType];
        if (!b) {
            [self hideVideoView];
        }
    }
}

- (void)playContent
{
	[self playNext];
}

- (void)playNext
{
    switch (yumeAdType) {
		case YuMeAdTypePreroll:
            NSLog(@"Playing content 1");
			[LogViewController writeLog:@"Playing content 1"];
			count = 0;
			[self showContentVideoView];
			contentPlaying = YES;
			[videodisplayView play:[self localMovieURL:@"one" type:@"m4v"]];
			break;
			
		case YuMeAdTypeMidroll:
            NSLog(@"Playing content 2");
			[LogViewController writeLog:@"Playing content 2"];
			[self showContentVideoView];
			contentPlaying = YES;
			[videodisplayView play:[self localMovieURL:@"two" type:@"m4v"]];
			break;
			
		default:
            NSLog(@"Playing content - default");
            if (count == 0) {
                if (!settings.isPrerollEnabled) {
                    [LogViewController writeLog:@"Playing content 1"];
                    count = 0;
                    [self showContentVideoView];
                    contentPlaying = YES;
                    [videodisplayView play:[self localMovieURL:@"one" type:@"m4v"]];
                }
            } else {
                [LogViewController writeLog:@"Done"];
                [self hideVideoView];
                contentPlaying = NO;
            }
			break;
	}
}

- (NSURL *)localMovieURL:(NSString *)name type:(NSString *)type
{
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		NSString *moviePath = [bundle pathForResource:name	ofType:type];
		if (moviePath)
		{
			return [NSURL fileURLWithPath:moviePath];
		}
	}
    return nil;
}

- (void)contentCompleted
{
	[self hideVideoView];
	contentPlaying = NO;
	if (count == 0) {
        if (settings.isMidrollEnabled) {
            [LogViewController writeLog:@"Requesting a Midroll Ad..."];
            if ([self requestAdForType:YuMeAdTypeMidroll prefetch:NO]) {
                isPlayingStartAd = TRUE;
            }
        } else {
            yumeAdType = YuMeAdTypeMidroll;
            [self playContent];
		}
		count++;
	} else {
        if (settings.isPostrollEnabled) {
            [LogViewController writeLog:@"Requesting a Postroll Ad..."];
            if ([self requestAdForType:YuMeAdTypePostroll prefetch:NO]) {
                isPlayingStartAd = TRUE;
            }
        }
	}
}

- (void)showLoading
{
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinnerView.center = videodisplayView.center;
        spinnerView.hidesWhenStopped = YES;
        [videodisplayView addSubview:spinnerView];
        [spinnerView startAnimating];
    }
}

- (void)hideLoading
{
    if (spinnerView != nil) {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
        [spinnerView release]; spinnerView = nil;
    }
}


@end
