//
//  Network.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "Network.h"
#import "Constant.h"
#import "Meizi.h"

@implementation Network

+ (Network *)sharedInstance {
    static Network *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Network alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        singleton.requestSerializer.timeoutInterval = 30.0;
        singleton.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        singleton.responseSerializer.acceptableContentTypes = [singleton.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/html"]];
    });
    return singleton;
}

+ (void)getMeiziWithUrl:(NSString *)url page:(NSInteger)page completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion {
    [[Network sharedInstance] GET:url parameters:@{@"maxid": [@(page) stringValue]} success:^(NSURLSessionDataTask *task, id responseJSON) {
        if (responseJSON && [responseJSON[@"data"] isEqualToString:@"ok"]) {
            NSMutableArray *meiziArray = [NSMutableArray arrayWithArray:[Meizi objectArrayWithKeyValuesArray:responseJSON[@"imgs"]]];
            NSInteger nextPage = [((Meizi *)[meiziArray lastObject]).id integerValue];
            [meiziArray removeLastObject];
            completion(meiziArray, nextPage);
        } else {
            completion(nil, 0);
            [SVProgressHUD showErrorWithStatus:@"解析妹子出错"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, 0);
        [SVProgressHUD showErrorWithStatus:@"网络不给力哦"];
    }];
}

@end
