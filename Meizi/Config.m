//
//  Config.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-23.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "Config.h"

@implementation Config

static Config *singleton;

+ (Config*)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Config alloc]init];
    });
    return singleton;
}

/**
 *  设置样式
 *
 *  @param type 样式类型
 */
- (void)setLayoutType:(LayoutType)type {
    [[NSUserDefaults standardUserDefaults]setInteger:type forKey:@"LayoutType"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 *  获取样式类型
 *
 *  @return 样式类型
 */
- (LayoutType)getLayoutType {
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"LayoutType"];  //Default 0
}

@end
