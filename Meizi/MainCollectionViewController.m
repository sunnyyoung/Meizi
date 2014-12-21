//
//  MainCollectionViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 14-12-20.
//  Copyright (c) 2014年 Sunnyyoung. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "NetworkUtil.h"
#import "ImageCell.h"

@interface MainCollectionViewController ()

@property (nonatomic, assign)int page;
@property (nonatomic, weak)UIImage *selectedImage;
@property (nonatomic, strong)NSMutableArray *meizi;

@end

@implementation MainCollectionViewController

#pragma mark view

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionLayout];
    
    self.page = 1;      //初始页数
    self.meizi = [[NSMutableArray alloc]init];
    self.datasource = !self.datasource ? MEIZI_ALL:self.datasource;
    
    __weak typeof(self) weakself = self;
    //下拉刷新
    [self.collectionView addHeaderWithCallback:^{
        if (weakself.meizi.count == 0) {
            [weakself loadMeiziWithpage:1 completion:^(BOOL result, NSString *message) {
                [weakself.collectionView reloadData];
                [weakself.collectionView headerEndRefreshing];
            }];
        }else {
            [weakself.collectionView headerEndRefreshing];
        }
    }];
    //上拉加载更多
    [self.collectionView addFooterWithCallback:^{
        [weakself loadMeiziWithpage:weakself.page completion:^(BOOL result, NSString *message) {
            [weakself.collectionView reloadData];
            [weakself.collectionView footerEndRefreshing];
        }];
    }];
    //开始刷新啦哈哈哈哈哈!!!
    [self.collectionView headerBeginRefreshing];
}

/**
 *  设置CollectionView的Layout
 */
- (void)setCollectionLayout {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.columnCount = 2;
    layout.minimumColumnSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma marl loadMeizi

/**
 *  加载妹子图
 *
 *  @param page 页数
 */
- (void)loadMeiziWithpage:(int)page completion:(void (^)(BOOL result, NSString *message))completion{
    [[NetworkUtil sharedNetworkUtil]getMeizi:self.datasource pages:page success:^(NSString *succMsg, NSArray *meiziArray) {
        self.page++;
        [self.meizi addObjectsFromArray:meiziArray];
        completion(YES, succMsg);
    } failure:^(NSString *failMsg, NSError *error) {
        [KVNProgress showErrorWithStatus:failMsg];
        completion(NO, failMsg);
    }];
}

#pragma mark <SlideNavigationControllerDelegate>

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

#pragma marl <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 50);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.meizi.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    cell.imageView.image = nil;
    NSDictionary *meizi = [(TFHppleElement*)[self.meizi objectAtIndex:indexPath.row] attributes];
    cell.thumburl = [meizi valueForKey:@"data-src"];
    cell.imageurl = [meizi valueForKey:@"data-bigimg"];
    cell.detail = [meizi valueForKey:@"alt"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:cell.thumburl] placeholderImage:[UIImage imageNamed:@"PlaceholderImage"]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取选中的Cell
    ImageCell *cell = (ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //创建图片信息
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc]init];
    imageInfo.imageURL = [NSURL URLWithString:cell.imageurl];
    imageInfo.altText = cell.detail;
    imageInfo.referenceRect = cell.frame;
    imageInfo.referenceView = cell.superview;
    //图片浏览Viewer
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    imageViewer.interactionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark <JTSImageViewControllerInteractionsDelegate>

- (BOOL)imageViewerAllowCopyToPasteboard:(JTSImageViewController *)imageViewer {
    return YES;
}

- (BOOL)imageViewerShouldTemporarilyIgnoreTouches:(JTSImageViewController *)imageViewer {
    return NO;
}

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect {
    self.selectedImage = imageViewer.image;
    [[[UIActionSheet alloc]initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"保存到手机"
                       otherButtonTitles:nil, nil]showInView:self.view];
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [KVNProgress showWithStatus:@"正在保存..."];
            UIImageWriteToSavedPhotosAlbum(self.selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            break;
        }
        case 1: {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark SavePhotoToPhone
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error) {
        [KVNProgress showErrorWithStatus:@"保存图片失败"];
    }else{
        [KVNProgress showSuccessWithStatus:@"保存图片成功"];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
