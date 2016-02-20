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
    
    //Set Network
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [YTKNetworkConfig sharedInstance].baseUrl = BaseURL;
    [[YTKNetworkAgent sharedInstance] setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/css", nil] forKeyPath :@"_manager.responseSerializer.acceptableContentTypes"];
    
    //Set SVProgressHUD
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    return YES;
}

@end
