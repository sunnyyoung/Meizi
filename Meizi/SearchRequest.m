//
//  SearchRequest.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "SearchRequest.h"

@interface SearchRequest()

@property (nonatomic) NSInteger page;
@property (nonatomic) NSString *key;

@end

@implementation SearchRequest

- (instancetype)initWithPage:(NSInteger)page key:(NSString *)key {
    self = [super init];
    if (self) {
        _page = page;
        _key = key?key:@"";
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
    return @{@"m": @"topic_users",
             @"pageIndex": @(_page),
             @"key": _key};
}

@end
