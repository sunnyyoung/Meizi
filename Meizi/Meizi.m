//
//  Meizi.m
//  Meizi
//
//  Created by Sunnyyoung on 15/4/4.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "Meizi.h"

@implementation Meizi

- (NSString *)largeSrc {
    if ([self.src containsString:@"bmiddle"]) {
        return [self.src stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
    } else {
        return self.src;
    }
}

@end