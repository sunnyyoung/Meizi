//
//  NetworkUtil.h
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Meizi.h"

@interface NetworkUtil : AFHTTPSessionManager

+ (NetworkUtil*)sharedNetworkUtil;

- (void)getMeizi:(NSString*)url
           pages:(int)pages
         success:(void (^)(NSString *succMsg,id responseObject))success
         failure:(void (^)(NSString *failMsg,NSError *error))failure;

@end
