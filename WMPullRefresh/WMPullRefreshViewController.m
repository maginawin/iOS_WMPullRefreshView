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
@property (strong, nonatomic) WMMasterViewController* masterVC;
@property (strong, nonatomic) WMSlaverViewController* slaverVC;

@property (nonatomic) CGPoint beganPoint;
@property (nonatomic) CGFloat pageX;

@property (strong, nonatomic) UILabel* directLabel;
@property (strong, nonatomic) UILabel* statusLabel;

@property (nonatomic) BOOL isBegin;

@end

@implementation WMPullRefreshViewController
static int width;
static int height;

- (void)viewDidLoad {
    [super viewDidLoad];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    _mScrollView.delegate = self;
    _isBegin = NO;
    _beganPoint = CGPointZero;
    [self setupViewsHeadViewColor:[UIColor clearColor]];
    [self setupMasterView];
    [self setupSlaverView];
    [self setupRefreshViewsTextColor:[UIColor groupTableViewBackgroundColor]];
    [self setupAIView];
    [self setupSnowman];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)setupViewsHeadViewColor:(UIColor*)hvColor {
    _mScrollView.contentSize = CGSizeMake(width * 2, 0);
    _mScrollView.contentOffset = CGPointMake(0, 0);
    _mScrollView.bounces = YES;
    _mScrollView.alwaysBounceVertical = YES;
    _pageX = _mScrollView.contentOffset.x;
    _headView = [[UIView alloc] init];
    _headView.frame = CGRectMake(0, -height, width, height * 3);
    _headView.backgroundColor = hvColor;
    [_mScrollView addSubview:_headView];
}

- (void)setupMasterView {
    _masterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idMasterVC"];
    _masterVC.view.frame = CGRectMake(0, 0, width, height);
    [_mScrollView addSubview:_masterVC.view];
}

- (void)setupSlaverView {
    _slaverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"idSlaverVC"];
    _slaverVC.view.layer.frame = CGRectMake(width, 0, width, height);
    [_mScrollView addSubview:_slaverVC.view];
}

- (void)setupRefreshViewsTextColor:(UIColor*)textColor {
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 180) / 2, height - 44, 180, 44)];
    _statusLabel.textColor = textColor;
    _statusLabel.font = [UIFont systemFontOfSize:18];
    _statusLabel.text = NSLocalizedString(@"pulltorefresh", @"");
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:_statusLabel];
    _directLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.frame.origin.x - 44, height - 44, 44, 44)];
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
    UILabel* snowman = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 2, 88, 88)];
    snowman.textColor = [UIColor groupTableViewBackgroundColor];
    snowman.text = @"☃";
    snowman.font = [UIFont systemFontOfSize:64];
    [_headView addSubview:snowman];
    
    UILabel* snowmanSay = [[UILabel alloc] initWithFrame:CGRectMake(88, height / 2, 200, 88)];
    snowmanSay.textColor = [UIColor groupTableViewBackgroundColor];
    snowmanSay.text = @"Oops, I was found.";
    snowmanSay.font = [UIFont systemFontOfSize:17];
    [_headView addSubview:snowmanSay];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int yOffset = scrollView.contentOffset.y;
    if (yOffset != 0) {
        _mScrollView.contentOffset = CGPointMake(_pageX, yOffset);
    }
    if (yOffset <= -84) {
        if (!_isBegin) {
            [UIView animateWithDuration:0.1 animations:^ {
                _directLabel.transform = CGAffineTransformMakeRotation(3 * M_PI_2);
                _statusLabel.text = NSLocalizedString(@"releasetorefresh", @"");
            }];
            _isBegin = YES;
        }
    } else {
        if (_isBegin) {
            [UIView animateWithDuration:0.1 animations:^ {
                _directLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
                _statusLabel.text = NSLocalizedString(@"pulltorefresh", @"");
            }];
            _isBegin = NO;
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_isBegin) {
        [UIView animateWithDuration:0.2 animations:^ {
            _mScrollView.pagingEnabled = NO;
            _mScrollView.userInteractionEnabled = NO;
            _mScrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            //            _mScrollView.center = CGPointMake(width / 2, height / 2 + 64);
            _statusLabel.text = NSLocalizedString(@"refreshing", @"");
            _directLabel.hidden = YES;
            [_aiView startAnimating];
        } completion:^ (BOOL animated) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pullRefreshViewEnd];
            });
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageX = scrollView.contentOffset.x;
    CGPoint real = CGPointMake(width / 2 + _pageX, _headView.center.y);
    _headView.center = real;
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
        _statusLabel.text = NSLocalizedString(@"pulltorefresh", @"");
        _mScrollView.pagingEnabled = YES;
        _mScrollView.userInteractionEnabled = YES;
    }];
}

@end
