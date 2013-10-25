//
//  YuMeSdkUnitTestInitAd.m
//  YuMeiOSSDK
//
//  Created by Bharath Ramakrishnan on 9/11/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestInitAd.h"
#import "YuMeSdkUnitUtils.h"

#define RUN_AD_EXPIRY 1

@implementation YuMeSdkUnitTestInitAd

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

- (void)common_YuMeSdkInit:(NSString *)testCaseId {
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testCaseId];
    params.pAdServerUrl = @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_200/";
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
    params.storageSize = 10.0;
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
    } else {
        GHTestLog(@"yumeSdkInit successful.");
    }
}

- (void)initEventListener:(NSArray *)userInfo {
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

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called when SDK is not initialized.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_InitAd(): YuMe SDK is not Initialized."
- (void)testUseCase_InitAd001 {

    // Create the resultArray
    if (resultArray)
        [resultArray release]; resultArray = nil;
    
    if (resultArray == nil)
        resultArray = [[NSMutableArray alloc] init];
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    GHAssertTrue(![yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkInitAd(): YuMe SDK is not Initialized.", @"");
    }
}

- (void)testUseCase_InitAd002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHFail(@"Please execute the test manually without Network Connection.");
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Please execute the test manually without Network Connection." userInfo:nil]];
}

- (void)testUseCase_InitAd003 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHFail(@"Please execute the test manually without Network Connection.");
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Please execute the test manually without Network Connection." userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// Non-200 OK response is received.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
- (void)testUseCase_InitAd004 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.bEnableAutoPrefetch = FALSE;
    params.pDomainId = @"211yCcbVJNQ1";
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"InitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    if (pError)
        GHFail(@"testUseCase_InitAd004 <Error>: %@", [[YuMeSdkUnitUtils getErrDesc:pError] description]);
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// Non-200 OK response is received.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
// 2. Starts auto prefetch timer.
// 2a) attempts auto-prefetching in 2, 4, 8, 16, 32, 64, 128, 128, 128... seconds interval, until a 200 OK response is received.
- (void)testUseCase_InitAd005 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.bEnableAutoPrefetch = TRUE;
    params.pDomainId = @"211yCcbVJNQ1";
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    //[self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    if (pError)
        GHFail(@"testUseCase_InitAd005<Error>: %@", [[YuMeSdkUnitUtils getErrDesc:pError] description]);
    
    [YuMeSdkUnitUtils waitForCompletion:10];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// 200 OK response is received.
// Playlist is EMPTY and Invalid.
// NOTE: An empty playlist is invalid, if <unfilled> tracker is missing (or) empty.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
- (void)testUseCase_InitAd006 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = EMPTY_INVALID_PL;
    params.bEnableAutoPrefetch = FALSE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    //[self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// 200 OK response is received.
// Playlist is EMPTY and Invalid.
// NOTE: An empty playlist is invalid, if <unfilled> tracker is missing (or) empty.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
// 2. Starts auto prefetch timer.
// 2a) attempts auto-prefetching in 2, 4, 8, 16, 32, 64, 128, 128, 128... seconds interval, until a 200 OK response is received.
- (void)testUseCase_InitAd007 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = EMPTY_INVALID_PL;
    params.bEnableAutoPrefetch = TRUE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);

    //NSLog(@"%s", __PRETTY_FUNCTION__);
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    // Crash
#if 0
        [self waitForCompletion:2];
        GHAssertTrue([yumeSDK yumeSdkDeInit:&pError], @"Clear");
        if (pError) {
            GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        }
#endif
    
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// 200 OK response is received.
// Playlist is FILLED and Invalid.
// NOTE: A filled playlist is invalid, if,a. <filled> tracker is missing (or) empty. (OR) b. <unfilled> tracker is missing (or) empty.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
- (void)testUseCase_InitAd008 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = FILLED_INVALID_PL;
    params.bEnableAutoPrefetch = FALSE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);

    [self prepare];
    
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");

   // GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// 200 OK response is received.
