//
//  LoadingViewManager.m
//  AudioNowPlayer
//
//  Created by Florin Moisa on 14/01/15.
//  Copyright (c) 2015 AudioNowDigital. All rights reserved.
//

#import "LoadingViewManager.h"
#import "Tools.h"

@implementation LoadingViewManager

static UIView *rootView;
static UIActivityIndicatorView *activityIndicator;
static UIView *backgroundView;

+(void)showLoadingViewInParentView:(UIView *)parentView
{
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 71)];
    
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"01.png"],
                                         [UIImage imageNamed:@"02.png"], nil];
    animatedImageView.animationDuration = 1.0f;
    animatedImageView.animationRepeatCount = 0;
    animatedImageView.center = CGPointMake(parentView.bounds.size.width / 2, parentView.bounds.size.height / 2);
    [animatedImageView startAnimating];

    [backgroundView removeFromSuperview];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.bounds.size.width, parentView.bounds.size.height)];
    backgroundView.backgroundColor = [Tools colorFromHexString:@"#474747"];
    backgroundView.alpha = 0.7;
    
    [backgroundView addSubview:animatedImageView];
    
    
    rootView = parentView;
    rootView.userInteractionEnabled = NO;
    [rootView addSubview:backgroundView];
}

+(void)hideLoadingView
{
    [activityIndicator stopAnimating];
    [backgroundView removeFromSuperview];
    rootView.userInteractionEnabled = YES;
}

@end
