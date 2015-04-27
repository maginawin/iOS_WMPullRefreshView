//
//  WMTableView.m
//  WMPullRefresh
//
//  Created by wangwendong on 15/4/27.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "WMTableView.h"

@interface WMTableView()

@property (strong, nonatomic) UIView* downView;
@property (strong, nonatomic) UILabel* downIcon;
@property (strong, nonatomic) UILabel* downText;
@property (nonatomic) BOOL isDownRefresh;
@property (nonatomic) BOOL hasDownRefresh;

@property (strong, nonatomic) UIView* upView;
@property (strong, nonatomic) UILabel* upIcon;
@property (strong, nonatomic) UILabel* upText;
@property (nonatomic) BOOL isUpRefresh;
@property (nonatomic) BOOL hasUpRefresh;

@end

@implementation WMTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        _isDownRefresh = NO;
        _hasDownRefresh = NO;
        _isUpRefresh = NO;
        _hasUpRefresh = NO;
    }
    return self;
}

- (void)addPullDownRefresh {
    _downView = [[UIView alloc] init];
    _downView.backgroundColor = [UIColor clearColor];
    _downView.frame = CGRectMake(0, -64, self.bounds.size.width, 64);
    [self addSubview:_downView];
    
    _downIcon = [[UILabel alloc] init];
    _downIcon.frame = CGRectMake(0, -64, self.bounds.size.width / 3, 64);
    _downIcon.font = [UIFont systemFontOfSize:31];
    _downIcon.textAlignment = NSTextAlignmentCenter;
    _downIcon.textColor = [UIColor purpleColor];
    _downIcon.text = @"➟";
    _downIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self addSubview:_downIcon];
    
    _downText = [[UILabel alloc] init];
    _downText.frame = CGRectMake(self.bounds.size.width / 3, -64, self.bounds.size.width / 2, 64);
    _downText.font = [UIFont systemFontOfSize:15];
    _downText.textAlignment = NSTextAlignmentLeft;
    _downText.textColor = [UIColor grayColor];
    _downText.text = @"Pull down refresh...";
    [self addSubview:_downText];
}

- (void)addPullUpRefresh {

}

- (void)downRefreshStart:(BOOL)enable {
    UIEdgeInsets moveEdgeInserts = UIEdgeInsetsZero;
    if (enable) {
        moveEdgeInserts = UIEdgeInsetsMake(64, 0, 0, 0);
        self.userInteractionEnabled = NO;
    } else {
        _hasDownRefresh = NO;
        self.userInteractionEnabled = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^ {
        if (enable) {
            UIEdgeInsets move = UIEdgeInsetsMake(64, 0, 0, 0);
            self.scrollEnabled = NO;
            NSString* titleString = @"Refreshing...";
            [UIView animateWithDuration:0.2 animations:^ {
                self.contentInset = move;
                _downText.text = titleString;
                [_refreshDelegate tableViewPullDownRefreshStart];
            }];
        } else {
            _hasDownRefresh = NO;
            [UIView animateWithDuration:0.5 animations:^ {
                _downText.text = @"Complete...";
                self.contentInset = UIEdgeInsetsZero;
            } completion:^ (BOOL finished) {
                _downText.text = @"Pull down refresh...";
                self.scrollEnabled = YES;
                [_refreshDelegate tableViewPullDownRefreshEnd];
            }];
        }
    });
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        if (!_hasDownRefresh) {
            CGPoint locationPoint = scrollView.contentOffset;
            if (locationPoint.y < -72) {
                if (!_isDownRefresh) {
                    _isDownRefresh = YES;
                    [UIView animateWithDuration:0.2 animations:^ {
                        _downIcon.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    }];
                }
                
            } else {
                if (_isDownRefresh) {
                    _isDownRefresh = NO;
                    [UIView animateWithDuration:0.2 animations: ^ {
                        _downIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
                    }];
                }
            }
        }
    } else if (scrollView.contentOffset.y > 0) {
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        if (scrollView.contentOffset.y < -72) {
            _hasDownRefresh = YES;
            NSLog(@"did pull down refresh with y : %.2f", scrollView.contentOffset.y);
            [self downRefreshStart:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self downRefreshStart:NO];
            });
        }
    }
}

@end
