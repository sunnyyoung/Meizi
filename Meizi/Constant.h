//
//  Constant.h
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#ifndef Meizi_Constant_h
#define Meizi_Constant_h

#define SCREEN_WIDTH    CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds)
#define SCREEN_HEIGHT    CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds)

static NSString * const BaseURL         = @"http://api.xiaojianjian.net";

static NSString * const Meizi_All       = @"0";
static NSString * const Meizi_DaXiong   = @"2";
static NSString * const Meizi_QiaoTun   = @"6";
static NSString * const Meizi_HeiSi     = @"7";
static NSString * const Meizi_MeiTui    = @"3";
static NSString * const Meizi_QingXin   = @"4";
static NSString * const Meizi_ZaHui     = @"5";

static NSString * const DoubanGroupURL  = @"http://www.douban.com/group/";
static NSString * const DoubanTopicURL  = @"http://www.douban.com/group/topic/";
static NSString * const DoubanPeopleURL = @"http://www.douban.com/group/people/";

#endif


//API: http://api.xiaojianjian.net/api/dbmeinv.htm
//
//m = images & pageIndex = 0
//
//- 所有: cagegoryID = 0
//- 大胸: cagegoryID = 2
//- 翘臀: cagegoryID = 6
//- 黑丝: cagegoryID = 7
//- 美腿: cagegoryID = 3
//- 清新: cagegoryID = 4
//- 杂烩: cagegoryID = 5
//
//- 精选: queryType = rank & pageIndex = 1
//- 小组: m = groups
//- 搜妹: m = topic_users & key = 关键词 & pageIndex = 1
//static NSString * const DBMeinvTopicURL = @"http://www.dbmeinv.com/dbgroup/app/topic_detail.htm?id=";
