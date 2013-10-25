//
//  YuMeSdkTestCaseVast2Linear.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 10/10/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkTestCaseVast2Linear.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkTestCaseVast2Linear

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
/*- (void)failWithException:(NSException *)exception {
    NSLog(@"");
}*/

- (void)vast2LinearEventListener:(NSArray *)userInfo {
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


// Vast2Linear : EmptyResponse

// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed empty
// URL: http://download.yumenetworks.com/yume/hariharan/visnu/vpai

// The ad should NOT get played and empty external ad tracker should get hit with the reason=1

- (void)testVA2LI_TC_0001 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
  
    // add testcasae
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed empty"];

    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = EMPTY_NO_CREATIVE;
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
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Fail"];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"The ad should NOT get played and empty external ad tracker should get hit with the reason=1";
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(vast2LinearEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");

    /*
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = @"The ad should NOT get played and empty external ad tracker should get hit with the reason=1";
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
    }
     */
}

// Vast2Linear :3rdpartyserverdoesnotrespond
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=21
// URL:http://10.10.30.145/2012/july_2012/july_18_html5/playlist/dynamic_preroll_playlist2.xm

// The ad should NOT get played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=21
- (void)testVA2LI_TC_0002 {
    
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];

    // add testcasae
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=21"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
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
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Fail"];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(vast2LinearEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = @"The ad should NOT get played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=21";
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
    }
}

// Vast2Linear : NoChildNodes
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed contains no children
// URL:http://download.yumenetworks.com/yume/harih

// The ad should NOT get played and empty external ad tracker should get hit with the reason=2
- (void)testVA2LI_TC_0003 {
    NSString *testId = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"test" withString:@""];
    
    // add testcasae
    [YuMeSdkUnitUtils createTestCase:testCaseResult testCaseId:testId preCondition:@"SDK State: Initialized" useCase:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed contains no children"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = EMPTY_NO_CHILDREN;
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
    
    pError = nil;
    GHAssertTrue([yumeSDK yumeSdkInitAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError].description;
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Fail"];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    GHTestLog(@"yumeSdkInitAd Successful.");
    
    [self prepare];
    NSArray *userInfo = [NSArray arrayWithObjects: NSStringFromSelector(_cmd), @"YuMeAdEventAdNotReady", nil];
    [self performSelectorInBackground:@selector(vast2LinearEventListener:) withObject:userInfo];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTIME_OUT];
    GHAssertEqualStrings([YuMeSdkUnitUtils getStatusString] , @"YuMeAdEventAdNotReady" , @"YuMeAdEventAdNotReady");
    GHTestLog(@"YuMeAdEventAdNotReady");
    
    pError = nil;
    GHAssertFalse([yumeSDK yumeSdkShowAd:YuMeAdTypePreroll errorInfo:&pError], @"");
    if (pError) {
        NSString *str = @"The ad should NOT get played and empty external ad tracker should get hit with the reason=2";
        [YuMeSdkUnitUtils closeTestCase:testCaseResult status:str result:@"Pass"];
    }
}

// Vast2Linear : NoAdNode
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed contains no ad node
// URL: http://download.yumenetworks.com/yume/harih

// The ad should NOT get played when the following feed url is used to configure the ad and the empty external ad tracker should appear with the reason=3
- (void)testVA2LI_TC_0004 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed contains no ad node" forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_NO_ADNODE;
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

// Vast2Linear : FeedNotFound
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed not found
// URL: http://download.yumenetworks.com/yume/hariharan/visnu

// The ad should NOT get played when the following feed url is used to configure the ad and the empty external ad tracker should appear with the reason=4

- (void)testVA2LI_TC_0005 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason=empty_response, xml feed not found" forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_FEED;
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

// Vast2Linear : NoCreative
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason= empty_response, xml feed contains no creative
//URL: http://download.yumenetworks.com/yume/hari

