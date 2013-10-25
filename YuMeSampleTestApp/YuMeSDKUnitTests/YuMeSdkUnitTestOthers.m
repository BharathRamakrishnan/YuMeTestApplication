//
//  YuMeSdkUnitTestOthers.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/24/13.
//  Copyright (c) 2013 Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestOthers.h"
#import "YuMeSdkUnitUtils.h"

#include <asl.h>

@implementation YuMeSdkUnitTestOthers

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

- (void)generalEventListener:(NSArray *)userInfo {
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

- (void) getLog {
    aslmsg q, m;
    int i;
    const char *key, *val;
    
    q = asl_new(ASL_TYPE_QUERY);
    
    aslresponse r = asl_search(NULL, q);
    while (NULL != (m = aslresponse_next(r)))
    {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        
        for (i = 0; (NULL != (key = asl_key(m, i))); i++)
        {
            NSString *keyString = [NSString stringWithUTF8String:(char *)key];
            
            val = asl_get(m, key);
            
            NSString *string = val?[NSString stringWithUTF8String:val]:@"";
            [tmpDict setObject:string forKey:keyString];
        }
        
        NSLog(@"%@", tmpDict);
    }
    aslresponse_free(r);
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Prefetched ad expired.

/* Expected behavior */
// 1. Notifies  AD_EXPIRED event to the application.
// 2. Doesn't autoprefetch a new ad, even if auto-prefetch is enabled.
- (void)testCase_General001 {
    
    // Create the resultArray
    if (resultArray)
        [resultArray release]; resultArray = nil;
    
    if (resultArray == nil)
        resultArray = [[NSMutableArray alloc] init];
    
    NSString *resultStr = @"";
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Prefetched ad expired." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    AppSettings *settings = [AppSettings readSettings];
    settings.isPrefetchOnAdExpired = FALSE;
    [AppSettings saveSettings:settings];
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");

    resultStr = [YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady"];
    
    [self waitForTimeout:110];
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
    GHTestLog(@"YuMeAdEventAdExpired Successful.");
    
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdExpired"]];
    
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Prefetch Callback Timer expired.

/* Expected behavior */
// 1. Makes a new prefetch request to the server.
// 2. Handles the response received.
- (void)testCase_General002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Prefetch Callback Timer expired." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_VALID_PL;
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
    [self performSelector:@selector(generalEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady Successful.");

    [testCaseResult setObject:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdNotReady"] forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];

    //int prefetchCallbackTimer = 900;
    //[YuMeSdkUnitUtils waitForCompletion:prefetchCallbackTimer];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// - InitAd called and a valid filled playlist is received with a 404 creative.
// - creative_retry_interval: 0.
// - creative_retry_attempts: 'n'.

/* Expected behavior */
// 1. Retries downloading the 404 asset 'n' number of times at 10 seconds interval.
- (void)testCase_General003 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"InitAd called and a valid filled playlist is received with a 404 creative." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_404_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");

    [YuMeSdkUnitUtils waitForCompletion:5];
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    GHTestLog(@"YuMeAdEventAdError Successful.");

    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdError"]];
    
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// - InitAd called and a valid filled playlist is received with a 404 creative.
// - creative_retry_interval: 5.
// - creative_retry_attempts: 0.

/* Expected behavior */
// 1. Retries downloading the 404 asset 5 times at 5 seconds interval.
- (void)testCase_General004 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"InitAd called and a valid filled playlist is received with a 404 creative." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_404_PL;
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
    
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");

    
    [YuMeSdkUnitUtils waitForCompletion:5];
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelector:@selector(generalEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    GHTestLog(@"YuMeAdEventAdError Successful.");

    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdError"]];

    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];

}


/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Events to be dispatched for all initAd calls.

/* Expected behavior */
// 1. AD_NOT_READY: If request times out (or) if the playlist is invalid (or) empty (or) non-200 OK.
// 2. AD_READY: Playlist received, Asset caching in progress. (or) Playlist received. Caching is disabled.
// 3. AD_AND_ASSETS_READY: Caching is enabled and all assets are cached.
- (void)testCase_General005 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Events to be dispatched for all initAd calls." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    
    // 1. AD_NOT_READY: If request times out (or) if the playlist is invalid (or) empty (or) non-200 OK.

    params.pAdServerUrl = EMPTY_VALID_PL;
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
    [self performSelector:@selector(generalEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady Successful.");

    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdNotReady : If request times out (or) if the playlist is invalid (or) empty (or) non-200 OK."]];

    
    // 2. AD_READY: Playlist received, Asset caching in progress. (or) Playlist received. Caching is disabled.

    params.pAdServerUrl = VALID_200_OK_PL;
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkModifyAdParams:params errorInfo:&pError], @"yumeSdkModifyAdParams Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    [params release];
    GHTestLog(@"yumeSdkModifyAdParams Successful.");

    
    pError = nil;
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
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");

    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady : Playlist received, Asset caching in progress. (or) Playlist received. Caching is disabled."]];

    // 3. AD_AND_ASSETS_READY: Caching is enabled and all assets are cached.
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Successful.");

    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdAndAssetsReady : Caching is enabled and all assets are cached."]];

    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Events to be dispatched for auto prefetched playlists.

/* Expected behavior */
// No events should be notified when an ad is auto prefetched.
- (void)testCase_General006 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Events to be dispatched for auto prefetched playlists." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    GHAssertNotNULL(params, @"params object not found");
    
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Successful.");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo3 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo3];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Successful.");
    
    [self prepare];
    NSArray *userInfo4 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo4];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Successful.");
    
    [YuMeSdkUnitUtils waitForCompletion:2];
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"No events should be notified when an ad is auto prefetched."]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];

}

/* Pre conditions */
// SDK State: Initialized
// Auto-Prefetch: ON

/* Usecase */
// 1. Call InitAd() with Caching: OFF.
// 2. Once, ad is ready for playing, turning Caching: ON
// 3. Call ShowAd

/* Expected behavior */
// 1. Stops the ad expiry timer.
// 2. Hits the Filled tracker received in the playlist.
// 3. Plays the ad from network (uses cached assets, if available) .
// 4. Notifies AD_PLAYING event.
// 5. Hits the impression trackers received in the playlist, at appropriate times.
// 6. On ad completion,
// 6a) Notifies AD_COMPLETED event.
// 6b) auto-prefetches a new playlist from the server.
// 6c) downloads the assets.
// 6d) starts the ad expiry timer, once assets are downloaded.
- (void)testCase_General007 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"1. Call InitAd() with Caching: OFF. \n 2. Once, ad is ready for playing, turning Caching: ON. \n 3. Call ShowAd" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = FALSE;  // 1. Call InitAd() with Caching: OFF.
    
    GHAssertNotNULL(params, @"params object not found");
    
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady"]];


    // 2. Once, ad is ready for playing, turning Caching: ON
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkSetCacheEnabled:YES errorInfo:&pError], @"yumeSdkSetCacheEnabled Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkSetCacheEnabled Successful.");
    
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"yumeSdkSetCacheEnabled Successful"]];

    // 3. Call ShowAd
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"yumeSdkShowAd Successful"]];
 
    [self prepare];
    NSArray *userInfo3 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo3];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Successful.");
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdPlaying Successful"]];

    [self prepare];
    NSArray *userInfo4 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo4];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Successful.");
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdCompleted Successful"]];

    [YuMeSdkUnitUtils waitForCompletion:2];
    
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized
// Auto-Prefetch: ON/OFF

