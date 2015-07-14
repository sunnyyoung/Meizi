//
//  Topic.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *head_user;
@property (nonatomic, copy) NSString *people_url;
@property (nonatomic, copy) NSString *user_district;

@end

@interface Topic : NSObject

@property (nonatomic, copy) NSString *topic_title;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *douban_group_id;
@property (nonatomic, assign) NSInteger douban_topic_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger topic_id;

@end