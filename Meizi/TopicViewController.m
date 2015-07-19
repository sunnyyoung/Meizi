//
//  TopicViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "TopicViewController.h"
#import "WebViewController.h"
#import "TopicTableViewCell.h"
#import "TopicRequest.h"
#import "Topic.h"

@interface TopicViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *topicArray;

@end

@implementation TopicViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _page = 1;
        _topicArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefreshHeaderAndFooter];
}

- (void)setupRefreshHeaderAndFooter {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTopic)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    header.autoChangeAlpha = YES;
    footer.automaticallyRefresh = NO;
    self.tableView.header = header;
    self.tableView.footer = footer;
    [self.tableView.header beginRefreshing];
}

- (void)refreshTopic {
    self.page = 1;
    TopicRequest *request = [[TopicRequest alloc] initWithPage:self.page groupdID:self.groupID];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self.topicArray removeAllObjects];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *topicArray = [Topic objectArrayWithKeyValuesArray:data];
        
        [self.topicArray addObjectsFromArray:topicArray];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.topicArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    }];
}

- (void)loadMoreTopic {
    TopicRequest *request = [[TopicRequest alloc] initWithPage:self.page+1 groupdID:self.groupID];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        self.page++;
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *topicArray = [Topic objectArrayWithKeyValuesArray:data];
        
        [self.topicArray addObjectsFromArray:topicArray];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.topicArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    }];
}

#pragma mark - TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.footer.hidden = self.topicArray.count == 0;
    return self.topicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell" forIndexPath:indexPath];
    Topic *topic = [self.topicArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = topic.topic_title;
    cell.usernameLabel.text = topic.user.nick_name;
    cell.timeLabel.text = topic.create_time;
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:topic.user.head_user]
                         placeholderImage:[UIImage imageNamed:@"Avatar"]
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Topic *topic = [self.topicArray objectAtIndex:indexPath.row];
    NSString *referer = [DoubanGroupURL stringByAppendingString:topic.douban_group_id];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", DoubanTopicURL, @(topic.douban_topic_id)]];
    [self performSegueWithIdentifier:@"toWebViewSection" sender:@{@"title": topic.topic_title,
                                                                  @"referer": referer,
                                                                  @"url": url}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toWebViewSection"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.title = sender[@"title"];
        webViewController.url = sender[@"url"];
        webViewController.referer = sender[@"referer"];
    }
}

@end
