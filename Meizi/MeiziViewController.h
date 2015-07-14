//
//  MeiziViewController.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface MeiziViewController : UIViewController

@property (weak, nonatomic) IBOutlet HMSegmentedControl *cagegoryMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
