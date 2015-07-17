//
//  RankViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "RankViewController.h"
#import "RankRequest.h"
#import "RankCell.h"
#import "Rank.h"

@interface RankViewController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *rankArray;

@end

@implementation RankViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _page = 1;
        _rankArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefreshHeaderAndFooter];
}

- (void)setupRefreshHeaderAndFooter {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshRank)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRank)];
    header.autoChangeAlpha = YES;
    footer.automaticallyRefresh = NO;
    self.collectionView.header = header;
    self.collectionView.footer = footer;
    [self.collectionView.header beginRefreshing];
}

- (void)refreshRank {
    self.page = 1;
    RankRequest *request = [[RankRequest alloc] initWithPage:self.page];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self.rankArray removeAllObjects];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *meiziArray = [Rank objectArrayWithKeyValuesArray:data];
        
        [self.rankArray addObjectsFromArray:meiziArray];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.rankArray removeAllObjects];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    }];
}

- (void)loadMoreRank {
    RankRequest *request = [[RankRequest alloc] initWithPage:self.page+1];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        self.page++;
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *meiziArray = [Rank objectArrayWithKeyValuesArray:data];
        
        [self.rankArray addObjectsFromArray:meiziArray];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.rankArray removeAllObjects];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
        
    }];
}

#pragma mark - CollectionView DataSource && Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.footer.hidden = self.rankArray.count == 0;
    return self.rankArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/3-1, SCREEN_WIDTH/3-1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RankCell" forIndexPath:indexPath];
    Rank *rank = [self.rankArray objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:rank.img_url];
    [cell.imageView setImageWithURL:imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoArray = [NSMutableArray array];
    for (Rank *rank in self.rankArray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:rank.img_url]];
        photo.caption = rank.topic_title;
        [photoArray addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photoArray];
    browser.alwaysShowControls = YES;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
}

@end
