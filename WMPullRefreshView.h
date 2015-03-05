//
//  WMPullRefreshView.h
//  WMPullRefresh
//
//  Created by wangwendong on 15/3/5.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMPullRefreshViewDelegate <NSObject>

@required

- (void)pullRefreshViewBeginRefreshing;

@end

@interface WMPullRefreshView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* mScrollView;

@property (nonatomic, strong) UIView* pullView;

@property (nonatomic, strong) UIView* pullHeadView;

@property (nonatomic, strong) UILabel* statusLabel;

@property (nonatomic, strong) UILabel* directLabel;

@end
