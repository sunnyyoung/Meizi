//
//  SYNavigationDropdownMenu.m
//  SYNavigationDropdownMenu
//
//  Created by Sunnyyoung on 16/5/26.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYNavigationDropdownMenu.h"

@interface SYNavigationDropdownMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UIView *menuHeaderView;
@property (nonatomic, strong) UIView *menuBackgroundView;

@end

@implementation SYNavigationDropdownMenu

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [SYNavigationDropdownMenu buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = navigationController.navigationBar.frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.navigationController = navigationController;
    }
    return self;
}

#pragma mark Layout method

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel setFont:self.titleFont];
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    [self setImage:self.arrowImage forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CGRectGetWidth(self.imageView.frame), 0.0, CGRectGetWidth(self.imageView.frame) + self.arrowPadding)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, CGRectGetWidth(self.titleLabel.frame) + self.arrowPadding, 0.0, -CGRectGetWidth(self.titleLabel.frame))];
    CGRect menuHeaderViewFrame = self.menuHeaderView.frame;
    menuHeaderViewFrame.size.width = CGRectGetWidth(self.navigationController.navigationBar.frame);
    menuHeaderViewFrame.size.height = self.cellHeight;
    self.menuHeaderView.frame = menuHeaderViewFrame;
    CGRect menuBackgroundViewFrame = [UIScreen mainScreen].bounds;
    menuBackgroundViewFrame.origin.y += CGRectGetMaxY(self.navigationController.navigationBar.frame);
    menuBackgroundViewFrame.size.height -= CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.menuBackgroundView.frame = menuBackgroundViewFrame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([super sizeThatFits:size].width + self.arrowPadding, [super sizeThatFits:size].height);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([super intrinsicContentSize].width + self.arrowPadding, [super intrinsicContentSize].height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect menuHeaderViewFrame = self.menuHeaderView.frame;
    if (scrollView.contentOffset.y < 0) {
        menuHeaderViewFrame.size.height = -scrollView.contentOffset.y;
    } else {
        menuHeaderViewFrame.size.height = 0.0;
    }
    self.menuHeaderView.frame = menuHeaderViewFrame;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource titleArrayForNavigationDropdownMenu:self][indexPath.row];
    cell.textLabel.font = self.cellTextFont;
    cell.textLabel.textColor = self.cellTextColor;
    cell.textLabel.textAlignment = self.cellTextAlignment;
    cell.backgroundColor = self.cellBackgroundColor;
    if (self.cellSelectedColor) {
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = self.cellSelectedColor;
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:self.cellSeparatorInsets];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.cellSeparatorInsets];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.keepCellSelection ?: [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(navigationDropdownMenu:didSelectTitleAtIndex:)]) {
        [self.delegate navigationDropdownMenu:self didSelectTitleAtIndex:indexPath.row];
        [self setTitle:[self.dataSource titleArrayForNavigationDropdownMenu:self][indexPath.row] forState:UIControlStateNormal];
    }
    [self hide];
}

#pragma mark - Public method

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuBackgroundView];
    CGRect menuTableViewFrame = self.menuTableView.frame;
    menuTableViewFrame.origin.y = -(MIN(self.titleArray.count * self.cellHeight, CGRectGetHeight(self.menuBackgroundView.frame)));
    self.menuTableView.frame = menuTableViewFrame;
    self.selected = YES;
    [UIView animateWithDuration:self.animationDuration * 1.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:kNilOptions animations:^{
        CGRect menuTableViewFrame = self.menuTableView.frame;
        menuTableViewFrame.origin.y = 0.0;
        self.menuTableView.frame = menuTableViewFrame;
        self.menuBackgroundView.alpha = 1.0;
    } completion:nil];
}

- (void)hide {
    self.selected = NO;
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGRect menuTableViewFrame = self.menuTableView.frame;
        menuTableViewFrame.origin.y = -(MIN(self.titleArray.count * self.cellHeight, CGRectGetHeight(self.menuBackgroundView.frame)));
        self.menuTableView.frame = menuTableViewFrame;
        self.menuBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.menuBackgroundView removeFromSuperview];
    }];
}

#pragma mark - Event Response

- (void)menuAction:(SYNavigationDropdownMenu *)sender {
    self.isSelected?[self hide]:[self show];
}

#pragma mark - Property method

- (UITableView *)menuTableView {
    if (_menuTableView == nil) {
        _menuTableView = [[UITableView alloc] initWithFrame:self.menuBackgroundView.bounds style:UITableViewStylePlain];
        _menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, CGFLOAT_MIN)];
        [_menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.menuBackgroundView addSubview:_menuTableView];
    }
    return _menuTableView;
}

- (UIView *)menuHeaderView {
    if (_menuHeaderView == nil) {
        _menuHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _menuHeaderView.backgroundColor = self.cellBackgroundColor;
        [self.menuBackgroundView addSubview:_menuHeaderView];
    }
    return _menuHeaderView;
}

