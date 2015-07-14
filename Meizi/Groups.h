//
//  Group.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Groups : NSObject

@property (nonatomic, copy) NSString *c_sort;
@property (nonatomic, copy) NSString *c_group_ab_name;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *c_group_name;
@property (nonatomic, assign) long long create_date_time;
@property (nonatomic, copy) NSString *c_group_url;
@property (nonatomic, copy) NSString *c_ico_url;
@property (nonatomic, copy) NSString *c_group_id;
@property (nonatomic, copy) NSString *c_group_intro;
@property (nonatomic, assign) NSInteger b;

@end
