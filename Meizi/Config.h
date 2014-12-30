//
//  Config.h
//  Meizi
//
//  Created by Sunnyyoung on 14-12-23.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  样式类型
 */
typedef NS_ENUM(NSInteger, LayoutType){
    /**
     *  Instagram
     */
    LayoutTypeInstagram,
    /**
     *  经典
     */
    LayoutTypeClassic,
    /**
     *  瀑布流
     */
    LayoutTypeWaterFall,
};

@interface Config : NSObject

+ (Config*)sharedConfig;

- (void)setLayoutType:(LayoutType)type;
- (LayoutType)getLayoutType;

@end