// Playlist is FILLED and Invalid.
// NOTE: A filled playlist is invalid, if, a. <filled> tracker is missing (or) empty. (OR) b. <unfilled> tracker is missing (or) empty.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
// 2. Starts auto prefetch timer.
// 2a) attempts auto-prefetching in 2, 4, 8, 16, 32, 64, 128, 128, 128... seconds interval, until a 200 OK response is received.
- (void)testUseCase_InitAd009 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = FILLED_INVALID_PL;
    params.bEnableAutoPrefetch = TRUE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");
    
/* 
    [self waitForCompletion:2];
    GHAssertTrue([yumeSDK yumeSdkDeInit:&pError], @"Clear");
        
    [self waitForCompletion:2];
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
  */
    
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// - 200 OK response is received.
// - Playlist is EMPTY and Valid.

/* Expected behavior */
// 1. Stops Auto Prefetch timer, if running.
// 2. Notifies AD_NOT_READY.
// 3. Starts Prefetch Request Callback Timer.
// 3a) makes a new prefetch request to server, when prefetch request callback timer expires.
- (void)testUseCase_InitAd010 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = EMPTY_VALID_PL;
    params.bEnableAutoPrefetch = FALSE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *pErrString = [NSString stringWithFormat:@"%@" , [[YuMeSdkUnitUtils getErrDesc:pError] description]];
        GHFail(@"Error : %@", pErrString);
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");

    [YuMeSdkUnitUtils waitForCompletion:65];
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// 200 OK response is received.
// Playlist is EMPTY and Valid.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
// 2. Starts Prefetch Request Callback Timer.
// 2a) makes a new prefetch request to server, when prefetch request callback timer expires.
- (void)testUseCase_InitAd011 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = EMPTY_VALID_PL;
    params.bEnableAutoPrefetch = TRUE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
       GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");

    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");
    
/*
     [self waitForCompletion:2];
    
     GHAssertTrue([yumeSDK yumeSdkDeInit:&pError], @"Clear");
        
     [self waitForCompletion:2];
     if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
*/
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED but missing all of the required assets.
// NOTE:
// a. For video, only mp4 creatives would be considered
// b. For slate based ads, only 1st slate would be considered, when checking for the presence of required assets.

/* Expected behavior */
// 1. Notifies AD_NOT_READY.
// 2. Prints the placementId_adId of this playlist in logs.
- (void)testUseCase_InitAd012 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = FILLED_MISSING_ASSETS_PL;
    params.bEnableAutoPrefetch = FALSE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");

    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED but missing all of the required assets.
// NOTE:
// a. For video, only mp4 creatives would be considered
// b. For slate based ads, only 1st slate would be considered, when checking for the presence of required assets.

/* Expected behavior */
// 1. Stops Auto Prefetch timer, if running.
// 2. Notifies AD_NOT_READY.
// 3. Starts auto prefetch timer.
// 3a) Prints the placementId_adId of this playlist in logs.
// 3b) attempts auto-prefetching in 2, 4, 8, 16, 32, 64, 128, 128, 128... seconds interval, until a valid playlist is received.
- (void)testUseCase_InitAd013 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = FILLED_MISSING_ASSETS_PL;
    params.bEnableAutoPrefetch = TRUE;

    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError] description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdNotReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMe Ad Not Ready");

   /*
        [self waitForCompletion:2];
        GHAssertTrue([yumeSDK yumeSdkDeInit:&pError], @"Clear");
        [self waitForCompletion:2];
        if (pError) {
            GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        }
     */
}

/* Pre conditions */
// SDK State: Initialized
// Caching: OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one of the required creatives.
// NOTE:
// a. For video, only mp4 creatives would be considered.
// b. For slate based ads, only 1st slate would be considered, when checking for the presence of required assets.
// c. No 404 mp4 / logo creatives should be present in the playlist.

/* Expected behavior */
// 1. Resets auto prefetch time interval to its default value.
// 2. Notifies AD_READY (FALSE).
// 3. Starts ad expiry timer.
// 3a) Notifies AD_EXPIRED event, if showAd() doesn't get called within timer expiry.
- (void)testUseCase_InitAd014 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    AppSettings *settings = [AppSettings readSettings];
    settings.isPrefetchOnAdExpired = FALSE;
    [AppSettings saveSettings:settings];

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = FALSE;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];    
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
#if RUN_AD_EXPIRY
    
    [self waitForTimeout:110];
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
    
