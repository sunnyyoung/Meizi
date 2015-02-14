//
//  NetworkUtil.h
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Meizi.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface NetworkUtil : AFHTTPSessionManager

+ (NetworkUtil*)sharedNetworkUtil;

- (void)getMeiziWithUrl:(NSString*)url
                   page:(NSInteger)page
             completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion;

@end
