//
//  SettingTableViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-23.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Meizi.h"

@interface SettingTableViewController ()

@property (nonatomic, strong)NSString *cachesPath;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshCacheSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <SlideNavigationControllerDelegate>

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

#pragma mark TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 1) {
                [[[UIActionSheet alloc]initWithTitle:@"确认清除缓存图片?"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:@"确认清除"
                                   otherButtonTitles:nil, nil]showInView:self.view];
            }
            break;
        }
    }
}

#pragma mark RefreshCacheSize

- (void)refreshCacheSize {
    [[SDImageCache sharedImageCache]calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        _CachesSizeLabel.text = [NSString stringWithFormat:@"%.2f M",totalSize/1048576.];
    }];
}

#pragma mark DeleteCaches

- (void)deleteCaches {
    [SVProgressHUD showWithStatus:DELETE_ING maskType:SVProgressHUDMaskTypeGradient];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [self refreshCacheSize];
        [SVProgressHUD showSuccessWithStatus:DELETE_SUCCESS_MSG];
    }];
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self deleteCaches];
            break;
        }
        case 1: {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        }
    }
}

@end
