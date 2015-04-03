//
//  MainViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MainViewController.h"
#import "Meizi.h"
#import "MeiziCell.h"

@interface MainViewController () <SlideNavigationControllerDelegate, NYTPhotosViewControllerDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *meiziArray;

@end

@implementation MainViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _datasource = MEIZI_ALL;
        _page = 0;
        _meiziArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [self setupHeaderAndFooter];
}

- (void)setupLayout {
    NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = 1.0;
    layout.minimumInteritemSpacing = 1.0;
    layout.sectionInset = UIEdgeInsetsZero;
}

- (void)setupHeaderAndFooter {
    [self.collectionView addLegendHeaderWithRefreshingTarget:self
                                            refreshingAction:@selector(refreshMeizi)];
    [self.collectionView addLegendFooterWithRefreshingTarget:self
                                            refreshingAction:@selector(loadMoreMeizi)];
    self.collectionView.footer.automaticallyRefresh = NO;
    self.collectionView.footer.hidden = YES;
    self.collectionView.header.textColor = [UIColor whiteColor];
    self.collectionView.footer.textColor = [UIColor whiteColor];
    [self.collectionView.header beginRefreshing];
}

- (void)refreshMeizi {
    _page = 0;
    [Network getMeiziWithUrl:_datasource page:_page completion:^(NSArray *meiziArray, NSInteger nextPage) {
        if (meiziArray.count > 0) {
            [_meiziArray removeAllObjects];
            [_meiziArray addObjectsFromArray:meiziArray];
            _page = nextPage;
            [self.collectionView.footer resetNoMoreData];
            [self.collectionView reloadData];
        }else {
            [self.collectionView.footer noticeNoMoreData];
        }
        [self.collectionView.header endRefreshing];
    }];
}

- (void)loadMoreMeizi {
    [Network getMeiziWithUrl:_datasource page:_page completion:^(NSArray *meiziArray, NSInteger nextPage) {
        if (meiziArray.count > 0) {
            [_meiziArray addObjectsFromArray:meiziArray];
            _page = nextPage;
            [self.collectionView reloadData];
        } else {
            [self.collectionView.footer noticeNoMoreData];
        }
        [self.collectionView.footer endRefreshing];
    }];
}

#pragma mark SlideNavigationControllerDelegate
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

#pragma mark CollectionView DataSource && Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.footer.hidden = (_meiziArray.count == 0);
    return _meiziArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Meizi *meizi = _meiziArray[indexPath.row];
    CGSize size = CGSizeMake([meizi width].integerValue, [meizi height].integerValue);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"MeiziCell";
    MeiziCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    Meizi *meizi = _meiziArray[indexPath.row];

    [cell.imageView setImageWithURL:[NSURL URLWithString:meizi.path]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              meizi.image = image;
                          }
        usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    return cell;
}

#pragma mark 点击CollectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MeiziCell *selectedCell = (MeiziCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!selectedCell.imageView.image) {
        return;
    }
    Meizi *meizi = _meiziArray[indexPath.row];
    NYTPhotosViewController *photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:_meiziArray initialPhoto:meizi];
    photoViewController.delegate = self;
    [self presentViewController:photoViewController animated:YES completion:nil];
}

#pragma mark PhotoViewController显示图片
- (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id<NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
    Meizi *meizi = (Meizi *)photo;
    if (!meizi.image) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:meizi.path]
                                                        options:8|9
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          meizi.image = image;
                                                          [photosViewController updateImageForPhoto:meizi];
                                                      }];
    }
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
    MeiziCell *cell = (MeiziCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[_meiziArray indexOfObject:photo] inSection:0]];
    return cell;
}

@end
