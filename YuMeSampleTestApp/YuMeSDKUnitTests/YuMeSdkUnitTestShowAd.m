//
//  YuMeSdkUnitTestShowAd.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestShowAd.h"
#import "YuMeSdkUnitUtils.h"
#import "YuMeViewController.h"

@implementation YuMeSdkUnitTestShowAd

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return YES;
}

- (void)setUpClass {
    // Run at start of all tests in the class
    NSLog(@"######################## RUN START - SetUpClass #######################################");
    
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    NSLog(@"######################## RUN END - TeatDownClass #######################################");
}

- (void)setUp {
    // Run before each test method
    NSLog(@"************************ Unit Test - SetUp ************************");
    
    pYuMeTestInterface = [YuMeSdkUnitUtils getYuMeInterface];
    
    if(kUSE_OWN_VIDEOPLAYER) {
        if(videoController == nil)
            videoController = [[VideoPlayerController alloc] init];
    }
    
    if (pYuMeTestInterface)
        yumeSDK = [pYuMeTestInterface getYuMeSDKHandle];
    
    if (testCaseResult == nil)
        testCaseResult = [[NSMutableDictionary alloc] init];
    
}

- (void)tearDown {
    // Run after each test method
    if (yumeSDK) {
        [yumeSDK yumeSdkDeInit:&pError];
    }
    
    if (pYuMeTestInterface) {
        [pYuMeTestInterface release]; pYuMeTestInterface = nil;
    }
    
    if (kUSE_OWN_VIDEOPLAYER) {
        [videoController release]; videoController = nil;
    }
    if (testCaseResult) {
        [testCaseResult release]; testCaseResult = nil;
    }
    
    pError = nil;
    
    NSLog(@"************************ Unit Test - TearDown ************************");
}

// Override any exceptions; By default exceptions are raised, causing a test failure
- (void)failWithException:(NSException *)exception {
    
}

- (void)showAdEventListener:(NSArray *)userInfo {
    NSString *sel = [userInfo objectAtIndex:0];
    NSString *event = [userInfo objectAtIndex:1];
    
    BOOL b = [YuMeSdkUnitUtils yumeEventListenerLock:event];
    if (b)
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(sel)];
    else
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(sel)];
}


/**
 >> SDK State: Not Initialized
 
 >> Called when SDK is not initialized.
 
 >> 1. Throws Exception: "YuMeSDK_ShowAd(): YuMe SDK is not Initialized."
 */
- (void)testUseCase_ShowAd001 {
    
    // Create the resultArray
    if (resultArray)
        [resultArray release]; resultArray = nil;
    
    if (resultArray == nil)
        resultArray = [[NSMutableArray alloc] init];
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    GHAssertFalse([yumeSDK yumeSdkDeInit:&pError], @"YuMeSDK_DeInit(): YuMe SDK is not Initialized.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/**
 >> SDK State: Initialized
 Caching: ON/OFF
 Auto-Prefetch: ON/OFF
 
 >> Called with invalid ad block type. (e.g) YUME_ADBLOCKTYPE_NONE.
 
 >> 1. Throws Exception: "YuMeSDK_ShowAd(): Invalid Ad Block Type."
 */

- (void)testUseCase_ShowAd002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];

    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypeNone
                               errorInfo:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): Invalid Ad Block Type.", @"");
        GHTestLog(@"Result : %@", str);
    }

}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// Previous ad operation (startad / showad) is in progress.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_ShowAd(): Previous Ad Play in Progress."
// 2. Ad play continues.
- (void)testUseCase_ShowAd003 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL; // @"http://172.18.4.119/~bharath/test/"; 
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self waitForTimeout:2];
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll
                               errorInfo:&pError], @"yumeSdkShowAd Successful.");
    GHTestLog(@"yumeSdkShowAd Called.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHTestLog(@"Result : %@", str);
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): Previous Ad Play in Progress.", @"");
    }
    
    [self waitForTimeout:2];
    GHAssertTrue([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd Successful.");
    
    GHTestLog(@"yumeSdkStopAd Called.");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// Parent view not set.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_ShowAd(): Parent View Not Set for displaying the Ad."
- (void)testUseCase_ShowAd004 {

    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"NA for Latest iOS SDK." userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// No network connection.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_ShowAd(): No Network Connection available."
- (void)testUseCase_ShowAd005 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    /*
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl =  @"http://172.18.4.119/~bharath/test/";
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/GAIA.framework"];
    [b load];
    Class SKTelephonyController = NSClassFromString(@"SKTelephonyController");
    id tc = [SKTelephonyController sharedInstance];
    
    NSLog(@"-- myPhoneNumber: %@", [tc myPhoneNumber]);
    NSLog(@"-- imei: %@", [tc imei]);
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll
                               errorInfo:&pError], @"yumeSdkShowAd Successful.");
    GHTestLog(@"yumeSdkShowAd Called.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHTestLog(@"Result : %@", str);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");

    [self waitForTimeout:10];
     */
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Please execute the test manually without Network Connection." userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// No Prefetch operation of the given ad block type attempted earlier.

/* Expected behavior */
// 1. Hits the Generic Empty tracker. (e.g)  http://shadow01.yumenetworks.com/static_register_unfilled_request.gif?domain=211yCcbVJNQ&width=480&height=800&sdk_ver=4.0.2.9&platform=Android&make=samsung&model=GT-I9100&sw_ver=2.3.3&slot_type=PREROLL
// 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
- (void)testUseCase_ShowAd006 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl =  VALID_200_OK_PL;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll
                               errorInfo:&pError], @"yumeSdkShowAd Successful.");
    GHTestLog(@"yumeSdkShowAd Called.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHTestLog(@"Result : %@", str);
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): Previous Ad Play in Progress.", @"");
    }
}