// The ad should NOT get played when the following feed url is used to configure the ad and the empty external ad tracker should appear with the reason= 5
- (void)testVA2LI_TC_0006 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad and the empty external ad tracker appears with the reason= empty_response, xml feed contains no creative." forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = EMPTY_NO_CREATIVE;
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

// Vast2Linear : TrackerExceeded
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the following feed url is used to configure the ad when the xml feed returns response with more trackers for each quartiles which exceeds the maximum tracker mentioned in the network administrator and th

// The ad should NOT get played when the following feed url is used to configure the ad when the xml feed returns response with more trackers for each quartiles which exceeds the maximum tracker mentioned in the network administrator and the empty external ad
- (void)testVA2LI_TC_0007 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the following feed url is used to configure the ad when the xml feed returns response with more trackers for each quartiles which exceeds the maximum tracker mentioned in the network administrator and th" forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = TRACKERS_EXCEEDED;
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

// Vast2Linear : TrackerMax
// SDK State: Initialized

// To verify whether the ad is getting played when the VAST2.0  ad is configured with the following tag which returns response with more trackers for each quartile which meets the maximum tracker which is mentioned in network administrator:
// URL:http://downl

//The ad should get played when the VAST2.0  ad is configured with the following tag which returns response with more trackers for each quartile which meets the maximum tracker which is mentioned in network administrator:
// URL: http://download.yumenetworks.c
- (void)testVA2LI_TC_0008 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the VAST2.0  ad is configured with the following tag which returns response with more trackers for each quartile which meets the maximum tracker which is mentioned in network administrator:" forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = TRACKERS_EXCEEDED;
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

// Vast2Linear : WrapperExceeded
// SDK State: Initialized

// To verify wheher the ad is NOT getting played when the following feed url is used to configure the ad when the xml feed returns response with more wrappers which exceeds the maximum wrapper mentioned in the network administrator and the empty external ad

// The ad  should NOT get played when the following feed url is used to configure the ad when the xml feed returns response with more wrappers which exceeds the maximum wrapper mentioned in the network administrator and the empty external ad tracker should a

- (void)testVA2LI_TC_0009 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify wheher the ad is NOT getting played when the following feed url is used to configure the ad when the xml feed returns response with more wrappers which exceeds the maximum wrapper mentioned in the network administrator and the empty external ad" forKey:@"useCase"];
    
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

// Vast2Linear : WrapperMax
// SDK State: Initialized

// To verify whether the ad is getting played when the VAST2.0  ad is configured with the following tag which returns response with wrappers which meets the maximum wrappers which is mentioned in network administrator
// URL:http://download.yumenetworks.com/y

// The ad should get played when the VAST2.0  ad is configured with the following tag which returns response with wrappers which meets the maximum wrappers which is mentioned in network administrator
// URL:http://download.yumenetworks.com/yume/hariharan/visn

- (void)testVA2LI_TC_0010 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the VAST2.0  ad is configured with the following tag which returns response with wrappers which meets the maximum wrappers which is mentioned in network administrator." forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
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

// 	Vast2Linear : CreativeIncomatible
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0  ad is configured with the following tag which returns response with non complaint vpaid tag and the empty external ad tracker appears with the reason=incompatible_creative, noncompliant vpai

// N/A. Supports only for Web Based SDKs
- (void)testVA2LI_TC_0011 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0  ad is configured with the following tag which returns response with non complaint vpaid tag and the empty external ad tracker appears with the reason=incompatible_creative, noncompliant vpaid." forKey:@"useCase"];
    
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

// Vast2Linear : InCompatibleCreativeAS2VPAID
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0  ad is configured with the following tag which returns response with as2 vpaid tag then view the ad in the as3 player and the empty external ad tracker appears with the reason= incompatible_c

// N/A. Supports only for Web Based SDKs
- (void)testVA2LI_TC_0012 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0  ad is configured with the following tag which returns response with as2 vpaid tag then view the ad in the as3 player and the empty external ad tracker appears with the reason= incompatible_c" forKey:@"useCase"];
    
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

