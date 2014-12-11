//
//  MainViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-12.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"toAllSection";
            break;
        case 1:
            identifier = @"toSexSection";
            break;
        default:
            break;
    }
    return identifier;
}

- (CGFloat)leftMenuWidth {
    return 120.0;
}

- (BOOL)deepnessForLeftMenu {
    return YES;
}

@end