#endif

    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdExpired" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMeAdEventAdExpired");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF
// Storage Size: 0.0MB (OR)
// (bCacheAssetsInExtStorage = true & WRITE_EXTERNAL_STORAGE permission not set) (Android specific).

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one of the required creatives.
// NOTE:
// a. For video, only mp4 creatives would be considered.
// b. For slate based ads, only 1st slate would be considered, when checking for the presence of required assets.
// c. No 404 mp4 / logo creatives should be present in the playlist.

/* Expected behavior */
// 1. Resets auto prefetch time interval to its default value.
// 2. Notifies AD_READY (FALSE).
// 3. Turns off Caching.
// 4. Starts ad expiry timer.
// 4a) Notifies AD_EXPIRED event, if showAd() doesn't get called within timer expiry.
- (void)testUseCase_InitAd015 {
    
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
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    params.storageSize = 0.0;
    
    GHTestLog(@"Ad server url : %@", VALID_200_OK_PL);
    
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
    
    GHTestLog(@"Initialization Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    GHTestLog(@"YuMeAdEventAdReady");

#if RUN_AD_EXPIRY
    [self waitForTimeout:110];
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");

    GHTestLog(@"YuMeAdEventAdExpired");
#endif
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdReady" yumeSdkInterface:pYuMeTestInterface interval:0.5]), @"YuMeAdEventAdReady");
    //[YuMeSdkUnitUtils waitForCompletion:110];
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdExpired" yumeSdkInterface:pYuMeTestInterface interval:0.5]), @"YuMeAdEventAdExpired");
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF
// Storage Size: 10.0MB

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one (or) all of the required creatives.
// NOTE:
// a. For video, only mp4 creatives would be considered
// b. For slate based ads, only 1st slate would be considered, when checking for the presence of required assets.
// c. No 404 mp4 / logo creatives should be present in the playlist.

/* Expected behavior */
// 1. Resets auto prefetch time interval to its default value.
// 2. Notifies AD_READY (FALSE).
// 3. Identifies the assets to be downloaded.
// 4. Fetches the size of the assets to be downloaded using HEAD request (HEAD request to be issued only if the 'size' attribute is missing (or) contains a value <= 0 for an asset).
// 5. Calculates the space requirements for high bitrate, checks if space is available for high bitrate, downloads high bitrate assets, if available space is sufficient. If space not sufficient, then tries with medium and low bitrate assets in the specified order.
// 6. Sets the download status to IN_PROGRESS.
// 7. Once all the assets are downloaded,
// 7a) Sets the download status to NOT_IN_PROGRESS.
// 7b) Notifies AD_READY (TRUE).
// 7c) Starts ad expiry timer.
// 7ca) Notifies AD_EXPIRED event, if showAd() doesn't get called within timer expiry.
- (void)testUseCase_InitAd016 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    [self common_YuMeSdkInit:@"test"];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdReady" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMeAdEventAdReady");
    [self prepare];    
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    //NSLog(@"downloadStatus : %u", downloadStatus);
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
   
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");

    downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 2, @"NOT_IN_PROGRESS Failed");
    
#if RUN_AD_EXPIRY
    //[self waitForTimeout:110];
    [YuMeSdkUnitUtils waitForCompletion:110];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
#endif
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdExpired" yumeSdkInterface:pYuMeTestInterface interval:0.5]), @"YuMeAdEventAdExpired");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF
//Storage Size: 0.2MB

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one (or) all of the required creatives.
// - Space available not sufficient for any of high, medium or low bitrate assets.
// NOTE:
// a. For video, only mp4 creatives would be considered
// b. For slate based ads, only 1st slate would be considered, when checking for the presence of required assets.
// c. No 404 mp4 / logo creatives should be present in the playlist.

/* Expected behavior */
// 1. Resets auto prefetch time interval to its default value.
// 2. Notifies AD_READY (FALSE).
// 3. Identifies the assets to be downloaded.
// 4. Fetches the size of the assets to be downloaded using HEAD request (HEAD request to be issued only if the 'size' attribute is missing (or) contains a value <= 0 for an asset).
// 5. Calculates the space requirements for high, medium, low bitrate assets.
// 6. Starts ad expiry timer.
// 6a) Notifies AD_EXPIRED event, if showAd() doesn't get called within timer expiry.
- (void)testUseCase_InitAd017 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    params.storageSize = 0.2;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");

    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    //NSLog(@"downloadStatus : %u", downloadStatus);
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");

    downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 2, @"NOT_IN_PROGRESS Failed");

