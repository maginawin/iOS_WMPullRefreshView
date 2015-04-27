//
//  WMTableView.h
//  WMPullRefresh
//
//  Created by wangwendong on 15/4/27.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMTableViewDelegate <NSObject>

- (void)tableViewPullDownRefreshStart;

- (void)tableViewPullDownRefreshEnd;

@end

@interface WMTableView : UITableView <UIScrollViewDelegate, UITableViewDelegate>

@property (weak, nonatomic) id<WMTableViewDelegate> refreshDelegate;

- (void)addPullDownRefresh;

- (void)addPullUpRefresh;

@end
