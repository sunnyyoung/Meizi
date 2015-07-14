//
//  MeiziRequest.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziRequest.h"

@interface MeiziRequest()

@property (nonatomic) NSInteger page;
@property (nonatomic) MeiziType type;

@end

@implementation MeiziRequest

- (instancetype)initWithPage:(NSInteger)page meiziType:(MeiziType)type {
    self = [super init];
    if (self) {
        _page = page;
        _type = type;
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
             @"pageIndex": @(_page),
             @"cagegoryId": @(_type)};
}

@end