/* Usecase */
// 1. Call InitAd() with Caching: OFF.
// 2. Once, ad is ready for playing, turning Caching: ON
// 3. Call InitAd again

/* Expected behavior */
// 1. Leaves the Ad expiry timer undisturbed.
// 2. Downloads the assets.
// 3. Notifies AD_READY(TRUE), once assets are downloaded.
- (void)testCase_General008 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"1. Call InitAd() with Caching: OFF. \n 2. Once, ad is ready for playing, turning Caching: ON \n 3. Call InitAd again" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableCaching = FALSE;  // 1. Call InitAd() with Caching: OFF.
    
    GHAssertNotNULL(params, @"params object not found");
    
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];

    // 2. Once, ad is ready for playing, turning Caching: ON
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkSetCacheEnabled:YES errorInfo:&pError], @"yumeSdkSetCacheEnabled Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkSetCacheEnabled Successful.");
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"yumeSdkSetCacheEnabled Successful"]];

    pError = nil;
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
    NSArray *userInfo1= [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Successful.");
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdAndAssetsReady Successful"]];
    
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// showAd called in when prefetched ad is expired.

/* Expected behavior */
// 1. Hits the unfilled tracker by appending (ad_catalog=placementId_adId).
- (void)testCase_General009 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"showAd called in when prefetched ad is expired." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Successful.");
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdAndAssetsReady Successful"]];

    [YuMeSdkUnitUtils waitForCompletion:110];
    
    [self prepare];
    NSArray *userInfo2 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdExpired", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo2];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdExpired" , @"YuMeAdEventAdExpired");
    GHTestLog(@"YuMeAdEventAdExpired Successful.");
    resultStr = [resultStr stringByAppendingString:@"\n"];
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdExpired Successful"]];
    
    // 3. Call ShowAd
    pError = nil;
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkShowAd(): No Prefetched Ad Present.", @"");
        GHTestLog(@"Result : %@", str);
        resultStr = [resultStr stringByAppendingString:@"\n"];
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Error Throw Exception: yumeSdkShowAd(): No Prefetched Ad Present.";
        resultStr = [resultStr stringByAppendingString:@"\n"];
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// showAd called and filled tracker gets hit.