- (UIView *)menuBackgroundView {
    if (_menuBackgroundView == nil) {
        _menuBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _menuBackgroundView.clipsToBounds = YES;
        _menuBackgroundView.alpha = 0.0;
        _menuBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    return _menuBackgroundView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:self.animationDuration animations:^{
        if (selected) {
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.imageView.transform = CGAffineTransformMakeRotation(0.0);
        }
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)setDataSource:(id<SYNavigationDropdownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    [self setTitle:self.titleArray.firstObject forState:UIControlStateNormal];
}

- (void)setDelegate:(id<SYNavigationDropdownMenuDelegate>)delegate {
    _delegate = delegate;
    if ([delegate respondsToSelector:@selector(navigationDropdownMenu:didSelectTitleAtIndex:)]) {
        [self addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - ReadOnly Property

- (NSArray<NSString *> *)titleArray {
    if ([self.dataSource respondsToSelector:@selector(titleArrayForNavigationDropdownMenu:)]) {
        return [self.dataSource titleArrayForNavigationDropdownMenu:self];
    } else {
        return nil;
    }
}

- (UIFont *)titleFont {
    if ([self.dataSource respondsToSelector:@selector(titleFontForNavigationDropdownMenu:)]) {
        return [self.dataSource titleFontForNavigationDropdownMenu:self];
    } else {
        return [UIFont systemFontOfSize:17.0];
    }
}

- (UIColor *)titleColor {
    if ([self.dataSource respondsToSelector:@selector(titleColorForNavigationDropdownMenu:)]) {
        return [self.dataSource titleColorForNavigationDropdownMenu:self];
    } else {
        return [UIColor blackColor];
    }
}

- (UIImage *)arrowImage {
    if ([self.dataSource respondsToSelector:@selector(arrowImageForNavigationDropdownMenu:)]) {
        return [self.dataSource arrowImageForNavigationDropdownMenu:self];
    } else {
        return nil;
    }
}

- (CGFloat)arrowPadding {
    if ([self.dataSource respondsToSelector:@selector(arrowPaddingForNavigationDropdownMenu:)] && self.arrowImage) {
        return [self.dataSource arrowPaddingForNavigationDropdownMenu:self];
    } else {
        return 0.0;
    }
}

- (NSTimeInterval)animationDuration {
    if ([self.dataSource respondsToSelector:@selector(animationDurationForNavigationDropdownMenu:)]) {
        return [self.dataSource animationDurationForNavigationDropdownMenu:self];
    } else {
        return 0.25;
    }
}

- (BOOL)keepCellSelection {
    if ([self.dataSource respondsToSelector:@selector(keepCellSelectionForNavigationDropdownMenu:)]) {
        return [self.dataSource keepCellSelectionForNavigationDropdownMenu:self];
    } else {
        return YES;
    }
}

- (CGFloat)cellHeight {
    if ([self.dataSource respondsToSelector:@selector(cellHeightForNavigationDropdownMenu:)]) {
        return [self.dataSource cellHeightForNavigationDropdownMenu:self];
    } else {
        return 45.0;
    }
}

- (UIEdgeInsets)cellSeparatorInsets {
    if ([self.dataSource respondsToSelector:@selector(cellSeparatorInsetsForNavigationDropdownMenu:)]) {
        return [self.dataSource cellSeparatorInsetsForNavigationDropdownMenu:self];
    } else {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
}

- (NSTextAlignment)cellTextAlignment {
    if ([self.dataSource respondsToSelector:@selector(cellTextAlignmentForNavigationDropdownMenu:)]) {
        return [self.dataSource cellTextAlignmentForNavigationDropdownMenu:self];
    } else {
        return NSTextAlignmentCenter;
    }
}

- (UIFont *)cellTextFont {
    if ([self.dataSource respondsToSelector:@selector(cellTextFontForNavigationDropdownMenu:)]) {
        return [self.dataSource cellTextFontForNavigationDropdownMenu:self];
    } else {
        return [UIFont systemFontOfSize:16.0];
    }
}

- (UIColor *)cellTextColor {
    if ([self.dataSource respondsToSelector:@selector(cellTextColorForNavigationDropdownMenu:)]) {
        return [self.dataSource cellTextColorForNavigationDropdownMenu:self];
    } else {
        return [UIColor blackColor];
    }
}

- (UIColor *)cellBackgroundColor {
    if ([self.dataSource respondsToSelector:@selector(cellBackgroundColorForNavigationDropdownMenu:)]) {
        return [self.dataSource cellBackgroundColorForNavigationDropdownMenu:self];
    } else {
        return [UIColor whiteColor];
    }
}

- (UIColor *)cellSelectedColor {
    if ([self.dataSource respondsToSelector:@selector(cellSelectedColorForNavigationDropdownMenu:)]) {
        return [self.dataSource cellSelectedColorForNavigationDropdownMenu:self];
    } else {
        return nil;
    }
}

@end
