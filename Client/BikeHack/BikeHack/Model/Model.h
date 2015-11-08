//
//  Model.h
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/7/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject {
    NSMutableArray *route;
}

@property (nonatomic, retain) NSMutableArray *route;

+ (id)sharedManager;

@end