// Vast2Linear : InCompatibleCreativeAS3VPAID
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0  ad is configured with the following tag which returns response with as3 vpaid tag then view the ad in the as2 player and empty external ad tracker appears with the reason=incompatible_creati

// N/A. Supports only for Web Based SDKs

- (void)testVA2LI_TC_0013 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0  ad is configured with the following tag which returns response with as3 vpaid tag then view the ad in the as2 player and empty external ad tracker appears with the reason=incompatible_creati." forKey:@"useCase"];
    
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

// Vast2Linear : FeedMalFormed
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 ad is configured with the following tag which returns the malformed xml response and empty external ad tracker appears with the reason=other, xml feed malformed
// URL:http://download.yumenet

// The ad should NOT get played when the VAST2.0 ad is configured with the following tag which returns the malformed xml response and empty external ad tracker should appear with the reason=14

- (void)testVA2LI_TC_0014 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 ad is configured with the following tag which returns the malformed xml response and empty external ad tracker appears with the reason=other, xml feed malformed." forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    params.pAdServerUrl = XML_MALFORMED;
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

// Vast2Linear : VpaidAdError
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 ad is configured with the following tag which returns the response with ad error vpaid then view the ad in the player and empty external ad tracker appears with a reason=other, vpaid ad error

// N/A. Supports only for Web Based SDKs

- (void)testVA2LI_TC_0015 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 ad is configured with the following tag which returns the response with ad error vpaid then view the ad in the player and empty external ad tracker appears with a reason=other, vpaid ad error." forKey:@"useCase"];
    
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

// Vast2Linear : AdUnreachableVpaidSwfNotFound
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 ad is configured with the following tag which returns a reponse with the VPAID SWF not found , view the ad in the player and empty external ad tracker appears with reason=ad_unreachable, vpai

// N/A. Supports only for Web Based SDKs

- (void)testVA2LI_TC_0016 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 ad is configured with the following tag which returns a reponse with the VPAID SWF not found , view the ad in the player and empty external ad tracker appears with reason=ad_unreachable, vpaid." forKey:@"useCase"];
    
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

// Vast2Linear : AdUnreachableVastCreativeNotFound
// SDK State: Initialized

// To verify whether the ad is NOT get played when the VAST2.0 ad is configured with the following tag which returns a reponse with the VAST creative not found , view the ad in the player and empty external ad tracker appears with reason=ad_unreachable, vast

// The ad should NOT get played when the VAST2.0 ad is configured with the following tag which returns a reponse with the VAST creative not found , view the ad in the player and empty external ad tracker should appear with reason=18
// URL: http://download.yum

- (void)testVA2LI_TC_0017 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT get played when the VAST2.0 ad is configured with the following tag which returns a reponse with the VAST creative not found , view the ad in the player and empty external ad tracker appears with reason=ad_unreachable, vast." forKey:@"useCase"];
    
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

// Vast2:Linear : NonLinearAdInLinearPlacement
// SDK State: Initialized

// To verify whether the ad is NOT getting playing when the VAST2.0 linear ad configured in the overlay slot with the below mentioned tag and view the ad in the player,and empty external ad tracker appears with the reason=Non-linear ad in linear placement URL

// The ad should NOT get played when the VAST2.0 linear ad configured in the overlay slot with the below mentioned tag and view the ad in the player,and empty external ad tracker should appear with the reason=20
// URL: http://vast.bp3847225.btrll.com/vast/384

- (void)testVA2LI_TC_0018 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting playing when the VAST2.0 linear ad configured in the overlay slot with the below mentioned tag and view the ad in the player,and empty external ad tracker appears with the reason=Non-linear ad in linear placement URL." forKey:@"useCase"];
    
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

// Vast2:Linear : SecurityError
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 linear ad configured with the below mentioned tag returns a reponse which contains a VPAID swf with the security error, view the ad in the player and empty external ad tracker appears with th

