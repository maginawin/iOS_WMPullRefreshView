//
//  WMPullRefreshViewController.m
//  WMPullRefresh
//
//  Created by maginawin on 15-3-5.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "WMPullRefreshViewController.h"

@interface WMPullRefreshViewController ()

@property (strong, nonatomic) UIActivityIndicatorView* aiView;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) UILabel* directLabel;
@property (strong, nonatomic) UILabel* statusLabel;

@property (nonatomic) BOOL isBegin;

@end

@implementation WMPullRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mScrollView.delegate = self;
    _isBegin = NO;
    [self setupViewsHeadViewColor:[UIColor blackColor]];
    [self setupRefreshViewsTextColor:[UIColor groupTableViewBackgroundColor]];
    [self setupAIView];
    [self setupSnowman];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)setupViewsHeadViewColor:(UIColor*)hvColor {
    _mScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    _headView = [[UIView alloc] init];
    _headView.frame = CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height * 3);
    _headView.backgroundColor = hvColor;
    [_mScrollView addSubview:_headView];
    _mainView.backgroundColor = [UIColor redColor];
    [_mScrollView addSubview:_mainView];
}

- (void)setupRefreshViewsTextColor:(UIColor*)textColor {
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 180) / 2, self.view.bounds.size.height - 44, 180, 44)];
    _statusLabel.textColor = textColor;
    _statusLabel.font = [UIFont systemFontOfSize:18];
    _statusLabel.text = @"Pull to refresh";
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_statusLabel];
    _directLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.frame.origin.x - 44, self.view.bounds.size.height - 44, 44, 44)];
    _directLabel.textColor = textColor;
    _directLabel.font = [UIFont systemFontOfSize:32];
    _directLabel.text = @"➟";
    _directLabel.textAlignment = NSTextAlignmentCenter;
    _directLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    [_headView addSubview:_directLabel];
}

- (void)setupAIView {
    _aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _aiView.color = _statusLabel.textColor;
    _aiView.hidesWhenStopped = YES;
    _aiView.frame = _directLabel.frame;
    [_aiView stopAnimating];
    [_headView addSubview:_aiView];
}

- (void)setupSnowman {
    UILabel* snowman = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, 88, 88)];
    snowman.textColor = [UIColor groupTableViewBackgroundColor];
    snowman.text = @"☃";
    snowman.font = [UIFont systemFontOfSize:64];
    [_headView addSubview:snowman];
    
    UILabel* snowmanSay = [[UILabel alloc] initWithFrame:CGRectMake(88, self.view.frame.size.height / 2, 200, 88)];
    snowmanSay.textColor = [UIColor groupTableViewBackgroundColor];
    snowmanSay.text = @"Oops, I was found.";
    snowmanSay.font = [UIFont systemFontOfSize:17];
    [_headView addSubview:snowmanSay];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int yOffset = scrollView.contentOffset.y;
    NSLog(@"%d", yOffset);
    if (yOffset < -64) {
        if (!_isBegin) {
            _directLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
            _statusLabel.text = @"Loosen for refresh";
            _isBegin = YES;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_isBegin) {
        [UIView animateWithDuration:0.2 animations:^ {
            _mScrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            _statusLabel.text = @"Refreshing";
            _directLabel.hidden = YES;
            [_aiView startAnimating];
        } completion:^ (BOOL animated) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pullRefreshViewEnd];
            });
        }];
    }
}

#pragma mark -

- (void)pullRefreshViewEnd {
    _isBegin = NO;
    [UIView animateWithDuration:0.2 animations:^ {
        _directLabel.hidden = NO;
        [_aiView stopAnimating];
        _mScrollView.contentInset = UIEdgeInsetsZero;
    } completion:^ (BOOL animated) {
        _directLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        _statusLabel.text = @"Pull refreshing";
    }];
}

@end