/**
 >> SDK State: Initialized
 Caching: ON/OFF
 Auto-Prefetch: ON/OFF
 
 >> Prefetched ad is present but empty.
 
 >> 1. Hits the Unfilled tracker received in the playlist.
 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
 */

- (void)testUseCase_ShowAd007 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_VALID_PL;
    params.bEnableAutoPrefetch = FALSE;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is not Successful.");

    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady Fired");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"ShowAd is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: OFF (OR) (Caching: ON & StorageSize: 0.0 MB)
// Auto-Prefetch: OFF

/* Usecase */
// Prefetched ad is present but assets are not cached. NOTE: All / Some of the assets of the current playlist may already have been cached during previous prefetch operations.

/* Expected behavior */
// 1. Stops the ad expiry timer.
// 2. Hits the Filled tracker received in the playlist.
// 3. Plays the ad from network (uses cached assets, if available) .
// 4. Notifies AD_PLAYING event.
// 5. Hits the impression trackers received in the playlist, at appropriate times.
// 6. Notifies AD_COMPLETED event, on ad completion.
- (void)testUseCase_ShowAd008 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    params.storageSize = 0.0;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    GHTestLog(@"YuMeAdEventAdReady Fired.");
   
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    
   /* YuMeViewController *viewController =  nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController = [[[YuMeViewController alloc] initWithNibName:@"YuMeViewController_iPhone" bundle:nil] autorelease];
    } else {
        viewController = [[[YuMeViewController alloc] initWithNibName:@"YuMeViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = viewController;

    //[viewController.view addSubview:adView];
    
    NSLog(@">> %@", self.window.rootViewController);
    
    [self.window addSubview:adView];
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkSetParentView:adView viewController:viewController errorInfo:&pError], @"yumeSdkSetParentView Successful");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }*/
        
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self waitForTimeout:2];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: OFF (OR) (Caching: ON & StorageSize: 0.0 MB)
// Auto-Prefetch: ON

/* Usecase */
// Prefetched ad is present but assets are not cached. NOTE: All / Some of the assets of the current playlist may already have been cached during previous prefetch operations.

/* Expected behavior */
// 1. Stops the ad expiry timer.
// 2. Hits the Filled tracker received in the playlist.
// 3. Plays the ad from network (uses cached assets, if available) .
// 4. Notifies AD_PLAYING event.
// 5. Hits the impression trackers received in the playlist, at appropriate times.
// 6. On ad completion,
// 6a) Notifies AD_COMPLETED event.
// 6b) auto prefetches a new playlist from the server and handles the new playlist response.
- (void)testUseCase_ShowAd009 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
    params.storageSize = 0.0;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    GHTestLog(@"YuMeAdEventAdReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self waitForTimeout:2];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:5];
}

