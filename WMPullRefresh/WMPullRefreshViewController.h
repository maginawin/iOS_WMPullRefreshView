//
//  WMPullRefreshViewController.h
//  WMPullRefresh
//
//  Created by maginawin on 15-3-5.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMPullRefreshViewControllerDelegate <NSObject>

@required
- (void)pullRefreshViewStart;

@end

@interface WMPullRefreshViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) id<WMPullRefreshViewControllerDelegate> delegate;

- (void)pullRefreshViewEnd;

@end
