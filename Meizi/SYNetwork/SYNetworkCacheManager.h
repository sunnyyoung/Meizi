//
//  SYNetworkCacheManager.h
//  SYNetwork
//
//  Created by Sunnyyoung on 16/3/24.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>

@interface SYNetworkCacheManager : NSObject

+ (SYNetworkCacheManager *)sharedInstance;

- (id<NSCoding>)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

@end
