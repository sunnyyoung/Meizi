//
//  LayoutsTableViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-30.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "LayoutsTableViewController.h"
#import "Config.h"

@interface LayoutsTableViewController ()

@property (nonatomic, strong)NSIndexPath *selectedIndex;

@end

@implementation LayoutsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.selectedIndex = [NSIndexPath indexPathForRow:[[Config sharedConfig]getLayoutType] inSection:0];
    [self.tableView cellForRowAtIndexPath:self.selectedIndex].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndex = indexPath;
    [[Config sharedConfig]setLayoutType:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex != indexPath) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
