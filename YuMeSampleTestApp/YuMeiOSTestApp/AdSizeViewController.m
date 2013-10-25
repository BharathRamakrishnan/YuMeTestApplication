//
//  AdSizeViewController.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "AdSizeViewController.h"
#import "AppUtils.h"
#import "AppSettings.h"

@interface AdSizeViewController ()

@end

@implementation AdSizeViewController
@synthesize txtX;
@synthesize txtY;
@synthesize txtWidth;
@synthesize txtHeight;
@synthesize lblMaxWidth;
@synthesize lblMaxHeight;

@synthesize txtX2;
@synthesize txtY2;
@synthesize txtWidth2;
@synthesize txtHeight2;
@synthesize lblMaxWidth2;
@synthesize lblMaxHeight2;

@synthesize adSizeScrollView;

- (void)initialize
{
    adRectPortraitX         = 0.0;
	adRectPortraitY         = 0.0;
	adRectPortraitWidth     = 0.0;
	adRectPortraitHeight    = 0.0;
	
	adRectLandscapeX        = 0.0;
	adRectLandscapeY        = 0.0;
	adRectLandscapeWidth    = 0.0;
	adRectLandscapeHeight   = 0.0;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    adSizeScrollView.contentSize = adSizeScrollView.frame.size;
    adSizeScrollView.frame = self.view.frame;
    [self.view addSubview:adSizeScrollView];
    
    
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
    
    txtX.inputAccessoryView = numberToolbar;
    txtY.inputAccessoryView = numberToolbar;
    txtWidth.inputAccessoryView = numberToolbar;
    txtHeight.inputAccessoryView = numberToolbar;
    txtX2.inputAccessoryView = numberToolbar;
    txtY2.inputAccessoryView = numberToolbar;
    txtWidth2.inputAccessoryView = numberToolbar;
    txtHeight2.inputAccessoryView = numberToolbar;
    [numberToolbar release]; numberToolbar = nil;

    
    // Do any additional setup after loading the view from its nib.
}

-(void)doneWithNumberPad
{
    [txtX resignFirstResponder];
    [txtY resignFirstResponder];
    [txtWidth resignFirstResponder];
    [txtHeight resignFirstResponder];
    [txtX2 resignFirstResponder];
    [txtY2 resignFirstResponder];
    [txtWidth2 resignFirstResponder];
    [txtHeight2 resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (IBAction)saveAction:(id)sender
{
    //	[target performSelector:action withObject:TRUE];
	
    AppSettings *s = [AppSettings readSettings];
    
	CGRect r = [self getPortraitValues];
	adRectPortraitX = r.origin.x;
	adRectPortraitY = r.origin.y;
	adRectPortraitWidth = r.size.width;
	adRectPortraitHeight = r.size.height;
	
	CGSize maxValues = [AppUtils getMaxAdViewBoundsInPortrait];
	
	if (adRectPortraitWidth == 0) {
		adRectPortraitWidth = maxValues.width;
	}
	
	if (adRectPortraitHeight == 0) {
		adRectPortraitHeight = maxValues.height;
	}
	
	r = [self getLandscapeValues];
	adRectLandscapeX = r.origin.x;
	adRectLandscapeY = r.origin.y;
	adRectLandscapeWidth = r.size.width;
	adRectLandscapeHeight = r.size.height;
	
	maxValues = [AppUtils getMaxAdViewBoundsInLandscape];
	
	if (adRectLandscapeWidth== 0) {
		adRectLandscapeWidth = maxValues.width;
	}
	
	if (adRectLandscapeHeight== 0) {
		adRectLandscapeHeight = maxValues.height;
	}
    
	s.adRectPortrait = CGRectMake(adRectPortraitX, adRectPortraitY, adRectPortraitWidth, adRectPortraitHeight);
	s.adRectLandscape = CGRectMake(adRectLandscapeX, adRectLandscapeY, adRectLandscapeWidth, adRectLandscapeHeight);
	
	[AppSettings saveSettings:s];
	
    [self.view removeFromSuperview];
}

- (IBAction)cancelAction:(id)sender {
    //	[target performSelector:action withObject:FALSE];
	//[self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
}


- (void)updateValues {
	AppSettings *s = [AppSettings readSettings];
    
	txtX.delegate = txtY.delegate = txtWidth.delegate = txtHeight.delegate = self;
	txtX2.delegate = txtY2.delegate = txtWidth2.delegate = txtHeight2.delegate = self;
	
	txtX.text = [[NSNumber numberWithFloat:s.adRectPortrait.origin.x] stringValue];
	txtY.text = [[NSNumber numberWithFloat:s.adRectPortrait.origin.y] stringValue];
	txtWidth.text = [[NSNumber numberWithFloat:s.adRectPortrait.size.width] stringValue];
	txtHeight.text = [[NSNumber numberWithFloat:s.adRectPortrait.size.height] stringValue];
    
	txtX2.text = [[NSNumber numberWithFloat:s.adRectLandscape.origin.x] stringValue];
	txtY2.text = [[NSNumber numberWithFloat:s.adRectLandscape.origin.y] stringValue];
	txtWidth2.text = [[NSNumber numberWithFloat:s.adRectLandscape.size.width] stringValue];
	txtHeight2.text = [[NSNumber numberWithFloat:s.adRectLandscape.size.height] stringValue];
	
	CGSize maxValues = [AppUtils getMaxAdViewBoundsInPortrait];
	
	lblMaxWidth.text = [NSString stringWithFormat:@"%6.2f", maxValues.width];
	lblMaxHeight.text = [NSString stringWithFormat:@"%6.2f", maxValues.height];
    
	maxValues = [AppUtils getMaxAdViewBoundsInLandscape];
	
	lblMaxWidth2.text = [NSString stringWithFormat:@"%6.2f", maxValues.width];
	lblMaxHeight2.text = [NSString stringWithFormat:@"%6.2f", maxValues.height];
}

- (CGRect)getPortraitValues {
	return CGRectMake([txtX.text floatValue], [txtY.text floatValue], [txtWidth.text floatValue], [txtHeight.text floatValue]);
}

- (CGRect)getLandscapeValues {
	return CGRectMake([txtX2.text floatValue], [txtY2.text floatValue], [txtWidth2.text floatValue], [txtHeight2.text floatValue]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)deIntialize
{
    [txtX release]; txtX = nil;
	[txtY release]; txtY = nil;
	[txtWidth release]; txtWidth = nil;
	[txtHeight release]; txtHeight = nil;
	[lblMaxHeight release]; lblMaxHeight = nil;
	[lblMaxWidth release]; lblMaxWidth = nil;
    
	[txtX2 release]; txtX2 = nil;
	[txtY2 release]; txtY2 = nil;
	[txtWidth2 release]; txtWidth2 = nil;
	[txtHeight2 release]; txtHeight2 = nil;
	[lblMaxHeight2 release]; lblMaxHeight2 = nil;
	[lblMaxWidth2 release]; lblMaxWidth2 = nil;
    
    [adSizeScrollView release]; adSizeScrollView = nil;
    [displayStatusBar release]; displayStatusBar = nil;
}

- (void)dealloc
{
    [self deIntialize];
    [super dealloc];
}

@end