/* Expected behavior */
// 1. Appends (ad_catalog=placementId_adId) to the filled tracker.
- (void)testCase_General010 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"ShowAd called and filled tracker gets hit." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    GHAssertNotNULL(params, @"params object not found");
    
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Successful.");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"yumeSdkShowAd Successful."]];

    [YuMeSdkUnitUtils waitForCompletion:2];
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkStopAd Successful.");
    
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];

}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// initAd called when all the assets for one (or) more ads exists in cache.

/* Expected behavior */
// 1. Populates the (ad_guid) element in the JSON object with the ad_guid values of all those ads.
- (void)testCase_General011 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"initAd called when all the assets for one (or) more ads exists in cache." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    GHAssertNotNULL(params, @"params object not found");
    
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful."]];

    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Tracker URLs that gets redirected but the Redirected URLs contains characters to be encoded.

/* Expected behavior */
// 1. Encodes the redirected URLs and hits them.
- (void)testCase_General012 {

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:@"Please execute the test manually with Tracker URLs that gets redirected but the Redirected URLs contains characters to be encoded." userInfo:nil]];

    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Tracker URLs that gets redirected but the Redirected URLs contains characters to be encoded." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_REDIRECT_TREACKERS_PL;
    GHAssertNotNULL(params, @"params object not found");
    
    GHTestLog(@"AdServer Url : %@", params.pAdServerUrl);
    
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
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady Successful.");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady Successful.");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkShowAd Successful.");
    
    [self prepare];
    NSArray *userInfo3 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo3];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Successful.");
    
    [self prepare];
    NSArray *userInfo4 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdCompleted", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo4];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdCompleted" , @"YuMeAdEventAdCompleted");
    GHTestLog(@"YuMeAdEventAdCompleted Successful.");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"AdPlayed Completed: Encodes the redirected URLs and hits them."]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params:
