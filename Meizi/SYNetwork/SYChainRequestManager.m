//
//  SYChainRequestManager.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/31.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYChainRequestManager.h"
#import "SYChainRequest.h"

@interface SYChainRequestManager ()

@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation SYChainRequestManager

+ (SYChainRequestManager *)sharedInstance {
    static SYChainRequestManager *instance;
    static dispatch_once_t SYChainRequestManagerToken;
    dispatch_once(&SYChainRequestManagerToken, ^{
        instance = [[SYChainRequestManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(SYChainRequest *)chainRequest {
    @synchronized (self) {
        [self.requestArray addObject:chainRequest];
    }
}

- (void)removeChainRequest:(SYChainRequest *)chainRequest {
    @synchronized (self) {
        [self.requestArray removeObject:chainRequest];
    }
}

@end
