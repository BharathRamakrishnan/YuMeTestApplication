//
//  SettingsViewController.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/28/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppSettings.h"
#import "YuMeViewController.h"
#import "AppUtils.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize txtAdServerURL;
@synthesize txtDomain;
@synthesize txtParams;
@synthesize txtAdTimeout;
@synthesize txtPlayTimeout;
@synthesize switchAutoSpeedDetect;
@synthesize switchHighBitRate;
@synthesize switchOrientationChange;
@synthesize switchPreroll;
@synthesize switchMidroll;
@synthesize switchPostroll;
@synthesize switchCaching;
@synthesize switchPrefetch;
@synthesize switchViewOption;
@synthesize txtdiskQuto;
@synthesize txtLogLevel;
@synthesize switchControlBar;
@synthesize switchVAST;
@synthesize switchOverrideOrientation;
@synthesize switchParentViewInfo;
@synthesize switchPrefetchExpired;
@synthesize switchSurvey;
@synthesize switchTTC;
@synthesize switchStreamingAds;
@synthesize switchPartialAssets;
@synthesize btnSave;
@synthesize btnCancel;
@synthesize switchPlayType;
@synthesize settingScrollView;
@synthesize scrollHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        scrollHeight         = 0;
        adSizeViewController = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollHeight = settingScrollView.frame.size.height;
    settingScrollView.contentSize = settingScrollView.frame.size;
    settingScrollView.frame = self.view.frame;
    [self.view addSubview:settingScrollView];
    
    [switchPlayType addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    txtAdServerURL.delegate = self;
	txtDomain.delegate = self;
	txtParams.delegate = self;
	txtAdTimeout.delegate = self;
	txtPlayTimeout.delegate = self;
    txtdiskQuto.delegate = self;
	txtLogLevel.delegate = self;
    
    UIToolbar *numberToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,44)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithNumberPad)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:flex, barButtonItem, nil];
    [numberToolbar setItems:items];
    [barButtonItem release]; barButtonItem = nil;
    [flex release]; flex = nil;
    [items release]; items = nil;
    
    txtAdTimeout.inputAccessoryView = numberToolbar;
    txtPlayTimeout.inputAccessoryView = numberToolbar;
    txtdiskQuto.inputAccessoryView = numberToolbar;
    txtLogLevel.inputAccessoryView = numberToolbar;
    [numberToolbar release]; numberToolbar = nil;
}

- (void)handleOrientation
{
    CGRect frame;
    frame  = txtAdServerURL.frame;
    frame.size.width = self.view.frame.size.width;
    txtAdServerURL.frame = frame;
    
    frame = txtDomain.frame;
    frame.size.width = self.view.frame.size.width;
    txtDomain.frame = frame;
    
    frame = txtParams.frame;
    frame.size.width = self.view.frame.size.width;
    txtParams.frame = frame;

#if 0
    frame = txtAdTimeout.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    txtAdTimeout.frame = frame;
    
    frame = txtPlayTimeout.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    txtPlayTimeout.frame = frame;
    
    frame = txtdiskQuto.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    txtdiskQuto.frame = frame;
    
    frame = txtLogLevel.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    txtLogLevel.frame = frame;
    
    frame = switchAutoSpeedDetect.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchAutoSpeedDetect.frame = frame;
    
    frame = switchHighBitRate.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchHighBitRate.frame = frame;
    
    frame = switchOrientationChange.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchOrientationChange.frame = frame;
    
    frame = switchPreroll.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchPreroll.frame = frame;
    
    frame = switchMidroll.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchMidroll.frame = frame;
    
    frame = switchPostroll.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchPostroll.frame = frame;
    
    frame = switchCaching.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchCaching.frame = frame;
    
    frame = switchPrefetch.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchPrefetch.frame = frame;
    
    frame = switchViewOption.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchViewOption.frame = frame;
    
    frame = switchControlBar.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchControlBar.frame = frame;
    
    frame = switchVAST.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchVAST.frame = frame;
    
    frame = switchOverrideOrientation.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchOverrideOrientation.frame = frame;
    
    frame = switchPlayType.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width;
    switchPlayType.frame = frame;
#endif
    
    frame = btnSave.frame;
    frame.origin.x = (self.view.frame.size.width / 2) + 20;
    btnSave.frame = frame;
    
    frame = btnCancel.frame;
    frame.origin.x = (self.view.frame.size.width / 2) - (frame.size.width) - 20;
    btnCancel.frame = frame;
   
    frame = label1.frame;
    frame.size.width = self.view.frame.size.width;
    label1.frame = frame;

    frame = label2.frame;
    frame.size.width = self.view.frame.size.width;
    label2.frame = frame;
    
    frame = label3.frame;
    frame.size.width = self.view.frame.size.width;
    label3.frame = frame;
    
    frame = label4.frame;
    frame.size.width = self.view.frame.size.width;
    label4.frame = frame;
    
    frame = label5.frame;
    frame.size.width = self.view.frame.size.width;
    label5.frame = frame;
    
    frame = label6.frame;
    frame.size.width = self.view.frame.size.width;
    label6.frame = frame;
    
    frame = label7.frame;
    frame.size.width = self.view.frame.size.width;
    label7.frame = frame;
    
    frame = label8.frame;
    frame.size.width = self.view.frame.size.width;
    label8.frame = frame;
}


