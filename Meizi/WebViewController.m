//
//  WebViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/17.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <KINWebBrowserDelegate>

@end

@implementation WebViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadURL:self.url];
}

- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didFinishLoadingURL:(NSURL *)URL {
    if (webBrowser.wkWebView) {
    }
}

@end
