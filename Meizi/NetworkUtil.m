//
//  NetworkUtil.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "NetworkUtil.h"

@implementation NetworkUtil

static NetworkUtil *singleton;

+ (NetworkUtil*)sharedNetworkUtil {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[NetworkUtil alloc]initWithBaseURL:nil];
        singleton.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return singleton;
}

- (void)getMeizi:(NSString*)url
           pages:(int)pages
         success:(void (^)(NSString *succMsg,id responseObject))success
         failure:(void (^)(NSString *failMsg,NSError *error))failure {
    NSNumber *page = [NSNumber numberWithInteger:pages];
    [self GET:url parameters:@{@"p": page} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            success(@"妹子到手",responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(@"网络错误操!",error);
    }];
}

@end