//N/A. Supports only for Web Based SDKs
- (void)testVA2LI_TC_0019 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 linear ad configured with the below mentioned tag returns a reponse which contains a VPAID swf with the security error, view the ad in the player and empty external ad tracker appears with th." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlainVideoAdPlay
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the plainvideo ad

// The ad should get played in the player when the VAST2XML repsonse is serving the plain video ad
- (void)testVA2LI_TC_0020 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the plainvideo ad." forKey:@"useCase"];
    
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

// Vast2Linear : PlainImageAdPlay
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the plainimage ad

// The ad should get played in the player when the VAST2XML repsonse is serving the plain image ad
- (void)testVA2LI_TC_0021 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the plainimage ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : ResponseVAST2.0Ad
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the VAST2.0 ad

// The ad should get played in the player when the VAST2XML repsonse is serving the VAST2.0 ad
- (void)testVA2LI_TC_0022 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the VAST2.0 ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : FirstGenMobileBillBoardAd
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the First Gen Mobile Billboard ad

// The ad should get played in the player when the VAST2XML repsonse is serving the First Gen Mobile Billboard ad
- (void)testVA2LI_TC_0023 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the First Gen Mobile Billboard ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : FirstGenMobileConnectAd
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the First Gen Mobile Connect ad

// The ad should get played in the player when the VAST2XML repsonse is serving the First Gen Mobile Connect ad
- (void)testVA2LI_TC_0024 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the First Gen Mobile Connect ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : NextGenMobileBillBoardAd
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Next/Second Gen Mobile Billboard ad

// The ad should get played in the player when the VAST2XML repsonse is serving the Next/Second Gen Mobile Billboard ad
- (void)testVA2LI_TC_0025 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Next/Second Gen Mobile Billboard ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : NextGenMobileConnectAd
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Next/Second Gen Mobile Connect ad

// The ad should get played in the player when the VAST2XML repsonse is serving the Next/Second Gen Mobile Billboard ad
- (void)testVA2LI_TC_0026 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Next/Second Gen Mobile Connect ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : ResponseMobileFlipTap
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Mobile Flip Tap

// The ad should get played in the player when the VAST2XML repsonse is serving the Mobile Flip Tap
- (void)testVA2LI_TC_0027 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Mobile Flip Tap" forKey:@"useCase"];
    
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

// 	Vast2Linear : ResponseMobileFlipSwipe
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Mobile Flip Swipe

// The ad should get played in the player when the VAST2XML repsonse is serving the Mobile Flip Swipe
- (void)testVA2LI_TC_0028 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the Mobile Flip Swipe." forKey:@"useCase"];
    
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

//  Vast2Linear : ResponseSlateBasedClick2video
// SDK State: Initialized

// To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the slate based click2video ad

// The ad should get played in the player when the VAST2XML repsonse is serving the slate based click2video ad
- (void)testVA2LI_TC_0029 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify the appearance of the ad in the player when the VAST2XML adresponse is returning the slate based click2video ad." forKey:@"useCase"];
    
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

// 	Vast2Linear : InvalidVastVPAID
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 VPAID ad is configured

// The ad should NOT get played when the VAST2.0 VPAID ad is configured
- (void)testVA2LI_TC_0030 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 VPAID ad is configured." forKey:@"useCase"];
    
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

// 	Vast2Linear : ValidVastLinearAd	SDK State: Initialized

// To verify whether the ad is getting played when the VAST2.0 Linear ad is configured

// The ad should get played when the VAST2.0 linear ad is configured
- (void)testVA2LI_TC_0031 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the VAST2.0 Linear ad is configured." forKey:@"useCase"];
    
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

// 	Vast2Linear : InvalidVastNonLinearAd
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 Non Linear ad is configured

// The ad should NOT get played when the VAST2,0 Non Linear ad is configured
- (void)testVA2LI_TC_0032 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 Non Linear ad is configured." forKey:@"useCase"];
    
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

// 	Vast2Linear : ValidVastLinearWrapperAd
// SDK State: Initialized

// To verify whether the ad is getting played when the VAST2.0 Linear Wrapper ad is configured

