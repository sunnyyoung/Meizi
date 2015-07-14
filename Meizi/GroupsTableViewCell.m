//
//  GroupTableViewCell.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "GroupsTableViewCell.h"

@implementation GroupsTableViewCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame)/2;
}

@end