/**
 >> SDK State: Initialized
 Caching: ON
 Auto-Prefetch: ON/OFF
 
 >> Asset Download operation in progress.
 
 >> 1. Hits the Filled tracker received in the playlist.
 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present."
 */

- (void)testUseCase_ShowAd010 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is Successful.");
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    GHTestLog(@"yumeSdkGetDownloadStatus : %u", downloadStatus);
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: OFF

/* Usecase */
// Assets are downloaded and ready for playing.

/* Expected behavior */
// 1. Stops the ad expiry timer.
// 2. Hits the Filled tracker received in the playlist.
// 3. Plays the ad from cache.
// 4. Notifies AD_PLAYING event.
// 5. Hits the impression trackers received in the playlist, at appropriate times.
// 6. Notifies AD_COMPLETED event, on ad completion.
- (void)testUseCase_ShowAd011 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON

/* Usecase */
// Assets are downloaded and ready for playing.

/* Expected behavior */
// 1. Stops the ad expiry timer.
// 2. Hits the Filled tracker received in the playlist.
// 3. Plays the ad from cache.
// 4. Notifies AD_PLAYING event.
// 5. Hits the impression trackers received in the playlist, at appropriate times.
// 6. On ad completion,
// 6a) Notifies AD_COMPLETED event.
// 6b) auto prefetches a new playlist from the server and handles the new playlist response.
- (void)testUseCase_ShowAd012 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];

}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// No unplayed ad exists in cache (the ad fetched previously is played already).

/* Expected behavior */
// 1. Hits the Generic Empty tracker. (e.g)  http://shadow01.yumenetworks.com/static_register_unfilled_request.gif?domain=211yCcbVJNQ&width=480&height=800&sdk_ver=4.0.2.9&platform=Android&make=samsung&model=GT-I9100&sw_ver=2.3.3&slot_type=PREROLL
// 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
- (void)testUseCase_ShowAd013 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];

    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
    GHTestLog(@"yumeSdkShowAd Failed.");
    
}

/**
 >> SDK State: Initialized
 Caching: ON/OFF
 Auto-Prefetch: ON
 
 >> Ad in cache is expired.
 
 >> 1. Hits the Unfilled tracker received in the playlist.
 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
 3. Makes a new prefetch request to the server.
 4. Handles the response received.
 */

- (void)testUseCase_ShowAd014 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is Successful.");
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:110];

    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
    GHTestLog(@"YuMeAdEventAdExpired Fired.");

    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Failed.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/**
 >> SDK State: Initialized
 Caching: ON/OFF
 Auto-Prefetch: OFF
 
 >> Ad in cache is expired.
 
 >> 1. Hits the Unfilled tracker received in the playlist.
 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present."
 */

- (void)testUseCase_ShowAd015 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is Successful.");
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:110];
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
    GHTestLog(@"YuMeAdEventAdExpired Fired.");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
    [self waitForTimeout:2];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: OFF

/* Usecase */
// Prefetched ad present but the downloads are aborted.

