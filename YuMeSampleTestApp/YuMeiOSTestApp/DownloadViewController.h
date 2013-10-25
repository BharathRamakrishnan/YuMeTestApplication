//
//  DownloadViewController.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 4/5/13.
//
//

#import <UIKit/UIKit.h>

@interface DownloadViewController : UIViewController
{
    IBOutlet UIButton *btnClose;
    IBOutlet UILabel *downloadStatus;
    IBOutlet UILabel *downloadPercentage;
    
  	NSTimer *updateTimer;
}

- (void)startDownloadTimer;
- (IBAction)closeAction:(id)sender;
@end
