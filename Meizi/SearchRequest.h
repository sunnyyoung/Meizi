//
//  SearchRequest.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface SearchRequest : YTKRequest

- (instancetype)initWithPage:(NSInteger)page key:(NSString *)key;

@end
