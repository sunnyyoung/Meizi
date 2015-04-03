//
//  Network.h
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface Network : AFHTTPSessionManager

+ (Network *)sharedInstance;

+ (void)getMeiziWithUrl:(NSString *)url
                   page:(NSInteger)page
             completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion;

@end
