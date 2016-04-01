//
//  SYBatchRequestManager.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/28.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYBatchRequest;

@interface SYBatchRequestManager : NSObject

+ (SYBatchRequestManager *)sharedInstance;

- (void)addBatchRequest:(SYBatchRequest *)batchRequest;
- (void)removeBatchRequest:(SYBatchRequest *)batchRequest;

@end