// The ad should get played when the VAST2.0 Linear Wrapper ad is configured
- (void)testVA2LI_TC_0033 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the VAST2.0 Linear Wrapper ad is configured." forKey:@"useCase"];
    
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

// 	Vast2Linear : MaxWrapperRetry
// SDK State: Initialized

// To verify whether the SDK retries the download of the wrapper when the VAST2.0 wrapper fails to download for the first tim based on the parameter "MaxWrapperRetry"

// The SDK should retry the download of the wrapper when the VAST2.0 wrapper fails to download for the first tim based on the parameter "MaxWrapperRetry"
- (void)testVA2LI_TC_0034 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the SDK retries the download of the wrapper when the VAST2.0 wrapper fails to download for the first tim based on the parameter 'MaxWrapperRetry'." forKey:@"useCase"];
    
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

// 	Vast2Linear : ExtensionTypeYuMe
// SDK State: Initialized

// To verify whether the ad is getting played only when the "<Extension type="YuMe">" appears below the <Extensions> block in the VAST2XML adresponse

// The ad should get played only when the "<Extension type="YuMe">" appears below the <Extensions> block in the VAST2XML adresponse
- (void)testVA2LI_TC_0035 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played only when the '<Extension type='YuMe'>' appears below the <Extensions> block in the VAST2XML adresponse." forKey:@"useCase"];
    
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

// 	Vast2Linear : NotExtensionTypeYuMe
// SDK State: Initialized

// To verify whether the ad is NOT getting played only when the "<Extension type="YuMe">" is NOT appearing below the <Extensions> block in the VAST2XML adresponse

// The ad should get played only when the "<Extension type="YuMe">" appears below the <Extensions> block in the VAST2XML adresponse
- (void)testVA2LI_TC_0036 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played only when the '<Extension type='YuMe'>' is NOT appearing below the <Extensions> block in the VAST2XML adresponse." forKey:@"useCase"];
    
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

// Vast2Linear : VastToRTMPCreative
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the third  party VAST2.0 ad is configured which in turns returns the "RTMP" type of Creative

// The ad should NOT get played when the third  party VAST2.0 ad is configured which in turns returns the "RTMP" type of Creative
- (void)testVA2LI_TC_0037 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the third  party VAST2.0 ad is configured which in turns returns the 'RTMP' type of Creative." forKey:@"useCase"];
    
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

// 	Vast2Linear : VastToHTTPCreative
// SDK State: Initialized

// To verify whether the ad is getting played when the third party VAST2.0 ad is configured which in turn returns  the "HTTP" type Creative

// The ad should get played when the third party VAST2.0 ad is configured which in turn returns  the "HTTP" type Creative
- (void)testVA2LI_TC_0038 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the third party VAST2.0 ad is configured which in turn returns  the 'HTTP' type Creative." forKey:@"useCase"];
    
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

// 	Vast2Linear : WrapperLevelCreative
// SDK State: Initialized

// To verify whether the wrapper level creatives are considered to display to ad in the player

// The wrapper level creatives should be considered  to display the ad in the player
- (void)testVA2LI_TC_0039 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the wrapper level creatives are considered to display to ad in the player." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlayLeastSequenceNumCreative
// SDK State: Initialized

// To verify whether the least sequence number creative is taken to play the creative in the player when the sequence number is available in the VAST2.0 third party tag

// The least sequence number creative should be taken to play the creative in the player when the sequence number is available in the VAST2.0 third party tag
- (void)testVA2LI_TC_0040 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the least sequence number creative is taken to play the creative in the player when the sequence number is available in the VAST2.0 third party tag." forKey:@"useCase"];
    
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

// 	Vast2Linear : NoSequencePlayFirstCreative
// SDK State: Initialized

// To verify whether the first creative in the sequence is taken to play the ad when the sequence number is NOT available in the VAST2.0 third party tag

