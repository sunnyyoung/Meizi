//
//  AppDelegate.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "AppDelegate.h"
#import "SYNetwork.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Set Network
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [SYNetworkConfig sharedInstance].baseURL = BaseURL;
    
    //Set SVProgressHUD
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    return YES;
}

@end
