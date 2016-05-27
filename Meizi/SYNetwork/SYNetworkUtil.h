//
//  SYNetworkUtil.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/24.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

FOUNDATION_EXPORT void SYNetworkLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@class SYBaseRequest;

@interface SYNetworkUtil : NSObject

+ (BOOL)isValidateJSONObject:(id)jsonObject withJSONObjectValidator:(id)jsonObjectValidator;
+ (NSString *)cacheKeyWithRequest:(SYBaseRequest *)request;

@end
