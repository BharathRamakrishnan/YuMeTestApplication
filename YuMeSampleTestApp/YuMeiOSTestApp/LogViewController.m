//
//  LogViewController.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 3/29/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "LogViewController.h"
#import "AppUtils.h"

@interface LogViewController ()

@end

NSFileHandle *logFile = nil;

@implementation LogViewController

@synthesize txtLogView;
@synthesize toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addToolBar];
    self.navigationController.navigationBarHidden = NO;
	self.view.frame = [[UIScreen mainScreen] applicationFrame];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
	txtLogView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    txtLogView.delegate = self;
    self.title = @"Log";
}

- (void)addToolBar
{
    CGRect mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation] ;
    // right side of nav bar
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, mainView.size.width, 44)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(backAction:)];
    backButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:backButton];
    [backButton release]; backButton = nil;
   
    [toolbar setItems:buttons animated:NO];
    toolbar.barStyle = UIToolbarPositionTop;
    [buttons release]; buttons = nil;
    [self.view addSubview:toolbar];
    [toolbar release]; toolbar = nil;
}

- (IBAction)backAction:(id)sender
{
    [self.view removeFromSuperview];
}

- (void)orientationChaged
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect mainView;
    //change sub view of scrollview accordingly to orientation
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        self.toolbar.frame = CGRectMake(0,0,mainView.size.width,44);
            self.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
    } else {
        mainView = [AppUtils getCurrentScreenBoundsDependOnOrientation];
        self.toolbar.frame = CGRectMake(0,0,mainView.size.width,44);
        self.view.frame = CGRectMake(0, 0, mainView.size.width, mainView.size.height);
    }
}

- (void)displayLog {
	NSString *logFile = [LogViewController getLogFilePath];
	if (logFile) {
		NSString *s = [NSString stringWithContentsOfFile:logFile encoding:NSUTF8StringEncoding error:nil];
		txtLogView.text = s;
	}
}

+ (NSString *)getLogFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		NSLog(@"Documents directory not found");
		return nil;
	}
	return [documentsDirectory stringByAppendingPathComponent:@"yume_log.txt"];
}

+ (void)createLogFile {
	if (logFile) {
		[logFile release]; logFile = nil;
	}
	
	NSString *filePath = [LogViewController getLogFilePath];
	if (filePath) {
		if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
			logFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
			[logFile retain];
		}
	}
}

+ (void)writeLog:(NSString *)aString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];
	NSDate *dt = [NSDate date];
	NSString *s = [NSString stringWithFormat:@"%@: ", [dateFormatter stringFromDate:dt]];
	[logFile writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];
	[dateFormatter release]; dateFormatter = nil;
	
	[logFile writeData:[aString dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *d = [NSData dataWithBytes:"\n" length:1];
	[logFile writeData:d];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[txtLogView release]; txtLogView = nil;
    [toolbar release]; toolbar = nil;
    [super dealloc];
}


@end
