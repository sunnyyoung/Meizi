//
//  MainCollectionViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MJRefresh.h"
#import "NetworkUtil.h"
#import "ImageCell.h"

@interface MainCollectionViewController ()

@property (nonatomic, assign) NSInteger      page;;
@property (nonatomic, strong) NSMutableArray *meizi;
@property (nonatomic, weak  ) UIImage        *selectedImage;

@end

@implementation MainCollectionViewController

#pragma mark initialize

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _datasource = _datasource?_datasource:MEIZI_ALL;
        _meizi = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark view

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self.collectionView addHeaderWithTarget:self action:@selector(refreshMeizi)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreMeizi)];
    [self.collectionView headerBeginRefreshing];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)removeNotification {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self willRotateToInterfaceOrientation:orientation duration:1.0];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView reloadData];
}

#pragma marl loadMeizi

- (void)refreshMeizi {
    [[NetworkUtil sharedNetworkUtil]getMeiziWithUrl:_datasource page:0 completion:^(NSArray *meiziArray, NSInteger nextPage) {
        if (meiziArray.count > 0) {
            [_meizi removeAllObjects];
            [_meizi addObjectsFromArray:meiziArray];
            _page = nextPage;
            NSLog(@"%@",@(_page));
            [self.collectionView reloadData];
        }else {
            [self.collectionView setFooterHidden:YES];
        }
        [self.collectionView headerEndRefreshing];
    }];
}

- (void)loadMoreMeizi {
    [[NetworkUtil sharedNetworkUtil]getMeiziWithUrl:_datasource page:_page completion:^(NSArray *meiziArray, NSInteger nextPage) {
        if (meiziArray.count > 0) {
            [_meizi addObjectsFromArray:meiziArray];
            _page = nextPage;
            NSLog(@"%@",@(_page));
            [self.collectionView reloadData];
        }else {
            [self.collectionView setFooterHidden:YES];
        }
        [self.collectionView footerEndRefreshing];
    }];
}

#pragma mark SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _meizi.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        return CGSizeMake(CGRectGetWidth(self.view.bounds) / 3 - 1, CGRectGetWidth(self.view.bounds) / 3 - 1);
    }else {
        return CGSizeMake(CGRectGetWidth(self.view.bounds) / 5 - 1, CGRectGetWidth(self.view.bounds) / 5 - 1);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    NSString *imageurl = [NSString stringWithFormat:@"%@%@", PIC_HOST,[_meizi objectAtIndex:indexPath.row][@"path"]];
    
    [cell.indicator startAnimating];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.indicator stopAnimating];
        [cell.indicator setHidden:YES];
    }];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取选中的Cell
    ImageCell *cell = (ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //创建图片信息
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc]init];
    imageInfo.image = cell.imageView.image;
    imageInfo.referenceRect = cell.frame;
    imageInfo.referenceView = cell.superview;
    //图片浏览Viewer
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    imageViewer.interactionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark JTSImageViewControllerInteractionsDelegate

- (BOOL)imageViewerAllowCopyToPasteboard:(JTSImageViewController *)imageViewer {
    return YES;
}

- (BOOL)imageViewerShouldTemporarilyIgnoreTouches:(JTSImageViewController *)imageViewer {
    return NO;
}

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect {
    _selectedImage = imageViewer.image;
    [[[UIActionSheet alloc]initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"保存到手机"
                       otherButtonTitles:nil, nil]showInView:self.view];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [SVProgressHUD showWithStatus:@"正在保存..."];
            UIImageWriteToSavedPhotosAlbum(_selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            break;
        }
        case 1: {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        }
    }
}

#pragma mark SavePhotoToPhone

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end
