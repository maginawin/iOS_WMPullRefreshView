//
//  WMPullRefreshViewController.h
//  WMPullRefresh
//
//  Created by maginawin on 15-3-5.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMasterViewController.h"
#import "WMSlaverViewController.h"

@interface WMPullRefreshViewController : UIViewController <UIScrollViewDelegate>

- (void)pullRefreshViewEnd;

@end
