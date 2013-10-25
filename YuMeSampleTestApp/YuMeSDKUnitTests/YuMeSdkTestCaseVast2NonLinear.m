//
//  YuMeSdkTestCaseVast2NonLinear.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 10/10/13.
//  Copyright (c) 2013 Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkTestCaseVast2NonLinear.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkTestCaseVast2NonLinear

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

- (void)vast2NonLinearEventListener:(NSArray *)userInfo {
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

// 	Vast2NonLinear : Vast having non Linear creative
// SDK State: Initialized

// To verify whether the ad is getting played when the VAST2.0 ad having multiple non linear creatives

// The ad should get played when the VAST2.0 ad having multiple non linear creatives
- (void)testVA2NLI_TC_0001 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the VAST2.0 ad having multiple non linear creatives" forKey:@"useCase"];
    
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
}

// 	Vast2Linear : LinearAdinNonLinearPlacement
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 NON linear ad configured in the preroll slot with the below mentioned tag and view the ad in the player and the empty external tracker appears with the reason=Linear ad in non-linear placemen

// The ad should NOT get played when the VAST2.0 NON linear ad configured in the preroll slot with the below mentioned tag and view the ad in the player and the empty external tracker should appear with the reason=Linear ad in non-linear placement.
// URL:htt
- (void)testVA2NLI_TC_0002 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 NON linear ad configured in the preroll slot with the below mentioned tag and view the ad in the player and the empty external tracker appears with the reason=Linear ad in non-linear placemen" forKey:@"useCase"];
    
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
}


@end
