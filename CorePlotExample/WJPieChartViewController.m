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
    NSArray *_types;
    NSArray *_colors;
}
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostingView;

@end

@implementation WJPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"饼状图";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    _dataSource = @[@0.32, @0.25, @0.40, @0.13];
    _types = @[@"学习", @"娱乐", @"工作", @"运动"];
    _colors = @[[UIColor orangeColor], [UIColor greenColor], [UIColor yellowColor], [UIColor purpleColor]];
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
    _hostingView.allowPinchScaling = NO;

    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 1.0;
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.color = [CPTColor orangeColor];
    textStyle.fontName = @"HelveticaNeue-Bold";
    textStyle.fontSize = 20;
    textStyle.textAlignment = CPTTextAlignmentCenter;

    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:_hostingView.bounds];
    _hostingView.hostedGraph = graph;
    // CPTGraph 四边不留白
    graph.paddingLeft = 0.0;
    graph.paddingTop = 0.0;
    graph.paddingRight = 0.0;
    graph.paddingBottom = 0.0;
    graph.axisSet = nil;

    graph.titleTextStyle = textStyle;     // 标题风格
    graph.title = @"饼状图";               // 标题
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;     // 标题位置
    
    // 饼状图
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.delegate = self;
    pieChart.dataSource = self;
    // 设置饼状图的半径
    pieChart.pieRadius = MIN(CGRectGetWidth(_hostingView.bounds), CGRectGetHeight(_hostingView.bounds))*0.7/2.0;
    pieChart.identifier = graph.title;
    // 饼状图开始的角度
    pieChart.startAngle = M_PI_4;
    // 饼状图的起始方向（顺时间方向／逆时间方向）
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.labelOffset = -0.6 * pieChart.pieRadius;
    // 边框样式
    pieChart.borderLineStyle = lineStyle;
    textStyle.fontSize = 15;
    textStyle.color = [CPTColor whiteColor];
    pieChart.labelTextStyle = textStyle;
    // 渐变色设置
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    [_hostingView.hostedGraph addPlot:pieChart];
    
    // 标注图
    CPTLegend *legend = [[CPTLegend alloc] initWithGraph:graph];
    legend.numberOfColumns = 1;
    legend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    textStyle.fontSize = 18;
    textStyle.color = [CPTColor blackColor];
    legend.textStyle = textStyle;
    graph.legend = legend;
    if (CGRectGetHeight(self.view.bounds) < CGRectGetWidth(self.view.bounds)) {
        graph.legendAnchor = CPTRectAnchorRight;
        graph.legendDisplacement = CGPointMake(-20, 0);
    }
    else {
        graph.legendAnchor = CPTRectAnchorBottomRight;
        graph.legendDisplacement = CGPointMake(-8, 8);
    }
}

#pragma mark - CPTPieChartDataSource
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _dataSource.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    return _dataSource[idx];
}

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    UIColor *color = _colors[idx];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:color.CGColor]];
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    CGFloat value = [_dataSource[idx] floatValue]*100;
    CPTTextLayer *layer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d%%", (int)value]];
    layer.textStyle = plot.labelTextStyle;
    return layer;
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    return _types[idx];
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
