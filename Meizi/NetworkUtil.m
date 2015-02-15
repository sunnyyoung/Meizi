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
        singleton = [[NetworkUtil alloc]init];
        singleton.requestSerializer.timeoutInterval = NETWORK_TIMOUT;
        singleton.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        singleton.responseSerializer.acceptableContentTypes = [singleton.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/html"]];
    });
    return singleton;
}

- (void)getMeiziWithUrl:(NSString*)url page:(NSInteger)page completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion {
    [self GET:url parameters:@{@"maxid": [@(page) stringValue]} success:^(NSURLSessionDataTask *task, id responseJSON) {
        
        BOOL isNetWorkOK = [responseJSON[@"data"] isEqualToString:@"ok"]; //判断返回是否正确
        NSArray *resultArray = responseJSON[@"imgs"];   //妹子数组
        
        if (isNetWorkOK) {
            completion(resultArray,[[resultArray lastObject][@"id"] integerValue]);
        }else {
            [SVProgressHUD showErrorWithStatus:NO_MEIZI_MSG];
            completion(nil,0);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil,0);
        [SVProgressHUD showErrorWithStatus:NETWORK_ERR_MSG maskType:SVProgressHUDMaskTypeGradient];
    }];
}

@end