- (void)orientationChanged
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect mainView;
    //change sub view of scrollview accordingly to orientation
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        self.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
        self.settingScrollView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height - 20);
        self.settingScrollView.contentSize = CGSizeMake(mainView.size.width, self.scrollHeight);
        [self handleOrientation];
    } else {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        self.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
        self.settingScrollView.frame = CGRectMake(0,0,mainView.size.width,mainView.size.height -20);
        self.settingScrollView.contentSize = CGSizeMake(mainView.size.width,self.scrollHeight);
        [self handleOrientation];
    }
}

- (void)refreshValues
{
	txtAdServerURL.delegate = self;
	txtDomain.delegate      = self;
	txtParams.delegate      = self;
	txtAdTimeout.delegate   = self;
	txtPlayTimeout.delegate = self;
    txtdiskQuto.delegate    = self;
	txtLogLevel.delegate    = self;
	
    AppSettings *a = [AppSettings readSettings];
    
    txtAdServerURL.text = a.adServerURL;
	txtDomain.text      = a.domain;
	txtParams.text      = a.params;
	txtAdTimeout.text   = a.adTimeOut;
	txtPlayTimeout.text = a.playTimeOut;
	txtdiskQuto.text    = a.diskQuto;
	txtLogLevel.text    = a.logLevel;
    
	switchAutoSpeedDetect.on            = a.isAutoSpeedDetect;
	switchHighBitRate.on                = a.isHighBitrate;
	switchOrientationChange.on          = a.isOrientationChange;
	switchPreroll.on                    = a.isPrerollEnabled;
	switchMidroll.on                    = a.isMidrollEnabled;
	switchPostroll.on                   = a.isPostrollEnabled;
    switchPrefetch.on                   = a.isautoPrefetchEnabled;
	switchViewOption.on                 = a.useSeparateViews;
	switchControlBar.on                 = a.isEnabledControlBar;
    switchCaching.on                    = a.iscachingEnabled;
    switchPrefetchExpired.on            = a.isPrefetchOnAdExpired;
    switchOverrideOrientation.on        = a.isOverrideOrientation;
    switchParentViewInfo.on             = a.isParentViewInfo;
    switchPlayType.selectedSegmentIndex = a.playTypeEnum;
    switchSurvey.on                     = a.isSurveyEnabled;
    switchTTC.on                        = a.isTTCEnable;
    switchStreamingAds.on               = a.isStreamingAdsEnabled;
    switchPartialAssets.on              = a.isShowPartialAssets;
    
    //YuMeInterface *sdk = [YuMeViewController getYuMeInterface];
	//switchCaching.on = [sdk yumeIsCacheEnabled];
}

- (IBAction)cancelAction:(id)sender
{
    [self.view removeFromSuperview];
}