// The first creative in the sequence should be taken to play the ad when the sequence number is NOT available in the VAST2.0 third party tag
- (void)testVA2LI_TC_0041 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the first creative in the sequence is taken to play the ad when the sequence number is NOT available in the VAST2.0 third party tag." forKey:@"useCase"];
    
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

// 	Vast2Linear : With/withoutSequencePlayFirstCreative
// SDK State: Initialized

// To verify whether the first creative is taken to play when the multiple creatives with or without sequence ids is available in the VAST2.0 Wrapper Third party tag

// The first creative should be taken to play when the multiple creatives with or without sequence ids is available in the VAST2.0 Wrapper Third party tag
- (void)testVA2LI_TC_0042 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the first creative is taken to play when the multiple creatives with or without sequence ids is available in the VAST2.0 Wrapper Third party tag." forKey:@"useCase"];
    
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

// 	Vast2Linear : With/withoutSequencePlayFirstCreative
// SDK State: Initialized

// To verify whether the main creative with least sequence id is played when VAST Linear ad is having multiple creatives – some with sequence ids and some without sequence ids.

// The main creative with least sequence id should be played when VAST Linear ad is having multiple creatives – some with sequence ids and some without sequence ids.
- (void)testVA2LI_TC_0043 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the main creative with least sequence id is played when VAST Linear ad is having multiple creatives – some with sequence ids and some without sequence ids." forKey:@"useCase"];
    
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

// 	Vast2Liner : MatchingSequenceCreativeAndCompanion
// SDK State: Initialized

// To verify whether the companion banners are get served based on the sequence number of the main creative is matching with the sequence number of the companion banner

// The companion banners should  get served based on the sequence number of the main creative is matching with the sequence number of the companion banner
- (void)testVA2LI_TC_0044 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the companion banners are get served based on the sequence number of the main creative is matching with the sequence number of the companion banner." forKey:@"useCase"];
    
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

// 	Vast2Liner : NotMatchingSequenceCreativeAndCompanion
// SDK State: Initialized

// To verify whether the companion banner is NOT getting served when the sequence number of the main creative is NOT matching with the sequence number of the companion banner

// The companion banner should NOT get served when the sequence number of the main creative is NOT matching with the sequence number of the companion banner
- (void)testVA2LI_TC_0045 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the companion banner is NOT getting served when the sequence number of the main creative is NOT matching with the sequence number of the companion banner." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlayFirstAdFromMultipleAdd
// SDK State: Initialized

// To verify whether the First ad is getting played when the multiple ads are available in the VAST2.0 third party tag ad response

// The First ad should get played when the multiple ads are available in the VAST2.0 third party tag ad response
- (void)testVA2LI_TC_0046 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the First ad is getting played when the multiple ads are available in the VAST2.0 third party tag ad response." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlayAdwithSequenceNumber
// SDK State: Initialized

// To verify whether the ad is getting played when the sequence number is available for the creatives of VAST2.0 NON linear third party ad response

// The ad should get played when the sequence number is available for the creatives of VAST2.0 NON linear third party ad response
- (void)testVA2LI_TC_0047 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the sequence number is available for the creatives of VAST2.0 NON linear third party ad response." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlayAdwithSizeAttribute
// SDK State: Initialized

// To verify whether the ad is getting played when the size attribute appears in the playlist for the creatives

// The ad should get played when the size attribute appears in the playlist for the creatives
- (void)testVA2LI_TC_0048 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the size attribute appears in the playlist for the creatives." forKey:@"useCase"];
    
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

// 	Vast2Linear : Vast2NonLinearAd
// SDK State: Initialized

// To verify whether the ad is getting played when the VAST2.0 ad having multiple non linear creatives

// The ad should get played when the VAST2.0 ad having multiple non linear creatives
- (void)testVA2LI_TC_0049 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played when the VAST2.0 ad having multiple non linear creatives." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlayListResponseWithNoMacroSection
// SDK State: Initialized

// To verify whether the Macros section is NOT present in the playlist response.

