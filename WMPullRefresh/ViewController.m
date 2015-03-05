//
//  ViewController.m
//  WMPullRefresh
//
//  Created by wangwendong on 15/3/5.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WMPullRefreshView *mPullRefreshView;
@property (weak, nonatomic) IBOutlet UIView *mSubView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_mPullRefreshView.mScrollView addSubview:_mSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
