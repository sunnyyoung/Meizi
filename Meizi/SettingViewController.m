//
//  SettingViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/17.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "SettingViewController.h"
#import "CacheSizeLabel+Manager.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet CacheSizeLabel *cacheSizeLabel;

@end

@implementation SettingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cacheSizeLabel reloadCacheSize];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.cacheSizeLabel clearCache];
    }
}

@end
