//
//  GroupViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupsTableViewCell.h"
#import "GroupsRequest.h"
#import "Groups.h"

@interface GroupsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *groupArray;

@end

@implementation GroupsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _page = 1;
        _groupArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefreshHeaderAndFooter];
}

- (void)setupRefreshHeaderAndFooter {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshGroup)];
    header.autoChangeAlpha = YES;
    self.tableView.header = header;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView.header beginRefreshing];
}

- (void)refreshGroup {
    self.page = 1;
    GroupsRequest *request = [[GroupsRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self.groupArray removeAllObjects];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *groupArray = [Groups objectArrayWithKeyValuesArray:data];
        
        [self.groupArray addObjectsFromArray:groupArray];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.groupArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    }];
}

#pragma mark - TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.footer.hidden = self.groupArray.count == 0;
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupsCell" forIndexPath:indexPath];
    Groups *group = self.groupArray[indexPath.row];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:group.c_ico_url]
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.titleLabel.text = group.c_group_name;
    cell.descriptionLabel.text = group.c_group_ab_name;
    return cell;
}

@end
