//
//  SearchViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "SearchViewController.h"
#import "WebViewController.h"
#import "ResultTableViewCell.h"
#import "SearchRequest.h"
#import "Result.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation SearchViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _page = 1;
        _resultArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefreshHeaderAndFooter];
    [self refreshResult];
}

- (void)setupRefreshHeaderAndFooter {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshResult)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreResult)];
    header.autoChangeAlpha = YES;
    footer.automaticallyRefresh = NO;
    self.tableView.header = header;
    self.tableView.footer = footer;
}

- (void)refreshResult {
    self.page = 1;
    SearchRequest *request = [[SearchRequest alloc] initWithPage:self.page key:self.key];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self.resultArray removeAllObjects];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *resultArray = [Result objectArrayWithKeyValuesArray:data];
        
        [self.resultArray addObjectsFromArray:resultArray];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.resultArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    }];
}

- (void)loadMoreResult {
    SearchRequest *request = [[SearchRequest alloc] initWithPage:self.page+1 key:self.key];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        self.page++;
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *resultArray = [Result objectArrayWithKeyValuesArray:data];
        
        [self.resultArray addObjectsFromArray:resultArray];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.resultArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    }];
}

#pragma mark - TableView DataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.footer.hidden = self.resultArray.count == 0;
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    Result *result = self.resultArray[indexPath.row];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:result.c_head_url]
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.nicknameLabel.text = result.c_nick_name;
    cell.idLabel.text = result.c_user_id;
    cell.hometownLabel.text = result.c_user_district;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Result *result = [self.resultArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/", DoubanPeopleURL, result.c_user_id]];
    [self performSegueWithIdentifier:@"toWebViewSection" sender:@{@"title": result.c_nick_name,
                                                                  @"url": url}];
}

#pragma mark - SearchBar Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.key = searchText;
    [self refreshResult];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toWebViewSection"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.title = sender[@"title"];
        webViewController.url = sender[@"url"];
    }
}

@end
