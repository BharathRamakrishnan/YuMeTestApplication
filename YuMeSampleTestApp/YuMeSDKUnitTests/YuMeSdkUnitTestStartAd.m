//
//  YuMeSdkUnitTestStartAd.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestStartAd.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestStartAd

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
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

- (void)startAdEventListener:(NSArray *)userInfo {
    NSString *sel = [userInfo objectAtIndex:0];
    NSString *event = [userInfo objectAtIndex:1];
    
    BOOL b = [YuMeSdkUnitUtils yumeEventListenerLock:event];
    if (b) {
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(sel)];
    } else {
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(sel)];
        [super failWithException:[NSException exceptionWithName:sel reason:@"kGHUnitWaitStatusFailure" userInfo:nil]];
    }
}


/**
 >> SDK State: Not Initialized
 
 >> Called when SDK is not initialized.
 
 >> 1. Throws Exception: "YuMeSDK_StartAd(): YuMe SDK is not Initialized."
 */
- (void)testUseCase_StartAd001 {
    
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
    
    GHAssertFalse([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll
                                errorInfo:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkStartAd(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Previous ad operation (startad / showad) is in progress.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_StartAd(): Previous Ad Play in Progress."
// 2. Ad play continues.
- (void)testUseCase_StartAd002 {
    
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];
    
    GHAssertFalse([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): Previous Ad Play in Progress.", @"");
        GHTestLog(@"Result : %@", str);
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd Successful.");
    GHTestLog(@"yumeSdkStopAd Fired.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/**
 >> SDK State: Initialized
 
 >> Parent view not set.
 
 >> 1. Throws Exception: "YuMeSDK_StartAd(): Parent View Not Set for displaying the Ad."
 */

- (void)testUseCase_StartAd003 {
    
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

    //GHAssertTrue(![yumeSDK yumeSdkSetParentView:mainView.view viewController:mainView errorInfo:&pError], @"yumeSdkSetParentView(): Invalid Ad View handle.");
        
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll
                                   errorInfo:&pError], @"Parent view is not set.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkSetParentView(): Invalid Ad View handle.", @"");
        GHTestLog(@"Result : %@", str);
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// No network connection.

/* Expected behavior */
// 1. Notifies AD_ABSENT followed by AD_COMPLETED events.
- (void)testUseCase_StartAd004 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Please execute the test manually without Network Connection." userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Request times out (OR)
// A non-200 OK response is received (OR)
// A 200 OK response is received but the playlist is empty (OR)
// A 200 OK is received, playlist is filled but doesn't contain the required assets. (OR)
// A 200 OK is received, but error occurred while parsing.

/* Expected behavior */
// 1. Notifies AD_ABSENT followed by AD_COMPLETED events.
- (void)testUseCase_StartAd005 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_VALID_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAbsent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAbsent" , @"YuMeAdEventAdAbsent");
    GHTestLog(@"YuMeAdEventAdAbsent Fired.");

#if 0
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
#endif
    
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// - Valid Filled Playlist received.
// - The playlist contains the required assets and all the assets valid.

/* Expected behavior */
// 1. Notifies AD_PRESENT event.
// 2. Plays the ad from network (uses cached assets, if available) .
// 3. Notifies AD_PLAYING event.
// 4. Hits the impression trackers received in the playlist, at appropriate times.
// 5. On ad completion,
// 5a) Notifies AD_COMPLETED event.
- (void)testUseCase_StartAd006 {
    
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// When prefetch operation is performed previously (or) currently in progress .

/* Expected behavior */
// 1. Stops the prefetch timers, if running (ad expiry timer, prefetch request callback timer & auto prefetch timer).
// 2. Aborts the ongoing/paused downloads.
// 3. Resets the auto-prefetch time interval.
// 4. Makes a new non-prefetch playlist request to the server.
// 5. Handles the response received.
- (void)testUseCase_StartAd007 {
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkInitAd Successful.");
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    GHTestLog(@"yumeSdkStartAd Successful.");

    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");
    
    GHAssertTrue([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd Successful.");
    GHTestLog(@"yumeSdkStopAd Called.");
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Filled Playlist is received but the main creative (log_url (or) video url)  results in 404 response.

/* Expected behavior */
// 1. Notifies AD_PRESENT event.
// 2. Attempts plays the ad from network (uses cached assets, if available) .
// 3. When 404 asset response is received.
// 3a) Notifies AD_COMPLETED event.
- (void)testUseCase_StartAd008 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_404_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");

    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Video play head doesn't move (progress) for the video time interval specified during initialization (before ad play start (or) after ad play start).

/* Expected behavior */
// 1. Ad Play Times out.
// 2. Notifies AD_COMPLETED event.
- (void)testUseCase_StartAd009 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_404_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// SDK is initialized with invalid domain (OR) invalid / malformed ad server url.

- (void)testUseCase_StartAd010 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"NA for Latest iOS SDK." userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// bSupportMP4 = false
// bSupport3GPP = false
// bSupportHighBitRate = false
// bSupportAutoNetworkDetect = false

/* Expected behavior */
// 1. Selects one of the following assets in the specified order, based on their availability:
// a. mp4 (384K) [Google TV: 1600K]
// b. mp4 (150K) [Google TV: 840K]
// c. mp4 (130K) [Google TV: 440K]
// d. 1st mp4 url received in the playlist, if any.
// e. 3gpp
- (void)testUseCase_StartAd011 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];
    
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// bSupportMP4 = true / false
// bSupport3GPP = true
// bSupportHighBitRate = true / false
// bSupportAutoNetworkDetect = true / false

/* Expected behavior */
// 1. Selects one of the following assets in the specified order, based on their availability:
// a. 3gpp
// b. mp4 (130K) [Google TV: 440K]
// c. mp4 (150K) [Google TV: 840K]
// d. mp4 (384K) [Google TV: 1600K]
// e. 1st mp4 url received in the playlist, if any.
- (void)testUseCase_StartAd012 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];
    
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// bSupportMP4 = true / false
// bSupport3GPP = false
// bSupportHighBitRate = true / false
// bSupportAutoNetworkDetect = true & cellular connectivity is present & WiFi is not present.

/* Expected behavior */
// 1. Selects one of the following assets in the specified order, based on their availability:
// a. 3gpp
// b. mp4 (130K) [Google TV: 440K]
// c. mp4 (150K) [Google TV: 840K]
// d. mp4 (384K) [Google TV: 1600K]
// e. 1st mp4 url received in the playlist, if any.
- (void)testUseCase_StartAd013 {

    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}


/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// bSupportMP4 = true
// bSupport3GPP = false
// bSupportHighBitRate = false
// bSupportAutoNetworkDetect = true / false.

/* Expected behavior */
// 1. Selects one of the following assets in the specified order, based on their availability:
// a. mp4 (130K) [Google TV: 440K]
// b. mp4 (150K) [Google TV: 840K]
// c. mp4 (384K) [Google TV: 1600K]
// d. 1st mp4 url received in the playlist, if any.
// e. 3gpp
- (void)testUseCase_StartAd014 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// bSupportMP4 = true
// bSupport3GPP = false
// bSupportHighBitRate = true
// bSupportAutoNetworkDetect = true / false.

/* Expected behavior */
// 1. Selects one of the following assets in the specified order, based on their availability:
// a. mp4 (384K) [Google TV: 1600K]
// b. mp4 (150K) [Google TV: 840K]
// c. mp4 (130K) [Google TV: 440K]
// d. 1st mp4 url received in the playlist, if any.
// e. 3gpp
- (void)testUseCase_StartAd015 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// Connection speed type: YuMeConnSpeedFast.
// Auto speed detection: false.
- (void)testUseCase_StartAd016 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// Connection speed type: YuMeConnSpeedFast.
// Auto speed detection: true & WiFi network is not available & 3G connectivity is available.
- (void)testUseCase_StartAd017 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// Connection speed type: YuMeConnSpeedFast.
// Auto speed detection: true & WiFi network is available.
- (void)testUseCase_StartAd018 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset Selection Logic when SDK is initialized with
// Connection speed type: YuMeConnSpeedSlow.
// Auto speed detection: true / false.
- (void)testUseCase_StartAd019 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// No network connection.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_StartAd(): No Network Connection available.".
- (void)testUseCase_StartAd020 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Playlist received with video url that gets redirected.

/* Expected behavior */
// The ad should play fine with the redirected video url.
- (void)testUseCase_StartAd021 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_VIDEO_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Playlist received with image url that gets redirected.

/* Expected behavior */
// The ad should play fine with the redirected image url.
- (void)testUseCase_StartAd022 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_IMAGE_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Playlist received with overlay url that gets redirected.

/* Expected behavior */
// The ad should play fine with the redirected overlay url.
- (void)testUseCase_StartAd023 {
    
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Please execute the test manually with Redirected Overlay Url." userInfo:nil]];
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_OVERLAY_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPresent", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPresent" , @"YuMeAdEventAdPresent");
    GHTestLog(@"YuMeAdEventAdPresent Fired.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(startAdEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Fired.");
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Start Ad"];
#endif

}

@end
