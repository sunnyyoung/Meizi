//
//  SYNetworkConfig.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/21.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYNetworkConfig.h"

@implementation SYNetworkConfig

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxConcurrentOperationCount = 4;
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return self;
}

+ (SYNetworkConfig *)sharedInstance {
    static SYNetworkConfig *instance;
    static dispatch_once_t SYNetworkConfigToken;
    dispatch_once(&SYNetworkConfigToken, ^{
        instance = [[SYNetworkConfig alloc] init];
    });
    return instance;
}

@end