/* Expected behavior */
// 1. Hits the Filled tracker received in the playlist.
// 2. Plays the ad from network (uses cached assets, if available) .
// 3. Notifies AD_PLAYING event.
// 4. Hits the impression trackers received in the playlist, at appropriate times.
// 5. On ad completion,
// 5a) Notifies AD_COMPLETED event.
- (void)testUseCase_ShowAd016 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    [yumeSDK yumeSdkClearCache:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    GHTestLog(@"YuMeAdEventAdReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkAbortDownload:&pError], @"yumeSdkAbortDownload Successful.");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkAbortDownload Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self waitForTimeout:2];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
//Auto-Prefetch: ON

/* Usecase */
// Prefetched ad present but the downloads are aborted.

/* Expected behavior */
// 1. Hits the Filled tracker received in the playlist.
// 2. Plays the ad from network (uses cached assets, if available) .
// 3. Notifies AD_PLAYING event.
// 4. Hits the impression trackers received in the playlist, at appropriate times.
// 5. On ad completion,
// 5a) Notifies AD_COMPLETED event.
// 5b) auto prefetches a new playlist from the server and handles the new playlist response.
- (void)testUseCase_ShowAd017 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    [yumeSDK yumeSdkClearCache:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    GHTestLog(@"YuMeAdEventAdReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkAbortDownload:&pError], @"yumeSdkAbortDownload Successful.");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkAbortDownload Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:5];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];
}


/**
 >> SDK State: Initialized
 Caching: ON
 Auto-Prefetch: OFF
 
 >> Prefetched ad present but asset downloading failed.
 
 >> 1. Hits the Filled tracker received in the playlist.
 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
 */

- (void)testUseCase_ShowAd018 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_404_PL;
    params.bEnableAutoPrefetch = FALSE;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is Successful.");
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: OFF

/* Usecase */
// Prefetched ad present but asset downloading failed.

/* Expected behavior */
// 1. Hits the Filled tracker received in the playlist.
// 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
- (void)testUseCase_ShowAd019 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_FILLED_404_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    [yumeSDK yumeSdkClearCache:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    
    GHTestLog(@"YuMeAdEventAdError Fired.");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// ShowAd called in the following condition:
// a. Previous InitAd request returned a valid filled response but none of the required assets were present.

/* Expected behavior */
// 1. Hits the Filled tracker received in the playlist.
// 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
- (void)testUseCase_ShowAd020 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Fired.");

    [yumeSDK yumeSdkClearCache:&pError];
    GHTestLog(@"yumeSdkClearCache Fired.");

    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// ShowAd called in any of the following conditions:
// a. Previous InitAd request timed out.
// b. Previous InitAd request returned a non-200 OK response.
// c. Previous InitAd request returned an invalid empty response.
// d. Previous InitAd request returned an invalid filled response.

/* Expected behavior */
// 1. Hits the Generic Empty tracker.(e.g)  http://shadow01.yumenetworks.com/static_register_unfilled_request.gif?domain=211yCcbVJNQ&width=480&height=800&sdk_ver=4.0.2.9&platform=Android&make=samsung&model=GT-I9100&sw_ver=2.3.3&slot_type=PREROLL
// 2. Throws Exception: "YuMeSDK_ShowAd(): No Prefetched Ad Present.".
- (void)testUseCase_ShowAd021 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = @"http://shadow01.yumenetworks.com1";
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"params: %@", params);
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    GHTestLog(@"Initialization Successful.");
    
    GHTestLog(@"*** Previous InitAd request returned a non-200 OK response *** ");
    // case 2:
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    GHTestLog(@"YuMeAdEventAdNotReady Fired.");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
    
    
    GHTestLog(@"*** Previous InitAd request returned an invalid empty response *** ");
    // case 3 :
    pError = nil;
    params.pAdServerUrl = EMPTY_INVALID_PL;
    GHAssertTrue([yumeSDK yumeSdkModifyAdParams:params errorInfo:&pError], @"yumeBspModifyParams(): Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    GHTestLog(@"YuMeAdEventAdNotReady Fired.");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
    
    GHTestLog(@"*** Previous InitAd request returned an invalid filled response *** ");
    // case 4:
    pError = nil;
    params.pAdServerUrl = FILLED_INVALID_PL;
    GHAssertTrue([yumeSDK yumeSdkModifyAdParams:params errorInfo:&pError], @"yumeBspModifyParams(): Successful.");
    [params release];

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(showAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    GHTestLog(@"YuMeAdEventAdNotReady Fired.");
    
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// Video playhead doesn't move (progress) for the video time interval specified during initialziation (before ad play start (or) after ad play start).

/* Expected behavior */
// 1. Ad Play Times out.
// 2. Notifies AD_COMPLETED event.
// 3. If auto-prefetching enabled, auto prefetches a new playlist from the server and handles the new playlist response.
- (void)testUseCase_ShowAd022 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Video playhead doesn't move (progress) for the video time interval specified during initialziation (before ad play start (or) after ad play start)." forKey:@"useCase"];

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Video playhead doesn't move (progress) for the video time interval specified during initialziation (before ad play start (or) after ad play start)." userInfo:nil]];
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Playing a Prefetched Ad"];
#endif

}

@end
