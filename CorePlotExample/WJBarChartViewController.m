//
//  WJBarChartViewController.m
//  CorePlotExample
//
//  Created by Jace on 20/03/17.
//  Copyright © 2017年 WangJace. All rights reserved.
//

#import "WJBarChartViewController.h"
#import <CorePlot.h>

#define BarChartDefaultColor(a) [CPTColor colorWithComponentRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:a]

@interface WJBarChartViewController () <CPTBarPlotDelegate, CPTBarPlotDataSource>
{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostingView;

@end

@implementation WJBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"柱状图";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    _dataSource = @[
                    @{ @"x" : @2, @"y" : @22 },
                    @{ @"x" : @4, @"y" : @15 },
                    @{ @"x" : @6, @"y" : @12 },
                    @{ @"x" : @8, @"y" : @7 },
                    @{ @"x" : @10, @"y" : @16 },
                    @{ @"x" : @12, @"y" : @26 },
                    @{ @"x" : @14, @"y" : @36 },
                    @{ @"x" : @16, @"y" : @30 },
                    @{ @"x" : @18, @"y" : @19 }
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
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0;
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.color = [CPTColor orangeColor];
    textStyle.fontSize = 20;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;

    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    // CPGraph 主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.frame = _hostingView.bounds;
    // CPGraph 四边不留白
    graph.paddingTop = 0;
    graph.paddingBottom = 0;
    graph.paddingLeft = 0;
    graph.paddingRight = 0;
    // 绘图区 4 边留白
    graph.plotAreaFrame.paddingTop = 30;
    graph.plotAreaFrame.paddingBottom = 50;
    graph.plotAreaFrame.paddingLeft = 50;
    graph.plotAreaFrame.paddingRight = 10;
    graph.plotAreaFrame.cornerRadius = 0;
    graph.plotAreaFrame.borderLineStyle = nil;     // 边框线风格，nil表示没有设置边框
    graph.titleTextStyle = textStyle;     // 标题风格
    graph.title = @"柱状图";               // 标题
    _hostingView.hostedGraph = graph;

    // 画图空间 plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    // 画图空间x,y轴的范围     x:0~20, y:0~40
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@0 length:@20];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@0 length:@40];

    // 坐标系
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    //x 轴：为坐标系的 x 轴
    CPTXYAxis *xOriginPoint = axisSet.xAxis;
    xOriginPoint.labelOffset = 0;
    xOriginPoint.labelFormatter = numberFormatter;
    //x 轴：线型设置
    xOriginPoint.axisLineStyle = lineStyle;
    // 长刻度线：线型设置
    xOriginPoint.majorTickLineStyle = lineStyle;
    xOriginPoint.majorTickLength = 5;          // 刻度线的长度
    xOriginPoint.majorIntervalLength = @2;     // 刻度线的跨度
    // 短刻度线：线型设置
    xOriginPoint.minorTickLineStyle = lineStyle;
    xOriginPoint.minorTickLength = 2.5;       // 刻度线的长度
    // 起始值
    xOriginPoint.orthogonalPosition = @0;
    // 坐标轴名称
    xOriginPoint.title = @"x 轴";
    //y 轴：为坐标系的 y 轴
    CPTXYAxis *yOriginPoint = axisSet.yAxis;
    yOriginPoint.labelOffset = 0;
    yOriginPoint.labelFormatter = numberFormatter;
    //y 轴：线型设置
    yOriginPoint.axisLineStyle = lineStyle;
    // 长刻度线：线型设置
    yOriginPoint.majorTickLineStyle = lineStyle;
    yOriginPoint.majorTickLength = 5;          // 刻度线的长度
    yOriginPoint.majorIntervalLength = @5;     // 刻度线的跨度
    // 短刻度线：线型设置
    yOriginPoint.minorTickLineStyle = lineStyle;
    yOriginPoint.minorTickLength = 2.5;        // 刻度线的长度
    // 起始值
    yOriginPoint.orthogonalPosition = @0;
    // 坐标轴名称
    yOriginPoint.title  = @"y 轴";

    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = BarChartDefaultColor(1.0);
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:BarChartDefaultColor(1.0) horizontalBars:NO];
    // 柱状图的驻宽
    barPlot.barWidth = @1;
    // 柱状图的柱子向左偏移： 1.0
    barPlot.barOffset = @0.0;
    // 柱状图的柱子圆角
    barPlot.barCornerRadius = 2.0;
    barPlot.lineStyle = borderLineStyle;
    // 柱状图的标识
    barPlot.identifier = @"BarChart";
    barPlot.dataSource = self;
    barPlot.delegate = self;
    [graph addPlot:barPlot];
}

#pragma mark - CPTBarPlotDataSource
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _dataSource.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSDictionary *dic = _dataSource[idx];
    NSNumber *num = nil;
    switch (fieldEnum) {
        case CPTBarPlotFieldBarLocation:
        {
            // x轴
            num = dic[@"x"];
        }
            break;
        case CPTBarPlotFieldBarTip:
        {
            // y轴
            num = dic[@"y"];
        }
            break;
        default:
            break;
    }
    return num;
}

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx
{
    // 渐变色
    CPTGradient *fillGradient = [CPTGradient gradientWithBeginningColor:BarChartDefaultColor(0.8) endingColor:BarChartDefaultColor(0.2)];
    fillGradient.angle = -90.0;
    return [CPTFill fillWithGradient:fillGradient];
}

#pragma mark - CPTBarPlotDelegate
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx
{
    NSLog(@"index = %lu", (unsigned long)idx);
}

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
