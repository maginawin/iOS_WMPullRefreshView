//
//  WMPullRefreshView.m
//  WMPullRefresh
//
//  Created by wangwendong on 15/3/5.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "WMPullRefreshView.h"

@interface WMPullRefreshView()


@end

@implementation WMPullRefreshView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupBaseView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    [self setupScrollView];
    [self setupPullView];
    [self setupStatusLabel];
    [self setupDirectLabel];
}

- (void)setupScrollView {
    self.frame = [UIScreen mainScreen].bounds;
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _mScrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _mScrollView.contentSize = self.frame.size;
    _mScrollView.alwaysBounceVertical = YES;
    _mScrollView.delegate = self;
    [self addSubview:_mScrollView];
}

- (void)setupPullView {
    _pullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 64)];
    _pullView.backgroundColor = [UIColor clearColor];
    [_mScrollView addSubview:_pullView];
    
    _pullHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
    _pullHeadView.backgroundColor = [UIColor purpleColor];
    [_pullView addSubview:_pullHeadView];
}

- (void)setupStatusLabel {
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 8, 120, 48)];
    _statusLabel.textColor = [UIColor darkTextColor];
    _statusLabel.font = [UIFont systemFontOfSize:16];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.text = @"Pull refreshing";
    [_pullHeadView addSubview:_statusLabel];
}

- (void)setupDirectLabel {
    _directLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 8, 48, 48)];
    _directLabel.textColor = [UIColor darkTextColor];
    _directLabel.font = [UIFont systemFontOfSize:32];
    _directLabel.text = @"➟";
    _directLabel.textAlignment = NSTextAlignmentCenter;
    _directLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    [_pullHeadView addSubview:_directLabel];
}

- (void)pullRefreshViewEnd {

}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger yOffset = scrollView.contentOffset.y;
    if (yOffset < -20) {
        [_delegate pullRefreshViewBegin];
        _directLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

@end
