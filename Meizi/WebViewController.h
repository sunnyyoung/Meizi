//
//  WebViewController.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/19.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardButton;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *referer;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
