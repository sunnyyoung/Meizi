//
//  SettingTableViewController.h
//  Meizi
//
//  Created by Sunnyyoung on 14-12-23.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDImageCache.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <iOS-Slide-Menu/SlideNavigationController.h>

@interface SettingTableViewController : UITableViewController<SlideNavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *CachesSizeLabel;

@end
