//
//  LoadingViewManager.h
//  AudioNowPlayer
//
//  Created by Florin Moisa on 14/01/15.
//  Copyright (c) 2015 AudioNowDigital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingViewManager : NSObject

+(void)showLoadingViewInParentView:(UIView *)parentView;
+(void)hideLoadingView;

@end
