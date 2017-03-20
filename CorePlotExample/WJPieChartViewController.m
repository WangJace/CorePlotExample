//
//  WJPieChartViewController.m
//  CorePlotExample
//
//  Created by Jace on 20/03/17.
//  Copyright © 2017年 WangJace. All rights reserved.
//

#import "WJPieChartViewController.h"
#import <CorePlot.h>

@interface WJPieChartViewController () <CPTPieChartDelegate, CPTPieChartDataSource>
{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostingView;

@end

@implementation WJPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"饼状图";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    _dataSource = @[
                    @{@"value":@"0.32", @"type":@"学习", @"color":[UIColor orangeColor]},
                    @{@"value":@"0.25", @"type":@"娱乐", @"color":[UIColor greenColor]},
                    @{@"value":@"0.40", @"type":@"工作", @"color":[UIColor yellowColor]},
                    @{@"value":@"0.13", @"type":@"运动", @"color":[UIColor lightGrayColor]},
                    ];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CPTGraph *graph = _hostingView.hostedGraph;
    if (!graph) {
        [self setPlot];
    }
    else {
        graph.frame = _hostingView.bounds;
    }
}

- (void)setPlot {
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor purpleColor];
    lineStyle.lineWidth = 1.0;
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.color = [CPTColor orangeColor];
    textStyle.fontSize = 20;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    // CPGraph 主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.frame = _hostingView.bounds;
    graph.axisSet = nil;
    // CPGraph 四边不留白
    graph.paddingTop = 5;
    graph.paddingBottom = 5;
    graph.paddingLeft = 10;
    graph.paddingRight = 10;
    graph.titleTextStyle = textStyle;     // 标题风格
    graph.title = @"饼状图";               // 标题
    _hostingView.hostedGraph = graph;
    
    // 饼状图
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.identifier = @"PieChart";
//    pieChart.delegate = self;
    pieChart.dataSource = self;
    // 设置饼状图的半径
    pieChart.cornerRadius = 20;
    // 饼状图的中心
    pieChart.centerAnchor = _hostingView.center;
    // 饼状图开始的角度
    pieChart.startAngle = M_PI_4;
    // 饼状图的起始方向（顺时间方向／逆时间方向）
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 边框样式
    pieChart.borderLineStyle = lineStyle;
    pieChart.labelOffset = 10;
    [graph addPlot:pieChart];
    
    // 标注图
    CPTLegend *legend = [[CPTLegend alloc] init];
    legend.numberOfColumns = 1;
    [legend setFill:[CPTFill fillWithColor:[CPTColor whiteColor]]];
    legend.delegate = self;
    graph.legend = legend;
}

#pragma mark - CPTPieChartDataSource
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _dataSource.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSDictionary *dic = _dataSource[idx];
    NSNumber *value = dic[@"value"];
    return value;
}

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    NSDictionary *dic = _dataSource[idx];
    UIColor *color = dic[@"color"];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:color.CGColor]];
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    NSDictionary *dic = _dataSource[idx];
    NSNumber *value = dic[@"value"];
    CPTTextLayer *layer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d", (int)[value doubleValue]*100]];
    layer.textStyle = plot.labelTextStyle;
    return layer;
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    NSDictionary *dic = _dataSource[idx];
    NSNumber *type = dic[@"type"];
    return [type stringValue];
}

#pragma mark - CPTPieChartDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
