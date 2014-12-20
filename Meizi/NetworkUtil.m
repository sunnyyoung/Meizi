//
//  NetworkUtil.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "NetworkUtil.h"
#import <hpple/TFHpple.h>

@implementation NetworkUtil

static NetworkUtil *singleton;

+ (NetworkUtil*)sharedNetworkUtil {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[NetworkUtil alloc]initWithBaseURL:nil];
        singleton.requestSerializer.timeoutInterval = NETWORK_TIMOUT;
        singleton.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return singleton;
}

- (void)getMeizi:(NSString*)url
           pages:(int)pages
         success:(void (^)(NSString *succMsg,NSArray *meiziArray))success
         failure:(void (^)(NSString *failMsg,NSError *error))failure {
    NSNumber *page = [NSNumber numberWithInteger:pages];
    [self GET:url parameters:@{@"p": page} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *meiziArray = [[TFHpple hppleWithHTMLData:responseObject]searchWithXPathQuery:@"/html/body/div[2]/ul[2]/li[@*]/div/div/span/img"];
        if (meiziArray.count != 0) {
            success(GOT_MEIZI_MSG,meiziArray);
        }else {
            failure(NO_MEIZI_MSG,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(NETWORK_ERR_MSG,error);
    }];
}

@end
