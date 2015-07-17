//
//  TopicTableViewCell.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "TopicTableViewCell.h"

@implementation TopicTableViewCell

- (void)awakeFromNib {
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame)/2;
}

@end
