//
//  WMNewViewController.m
//  WMPullRefresh
//
//  Created by wangwendong on 15/4/27.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "WMNewViewController.h"

@interface WMNewViewController ()
@property (weak, nonatomic) IBOutlet WMTableView *mTableView;

@end

@implementation WMNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mTableView.dataSource = self;
    
    // Reset table view's frame
    float navHeight = self.navigationController.navigationBar.frame.size.height;
    _mTableView.frame = CGRectMake(0, navHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navHeight);
    
    // If use nav, make no low layout at table view use this method
    self.automaticallyAdjustsScrollViewInsets = 0;
    
    // Add pull down view
    [_mTableView addPullDownRefresh];
}

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"idCell0" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    UILabel* textLabel = (UILabel*)cell.textLabel;
    textLabel.text = [NSString stringWithFormat:@"%d", (int)row];
    UILabel* detailLabel = (UILabel*)cell.detailTextLabel;
    detailLabel.text = [NSString stringWithFormat:@"%d", arc4random() * 100 % 101];
    return cell;
}

@end