#if RUN_AD_EXPIRY
    //[YuMeSdkUnitUtils waitForCompletion:110];
    [self waitForTimeout:110];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
#endif
    
    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdExpired" yumeSdkInterface:pYuMeTestInterface interval:0.5]), @"YuMeAdEventAdExpired");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON
//Storage Size: 10.0MB

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one (or) all of the required creatives.
// - Fetching size using HEAD Request / Asset download fails (timeout (or) 404 creatives). (OR)
// - Networkcable is unplugged when asset downloads is in progress.

/* Expected behavior */
// 1. Resets auto prefetch time interval to its default value.
// 2. Notifies AD_READY (FALSE).
// 3. Identifies the assets to be downloaded.
// 4. Fetches the size of the assets to be downloaded using HEAD request (HEAD request to be issued only if the 'size' attribute is missing (or) contains a value <= 0 for an asset).
// 5. Calculates the space requirements for high, medium, low bitrate assets and starts downloading.
// 6. Sets the download status to IN_PROGRESS.
// 7. Retries 'n' number of times at every 'x' interval of time.
// 7a) 'n' = value of <creative_retry_attempts> in the playlist.
// 7b) 'x' = value of <creative_retry_interval> in the playlist.
// 8. After retry attempts, starts auto prefetch timer.
// 8a) Sets the download status to NOT_IN_PROGRESS.
// 8b) Notifies AD_ERROR event with appropriate eventInfo "Assets Download failed.".
// 8c) attempts auto-prefetching in 2, 4, 8, 16, 32, 64, 128, 128, 128... seconds interval, until a valid playlist is received.
- (void)testUseCase_InitAd018 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_FILLED_404_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
    params.storageSize = 0.2;
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    //[YuMeSdkUnitUtils waitForCompletion:5];
    [self waitForTimeout:5];
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");

    //GHAssertTrue(([YuMeSdkUnitUtils yumeEventListener:@"YuMeAdEventAdError" yumeSdkInterface:pYuMeTestInterface interval:1.0]), @"YuMeAdEventAdError");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: OFF
// Storage Size: 10.0MB

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one (or) all of the required creatives.
// - Fetching size using HEAD Request / Asset download fails (timeout (or) 404 creatives). (OR)
// - Networkcable is unplugged when asset downloads is in progress.

/* Expected behavior */
// 1. Resets auto prefetch time interval to its default value.
// 2. Notifies AD_READY.
// 3. Identifies the assets to be downloaded.
// 4. Fetches the size of the assets to be downloaded using HEAD request (HEAD request to be issued only if the 'size' attribute is missing (or) contains a value <= 0 for an asset).
// 5. Calculates the space requirements for high, medium, low bitrate assets and starts downloading.
// 6. Sets the download status to IN_PROGRESS.
// 7. Retries 'n' number of times at every 'x' interval of time.
// 7a) 'n' = value of <creative_retry_attempts> in the playlist.
// 7b) 'x' = value of <creative_retry_interval> in the playlist.
// 8. After retry attempts,
// 8a) Sets the download status to NOT_IN_PROGRESS.
// 8b) Notifies AD_ERROR event with appropriate eventInfo "Assets Download failed.".
- (void)testUseCase_InitAd019 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_FILLED_404_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    params.storageSize = 10.0;
    
    GHTestLog(@"Ad Server Url : %@", params.pAdServerUrl);
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[YuMeSdkUnitUtils getErrDesc:pError].description userInfo:nil]];
    }
    
    [self waitForTimeout:5];
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF
//Storage Size: 2.0MB

/* Usecase */
// - 200 OK response is received.
// - Playlist is FILLED and contains atleast one (or) all of the required creatives.
// - Space available not sufficient – old assets not associated with the current playlist deleted for reclaiming space for new assets.
// NOTE :
// a. No 404 mp4 / logo creatives should be present in the playlist.

