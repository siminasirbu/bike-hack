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
static UIView *backgroundView;
static UIImageView* animatedImageView;
static BOOL isAnimateing;

+(void)showLoadingViewInParentView:(UIView *)parentView
{
    animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 71)];
    
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"01.png"],
                                         [UIImage imageNamed:@"02.png"], nil];
    animatedImageView.animationDuration = 1.0f;
    animatedImageView.animationRepeatCount = 0;
    animatedImageView.center = CGPointMake(parentView.bounds.size.width / 2, parentView.bounds.size.height / 2);
    [animatedImageView startAnimating];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake((parentView.bounds.size.width - 100 )/ 2, (parentView.bounds.size.height - 100 )/ 2, 100, 100)];
    backgroundView.backgroundColor = [Tools colorFromHexString:@"#474747"];
    backgroundView.alpha = 0.7;
    backgroundView.layer.cornerRadius = backgroundView.frame.size.width / 2;
    
    isAnimateing = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // Animate it to 4 the size
        const CGFloat scale = 10;
        [backgroundView setTransform:CGAffineTransformMakeScale(scale, scale)];
    } completion:^(BOOL finished) {
        isAnimateing = NO;
    }];
    
    rootView = parentView;
    rootView.userInteractionEnabled = NO;
    [rootView addSubview:backgroundView];
    [rootView addSubview:animatedImageView];
}

+(void)hideLoadingViewAnimated {
    
    if (isAnimateing == YES) {
        [self hideLoadingView];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            
            // Animate it to -4 the size
            const CGFloat scale = 0.3;
            [backgroundView setTransform:CGAffineTransformMakeScale(scale, scale)];
        } completion:^(BOOL finished) {
            [self hideLoadingView];
        }];
    }
    
}

+(void)hideLoadingView {
    [animatedImageView stopAnimating];
    rootView.userInteractionEnabled = YES;
    [backgroundView removeFromSuperview];
    backgroundView = nil;
    [animatedImageView removeFromSuperview];
    animatedImageView = nil;
    rootView = nil;
}

@end
