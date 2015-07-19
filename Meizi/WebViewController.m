//
//  WebViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/19.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [SVProgressHUD showWithStatus:@"加载中"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request.URL.absoluteString);
    NSDictionary *headers = [request allHTTPHeaderFields];
    BOOL hasReferer = [headers objectForKey:@"Referer"] != nil;
    if (!hasReferer) {
        // relaunch with a modified request
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:@"GET"];
                [request setValue:weakSelf.referer?:@"" forHTTPHeaderField: @"Referer"];
                [weakSelf.webView loadRequest:request];
            });
        });
        return NO;
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //Enable the ToolBar buttons
    if (!self.goBackButton.isEnabled || !self.goForwardButton.isEnabled) {
        self.goBackButton.enabled = YES;
        self.goForwardButton.enabled = YES;
    }
    NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    if ([htmlString containsString:@"你想要的东西不在这儿"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"帖子已经被删除啦~"];
    } else {
        [SVProgressHUD dismiss];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

@end