/* Expected behavior */
//1. Resets auto prefetch time interval to its default value.
//2. Notifies AD_READY.
//3. Identifies the assets to be downloaded.
//4. Fetches the size of the assets to be downloaded using HEAD request (HEAD request to be issued only if the 'size' attribute is missing (or) contains a value <= 0 for an asset).
//5. Calculates the space requirements for high, medium, low bitrate assets, reclaims space for new assets by deleting old assets (FIFO logic) not associated with current playlist. If space available sufficient, starts downloading assets.
//6. Sets the download status to IN_PROGRESS.
//7. Once all the assets are downloaded
//7a) Sets the download status to NOT_IN_PROGRESS.
//7b) Notifies AD_AND_ASSETS_READY.
//7c) Starts ad expiry timer.
//7ca) Notifies AD_EXPIRED event, if showAd() doesn't get called within timer expiry.
- (void)testUseCase_InitAd020 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
    params.storageSize = 2.0;
    
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

    [yumeSDK yumeSdkClearCache:&pError];

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];
    
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");

    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");

#if RUN_AD_EXPIRY
    [YuMeSdkUnitUtils waitForCompletion:110];
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
#endif
        
    downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 2, @"NOT_IN_PROGRESS Failed");
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called without any pattern change, when a a filled prefetched ad is already available.

/* Expected behavior */
// 1. Notifies AD_READY (FALSE), if caching is disabled.
// 2. Notifies AD_READY (TRUE), if caching is enabled.
// 3. Ad expiry timer continues to run, if running.
// 4. No new playlist request made to the server.
- (void)testUseCase_InitAd021 {
    
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
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHTestLog(@"Initialization Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");

    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) called again without pattern change.");

    // Init Ad call without pattern change
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");

#if RUN_AD_EXPIRY
    [self waitForTimeout:110];

    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
    
    GHTestLog(@"YuMeAdEventAdExpired");
#endif
    
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called with pattern change (different ad block type (or) qs params changed), when a filled prefetched ad is already available.

/* Expected behavior */
// 1. Stops the Ad Expiry Timer.
// 2. Makes a new prefetch request to the server.
// 3. Handles the response received.
- (void)testUseCase_InitAd022 {
    
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
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
    
    // Init Ad call with pattern change
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) called again with pattern change.");
    
    params.pAdditionalParams = @"a=b";
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");

    [params release];
    
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) (patteren change) Successful.");
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called without any pattern change, when previous InitAd's download operation is in progress.

/* Expected behavior */
// 1. Notifies AD_READY (FALSE) immediately.
// 2. The first InitAd's download operation continues.
// 3. Notifies  AD_READY (TRUE) & starts the ad expiry timer, once the first InitAd's assets are downloaded.
- (void)testUseCase_InitAd023 {
    
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
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHTestLog(@"Initialization Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHTestLog(@"downloadStatus : %u", downloadStatus);
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");

    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) called again without pattern change.");
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) (without patteren change) Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called with pattern change (different ad block type (or) qs params changed), when previous InitAd's download operation is in progress.

