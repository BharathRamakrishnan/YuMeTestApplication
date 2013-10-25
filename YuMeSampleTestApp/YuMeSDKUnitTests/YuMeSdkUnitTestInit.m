//
//  YuMeSdkUnitTestInit.m
//  YuMeiOSSDKUnitTests
//
//  Created by Bharath Ramakrishnan on 9/5/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestInit.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestInit


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
    
    pError = nil;
    
    if (testCaseResult) {
        [testCaseResult release]; testCaseResult = nil;
    }
    
    NSLog(@"************************ Unit Test - TearDown ************************");
}

// Override any exceptions; By default exceptions are raised, causing a test failure
- (void)failWithException:(NSException *)exception {
    NSLog(@"Failed with exception: %@", exception);
}


/* Pre conditions */
// SDK State: Not Initialized

/* Use Case */
// Called for the first time after SDK instantiation (with YuMeAdParams object containing valid values for ad server url, domain id, ad timeout value & video timeout value).

/* Expected behavior*/
// 1. Initialization Successful.
// 2. No Exceptions thrown.
- (void)testUseCase_Init001 {
    
    // Create the resultArray
    if (resultArray)
        [resultArray release]; resultArray = nil;
    
    if (resultArray == nil)
        resultArray = [[NSMutableArray alloc] init];
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called for the first time after SDK instantiation (with YuMeAdParams object containing valid values for ad server url, domain id, ad timeout value & video timeout value)" forKey:@"useCase"];
    
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
    [params release];
    
    if (pError) {
        NSString *str = [[YuMeSdkUnitUtils getErrDesc:pError] description];
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        [testCaseResult setObject:@"Initialization Successful." forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with NULL YuMeAdParams object.

/* Expected behavior*/
// 1. Throws Exception: "YuMeSDK_Init(): Invalid Ad Param object."
- (void)testUseCase_Init002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with NULL YuMeAdParams object." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params =  nil; //[YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNil(params, @"params object is NULL");
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                       videoPlayerDelegate:videoController
                                 errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                                 errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];

    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid Ad Param object.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : yumeSdkInit(): Invalid Ad Param object";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/*  Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with NULL YuMeAppInterface object.

/* Expected behavior*/
// 1. Throws Exception: "YuMeSDK_Init(): Invalid Ad Param object."
- (void)testUseCase_Init003 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with NULL YuMeAppInterface object." forKey:@"useCase"];
    
    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    
    YuMeAdParams *params =  [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNil(params, @"params object is NULL");
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:nil
                       videoPlayerDelegate:videoController
                                 errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:nil
                                 errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];
    
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid YuMeAppDelegate object.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : yumeSdkInit(): Invalid YuMeAppDelegate object.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/*  Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing NULL (or) empty ad server url.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): Invalid Ad Server Url."
- (void)testUseCase_Init004 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing NULL (or) empty ad server url." forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with NULL YuMeAdParams object." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                       videoPlayerDelegate:videoController
                                 errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                                 errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];

    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid Ad Server Url.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : Invalid Ad Server Url.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing malformed ad server url.
// (e.g) shadow01.yumenetworks.com (url without “http://”)

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): Malformed Ad Server Url."
- (void)testUseCase_Init005 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing malformed ad server url." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pAdServerUrl = @"shadow01.yumenetworks.com";
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                       videoPlayerDelegate:videoController
                                 errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                                 errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];
    
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Malformed Ad Server Url.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : Malformed Ad Server Url.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing NULL (or) empty domain id.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): Invalid Domain Id."
- (void)testUseCase_Init006 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing NULL (or) empty domain id." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.pDomainId = @"";
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                       videoPlayerDelegate:videoController
                                 errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                                 errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];
    
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid Domain Id.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : Invalid Domain Id.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing ad timeout value less than 4.

/* Expected behavior */
// 1. Ignores the ad timeout value received from app.
// 2. Sets the ad timeout to the default value of 5.
// 3. Initialization Successful.
// 4. No Exceptions thrown.
- (void)testUseCase_Init007 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing ad timeout value less than 4." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.adTimeout = 1;
    
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
        NSString *str = [[YuMeSdkUnitUtils getErrDesc:pError] description];
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"Initialization Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
    
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing ad timeout value greater than 60.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): Invalid Ad Timeout Value. It cannot exceed 60."
- (void)testUseCase_Init008 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing ad timeout value greater than 60." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.adTimeout = 61;
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];
    
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid Ad Connection Timeout Value. It cannot exceed 60.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : Invalid Ad Connection Timeout Value. It cannot exceed 60.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing video timeout value less than 3.

