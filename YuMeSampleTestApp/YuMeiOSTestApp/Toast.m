//
//  Toast.m
//  YuMeiOSTestApp
//
//  Created by Senthil on 11/03/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>

@implementation Toast

#define TOAST_DURATION  1.5 //seconds

- (id)initWithText: (NSString *)pMsg {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.textColor = [UIColor colorWithWhite:0 alpha:1];
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size: 15];
        self.text = pMsg;
        self.textAlignment = UITextAlignmentCenter;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)didMoveToSuperview {
    
    UIView* parent = self.superview;
    
    if(parent) {
        CGSize maximumLabelSize = CGSizeMake(300, 400);
        CGSize expectedLabelSize = [self.text sizeWithFont: self.font  constrainedToSize:maximumLabelSize lineBreakMode: NSLineBreakByTruncatingTail];
        
        expectedLabelSize = CGSizeMake(expectedLabelSize.width + 20, expectedLabelSize.height + 10);
        
        self.frame = CGRectMake(parent.center.x - expectedLabelSize.width / 2,
                                parent.bounds.size.height - expectedLabelSize.height - 10,
                                expectedLabelSize.width,
                                expectedLabelSize.height);
        
        CALayer *layer = self.layer;
        layer.cornerRadius = 4.0f;
        
        //[self performSelector:@selector(dismiss:) withObject:nil afterDelay:TOAST_DURATION];
        [self performSelectorOnMainThread:@selector(dismissToast:) withObject:nil waitUntilDone:NO];
    }
}

- (void)dismissToast:(id)sender {
    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:TOAST_DURATION];
}

- (void)dismiss:(id)sender {
    // Fade out the message and destroy self
    [UIView animateWithDuration:0.6  delay:0 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^  { self.alpha = 0; }
                     completion:^ (BOOL finished) { [self removeFromSuperview]; }];
}

@end //@implementation Toast