// The Macro section should NOT be available in the playlist and the default macros in the Wrapper Url and Tracker Urls should be replaced with the current timestamp value (in milliseconds).
- (void)testVA2LI_TC_0050 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the Macros section is NOT present in the playlist response." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlayListResponseWithMacroSection
// SDK State: Initialized

// To verify whether Macros section present and 'support' attribute is not present with some playlist macros present.

// The macros section should be available with default macros in the Wrapper Url and Tracker Urls and it should be replaced with the current timestamp value (in milliseconds) and also playlist macros should also get replaced with the received values.
- (void)testVA2LI_TC_0051 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether Macros section present and 'support' attribute is not present with some playlist macros present." forKey:@"useCase"];
    
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

// 	Vast2Linear : MacroSectionAttributeFalse
// SDK State: Initialized

// To verify whether the Macros section is present and 'support' attribute set to “false” along with some playlist macros present.

// The macros available should NOT be replaced with the values for both the default and the playlist macros when the 'support' attribute is set to false
- (void)testVA2LI_TC_0052 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the Macros section is present and 'support' attribute set to “false” along with some playlist macros present." forKey:@"useCase"];
    
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

// 	Vast2Linear : MacroSectionAttributeTrue
// SDK State: Initialized

// To verify whether the Macros section is present and 'support' attribute set to “true” along with the some of playlist macros present.

// The default macros in the Wrapper Url and Tracker Urls should be replaced with the current timestamp value (in milliseconds) and the playlist macros should also get replaced with the received values.

- (void)testVA2LI_TC_0053 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the Macros section is present and 'support' attribute set to “true” along with the some of playlist macros present." forKey:@"useCase"];
    
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

// 	Vast2Linear : MacroWithoutPlaylistMacro
// SDK State: Initialized

// To verify whether the Macros section is present when no playlist macros present.

// The default macros in the Wrapper Url and Tracker Urls should be replaced with the current timestamp value (in milliseconds).
- (void)testVA2LI_TC_0054 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the Macros section is present when no playlist macros present." forKey:@"useCase"];
    
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

// 	Vast2Linear : Playlist&DefaultMacroSame
// SDK State: Initialized

// To verify whether the playlist macro's name exactly matches the name of a default macro.

// The playlist macro's name should exactly match the name of the default macros and the playlist macro should be given preference to the default macro and the value received in the playlist for that macro will be used for replacements.
- (void)testVA2LI_TC_0055 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the playlist macro's name exactly matches the name of a default macro." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlaylistMacroContinues
// SDK State: Initialized

// To verify whether the Playlist macros are continuing to appear for the next ads also

// The playlist macros should be applicable only for the ad in which they were received and it should NOT be honored for the next ads.
- (void)testVA2LI_TC_0056 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the Playlist macros are continuing to appear for the next ads also." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlaylistMacroEmptyNameValue
// SDK State: Initialized

// To verify whether the playlist macro is appearing with empty name and/or value is present.

// The playlist macros without name or value should be discarded while replacing the macro
- (void)testVA2LI_TC_0057 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the playlist macro is appearing with empty name and/or value is present." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlaylistMacroSameNameValue
// SDK State: Initialized

// To verify whether more than one playlist macros with the same name but same/different values are present.

// The first existence of that macro will be used and the remaining will be discarded.
- (void)testVA2LI_TC_0058 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether more than one playlist macros with the same name but same/different values are present." forKey:@"useCase"];
    
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

// 	Vast2Linear : MacroIn1stAndConsecutiveResp
// SDK State: Initialized

// To verify whether the macros present in 1st as well as consecutive responses is considered in case of wrappers.

// The macros present in first response (whether inline or wrapper) should only be considered and those in 2nd response onwards should be ignored.
- (void)testVA2LI_TC_0059 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the macros present in 1st as well as consecutive responses is considered in case of wrappers." forKey:@"useCase"];
    
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

// 	Vast2Linear : PlaylistMacroNotinYuMeExtension
// SDK State: Initialized

// To verify whether the playlist macros is not present within YuMe Extension.

