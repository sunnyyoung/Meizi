//
//  AppDelegate.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-12.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "AppDelegate.h"
#import "SideBarViewController.h"
#import <iOS-Slide-Menu/SlideNavigationController.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupSideBarleft:(id)left right:(id)right {
    
    [[SlideNavigationController sharedInstance] setLeftMenu:left];
    [[SlideNavigationController sharedInstance] setRightMenu:right];
    
    [[SlideNavigationController sharedInstance] setEnableShadow:YES];
    [[SlideNavigationController sharedInstance] setEnableSwipeGesture:YES];
    [[SlideNavigationController sharedInstance] setAvoidSwitchingToSameClassViewController:NO];
    [[SlideNavigationController sharedInstance] setPortraitSlideOffset:CGRectGetWidth(self.window.bounds) - 100];
    [[SlideNavigationController sharedInstance] setLandscapeSlideOffset:CGRectGetHeight(self.window.bounds) - 100];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SideBarViewController *leftSideBar = (SideBarViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SideBar"];
    
    [self setupSideBarleft:leftSideBar right:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

@end
