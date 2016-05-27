//
//  SYBatchRequestManager.m
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/28.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYBatchRequestManager.h"

@interface SYBatchRequestManager ()

@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation SYBatchRequestManager

#pragma mark - LifeCycle

+ (SYBatchRequestManager *)sharedInstance {
    static SYBatchRequestManager *instance;
    static dispatch_once_t SYBatchRequestManagerToken;
    dispatch_once(&SYBatchRequestManagerToken, ^{
        instance = [[SYBatchRequestManager alloc] init];
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

- (void)addBatchRequest:(SYBatchRequest *)batchRequest {
    @synchronized (self) {
        [_requestArray addObject:batchRequest];
    }
}

- (void)removeBatchRequest:(SYBatchRequest *)batchRequest {
    @synchronized (self) {
        [_requestArray removeObject:batchRequest];
    }
}

@end
