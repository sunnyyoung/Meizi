//
//  MeiziRequest.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziRequest.h"
#import "Meizi.h"

@interface MeiziRequest()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) MeiziCategory category;

@end

@implementation MeiziRequest

- (instancetype)initWithPage:(NSInteger)page category:(MeiziCategory)category {
    self = [super init];
    if (self) {
        self.page = page;
        self.category = category;
    }
    return self;
}

+ (MeiziRequest *)requestWithPage:(NSInteger)page category:(MeiziCategory)category success:(void (^)(NSArray<Meizi *> *))success failure:(void (^)(NSString *))failure {
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:page category:category];
    [request startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        success?success(((MeiziRequest *)request).meiziArray):nil;
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        failure?failure(error.localizedDescription):nil;
    }];
    return request;
}

- (BOOL)enableCache {
    return (self.page == 1)?YES:NO;
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodGET;
}

- (NSString *)baseURL {
    return @"https://meizi.leanapp.cn";
}

- (NSString *)requestPath {
    NSString *category = @"";
    switch (self.category) {
        case MeiziCategoryAll:
            category = @"All";
            break;
        case MeiziCategoryDaXiong:
            category = @"DaXiong";
            break;
        case MeiziCategoryQiaoTun:
            category = @"QiaoTun";
            break;
        case MeiziCategoryHeisi:
            category = @"HeiSi";
            break;
        case MeiziCategoryMeiTui:
            category = @"MeiTui";
            break;
        case MeiziCategoryQingXin:
            category = @"QingXin";
            break;
        case MeiziCategoryZaHui:
            category = @"ZaHui";
            break;
        default:
            category = @"All";
            break;
    }
    return [NSString stringWithFormat:@"/category/%@/page/%@", category, @(self.page)];
}

- (NSArray<Meizi *> *)meiziArray {
    return [Meizi mj_objectArrayWithKeyValuesArray:self.responseJSONObject[@"results"]];
}

+ (NSArray<Meizi *> *)cachedMeiziArrayWithCategory:(MeiziCategory)category {
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:1 category:category];
    return [Meizi mj_objectArrayWithKeyValuesArray:request.cacheJSONObject[@"results"]];
}

@end
