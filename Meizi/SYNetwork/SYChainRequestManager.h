//
//  SYChainRequestManager.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/31.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYChainRequest;

@interface SYChainRequestManager : NSObject

+ (SYChainRequestManager *)sharedInstance;

- (void)addChainRequest:(SYChainRequest *)chainRequest;
- (void)removeChainRequest:(SYChainRequest *)chainRequest;

@end
