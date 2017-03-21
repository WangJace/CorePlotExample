//
//  WJH o meViewController.m
//  CorePlotExample
//
//  Created by 王傲云 on 16/7/9.
//  Copyright © 2016年 WangJace. All rights reserved.
//

#import "WJHomeViewController.h"
#import "WJBarChartViewController.h"
#import "WJLineChartViewController.h"
#import "WJPieChartViewController.h"

@interface WJHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataSource = @[@"柱形图", @"折线图", @"饼状图"];
    _myTableView.tableFooterView = [[UIView alloc] init];
    [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            // 柱状图
            WJBarChartViewController *barChartVC = [[WJBarChartViewController alloc] init];
            [self.navigationController pushViewController:barChartVC animated:YES];
        }
            break;
        case 1:
        {
            // 折线图
            WJLineChartViewController *lineChartVC = [[WJLineChartViewController alloc] init];
            [self.navigationController pushViewController:lineChartVC animated:YES];
        }
            break;
        case 2:
        {
            // 饼状图
            WJPieChartViewController *pieChartVC = [[WJPieChartViewController alloc] init];
            [self.navigationController pushViewController:pieChartVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
