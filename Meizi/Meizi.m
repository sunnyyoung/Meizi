//
//  Meizi.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "Meizi.h"
#import "Constant.h"

@implementation Meizi

- (void)setPath:(NSString *)path {
    _path = [PIC_HOST stringByAppendingString:path];
}

- (NSAttributedString *)attributedCaptionTitle {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:_title attributes:attributes];
}

@end
