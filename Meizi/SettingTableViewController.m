//
//  SettingTableViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-23.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Config.h"
#import "Meizi.h"

@interface SettingTableViewController ()

@property (nonatomic, strong)NSString *cachesPath;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取Caches文件夹大小并刷新Label
    if ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]) {
        self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        [self refreshCacheSize:self.CachesSizeLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self performSegueWithIdentifier:@"toLayoutsSection" sender:self];
            break;
        }
        case 1: {
            if (indexPath.row == 1) {
                [[[UIActionSheet alloc]initWithTitle:@"确认清除缓存图片?"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:@"确认清除"
                                   otherButtonTitles:nil, nil]showInView:tableView];
            }
            break;
        }
    }
}

#pragma mark Destinate Section

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewController *tableViewController = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"toLayoutsSection"]) {
        [tableViewController setTitle:@"浏览样式选择"];
    }
}

#pragma mark GetCacheSize

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark RefreshCacheSize

- (void)refreshCacheSize:(UILabel*)lable {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.cachesPath]) {
        lable.text = @"0.0M";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:self.cachesPath] objectEnumerator];
        NSString *fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString *fileAbsolutePath = [self.cachesPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            lable.text = [NSString stringWithFormat:@"%.2fM",folderSize/(1024.0*1024.0)];
        });
    });
}

#pragma mark DeleteCaches

- (void)deleteCaches {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bundleCachePath = [self.cachesPath stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    if ([fileManager fileExistsAtPath: bundleCachePath]) {
        [fileManager removeItemAtPath:bundleCachePath error:&error];
    }
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    [KVNProgress showSuccessWithStatus:DELETE_SUCCESS_MSG];
    [self refreshCacheSize:self.CachesSizeLabel];
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
