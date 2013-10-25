//
//  AdSizeViewController.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/30/13.
//
//

#import <UIKit/UIKit.h>

@interface AdSizeViewController : UIViewController <UITextFieldDelegate> {
	// For Portrait
	UITextField *txtX;
	UITextField *txtY;
	UITextField *txtWidth;
	UITextField *txtHeight;
    
	// For Landsscape
	UITextField *txtX2;
	UITextField *txtY2;
	UITextField *txtWidth2;
	UITextField *txtHeight2;
	
	// For Portrait
	UILabel *lblMaxWidth;
	UILabel *lblMaxHeight;
	
	// For Landsscape
	UILabel *lblMaxWidth2;
	UILabel *lblMaxHeight2;
	
	float adRectPortraitX;
	float adRectPortraitY;
	float adRectPortraitWidth;
	float adRectPortraitHeight;
	
	float adRectLandscapeX;
	float adRectLandscapeY;
	float adRectLandscapeWidth;
	float adRectLandscapeHeight;
    
    IBOutlet UIScrollView *adSizeScrollView;
    IBOutlet UISwitch *displayStatusBar;
}

@property (nonatomic, retain) IBOutlet UITextField *txtX;
@property (nonatomic, retain) IBOutlet UITextField *txtY;
@property (nonatomic, retain) IBOutlet UITextField *txtWidth;
@property (nonatomic, retain) IBOutlet UITextField *txtHeight;
@property (nonatomic, retain) IBOutlet UILabel *lblMaxWidth;
@property (nonatomic, retain) IBOutlet UILabel *lblMaxHeight;

@property (nonatomic, retain) IBOutlet UITextField *txtX2;
@property (nonatomic, retain) IBOutlet UITextField *txtY2;
@property (nonatomic, retain) IBOutlet UITextField *txtWidth2;
@property (nonatomic, retain) IBOutlet UITextField *txtHeight2;
@property (nonatomic, retain) IBOutlet UILabel *lblMaxWidth2;
@property (nonatomic, retain) IBOutlet UILabel *lblMaxHeight2;

@property (nonatomic, retain) IBOutlet UIScrollView *adSizeScrollView;

- (IBAction)saveAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

- (void)updateValues;

- (CGRect)getPortraitValues;
- (CGRect)getLandscapeValues;

@end
