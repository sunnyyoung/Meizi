//
//  SideBarViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "SideBarViewController.h"
#import "Meizi.h"
#import "MainCollectionViewController.h"

@interface SideBarViewController ()

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
     NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UICollectionViewController *collectionView = [storyboard instantiateViewControllerWithIdentifier:@"MainCollectionView"];
    switch (indexPath.row) {
        case 0:
            [collectionView setTitle:@"所有妹子"];
            [collectionView setValue:MEIZI_ALL forKey:@"datasource"];
            break;
        case 1:
            [collectionView setTitle:@"性感"];
            [collectionView setValue:MEIZI_SEX forKey:@"datasource"];
            break;
        case 2:
            [collectionView setTitle:@"有沟"];
            [collectionView setValue:MEIZI_CLEAVAGE forKey:@"datasource"];
            break;
        case 3:
            [collectionView setTitle:@"美腿"];
            [collectionView setValue:MEIZI_LEGS forKey:@"datasource"];
            break;
        case 4:
            [collectionView setTitle:@"小清新"];
            [collectionView setValue:MEIZI_FRESH forKey:@"datasource"];
            break;
        case 5:
            [collectionView setTitle:@"文艺"];
            [collectionView setValue:MEIZI_LITERATURE forKey:@"datasource"];
            break;
        case 6:
            [collectionView setTitle:@"美臀"];
            [collectionView setValue:MEIZI_CALLIPYGE forKey:@"datasource"];
            break;
        default:
            break;
    }
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:collectionView withSlideOutAnimation:NO andCompletion:nil];
}

@end
