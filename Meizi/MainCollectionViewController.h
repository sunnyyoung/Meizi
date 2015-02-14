//
//  MainCollectionViewController.h
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <iOS-Slide-Menu/SlideNavigationController.h>
#import <JTSImageViewController/JTSImageViewController.h>

@interface MainCollectionViewController : UICollectionViewController<SlideNavigationControllerDelegate, JTSImageViewControllerInteractionsDelegate, UIActionSheetDelegate>

@property (nonatomic, strong)NSString *datasource;  //数据源

@end
