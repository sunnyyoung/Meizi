//
//  MeiziRequest.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <hpple/TFHpple.h>
#import "SYNetwork/SYBaseRequest.h"

@class Meizi;

typedef NS_ENUM(NSUInteger, MeiziCategory) {
    MeiziCategoryAll = 0,
    MeiziCategoryDaXiong,
    MeiziCategoryQiaoTun,
    MeiziCategoryHeisi,
    MeiziCategoryMeiTui,
    MeiziCategoryQingXin,
    MeiziCategoryZaHui
};

@interface MeiziRequest : SYBaseRequest

+ (MeiziRequest *)requestWithPage:(NSInteger)page
                         category:(MeiziCategory)category
                          success:(void (^)(NSArray<Meizi *> *meiziArray))success
                          failure:(void (^)(NSString *message))failure;

+ (NSArray<Meizi *> *)cachedMeiziArrayWithCategory:(MeiziCategory)category;

@end
