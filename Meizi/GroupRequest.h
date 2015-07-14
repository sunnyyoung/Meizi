//
//  GroupRequest.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <YTKNetwork/YTKRequest.h>

@interface GroupRequest : YTKRequest

- (instancetype)initWithPage:(NSInteger)page groupdID:(NSString *)groupID;

@end
