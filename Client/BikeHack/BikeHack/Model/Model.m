//
//  Model.m
//  BikeHack
//
//  Created by Catalin-Andrei BORA on 11/7/15.
//  Copyright © 2015 The Planeteers. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize route;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static Model *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        route = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end