// The playlist macros which is available outside the extension block will NOT be considered.
- (void)testVA2LI_TC_0060 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the playlist macros is not present within YuMe Extension." forKey:@"useCase"];
    
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

// Vast2Linear:VASTCreativeofdeliverytypestreaming
// SDK State: Initialized

// To verify whether the ad is NOT getting played in the app when the prefetch is made when following feed is used to configure the VAST2.0 ad in which the creative in the VAST Inline ad is "delivery="streaming""

// The ad should NOT get played in the app when  the prefetch is made when following feed is used to configure the VAST2.0 ad in which the creative in the VAST Inline ad is "delivery="streaming""
- (void)testVA2LI_TC_0061 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played in the app when the prefetch is made when following feed is used to configure the VAST2.0 ad in which the creative in the VAST Inline ad is 'delivery='streaming''." forKey:@"useCase"];
    
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

// Vast2Linear:VASTCreativeofdeliverytypestreaming
// SDK State: Initialized

// To verify whether the ad is getting played in the app when the startad is made when following feed is used to configure the VAST2.0 ad in which the creative in the VAST Inline ad is "delivery="streaming""

// The ad should get played in the app when  the start ad is made when following feed is used to configure the VAST2.0 ad in which the creative in the VAST Inline ad is "delivery="streaming""
- (void)testVA2LI_TC_0062 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is getting played in the app when the startad is made when following feed is used to configure the VAST2.0 ad in which the creative in the VAST Inline ad is 'delivery='streaming''." forKey:@"useCase"];
    
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

//  Vast2Linear:VASTsmartclipclic2video
// SDK State: Initialized

// To verify whether the ad is NOT getting played in the app when the following feed is used to configure the VAST2.0 ad in which the click2video smartclip ad is configured:
// Feed url to be used:http://ad-emea.doubleclick.net/ad/testadvertiser.smartclip/lg_

// The ad should NOT get played in the app when the following feed is used to configure the VAST2.0 ad in which the click2video smartclip ad is configured:
// Feed url to be used: http://ad-emea.doubleclick.net/ad/testadvertiser.smartclip/lg_yume_clicktox;scty
- (void)testVA2LI_TC_0063 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played in the app when the following feed is used to configure the VAST2.0 ad in which the click2video smartclip ad is configured:" forKey:@"useCase"];
    
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

// Vast2Linear:VASTsmartclipclic2app
// SDK State: Initialized

// To verify whether the ad is NOT getting played in the app when the following feed is used to configure the VAST2.0 ad in which the click2app smartclip ad is configured:
// Feed url to be used: http://ad-emea.doubleclick.net/ad/testadvertiser.smartclip/lg_yum

// The ad should NOT get played in the app when the following feed is used to configure the VAST2.0 ad in which the click2app smartclip ad is configured:
// Feed url to be used: http://ad-emea.doubleclick.net/ad/testadvertiser.smartclip/lg_yume_clicktox;sctype=

- (void)testVA2LI_TC_0064 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played in the app when the following feed is used to configure the VAST2.0 ad in which the click2app smartclip ad is configured:" forKey:@"useCase"];
    
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

// Vast2Linear:Plainvideo
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the impression tracker is NOT available in the adresponse of the plain video

// The ad should NOT get played when the impression tracker is NOT available in the adresponse of the plain video
- (void)testVA2LI_TC_0065 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the impression tracker is NOT available in the adresponse of the plain video." forKey:@"useCase"];
    
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

// Vast2Linear:VASTadwithoutInlineandwrapper
// SDK State: Initialized

// To verify whether the ad is NOT getting played when the VAST2.0 ad is NOT having the Inline or Wrapper in the xml response

// The ad should NOT get played when the VAST2.0 ad is NOT having the Inline or Wrapper in the xml response
- (void)testVA2LI_TC_0066 {
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"To verify whether the ad is NOT getting played when the VAST2.0 ad is NOT having the Inline or Wrapper in the xml response." forKey:@"useCase"];
    
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
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Vast2Linear"];
#endif

}


@end
