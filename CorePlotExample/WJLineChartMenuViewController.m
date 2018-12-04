//
//  WJLineChartMenuViewController.m
//  CorePlotExample
//
//  Created by 王傲云 on 2018/12/3.
//  Copyright © 2018 WangJace. All rights reserved.
//

#import "WJLineChartMenuViewController.h"
#import <Masonry.h>
#import "WJBasicLineChartViewController.h"
#import "WJDashLineChartViewController.h"
#import "WJPointLintChartViewController.h"
#import "WJMultipleLineChartViewController.h"

@interface WJLineChartMenuViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataSource;
}
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation WJLineChartMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"线形图";
    _dataSource = @[@"Basic", @"Dash", @"Point", @"Mutiple"];
    [self.view addSubview:self.myTableView];
}

-  (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view).offset(self.view.safeAreaInsets.top);
            make.bottom.equalTo(self.view).offset(-self.view.safeAreaInsets.bottom);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view).offset(64);
            make.bottom.equalTo(self.view);
        }
    }];
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] init];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableFooterView = [UIView new];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    }
    return _myTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            // Basic
            WJBasicLineChartViewController *basicLineChartVC = [[WJBasicLineChartViewController alloc] init];
            [self.navigationController pushViewController:basicLineChartVC animated:YES];
        }
            break;
        case 1:
        {
            // Dash
            WJDashLineChartViewController *dashLineChartVC = [[WJDashLineChartViewController alloc] init];
            [self.navigationController pushViewController:dashLineChartVC animated:YES];
        }
            break;
        case 2:
        {
            // Point
            WJPointLintChartViewController *pointLineChartVC = [[WJPointLintChartViewController alloc] init];
            [self.navigationController pushViewController:pointLineChartVC animated:YES];
        }
            break;
        case 3:
        {
            // Multiple
            WJMultipleLineChartViewController *multipleLineChartVC = [[WJMultipleLineChartViewController alloc] init];
            [self.navigationController pushViewController:multipleLineChartVC animated:YES];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
