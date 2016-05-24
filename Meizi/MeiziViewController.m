//
//  MeiziViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziViewController.h"
#import "MeiziCategoryMenuView.h"
#import "MeiziRequest.h"
#import "MeiziCell.h"
#import "Meizi.h"
#import "AppDelegate.h"

@interface MeiziViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet MeiziCategoryMenuView *cagegoryMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCagegoryMenuView];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Setup

- (void)setupCagegoryMenuView {
    __weak typeof(self) weakSelf = self;
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
    NSInteger perLine = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)?3:5;
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
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView.collectionViewLayout finalizeCollectionViewUpdates];
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoURLArray = [NSMutableArray array];
    for (Meizi *meizi in self.meiziArray) {
        [photoURLArray addObject:meizi.src];
    }
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:photoURLArray caption:nil delegate:self];
    photoBrowser.enableStatusBarHidden = NO;
    photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark - Property method

- (UICollectionView *)collectionView {
    if (_collectionView.mj_footer == nil) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMeizi)];
        header.automaticallyChangeAlpha = YES;
        _collectionView.mj_header = header;
        _collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }
    if (_collectionView.mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMeizi)];
        footer.automaticallyRefresh = YES;
        _collectionView.mj_footer = footer;
    }
    return _collectionView;
}

- (NSMutableArray *)meiziArray {
    if (_meiziArray == nil) {
        _meiziArray = [NSMutableArray arrayWithArray:[MeiziRequest cachedMeiziArrayWithType:MeiziTypeAll]];
    }
    return _meiziArray;
}

- (void)setType:(MeiziType)type {
    _type = type;
    [self.meiziArray removeAllObjects];
    [self.meiziArray addObjectsFromArray:[MeiziRequest cachedMeiziArrayWithType:type]];
    [self.collectionView reloadData];
}

@end
