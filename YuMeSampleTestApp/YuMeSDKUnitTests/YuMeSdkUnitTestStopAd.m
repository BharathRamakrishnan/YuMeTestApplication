//
//  YuMeSdkUnitTestStopAd.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestStopAd.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestStopAd

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

/**
 >> SDK State: Not Initialized
 
 >> Called when SDK is not initialized.
 
 >> 1. Throws Exception: "YuMeSDK_StopAd(): YuMe SDK is not Initialized."
 */
- (void)testUseCase_StopAd001 {
    
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
    
    GHAssertFalse([yumeSDK yumeSdkStopAd:&pError], @"Initialization is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkStopAd(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : yumeSdkStopAd(): YuMe SDK is not Initialized.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/**
 >> SDK State: Initialized
 
 >> No ad play  (startad / showad) is in progress.
 
 >> 1. Throws Exception: "YuMeSDK_StopAd(): No Ad Operation in Progress."
 */
- (void)testUseCase_StopAd002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
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
    
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    GHAssertFalse([yumeSDK yumeSdkStopAd:&pError], @"yumeSdkStopAd is not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkStopAd(): No Ad Play in Progress.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : yumeSdkStopAd(): No Ad Play in Progress.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Stop Ad"];
#endif

}


@end
