//
//  MeiziRequest.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/14.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "MeiziRequest.h"
#import "Meizi.h"

@interface MeiziRequest()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) MeiziType type;

@end

@implementation MeiziRequest

- (instancetype)initWithPage:(NSInteger)page meiziType:(MeiziType)type {
    self = [super init];
    if (self) {
        self.page = page;
        self.type = type;
    }
    return self;
}

+ (MeiziRequest *)requestWithPage:(NSInteger)page meiziType:(MeiziType)type success:(void (^)(NSArray<Meizi *> *))success failure:(void (^)(NSString *))failure {
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:page meiziType:type];
    [request startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        MeiziRequest *meiziRequest = (MeiziRequest *)request;
        success?success([meiziRequest meiziArray]):nil;
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        MeiziRequest *meiziRequest = (MeiziRequest *)request;
        failure?failure(@(meiziRequest.responseStatusCode).stringValue):nil;
    }];
    return request;
}

- (BOOL)enableCache {
    return (self.page == 1)?YES:NO;
}

- (SYRequestMethod)requestMethod {
    return SYRequestMethodGET;
}

- (NSString *)requestPath {
    return @"/dbgroup/show.htm";
}

- (id)requestParameters {
    return @{@"pager_offset": @(self.page),
             @"cid": @(self.type)};
}

- (NSArray<Meizi *> *)meiziArray {
    return [MeiziRequest meiziArrayWithHTMLData:[self.responseString dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSArray<Meizi *> *)cachedMeiziArrayWithType:(MeiziType)type {
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:1 meiziType:type];
    return [MeiziRequest meiziArrayWithHTMLData:request.cacheData];
}

+ (NSArray<Meizi *> *)meiziArrayWithHTMLData:(NSData *)htmlData {
    TFHpple *rootDocument = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *liElementArray = [rootDocument searchWithXPathQuery:@"//*[@id=\"main\"]/div[2]/div[2]/ul/li"];
    NSMutableArray *meiziArray = [NSMutableArray array];
    for (TFHppleElement *liElement in liElementArray) {
        TFHpple *elementDocument = [TFHpple hppleWithHTMLData:[liElement.raw dataUsingEncoding:NSUTF8StringEncoding]];
        TFHppleElement *imageElement = [elementDocument peekAtSearchWithXPathQuery:@"//div/div[1]/a/img"];
        Meizi *meizi = [Meizi mj_objectWithKeyValues:imageElement.attributes];
        if (meizi != nil) {
            [meiziArray addObject:meizi];
        }
    }
    return meiziArray;
}

@end