- (IBAction)saveAction:(id)sender
{
	AppSettings *s = [AppSettings readSettings];
	
	s.adServerURL           = txtAdServerURL.text;
	s.domain                = txtDomain.text;
	s.params                = txtParams.text;
	s.adTimeOut             = txtAdTimeout.text;
	s.playTimeOut           = txtPlayTimeout.text;
    s.diskQuto              = txtdiskQuto.text;
    s.logLevel              = txtLogLevel.text;
	s.isAutoSpeedDetect     = switchAutoSpeedDetect.on;
	s.isHighBitrate         = switchHighBitRate.on;
    s.isEnabledControlBar   = switchControlBar.on;
	s.isOrientationChange   = switchOrientationChange.on;
	s.isPrerollEnabled      = switchPreroll.on;
	s.isMidrollEnabled      = switchMidroll.on;
	s.isPostrollEnabled     = switchPostroll.on;
    s.iscachingEnabled      = switchCaching.on;
    s.isautoPrefetchEnabled = switchPrefetch.on;
    s.isPrefetchOnAdExpired = switchPrefetchExpired.on;
    s.isOverrideOrientation = switchOverrideOrientation.on;
    s.isParentViewInfo      = switchParentViewInfo.on;
    NSInteger index         = switchPlayType.selectedSegmentIndex;
    s.playTypeEnum          = index;
    s.isSurveyEnabled       = switchSurvey.on;
    s.isTTCEnable           = switchTTC.on;
    s.isStreamingAdsEnabled = switchStreamingAds.on;
    s.isShowPartialAssets   = switchPartialAssets.on;

    //s.isVASTAdsEnabled      = switchVAST.on;
    
    [AppSettings saveSettings:s];
    [self.view removeFromSuperview];
}

- (IBAction)sizeAction:(id)sender
{
	if (!adSizeViewController) {
		adSizeViewController  = [[AdSizeViewController alloc] initWithNibName:@"AdSizeViewController" bundle:[AppUtils getNSBundle]];
        //		[adSizeViewController addTarget:self action:@selector(adSizeViewClosedAction:)];
	}
	[self.view addSubview:adSizeViewController.view];
    
    CGRect mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
    adSizeViewController.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
	[adSizeViewController updateValues];
}

#pragma UiSegmented Click Action
#pragma mark -

- (IBAction)segmentedControlValueChanged:(UISegmentedControl*)sender
{
#if 0
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[sender.subviews objectAtIndex:i]isSelected])
        {
            
            [[sender.subviews objectAtIndex:i] setTintColor:[UIColor blackColor]];
        }
        if ([[sender.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && ![[sender.subviews objectAtIndex:i] isSelected])
        {
            [[sender.subviews objectAtIndex:i] setTintColor:[UIColor whiteColor]];
        }
    }
#endif
}

#pragma TextField Delegate
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)doneWithNumberPad
{
    [txtAdTimeout resignFirstResponder];
    [txtPlayTimeout resignFirstResponder];
    [txtdiskQuto resignFirstResponder];
    [txtLogLevel resignFirstResponder];
}

- (void)deInitialize
{
    [txtAdServerURL release]; txtAdServerURL = nil;
    [txtDomain release]; txtDomain = nil;
    [txtParams release]; txtParams = nil;
    [txtAdTimeout release]; txtAdTimeout = nil;
    [txtPlayTimeout release]; txtPlayTimeout = nil;
    [txtdiskQuto release]; txtdiskQuto = nil;
    [txtLogLevel release]; txtLogLevel = nil;
    [switchAutoSpeedDetect release]; switchAutoSpeedDetect = nil;
    [switchHighBitRate release]; switchHighBitRate = nil;
    [switchOrientationChange release]; switchOrientationChange = nil;
    [switchPreroll release]; switchPreroll = nil;
    [switchMidroll release]; switchMidroll = nil;
    [switchPostroll release]; switchPostroll = nil;
    [switchCaching release]; switchCaching = nil;
    [switchPrefetch release]; switchPrefetch = nil;
    [switchViewOption release]; switchViewOption = nil;
    [switchControlBar release]; switchControlBar = nil;
    [switchVAST release]; switchVAST = nil;
    [switchOverrideOrientation release]; switchOverrideOrientation = nil;
    [switchParentViewInfo release]; switchParentViewInfo = nil;
    [switchPrefetchExpired release]; switchPrefetchExpired = nil;
    [switchPlayType release]; switchPlayType = nil;
    [switchSurvey release]; switchSurvey = nil;
    [switchTTC release]; switchTTC = nil;
    [switchStreamingAds release]; switchStreamingAds = nil;
    [switchPartialAssets release]; switchPartialAssets = nil;
    [btnSave release]; btnSave = nil;
    [btnCancel release]; btnCancel = nil;
    [settingScrollView release]; settingScrollView = nil;
}

- (void)dealloc
{
    [self deInitialize];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
