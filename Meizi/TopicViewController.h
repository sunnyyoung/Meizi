//
//  TopicViewController.h
//  Meizi
//
//  Created by Sunnyyoung on 15/7/15.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicViewController : UIViewController

@property (nonatomic, copy) NSString *groupID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
