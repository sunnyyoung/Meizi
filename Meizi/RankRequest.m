//
//  RankRequest.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "RankRequest.h"

@interface RankRequest()

@property (nonatomic) NSInteger page;

@end

@implementation RankRequest

- (instancetype)initWithPage:(NSInteger)page {
    self = [super init];
    if (self) {
        _page = page;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/api/dbmeinv.htm";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{@"m": @"images",
             @"queryType": @"rank",
             @"pageIndex": @(_page)};
}

@end
