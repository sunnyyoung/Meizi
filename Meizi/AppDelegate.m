//
//  AppDelegate.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self setupMenuViewController];
    return YES;
}

- (void)setupMenuViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LeftMenuViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenu"];
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenuViewController;
    [SlideNavigationController sharedInstance].rightMenu = nil;
    
    [SlideNavigationController sharedInstance].enableShadow = YES;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [SlideNavigationController sharedInstance].avoidSwitchingToSameClassViewController = NO;
    [[SlideNavigationController sharedInstance] setPortraitSlideOffset:SCREEN_WIDTH - 100];
    [[SlideNavigationController sharedInstance] setLandscapeSlideOffset:SCREEN_HEIGHT - 100];
}

@end
