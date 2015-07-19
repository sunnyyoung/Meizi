//
//  AppDelegate.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Set Background Color
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Set Network
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [YTKNetworkConfig sharedInstance].baseUrl = BaseURL;
    
    //Set UserAgent
    NSDictionary *userAgent = @{@"UserAgent": @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H143 Safari/600.1.4"};
    [[NSUserDefaults standardUserDefaults] registerDefaults:userAgent];
    
    //Set SVProgressHUD
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    return YES;
}

@end
