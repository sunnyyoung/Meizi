//
//  MeiziCell.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziCell.h"
#import "Meizi.h"

@interface MeiziCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MeiziCell

#pragma mark - Public method

- (void)setMeizi:(Meizi *)meizi {
    NSURL *imageURL = [NSURL URLWithString:meizi.src];
    [self.imageView setImageWithURL:imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
