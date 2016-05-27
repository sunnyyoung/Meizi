//
//  MeiziViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziViewController.h"
#import "SYNavigationDropdownMenu.h"
#import "MeiziRequest.h"
#import "MeiziCell.h"
#import "Meizi.h"
#import "AppDelegate.h"

@interface MeiziViewController () <UICollectionViewDelegateFlowLayout, SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) MeiziCategory category;
@property (nonatomic, strong) NSMutableArray *meiziArray;

@end

@implementation MeiziViewController

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _page = 1;
        _category = MeiziCategoryAll;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Orientation method

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView.collectionViewLayout finalizeCollectionViewUpdates];
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
    CGFloat screeWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    NSInteger perLine = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)?3:5;
    return CGSizeMake(screeWidth/perLine-1, screeWidth/perLine-1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeiziCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeiziCell" forIndexPath:indexPath];
    [cell setMeizi:self.meiziArray[indexPath.row]];
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoURLArray = [NSMutableArray array];
    for (Meizi *meizi in self.meiziArray) {
        [photoURLArray addObject:meizi.image_url];
    }
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:photoURLArray caption:nil delegate:self];
    photoBrowser.enableStatusBarHidden = NO;
    photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
    photoBrowser.initialPageIndex = indexPath.item;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark - NavigationDropdownMenu DataSource

- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return @[@"所有", @"大胸", @"翘臀", @"黑丝", @"美腿", @"清新", @"杂烩"];
}

- (UIImage *)arrowImageForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return [UIImage imageNamed:@"Arrow"];
}

- (CGFloat)arrowPaddingForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return 8.0;
}

- (BOOL)keepCellSelectionForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return NO;
}

#pragma mark - NavigationDropdownMenu Delegate

- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index {
    self.category = index;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Refresh method

- (void)refreshMeizi {
    self.page = 1;
    [MeiziRequest requestWithPage:self.page category:self.category success:^(NSArray<Meizi *> *meiziArray) {
        [self.collectionView.mj_header endRefreshing];
        [self reloadDataWithMeiziArray:meiziArray emptyBeforeReload:YES];
    } failure:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreMeizi {
    [MeiziRequest requestWithPage:self.page+1 category:self.category success:^(NSArray<Meizi *> *meiziArray) {
        [self.collectionView.mj_footer endRefreshing];
        [self reloadDataWithMeiziArray:meiziArray emptyBeforeReload:NO];
    } failure:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
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

#pragma mark - Property method

- (UINavigationItem *)navigationItem {
    UINavigationItem *navigationItem = [super navigationItem];
    if (navigationItem.titleView == nil) {
        SYNavigationDropdownMenu *dropdownMenu = [[SYNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController];
        dropdownMenu.dataSource = self;
        dropdownMenu.delegate = self;
        navigationItem.titleView = dropdownMenu;
    }
    return navigationItem;
}

- (UICollectionView *)collectionView {
    UICollectionView *collectionView = [super collectionView];
    if (collectionView.mj_header == nil) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMeizi)];
        header.automaticallyChangeAlpha = YES;
        collectionView.mj_header = header;
    }
    if (collectionView.mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMeizi)];
        footer.automaticallyRefresh = YES;
        collectionView.mj_footer = footer;
    }
    return collectionView;
}

- (NSMutableArray *)meiziArray {
    if (_meiziArray == nil) {
        _meiziArray = [NSMutableArray arrayWithArray:[MeiziRequest cachedMeiziArrayWithCategory:MeiziCategoryAll]];
    }
    return _meiziArray;
}

- (void)setCategory:(MeiziCategory)category {
    _category = category;
    [self.meiziArray removeAllObjects];
    [self.meiziArray addObjectsFromArray:[MeiziRequest cachedMeiziArrayWithCategory:category]];
    [self.collectionView reloadData];
}

@end
