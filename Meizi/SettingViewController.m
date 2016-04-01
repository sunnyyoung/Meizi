//
//  SettingViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/17.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self calculateImageCacheSize];
}

- (void)calculateImageCacheSize {
    __weak typeof(self) weakSelf = self;
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        weakSelf.cacheSizeLabel.text = [NSString stringWithFormat:@"%.2f M", totalSize/1024.0/1024.0];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD show];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"清理完成"];
            [weakSelf calculateImageCacheSize];
        }];
    }
}

@end
