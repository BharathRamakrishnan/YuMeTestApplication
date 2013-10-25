//
//  YuMeSdkUnitTestClearCache.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestClearCache.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestClearCache

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

- (void)eventListener:(NSArray *)userInfo {
    NSString *sel = [userInfo objectAtIndex:0];
    NSString *event = [userInfo objectAtIndex:1];
    
    BOOL b = [YuMeSdkUnitUtils yumeEventListenerLock:event];
    if (b)
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(sel)];
    else
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(sel)];
}


/* Pre conditions */
// SDK State:Not Initialized

/* Usecase */
// Called when SDK is not  initialized.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_ClearCache(): YuMe SDK is not Initialized."
- (void)testCase_ClearCache001 {
    
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
    
    GHAssertFalse([yumeSDK yumeSdkClearCache:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkClearCache(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : yumeSdkClearCache(): YuMe SDK is not Initialized.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// No prefetch operation is attempted after SDK initialization.

/* Expected behavior */
// 1. Clears the assets in cache.
- (void)testCase_ClearCache002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"No prefetch operation is attempted after SDK initialization." forKey:@"useCase"];

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
    
    GHAssertTrue([yumeSDK yumeSdkClearCache:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHFail(@"Error : %@", str.description);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkClearCache Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
//Auto-Prefetch: OFF

/* Usecase */
// Prefetch operation is completed (or) currently in progress (or) paused (or) aborted.

/* Expected behavior */
// 1. Stops the prefetch related timers, if running.
// 2. Aborts the ongoing downloads.
// 3. Clears the assets in cache.
// 4. Clears the partly downloaded assets.
// 5. Performs the necessary internal clean-up.
// 6. Sets the download status as NOT_IN_PROGRESS.
- (void)testCase_ClearCache003 {
    
    NSString *resultStr = @"";
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Prefetch operation is completed (or) currently in progress (or) paused (or) aborted." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    params.pAdServerUrl = VALID_200_OK_PL;
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
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        resultStr = [resultStr stringByAppendingString:[YuMeSdkUnitUtils logString:str]];
        [testCaseResult setObject:resultStr forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(eventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkClearCache:&pError], @"");
    GHTestLog(@"yumeSdkClearCache called.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHFail(@"Error : %@", str.description);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkClearCache Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
    
    pError = nil;
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHTestLog(@"downloadStatus : %d", downloadStatus);
    GHAssertEquals(downloadStatus, 2, @"NOT_IN_PROGRESS Failed");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHFail(@"Error : %@", str.description);
        GHTestLog(@"Error : %@", str.description);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON

/* Usecase */
// Prefetch operation is completed (or) currently in progress (or) paused (or) aborted.

/* Expected behavior */
// 1. Stops the prefetch related timers, if running.
// 2. Aborts the ongoing downloads.
// 3. Clears the assets in cache.
// 4. Clears the partly downloaded assets.
// 5. Performs the necessary internal clean-up.
// 6. Sets the download status as NOT_IN_PROGRESS.
// 7. Makes a new prefetch request (ad_block_type: last fetched type) to the server.
// 8. Handles the response received.
- (void)testCase_ClearCache004 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
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
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelectorInBackground:@selector(eventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");

    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkClearCache:&pError], @"");
    GHTestLog(@"yumeSdkClearCache called.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkClearCache Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }

    pError = nil;
    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHAssertEquals(downloadStatus, 2, @"NOT_IN_PROGRESS Failed");
    GHTestLog(@"downloadStatus : %d", downloadStatus);
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHFail(@"Error : %@", str.description);
        GHTestLog(@"Error : %@", str.description);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    [self waitForTimeout:5];
}

/* Pre conditions */
// SDK State: Initialized
// Caching: ON
// Auto-Prefetch: ON/OFF

/* Usecase */
// Ad play (startAd (or) showAd) in progress.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_ClearCache(): Ad Play in Progress."
- (void)testCase_ClearCache005 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = VALID_200_OK_PL;
    params.bEnableAutoPrefetch = TRUE;
    params.bEnableCaching = TRUE;
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
    
    GHAssertTrue([yumeSDK yumeSdkStartAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    GHTestLog(@"yumeSdkStartAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdPlaying", nil];
    [self performSelectorInBackground:@selector(eventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdPlaying" , @"YuMeAdEventAdPlaying");
    GHTestLog(@"YuMeAdEventAdPlaying Fired.");
    
    [self waitForTimeout:2];
    
    GHAssertTrue([yumeSDK yumeSdkClearCache:&pError], @"");
    GHTestLog(@"yumeSdkClearCache called.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkClearCache(): Ad Play in Progress.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Failed : yumeSdkClearCache(): Ad Play in Progress.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [yumeSDK yumeSdkStopAd:&pError];
    GHTestLog(@"Ad Stopped");
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"ClearCache"];
#endif

}

@end
