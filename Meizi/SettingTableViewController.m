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
    //获取样式类型
    if ([[Config sharedConfig]getLayoutType] == LayoutTypeWaterFall) {
        self.LayoutSwitch.on = YES;
    }else {
        self.LayoutSwitch.on = NO;
    }
    //获取Caches文件夹大小
    if ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]) {
        self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.CachesSizeLabel.text = [NSString stringWithFormat:@"%.2fM",[self getCacheSize]];
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
            //Do Nothing
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

#pragma mark LayoutSwitch action

- (IBAction)layoutSwitchChange:(id)sender {
    if (self.LayoutSwitch.isOn) {
        [[Config sharedConfig]setLayoutType:LayoutTypeWaterFall];
    }else {
        [[Config sharedConfig]setLayoutType:LayoutTypeClassic];
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

- (float)getCacheSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.cachesPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:self.cachesPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [self.cachesPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
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
    self.CachesSizeLabel.text = [NSString stringWithFormat:@"%.2fM",[self getCacheSize]];
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