/* Expected behavior */
// 1. Aborts the ongoing downloads.
// 2. Makes a new prefetch request to the server.
// 3. Handles the response received.
- (void)testUseCase_InitAd024 {
    
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
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");

    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHTestLog(@"downloadStatus : %u", downloadStatus);
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) called again with pattern change.");
    pError = nil;
    params.pAdditionalParams = @"a=b";
    GHAssertTrue([yumeSDK yumeSdkModifyAdParams:params errorInfo:&pError], @"");
    [params release];
    GHTestLog(@"yumeSdkModifyAdParams Sucessful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError] description]);
    
    GHTestLog(@"yumeSdkInitAd:(YuMeAdTypePreroll) (with patteren change) Successful.");
 
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");    
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called when startAd is in progress.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_InitAd(): Ad is Playing right now. Please try after sometime."
// 2. Ad play continues.
- (void)testUseCase_InitAd025 {
    
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
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHTestLog(@"Initialization Successful.");
    
    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [yumeSDK yumeSdkSetParentView:adView viewController:nil errorInfo:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    GHTestLog(@"StartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");


    GHTestLog(@"YuMeAdEventAdPlaying");
    
    GHAssertFalse([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    GHTestLog(@"yumeSdkInitAd initiated.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkInitAd(): Previous Ad Play in Progress.", @"");
        GHTestLog(@"Error: %@", str);
    }
    
    [yumeSDK yumeSdkStopAd:&pError];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called when showAd is in progress.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_InitAd(): Previously prefetched ad is Playing right now. Please try after sometime."
//2. Ad play continues.

 - (void)testUseCase_InitAd026 {
     
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
     
     GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
     
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
     
     GHTestLog(@"Initialization Successful.");
     
     GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
     GHTestLog(@"yumeSdkInitAd Successful.");
     
     [self prepare];
     NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
     [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
     GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
     GHTestLog(@"YuMeAdEventAdAndAssetsReady");
     
     UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
     [yumeSDK yumeSdkSetParentView:adView viewController:nil errorInfo:&pError];
    
     GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
     GHTestLog(@"yumeSdkShowAd Successful.");
     
     [self prepare];
     NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
     [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
     GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
     GHTestLog(@"YuMeAdEventAdPlaying");
     
     [self waitForTimeout:2];

     GHAssertFalse([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
     GHTestLog(@"yumeSdkInitAd initiated.");
     if (pError) {
         NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
         GHAssertEqualObjects(str, @"yumeSdkInitAd(): Previous Ad Play in Progress.", @"");
         GHTestLog(@"Error: %@", str);
     }

     pError = nil;
     GHAssertTrue([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd Successful.");
     if (pError) {
         GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError] description]);
         [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:[[YuMeSdkUnitUtils getErrDesc:pError] description] userInfo:nil]];
     }
}



/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: OFF

/* Usecase */
// InitAd called (with (or) without pattern change) in any of the following conditions:
// a. Previous InitAd request timed out.
// b. Previous InitAd request returned a non-200 OK response.
// c. Previous InitAd request returned an invalid empty response.
// d. Previous InitAd request returned an invalid filled response.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testUseCase_InitAd027 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_INVALID_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHTestLog(@"Initialization Successful.");
    
    [yumeSDK yumeSdkClearCache:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError] description]);
    
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
         GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    GHTestLog(@"yumeSdkInitAd Initiated.");
    
    [self waitForTimeout:2];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
//Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called (with (or) without pattern change) in the following condition:
// a. Previous InitAd request returned a valid filled response but none of the required assets were present.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testUseCase_InitAd028 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = FILLED_MISSING_ASSETS_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHTestLog(@"Initialization Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypeMidroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self waitForTimeout:5];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called without any pattern change, when an empty prefetched ad is already available.

/* Expected behavior */
// 1. Notifies AD_NOT_READY immediately.
// 2. The Prefetch Request Callback Timer continues to run.
- (void)testUseCase_InitAd029 {
    
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
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");

   
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
        
    /*
     [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
     */
    GHTestLog(@"YuMeAdEventAdNotReady");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called with pattern change (different ad block type (or) qs params changed), when an empty prefetched ad is already available.

/* Expected behavior */
// 1. Stops the Prefetch Request Callback Timer.
// 2. Makes a new prefetch request to the server.
// 3. Handles the response received.
- (void)testUseCase_InitAd030 {
    
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
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    [self waitForTimeout:5];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypeMidroll errorInfo:&pError], @"");
    GHTestLog(@"YuMeAdTypeMidroll request");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: OFF

/* Usecase */
// InitAd called (with (or) without pattern change) in the following condition:
// a. Previous InitAd request returned a valid filled response but download attempts failed due to 404 creative.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testUseCase_InitAd031 {
    
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
    params.bEnableCaching = TRUE;

    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
 
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    GHTestLog(@"YuMeAdEventAdError");

    params.pAdServerUrl = @"http://shadow01.yumenetworks.com";
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
 
    [params release];
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called with pattern change (different ad block type (or) qs params changed), when the previous InitAd's downloads are paused.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testUseCase_InitAd032 {
    
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
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");

    GHAssertTrue([yumeSDK yumeSdkPauseDownload:&pError], @"Pause download");
        
    params.pAdditionalParams = @"a=c";
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkModifyAdParams:params errorInfo:&pError], @"yumeSdkModifyAdParams Successful.");

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    [params release];
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
}


/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called without pattern change, when the previous InitAd's downloads are paused.

/* Expected behavior */
// 1. Notifies AD_READY (FALSE) immediately.
// 2. The first InitAd's download operations remains paused.
- (void)testUseCase_InitAd033 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"InitAd called without pattern change, when the previous InitAd's downloads are paused."];


    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    pError = nil;
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    GHAssertTrue([yumeSDK yumeSdkPauseDownload:&pError], @"Pause download");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }

    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }

    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");

   /*
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    */
    GHTestLog(@"YuMeAdEventAdReady");
    
    pError = nil;
    YuMeDownloadStatus downloadStatus1 = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus1, 3, @"PAUSED Failed");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called (with (or) without pattern change), when the previous InitAd's downloads are aborted.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testUseCase_InitAd034 {
    
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
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    [yumeSDK yumeSdkClearCache:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    GHAssertTrue([yumeSDK yumeSdkAbortDownload:&pError], @"Abort download");

    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus1 = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus1, 1, @"IN_PROGRESS Failed");
    
}

