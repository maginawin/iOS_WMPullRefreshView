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

@end
