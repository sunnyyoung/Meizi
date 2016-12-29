//
//  CacheSizeLabel+Manager.m
//  Meizi
//
//  Created by Sunnyyoung on 2016/12/29.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "CacheSizeLabel+Manager.h"

@implementation CacheSizeLabel (Manager)

- (void)reloadCacheSize {
    __weak typeof(self) weakSelf = self;
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        weakSelf.text = [NSString stringWithFormat:@"%.2f M", totalSize/1024.0/1024.0];
    }];
}

- (void)clearCache {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
        [weakSelf reloadCacheSize];
    }];
}

@end