- (void)testUseCase_InitAd035 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHFail(@"NA for Latest iOS SDK.");
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"NA for Latest iOS SDK." userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// InitAd called (with (or) without pattern change), when the previous InitAd's downloads are aborted.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testUseCase_InitAd036 {
    
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
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    pError = nil;
    [yumeSDK yumeSdkClearCache:&pError];
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    GHAssertTrue([yumeSDK yumeSdkAbortDownload:&pError], @"Abort download");
    GHTestLog(@"yumeSdkAbortDownload Successful.");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus1 = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus1, 1, @"IN_PROGRESS Failed");    
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// InitAd called with pattern change, when auto prefetch is in progress. 

/* Expected behavior */
// 1. The ongoing auto prefetch operation should be stopped and the new initAd() should be honored.
- (void)testUseCase_InitAd037 {
    
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
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    [yumeSDK yumeSdkClearCache:&pError];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");

    params.pAdditionalParams = @"a=b";
    GHAssertTrue([yumeSDK yumeSdkModifyAdParams:params errorInfo:&pError], @"yumeSdkModifyAdParams Successful.");
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo1 afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus1 = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus1, 1, @"IN_PROGRESS Failed");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON/OFF
// Auto-Prefetch: ON

/* Usecase */
// InitAd called without pattern change, when auto prefetch is in progress. 

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_InitAd(): Init Ad Request IGNORED as a similar request is in progress."
// 2. The auto-prefetch should continue.
- (void)testUseCase_InitAd038 {
    
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
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    [yumeSDK yumeSdkClearCache:&pError];
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 1, @"IN_PROGRESS Failed");
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
        GHTestLog(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    }
    
    YuMeDownloadStatus downloadStatus1 = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus1, 1, @"IN_PROGRESS Failed");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// Valid Playlist received with video url that gets redirected.

/* Expected behavior */
// The cached video asset should get stored using the file name received in the final redirected url.
- (void)testUseCase_InitAd039 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_VIDEO_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    [yumeSDK yumeSdkClearCache:&pError];
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// Valid Playlist received with image url that gets redirected.

/* Expected behavior */
// The cached image asset should get stored using the file name received in the final redirected url.
- (void)testUseCase_InitAd040 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_IMAGE_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    [yumeSDK yumeSdkClearCache:&pError];
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// Valid Playlist received with overlay url that gets redirected.

/* Expected behavior */
// The cached overlay asset should get stored using the file name received in the final redirected url.
- (void)testUseCase_InitAd041 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_OVERLAY_PL;
    params.bEnableAutoPrefetch = FALSE;
    params.bEnableCaching = TRUE;
    
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"Ad server url : %@", params.pAdServerUrl);
    
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
    
    [yumeSDK yumeSdkClearCache:&pError];
    [params release];
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError)
        GHFail(@"Error : %@", [[YuMeSdkUnitUtils getErrDesc:pError]description]);
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(initEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(initEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Prefetching An Ad"];
#endif

}

@end
