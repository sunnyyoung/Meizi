//
//  MeiziCategoryMenuView.m
//  Meizi
//
//  Created by Sunnyyoung on 16/4/1.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "MeiziCategoryMenuView.h"

@implementation MeiziCategoryMenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sectionTitles = @[@"所有", @"大胸", @"翘臀", @"黑丝", @"美腿", @"清新", @"杂烩"];
    self.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.selectionIndicatorHeight = 3.0;
    self.borderType = HMSegmentedControlBorderTypeBottom;
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 0.3;
    self.alpha = 0.9;
    self.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    self.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
}

@end
