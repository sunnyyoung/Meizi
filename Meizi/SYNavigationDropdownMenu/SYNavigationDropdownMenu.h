//
//  SYNavigationDropdownMenu.h
//  SYNavigationDropdownMenu
//
//  Created by Sunnyyoung on 16/5/26.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYNavigationDropdownMenu;

@protocol SYNavigationDropdownMenuDataSource <NSObject>

@required
- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;

@optional
- (UIFont *)titleFontForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIColor *)titleColorForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIImage *)arrowImageForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (CGFloat)arrowPaddingForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (NSTimeInterval)animationDurationForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (BOOL)keepCellSelectionForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (CGFloat)cellHeightForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIEdgeInsets)cellSeparatorInsetsForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (NSTextAlignment)cellTextAlignmentForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIFont *)cellTextFontForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIColor *)cellTextColorForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIColor *)cellBackgroundColorForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;
- (UIColor *)cellSelectedColorForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu;

@end

@protocol SYNavigationDropdownMenuDelegate <NSObject>

@required
- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index;

@end

@interface SYNavigationDropdownMenu : UIButton

@property (nonatomic, weak) id <SYNavigationDropdownMenuDataSource> dataSource;
@property (nonatomic, weak) id <SYNavigationDropdownMenuDelegate> delegate;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)show;
- (void)hide;

@end
