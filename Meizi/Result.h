//
//  Result.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, copy) NSString *c_head_url;
@property (nonatomic, copy) NSString *c_people_url;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *c_head_original_url;
@property (nonatomic, copy) NSString *c_user_district;
@property (nonatomic, assign) long long create_time;
@property (nonatomic, copy) NSString *c_user_id;
@property (nonatomic, assign) NSInteger topic_n;
@property (nonatomic, copy) NSString *c_nick_name;

@end
