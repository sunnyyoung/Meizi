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

#pragma mark - LifeCycle

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
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
}

- (void)setupRefreshHeaderAndFooter {
    self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMeizi)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMeizi)];
    header.automaticallyChangeAlpha = YES;
    footer.automaticallyRefresh = YES;
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Refresh method

- (void)refreshMeizi {
    self.page = 1;
    [MeiziRequest requestWithPage:self.page meiziType:self.type success:^(NSArray<Meizi *> *meiziArray) {
        [self.collectionView.mj_header endRefreshing];
        [self reloadDataWithMeiziArray:meiziArray emptyBeforeReload:YES];
    } failure:^(NSString *message) {
        [SVProgressHUD showWithStatus:message];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreMeizi {
    [MeiziRequest requestWithPage:self.page meiziType:self.type+1 success:^(NSArray<Meizi *> *meiziArray) {
        [self.collectionView.mj_footer endRefreshing];
        [self reloadDataWithMeiziArray:meiziArray emptyBeforeReload:NO];
    } failure:^(NSString *message) {
        [SVProgressHUD showWithStatus:message];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)reloadDataWithMeiziArray:(NSArray<Meizi *> *)meiziArray emptyBeforeReload:(BOOL)emptyBeforeReload {
    if (emptyBeforeReload) {
        self.page = 1;
        [self.meiziArray removeAllObjects];
        [self.meiziArray addObjectsFromArray:meiziArray];
        [self.collectionView.mj_footer resetNoMoreData];
    } else {
        if (meiziArray.count) {
            [self.meiziArray addObjectsFromArray:meiziArray];
            self.page++;
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.mj_footer.hidden = self.meiziArray.count == 0;
    return self.meiziArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger perLine = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)?3:5;
    return CGSizeMake(kScreenWidth/perLine-1, kScreenWidth/perLine-1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeiziCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeiziCell" forIndexPath:indexPath];
    [cell setMeizi:self.meiziArray[indexPath.row]];
    return cell;
}

#pragma mark - Orientation method

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView setCollectionViewLayout:self.collectionView.collectionViewLayout animated:YES];
        } completion:nil];
    }];
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoArray = [NSMutableArray array];
    for (Meizi *meizi in self.meiziArray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:meizi.src]];
        photo.caption = meizi.title;
        [photoArray addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photoArray];
    browser.alwaysShowControls = YES;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
}

@end