// QS Params "1=one&2=two&3=three&4=four&5=five&6=six&7=seven&8=eigth&9=nine&10=ten1,ten2"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows:
// Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?1=one&2=two&3=three&4=four&5=five&6=six&7=seven&8=eigth&9=nine&10=ten1%2Cten2

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24912154","latitude":"12.995290180000001","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"","imu":[],"publisher_page":""}
- (void)testCase_General013 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"he following Query string params is passed during Initialization / Modify Params: QS Params '1=one&2=two&3=three&4=four&5=five&6=six&7=seven&8=eigth&9=nine&10=ten1,ten2'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"1=one&2=two&3=three&4=four&5=five&6=six&7=seven&8=eigth&9=nine&10=ten1,ten2";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params:
// QS Params ""

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24912154","latitude":"12.995290180000001","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"","imu":[],"publisher_page":""}
- (void)testCase_General014 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params """ forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params: "a=AAA&b=BBB&c=CC C&d=DDDD"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?a=AAA&b=BBB&c=CC%20C&d=DDDD

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24912154","latitude":"12.995290180000001","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"","imu":[],"publisher_page":""}
- (void)testCase_General015 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params: 'a=AAA&b=BBB&c=CC C&d=DDDD'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"a=AAA&b=BBB&c=CC C&d=DDDD";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params "a=b&a=m&c=d&e=f&age=25&gender=male&interests=Gardening,Reading Books,Listening Music&keywords=key1&income=10000&education=B.E (ECE)&guid=10&title=Ad Video&duration=15&categories=video,audio&tags=india,tamil nadu,andhra"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?a=b&a=m&c=d&e=f

// Playlist Request Body {"content":{"tags":["india","tamil nadu","andhra"],"guid":"10","categories":["video","audio"],"duration":"15","title":"Ad Video"},"demography":{"gender":"male","keywords":["key1"],"education":"B.E (ECE)","interests":["Gardening","Reading Books","Listening Music"],"income":"10000","age":"25"},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.2448366","latitude":"12.9860368","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"","imu":[],"publisher_page":""}
- (void)testCase_General016 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'a=b&a=m&c=d&e=f&age=25&gender=male&interests=Gardening,Reading Books,Listening Music&keywords=key1&income=10000&education=B.E (ECE)&guid=10&title=Ad Video&duration=15&categories=video,audio&tags=india,tamil nadu,andhra'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"a=b&a=m&c=d&e=f&age=25&gender=male&interests=Gardening,Reading Books,Listening Music&keywords=key1&income=10000&education=B.E (ECE)&guid=10&title=Ad Video&duration=15&categories=video,audio&tags=india,tamil nadu,andhra";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params "publisher_channel=channel&publisher_page=yume.com&imu=medrect,widesky,full_banner&exclude_placements=20000,20001&a=b&c=d&e=f&age=25&gender=male&interests=Gardening,Reading Books,Listening Music&keywords=key1&income=10000&education=B.E (ECE)&guid=10&title=Ad Video&duration=15&categories=video,audio&tags=india,tamil nadu,andhra&state=tamilnadu&city=chennai&postal_code=600028"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?a=b&c=d&e=f

// Playlist Request Body {"content":{"tags":["india","tamil nadu","andhra"],"guid":"10","categories":["video","audio"],"duration":"15","title":"Ad Video"},"demography":{"gender":"male","keywords":["key1"],"education":"B.E (ECE)","interests":["Gardening","Reading Books","Listening Music"],"income":"10000","age":"25"},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"","postal_code":"600028","state":"tamilnadu","gyroscope":"portrait","longitude":"80.24912154","latitude":"12.995290180000001","city":"chennai","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":["20000","20001"],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"channel","imu":["medrect","widesky","full_banner"],"publisher_page":"yume.com"}
- (void)testCase_General017 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'publisher_channel=channel&publisher_page=yume.com&imu=medrect,widesky,full_banner&exclude_placements=20000,20001&a=b&c=d&e=f&age=25&gender=male&interests=Gardening,Reading Books,Listening Music&keywords=key1&income=10000&education=B.E (ECE)&guid=10&title=Ad Video&duration=15&categories=video,audio&tags=india,tamil nadu,andhra&state=tamilnadu&city=chennai&postal_code=600028'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"publisher_channel=channel&publisher_page=yume.com&imu=medrect,widesky,full_banner&exclude_placements=20000,20001&a=b&c=d&e=f&age=25&gender=male&interests=Gardening,Reading Books,Listening Music&keywords=key1&income=10000&education=B.E (ECE)&guid=10&title=Ad Video&duration=15&categories=video,audio&tags=india,tamil nadu,andhra&state=tamilnadu&city=chennai&postal_code=600028";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params : "placement_id=7129"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?placement_id=7129

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24860685","latitude":"12.993759516666666","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"","imu":[],"publisher_page":""}
- (void)testCase_General018 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params : 'placement_id=7129'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"placement_id=7129";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params "publisher_channel=highlights&iabcat=Sports&iabsubcat=WorldSoccer&client_ip=193.35.132.6"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?iabcat=Sports&iabsubcat=WorldSoccer

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"193.35.132.6","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24860685","latitude":"12.993759516666666","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"highlights","imu":[],"publisher_page":""}
- (void)testCase_General019 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'publisher_channel=highlights&iabcat=Sports&iabsubcat=WorldSoccer&client_ip=193.35.132.6'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"publisher_channel=highlights&iabcat=Sports&iabsubcat=WorldSoccer&client_ip=193.35.132.6";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params "education1=B.E (ECE)"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url : http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?education1=B.E%20(ECE)education1=B.E%20(ECE)

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"193.35.132.6","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24860685","latitude":"12.993759516666666","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"highlights","imu":[],"publisher_page":""}
- (void)testCase_General020 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'education1=B.E (ECE)'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"education1=B.E (ECE)";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params "education1= %^{}|\\\"<>`"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url : http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?education1=%20%25%5E%7B%7D%7C%5C%22%3C%3E%60education1=%20%25%5E%7B%7D%7C%5C%22%3C%3E%60

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"193.35.132.6","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24860685","latitude":"12.993759516666666","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"highlights","imu":[],"publisher_page":""}
- (void)testCase_General021 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'education1= %^{}|\\\"<>`'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"education1= %^{}|\\\"<>`";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params "education1=~@#$&*()_-+=[]?;:'./"

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?education1=~%40%23%24&*()_-%2B=%5B%5D%3F%3B%3A'.%2Feducation1=~%40%23%24&*()_-%2B=%5B%5D%3F%3B%3A' .%2F

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"193.35.132.6","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24860685","latitude":"12.993759516666666","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"highlights","imu":[],"publisher_page":""}
- (void)testCase_General022 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'education1=~@#$&*()_-+=[]?;:'./'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @"education1=~@#$&*()_-+=[]?;:'./";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The following Query string params is passed during Initialization / Modify Params: QS Params " higher education = M.E& a=b "

/* Expected behavior */
// 1. SDK frames the playlist url and the JSON object as follows: Playlist Url http://shadow01.yumenetworks.com/dynamic_preroll_playlist.xml?%20higher%20education%20=%20M.E&%20a=b%20%20higher%20education%20=%20M.E&%20a=b%20

// Playlist Request Body {"content":{"tags":[],"guid":"","categories":[],"duration":"","title":""},"demography":{"gender":"","keywords":[],"education":"","interests":[],"income":"","age":""},"connection":{"type":"WiFi","bandwidth":"","service_provider":"sprint"},"referrer":"","geography":{"ip_address":"193.35.132.6","postal_code":"","state":"","gyroscope":"portrait","longitude":"80.24860685","latitude":"12.993759516666666","city":"","country":"us"},"player":{"height":"960","width":"540","version":""},"playlist_version":"v2","yume_sdk":{"exclude_placements":[],"pre_fetch":"false","ad_guid":[],"version":"3.0.10.9"},"device":{"os":"Android","storage_quota_in_mb":"10.0","model":"MB855","height":"960","width":"540","hardware_version":"","uuid":"ddfad7619103f352494da8df598bd747","make":"motorola","os_version":"2.3.4"},"domain":"211yCcbVJNQ","publisher_channel":"highlights","imu":[],"publisher_page":""}
- (void)testCase_General023 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The following Query string params is passed during Initialization / Modify Params: QS Params 'higher education = M.E& a=b'" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.pAdditionalParams = @" higher education = M.E& a=b ";
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Filled Playlist is received with <expiration_time> element missing (or) expiration_time <= 0.

/* Expected behavior */
// 1. Uses the default value for the expiration_time, which is 300 seconds.
- (void)testCase_General024 {
    
    NSString *resultStr = @"";
    resultStr = [resultStr stringByAppendingString:@"\n"];

    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Valid Filled Playlist is received with <expiration_time> element missing (or) expiration_time <= 0." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_MISSING_EXPIRATION_TIME_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Empty Playlist is received with <pre_fetch_call_back_interval> element missing (or) pre_fetch_call_back_interval <= 0.

/* Expected behavior */
// 1. Uses the default value for the pre_fetch_call_back_interval, which is 900 seconds.
- (void)testCase_General025 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Valid Empty Playlist is received with <pre_fetch_call_back_interval> element missing (or) pre_fetch_call_back_interval <= 0." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_EMPTY_MISSING_PREFETCH_CALLBACK_INTERVAL_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Filled Playlist is received with <creative_retry_interval> element missing (or) creative_retry_interval <= 0.

/* Expected behavior */
// 1. Uses the default value for the creative_retry_interval, which is 10 seconds.
- (void)testCase_General026 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Valid Filled Playlist is received with <creative_retry_interval> element missing (or) creative_retry_interval <= 0." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_MISSING_CREATIVE_RETRY_INTERVAL_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    GHTestLog(@"YuMeAdEventAdError");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdError Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Filled Playlist is received with <creative_retry_attempts> element missing (or) creative_retry_attempts <= 0.

/* Expected behavior */
// 1. Uses the default value for the creative_retry_attempts, which is 5.
- (void)testCase_General027 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Valid Filled Playlist is received with <creative_retry_attempts> element missing (or) creative_retry_attempts <= 0." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_MISSING_CREATIVE_RETRY_ATTEMPTS_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdError", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdError" , @"YuMeAdEventAdError");
    GHTestLog(@"YuMeAdEventAdError");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdError Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Valid Filled Mobile Billboard Playlist is received with <cb_active_time> element missing (or) cb_active_time <= 0.

/* Expected behavior */
// 1. Uses the default value for the cb_active_time, which is 5 seconds.
- (void)testCase_General028 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Valid Filled Mobile Billboard Playlist is received with <cb_active_time> element missing (or) cb_active_time <= 0." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_MISSING_CB_ACTIVE_TIME_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"YuMeAdEventAdReady Successful"]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// The 'size' attribute with value > 0 is received for an asset, but a different size is received in GET response for the same asset

/* Expected behavior */
// Storage space should be checked again - if space is available for the difference size calculated, then only asset should be cached, else it should be streamed when playing.
- (void)testCase_General029 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"The 'size' attribute with value > 0 is received for an asset, but a different size is received in GET response for the same asset" forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_FILLED_DIFF_SIZE_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    [self prepare];
    NSArray *userInfo1 = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    GHTestLog(@"YuMeAdEventAdAndAssetsReady");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"yumeSdkShowAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [YuMeSdkUnitUtils waitForCompletion:5];
  
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"Storage space should be checked again - if space is available for the difference size calculated, then only asset should be cached, else it should be streamed when playing."]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Addition of User Agent header in HTTP requests.

/* Expected behavior */
// The User Agent header containing App Name and Version should go out in all the HTTP requests.
- (void)testCase_General034 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Addition of User Agent header in HTTP requests." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);
    
    GHTestLog(@"pAdditionalParams : %@", params.pAdditionalParams);
    
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelectorInBackground:@selector(generalEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    GHTestLog(@"YuMeAdEventAdReady");
    
    resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:@"The User Agent header containing App Name and Version should go out in all the HTTP requests."]];
    [testCaseResult setObject:resultStr forKey:@"status"];
    [testCaseResult setObject:@"Pass" forKey:@"result"];
    [resultArray addObject:testCaseResult];
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
/* Expected behavior */
- (void)testCase_General030 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    NSString *str = @"NA for Latest iOS SDK.";
    [testCaseResult setObject:str forKey:@"status"];
    [testCaseResult setObject:@"Fail" forKey:@"result"];
    [resultArray addObject:testCaseResult];
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
/* Usecase */
/* Expected behavior */
- (void)testCase_General031 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];
    
    NSString *str = @"NA for Latest iOS SDK.";
    [testCaseResult setObject:str forKey:@"status"];
    [testCaseResult setObject:@"Fail" forKey:@"result"];
    [resultArray addObject:testCaseResult];
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
/* Usecase */
/* Expected behavior */
- (void)testCase_General032 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    NSString *str = @"NA for Latest iOS SDK.";
    [testCaseResult setObject:str forKey:@"status"];
    [testCaseResult setObject:@"Fail" forKey:@"result"];
    [resultArray addObject:testCaseResult];
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
/* Usecase */
/* Expected behavior */
- (void)testCase_General033 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    NSString *str = @"NA for Latest iOS SDK.";
    [testCaseResult setObject:str forKey:@"status"];
    [testCaseResult setObject:@"Fail" forKey:@"result"];
    [resultArray addObject:testCaseResult];
    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
}

/* Pre conditions */
// SDK State: Initialized
/* Usecase */
/* Expected behavior */
- (void)testCase_General035 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    NSString *str = @"Please execute the test manually and check if expired cookies are not sent in subsequent requests.";
    [testCaseResult setObject:str forKey:@"status"];
    [testCaseResult setObject:@"Fail" forKey:@"result"];
    [resultArray addObject:testCaseResult];
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"General"];
#endif

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    
}

@end
