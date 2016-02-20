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

@property (nonatomic) NSInteger page;
@property (nonatomic) MeiziType type;

@end

@implementation MeiziRequest

- (instancetype)initWithPage:(NSInteger)page meiziType:(MeiziType)type {
    self = [super init];
    if (self) {
        _page = page;
        _type = type;
    }
    return self;
}

+ (MeiziRequest *)requestWithPage:(NSInteger)page meiziType:(MeiziType)type success:(void (^)(NSArray<Meizi *> *))success failure:(void (^)(NSString *))failure {
    MeiziRequest *request = [[MeiziRequest alloc] initWithPage:page meiziType:type];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        MeiziRequest *meiziRequest = (MeiziRequest *)request;
        success?success([meiziRequest meiziArray]):nil;
    } failure:^(__kindof YTKBaseRequest *request) {
        MeiziRequest *meiziRequest = (MeiziRequest *)request;
        failure?failure(@(meiziRequest.responseStatusCode).stringValue):nil;
    }];
    return request;
}

- (NSString *)requestUrl {
    return @"/dbgroup/show.htm";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (id)requestArgument {
    return @{@"pager_offset": @(_page),
             @"cid": @(_type)};
}

- (NSArray<Meizi *> *)meiziArray {
    NSString *htmlString = self.responseString;
    TFHpple *rootDocument = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *liElements = [rootDocument searchWithXPathQuery:@"//*[@id=\"main\"]/div[3]/div[2]/ul/li"];
    NSMutableArray *meiziArray = [NSMutableArray array];
    for (TFHppleElement *liElement in liElements) {
        TFHppleElement *imageElement = [[[[liElement firstChildWithClassName:@"thumbnail"]
                                          firstChildWithClassName:@"img_single"]
                                         firstChildWithClassName:@"link"]
                                        firstChildWithTagName:@"img"];
        Meizi *meizi = [Meizi mj_objectWithKeyValues:imageElement.attributes];
        if (meizi != nil) {
            [meiziArray addObject:meizi];
        }
    }
    return meiziArray;
}

@end
