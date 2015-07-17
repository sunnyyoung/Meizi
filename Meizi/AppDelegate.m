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
    self.window.backgroundColor = [UIColor whiteColor];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [YTKNetworkConfig sharedInstance].baseUrl = BaseURL;
    return YES;
}

@end
