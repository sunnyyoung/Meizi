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

@property (nonatomic ,assign)int page;
@property (nonatomic ,strong)NSMutableArray *meizi;

@end

@implementation MainCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.meizi = [[NSMutableArray alloc]init];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMeiziWithpage:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self loadMeiziWithpage:self.page];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (void)loadMeiziWithpage:(int)page {
    page = !page ? 1:self.page;
    //[KVNProgress showWithStatus:@"正在获取妹子"];
    [[NetworkUtil sharedNetworkUtil]getMeizi:MEIZI_CALLIPYGE pages:page success:^(NSString *succMsg, id responseObject) {
        NSArray *meiziArray = [[TFHpple hppleWithHTMLData:responseObject]searchWithXPathQuery:@"/html/body/div[2]/ul[2]/li[@*]/div/div[1]/span/img"];
        [self.meizi addObjectsFromArray:meiziArray];
        self.page ++;
        [self.collectionView reloadData];
        [self.collectionView footerEndRefreshing];
        [KVNProgress dismiss];
    } failure:^(NSString *failMsg, NSError *error) {
        [KVNProgress showErrorWithStatus:@"获取妹子失败"];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [cell.imageView setImageWithURL:[NSURL URLWithString:cell.thumburl] placeholderImage:nil];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = (ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc]init];
    imageInfo.imageURL = [NSURL URLWithString:cell.imageurl];
    imageInfo.altText = cell.detail;
    imageInfo.referenceRect = cell.frame;
    imageInfo.referenceView = cell.superview;
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
    [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到手机" otherButtonTitles:nil, nil]showInView:self.view];
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //todo
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

@end