/* Expected behavior */
// 1. Ignores the video timeout value received from app.
// 2. Sets the video timeout to the default value of 6.
// 3. Initialization Successful.
// 4. No Exceptions thrown.
- (void)testUseCase_Init009 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing video timeout value less than 3." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.videoTimeout = 2;
    
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
        NSString *str = [[YuMeSdkUnitUtils getErrDesc:pError] description];
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"Initialization Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with YuMeAdParams object containing video timeout value greater than 60.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): Invalid Progressive Download Timeout Value. It cannot exceed 60 seconds."
- (void)testUseCase_Init010 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with YuMeAdParams object containing video timeout value greater than 60." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");

    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    params.videoTimeout = 61;
    
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization not Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization not Successful.");
    }
    [params release];

    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid Progressive Download Timeout Value. It cannot exceed 60 seconds.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : Invalid Progressive Download Timeout Value. It cannot exceed 60 seconds.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Called again when SDK is already initialized.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): YuMe SDK is already Initialized."
- (void)testUseCase_Init011 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called again when SDK is already initialized." forKey:@"useCase"];

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
    
    // Call Init Again
    if (videoController) {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
        
    } else {
        GHAssertFalse([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    [params release];
    
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualStrings(str, @"yumeSdkInit(): YuMe SDK is already Initialized.", @"");
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : YuMe SDK is already Initialized.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with NULL YuMeBSPInterface object.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_Init(): Invalid YuMeBSPInterface object."
- (void)testUseCase_Init012 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with NULL YuMeBSPInterface object." forKey:@"useCase"];

    NSString *str = @"NA for Latest iOS SDK.";
    [testCaseResult setObject:str forKey:@"status"];
    [testCaseResult setObject:@"Fail" forKey:@"result"];
    [resultArray addObject:testCaseResult];

    [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called with NULL YuMePlayerInterface object.
/* Expected behavior */
// 1. Throws Exception: "yumeSdkInit(): Invalid Video Player Handle."
- (void)testUseCase_Init013 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called with NULL YuMePlayerInterface object." forKey:@"useCase"];

    if(videoController) {
        GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
        GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
        
        YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
        GHAssertNotNULL(params, @"params object not found");
        
        GHTestLog(@"Initialization Invoked.");
        GHAssertFalse([yumeSDK yumeSdkInit:params
                               appDelegate:pYuMeTestInterface
                       videoPlayerDelegate:nil
                                 errorInfo:&pError], @"Initialization Successful.");
        [params release];
        if (pError) {
            NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
            GHAssertEqualStrings(str, @"yumeSdkInit(): Invalid Video Player Handle.", @"");
            GHTestLog(@"Result : %@", str);
            [testCaseResult setObject:str forKey:@"status"];
            [testCaseResult setObject:@"Pass" forKey:@"result"];
            [resultArray addObject:testCaseResult];
        } else {
            NSString *str = @"Throws Exception Problem : Invalid Video Player Handle.";
            [testCaseResult setObject:str forKey:@"status"];
            [testCaseResult setObject:@"Fail" forKey:@"result"];
            [resultArray addObject:testCaseResult];
            [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
        }
    } else {
        NSString *str = @"NA for Mobile Publishers.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Initialization"];
#endif
}
@end
