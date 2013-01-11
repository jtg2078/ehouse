//
//  EHouseManager.m
//  ehouse
//
//  Created by jason on 1/11/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "EHouseManager.h"

@implementation EHouseManager

#pragma mark - singleton implementation code

static EHouseManager *singletonManager = nil;

+ (EHouseManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static EHouseManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonManager == nil) {
            singletonManager = [super allocWithZone:zone];
            return singletonManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end
