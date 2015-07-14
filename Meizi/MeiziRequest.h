//
//  MeiziRequest.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

typedef NS_ENUM(NSUInteger, MeiziType) {
    MeiziTypeAll     = 0,
    MeiziTypeDaXiong = 2,
    MeiziTypeQiaoTun = 6,
    MeiziTypeHeisi   = 7,
    MeiziTypeMeiTui  = 3,
    MeiziTypeQingXin = 4,
    MeiziTypeZaHui   = 5
};

@interface MeiziRequest : YTKRequest

- (instancetype)initWithPage:(NSInteger)page meiziType:(MeiziType)type;

@end
