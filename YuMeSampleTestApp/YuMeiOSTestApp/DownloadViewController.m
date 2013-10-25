//
//  DownloadViewController.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 4/5/13.
//
//

#import "DownloadViewController.h"
#import "YuMeViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)startDownloadTimer
{
	[self stopDownloadTimer]; // In case already running
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(getDownloadTimerEvent:)
                                                 userInfo:nil
                                                  repeats:NO];
	[updateTimer retain];
}

- (void)stopDownloadTimer
{
	if (updateTimer) {
		//NSLog(@"Stopping retry download timer");
		if ([updateTimer isValid])
			[updateTimer invalidate];
		[updateTimer release]; updateTimer = nil;
	}
}

- (void)getDownloadTimerEvent:(NSTimer*)theTimer
{
	YuMeInterface *yumeInterface = [YuMeViewController getYuMeInterface];
    if (yumeInterface == nil)
        return;

    NSString *status =  [yumeInterface yumeGetDownloadStatus];
	downloadStatus.text = [NSString stringWithFormat:@"Download Status : %@", status];
    
    if ([status isEqual:@"DOWNLOADS_IN_PROGRESS"])
        [self startDownloadTimer];
    
	downloadPercentage.text =[NSString stringWithFormat:@"Downloaded Percentage: %.2f",[yumeInterface yumeGetDownloadedPercentage]];
}

- (IBAction)closeAction:(id)sender
{
    [self stopDownloadTimer];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
