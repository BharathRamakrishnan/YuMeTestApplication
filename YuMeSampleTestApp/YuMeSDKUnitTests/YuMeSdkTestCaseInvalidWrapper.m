//
//  YuMeSdkTestCaseInvalidWrapper.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 10/16/13.
//  Copyright (c) 2013 Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkTestCaseInvalidWrapper.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkTestCaseInvalidWrapper

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

- (void)invalidWrapperEventListener:(NSArray *)userInfo {
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

// Playlist with Wrapper
// SDK State : Initialized

// 1. Create an Ad with Wrapper attached.
// 2. Initialize the SDK
// 3. Play the Ad

// Ad should be played, if any Wrapper mentioned, play the ad from the Wrapper, verify same in Wireshark logs as well.
- (void)testTC_InvWrap_0001 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Wrapper"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_VALID;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying");

    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted");

    NSString *str = @"Ad should be played, if any Wrapper mentioned, play the ad from the Wrapper";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
}

// Playlist with Wrapper limit exceeded
// SDK State : Initialized

// 1. Create an Ad with Wrapper attached and limit execeeded.
// 2. Initialize the SDK
// 3. Play the Ad

// As Playlist Wrapper limit execeeded (>5), so Empty ad would be served by the server.
- (void)testTC_InvWrap_0002 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Wrapper limit exceeded"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_MAX;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
 
    NSString *str = @"As Playlist Wrapper limit execeeded, so Empty ad would be served by the server";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
}


// Playlist with Tracker
// SDK State : Initialized

// 1. Create an Ad with Tracker attached.
// 2. Initialize the SDK
// 3. Play the Ad

// Ad should be played, if any Tracker mentioned, Fire all the trackers, verify same in Wireshark logs as well.
- (void)testTC_InvWrap_0003 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Tracker"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_VALID;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkStartAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted");
    
    NSString *str = @"Ad should be played, if any Tracker mentioned, Fire all the trackers";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
}

// Playlist with Tracker limit execeeded
// SDK State : Initialized
// 1. Create an Ad with Tracker attached and limit execeeded.
// 2. Initialize the SDK
// 3. Play the Ad

// As Playlist Tracker limit execeeded(>10), so Empty ad would be served by the server.
- (void)testTC_InvWrap_0004 {
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Tracker limit execeeded"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_MAX_TRACKERS_EXCEED;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    NSString *str = @"As Playlist Tracker limit execeeded(>10), so Empty ad would be served by the server";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
}

// Playlist with Wrapper retry
// SDK State : Initialized
// 1. Create an Ad with Wrapper retry count enabled.
// 2. Initialize the SDK
// 3. Play the Ad

// TBD
- (void)testTC_InvWrap_0005 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Wrapper retry"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_RETRY;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    NSString *str = @"YuMeAdEventAdNotReady";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
}

// Playlist with Wrapper retry limit execeeded
// SDK State : Initialized

// 1. Create an Ad with Wrapper retry count enabled & execeeded.
// 2. Initialize the SDK
// 3. Play the Ad

// TBD
- (void)testTC_InvWrap_0006 {
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Wrapper retry limit execeeded"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_RETRY_EXCEED;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    NSString *str = @"YuMeAdEventAdNotReady";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
}

// 	Playlist with Tracker and Wrapper limit execeeded
// SDK State : Initialized

// 1. Create an Ad with Tracker & Wrapper attached and limit execeeded.
// 2. Initialize the SDK
// 3. Play the Ad

// As Playlist Tracker & Wrapper limit execeeded, so Empty ad would be served by the server.
- (void)testTC_InvWrap_0007 {
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"Playlist with Tracker and Wrapper limit execeeded"];
    
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = WRAPPER_MAX;
    GHAssertNotNULL(params, @"params object not found");
    
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
    [params release];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(invalidWrapperEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    NSString *str = @"As Playlist Tracker & Wrapper limit execeeded, so Empty ad would be served by the server.";
    [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"InvalidWrapper"];
#endif

}


@end
