//
//  YuMeSdkUnitTestGetDownloadPercentage.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestGetDownloadPercentage.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestGetDownloadPercentage

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

- (void)downPerEventListener:(NSArray *)userInfo {
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
// 1. Throws Exception: "YuMeSDK_GetDownloadedPercentage(): YuMe SDK is not Initialized."
- (void)testCase_GetDownloadedPercentage001 {
    
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
    
    GHAssertFalse([yumeSDK yumeSdkGetDownloadedPercentage:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkGetDownloadedPercentage(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Failed: yumeSdkGetDownloadedPercentage(): YuMe SDK is not Initialized.";;
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Fetching assets' size (HEAD request) in progress.

/* Expected behavior */
// 1. Returns 0%.
- (void)testCase_GetDownloadedPercentage002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Fetching assets' size (HEAD request) in progress." forKey:@"useCase"];

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
    
    pError = nil;
    [yumeSDK yumeSdkClearCache:&pError];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(downPerEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    pError = nil;
    float dPer = [yumeSDK yumeSdkGetDownloadedPercentage:&pError];
    NSString *timeValue = [NSString stringWithFormat:@"%.2f", dPer];
    GHAssertEqualObjects(timeValue, @"0.00", @" yumeSdkGetDownloadedPercentage : Fail");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkGetDownloadedPercentage Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}


/* Pre conditions */
// SDK State:Not Initialized

/* Usecase */
// Asset downloads in progress.

/* Expected behavior */
// 1. Returns the % of assets downloaded so far.
- (void)testCase_GetDownloadedPercentage003 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Asset downloads in progress." forKey:@"useCase"];

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
    
    pError = nil;
    [yumeSDK yumeSdkClearCache:&pError];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(downPerEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    [self waitForTimeout:1];
    
    pError = nil;
    float dPer = [[pYuMeTestInterface getYuMeSDKHandle] yumeSdkGetDownloadedPercentage:&pError];
    //NSString *timeValue = [NSString stringWithFormat:@"%.2f", dPer];
    GHAssertTrue((dPer >= 0.000000 ? TRUE: FALSE), @"yumeSdkGetDownloadedPercentage : Done");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkGetDownloadedPercentage Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}


/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset downloads paused.

/* Expected behavior */
// 1. Returns the % of assets downloaded so far.
- (void)testCase_GetDownloadedPercentage004 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Asset downloads paused." forKey:@"useCase"];

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
    
    pError = nil;
    [yumeSDK yumeSdkClearCache:&pError];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(downPerEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    [self waitForTimeout:1];

    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkPauseDownload:&pError], @"");
    GHTestLog(@"yumeSdkPauseDownload called");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }

    pError = nil;
    float dPer = [[pYuMeTestInterface getYuMeSDKHandle] yumeSdkGetDownloadedPercentage:&pError];
    GHAssertTrue((dPer >= 0 ? TRUE: FALSE), @"yumeSdkGetDownloadedPercentage : Done");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkGetDownloadedPercentage Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset downloads completed and ad is ready for playing.

/* Expected behavior */
// 1. Returns 100%.
- (void)testCase_GetDownloadedPercentage005 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Asset downloads completed and ad is ready for playing." forKey:@"useCase"];

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
    
    pError = nil;
    [yumeSDK yumeSdkClearCache:&pError];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdAndAssetsReady", nil];
    [self performSelector:@selector(downPerEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdAndAssetsReady" , @"YuMeAdEventAdAndAssetsReady");
    
    pError = nil;
    float dPer = [[pYuMeTestInterface getYuMeSDKHandle] yumeSdkGetDownloadedPercentage:&pError];
    GHAssertTrue((dPer == 100.0 ? TRUE: FALSE), @"yumeSdkGetDownloadedPercentage : Done");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkGetDownloadedPercentage Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}


/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// No asset downloads in progress / assets downloads aborted.

/* Expected behavior */
// 1. Returns 0%.
- (void)testCase_GetDownloadedPercentage006 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"No asset downloads in progress / assets downloads aborted." forKey:@"useCase"];

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
    
    pError = nil;
    [yumeSDK yumeSdkClearCache:&pError];
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(downPerEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkAbortDownload:&pError], @"");
    GHTestLog(@"yumeSdkAbortDownload called");
    float dPer = [[pYuMeTestInterface getYuMeSDKHandle] yumeSdkGetDownloadedPercentage:&pError];
    GHAssertTrue((dPer >= 0.0 ? TRUE: FALSE), @"yumeSdkGetDownloadedPercentage : Done");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        GHFail(@"Error : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkGetDownloadedPercentage Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Get Download Percentage"];
#endif

}

@end
