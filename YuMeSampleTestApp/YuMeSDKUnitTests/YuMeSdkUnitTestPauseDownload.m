//
//  YuMeSdkUnitTestPauseDownload.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestPauseDownload.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestPauseDownload

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

- (void)pauseEventListener:(NSArray *)userInfo {
    NSString *sel = [userInfo objectAtIndex:0];
    NSString *event = [userInfo objectAtIndex:1];
    
    BOOL b = [YuMeSdkUnitUtils yumeEventListenerLock:event];
    if (b)
        [self notify:kGHUnitWaitStatusSuccess forSelector:NSSelectorFromString(sel)];
    else
        [self notify:kGHUnitWaitStatusFailure forSelector:NSSelectorFromString(sel)];
}


/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called when SDK is NOT initialized.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_PauseDownload(): YuMe SDK is not Initialized."
- (void)testCase_PauseDownload001 {
    
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
    
    GHAssertFalse([yumeSDK yumeSdkPauseDownload:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkPauseDownload(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Failed: yumeSdkPauseDownload(): YuMe SDK is not Initialized.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// No asset downloads in progress.

/* Expected behavior */
// 1. Does nothing.
- (void)testCase_PauseDownload002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"No asset downloads in progress." forKey:@"useCase"];

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

    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkPauseDownload:&pError], @"yumeSdkPauseDownload Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHFail(@"Error : %@", str.description);
        GHTestLog(@"Error : %@", str.description);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkPauseDownload Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Asset downloads in progress.

/* Expected behavior */
// 1. Pauses the ongoing asset downloads.
// 2. Sets the download status to PAUSED.
- (void)testCase_PauseDownload003 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Asset downloads in progress." forKey:@"useCase"];

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
    if (pError)
        GHFail(@"Error : %@", [YuMeSdkUnitUtils getErrDesc:pError].description);
    
    [self prepare];
    
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdReady", nil];
    [self performSelector:@selector(pauseEventListener:) withObject:userInfo afterDelay:0.1];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdReady" , @"YuMeAdEventAdReady");
    
    [self waitForTimeout:2];
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkPauseDownload:&pError], @"yumeSdkPauseDownload Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHFail(@"Error : %@", str.description);
        GHTestLog(@"Error : %@", str.description);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkPauseDownload Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }

    YuMeDownloadStatus downloadStatus = [yumeSDK yumeSdkGetDownloadStatus:&pError];
    GHTestLog(@"downloadStatus : %u", downloadStatus);
    GHAssertEquals(downloadStatus, 3, @"Paused Failed");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Pause Download"];
#endif

}

@end
