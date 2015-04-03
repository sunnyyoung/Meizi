//
//  MainViewController.h
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <iOS-Slide-Menu/SlideNavigationController.h>
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface MainViewController : UICollectionViewController <NHBalancedFlowLayoutDelegate>

@property (nonatomic, strong) NSString *datasource;

@end
