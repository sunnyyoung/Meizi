//
//  MeiziViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziViewController.h"
#import "MeiziRequest.h"
#import "MeiziCell.h"
#import "Meizi.h"

@interface MeiziViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) MeiziType type;
@property (nonatomic, strong) NSMutableArray *meiziArray;

@end

@implementation MeiziViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _page = 1;
        _type = MeiziTypeAll;
        _meiziArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCagegoryMenuView];
    [self setupRefreshHeaderAndFooter];
}

#pragma mark - Setup
- (void)setupCagegoryMenuView {
    __weak typeof(self) weakSelf = self;
    self.cagegoryMenu.sectionTitles = @[@"所有", @"大胸", @"翘臀", @"黑丝", @"美腿", @"清新", @"杂烩"];
    self.cagegoryMenu.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.cagegoryMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.cagegoryMenu.selectionIndicatorHeight = 3.0;
    self.cagegoryMenu.borderType = HMSegmentedControlBorderTypeBottom;
    self.cagegoryMenu.borderColor = [UIColor lightGrayColor];
    self.cagegoryMenu.borderWidth = 0.3;
    self.cagegoryMenu.alpha = 0.9;
    self.cagegoryMenu.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    self.cagegoryMenu.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
    [self.cagegoryMenu setIndexChangeBlock:^(NSInteger index) {
        switch (index) {
            case 0:
                weakSelf.type = MeiziTypeAll;
                break;
            case 1:
                weakSelf.type = MeiziTypeDaXiong;
                break;
            case 2:
                weakSelf.type = MeiziTypeQiaoTun;
                break;
            case 3:
                weakSelf.type = MeiziTypeHeisi;
                break;
            case 4:
                weakSelf.type = MeiziTypeMeiTui;
                break;
            case 5:
                weakSelf.type = MeiziTypeQingXin;
                break;
            case 6:
                weakSelf.type = MeiziTypeZaHui;
                break;
            default:
                break;
        }
        [weakSelf.collectionView.header beginRefreshing];
    }];
}

- (void)setupRefreshHeaderAndFooter {
    self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMeizi)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMeizi)];
    header.autoChangeAlpha = YES;
    footer.automaticallyRefresh = NO;
    self.collectionView.header = header;
    self.collectionView.footer = footer;
    [self.collectionView.header beginRefreshing];
}

#pragma mark - Refresh And LoadMore
- (void)refreshMeizi {
    self.page = 1;
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:self.page meiziType:self.type];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self.meiziArray removeAllObjects];
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *meiziArray = [Meizi objectArrayWithKeyValuesArray:data];
        
        [self.meiziArray addObjectsFromArray:meiziArray];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.meiziArray removeAllObjects];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        
    }];
}

- (void)loadMoreMeizi {
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:self.page+1 meiziType:self.type];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        self.page++;
        NSDictionary *data = [request.responseJSONObject objectForKey:@"data"];
        NSArray *meiziArray = [Meizi objectArrayWithKeyValuesArray:data];
        
        [self.meiziArray addObjectsFromArray:meiziArray];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.meiziArray removeAllObjects];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
        
    }];
}

#pragma mark - CollectionView DataSource && Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.footer.hidden = self.meiziArray.count == 0;
    return self.meiziArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/3-1, SCREEN_WIDTH/3-1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeiziCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeiziCell" forIndexPath:indexPath];
    Meizi *meizi = [self.meiziArray objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:meizi.img_url];
    [cell.imageView setImageWithURL:imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoArray = [NSMutableArray array];
    for (Meizi *meizi in self.meiziArray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:meizi.img_url]];
        photo.caption = meizi.topic_title;
        [photoArray addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photoArray];
    browser.alwaysShowControls = YES;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
}

@end
