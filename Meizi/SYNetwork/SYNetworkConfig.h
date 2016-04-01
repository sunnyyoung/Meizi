//
//  SYNetworkConfig.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/21.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFSecurityPolicy.h>

@interface SYNetworkConfig : NSObject

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

+ (SYNetworkConfig *)sharedInstance;

@end
