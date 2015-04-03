//
//  LeftMenuViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/8.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MainViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    switch (indexPath.section) {
        case 0: {
            //取MainCollectionView
            MainViewController *collectionView = [storyboard instantiateViewControllerWithIdentifier:@"MainCollectionView"];
            switch (indexPath.row) {
                case 0:
                    collectionView.title = @"所有妹子";
                    collectionView.datasource = MEIZI_ALL;
                    break;
                case 1:
                    collectionView.title = @"性感";
                    collectionView.datasource = MEIZI_SEX;
                    break;
                case 2:
                    collectionView.title = @"有沟";
                    collectionView.datasource = MEIZI_CLEAVAGE;
                    break;
                case 3:
                    collectionView.title = @"美腿";
                    collectionView.datasource = MEIZI_LEGS;
                    break;
                case 4:
                    collectionView.title = @"小清新";
                    collectionView.datasource = MEIZI_FRESH;
                    break;
                case 5:
                    collectionView.title = @"文艺";
                    collectionView.datasource = MEIZI_LITERATURE;
                    break;
                case 6:
                    collectionView.title = @"美臀";
                    collectionView.datasource = MEIZI_CALLIPYGE;
                    break;
                case 7:
                    collectionView.title = @"有点意思";
                    collectionView.datasource = MEIZI_FUNNY;
                    break;
                case 8:
                    collectionView.title = @"尺度";
                    collectionView.datasource =  MEIZI_RATING;
                    break;
            }
            //跳转MainCollectionView
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:collectionView
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];
            break;
        }
        case 1: {
            //取SettingTableView
            UITableViewController *settingTableView = [storyboard instantiateViewControllerWithIdentifier:@"SettingTableView"];
            //跳转SettingTableView
            [settingTableView setTitle:@"设置"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:settingTableView
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];
            break;
        }
    }
}

@end
