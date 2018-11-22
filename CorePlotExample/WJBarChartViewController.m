//
//  WJBarChartViewController.m
//  CorePlotExample
//
//  Created by Jace on 20/03/17.
//  Copyright © 2017年 WangJace. All rights reserved.
//

#import "WJBarChartViewController.h"
#import <CorePlot.h>
#import <Masonry.h>

#define BarChartDefaultColor(a) [CPTColor colorWithComponentRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:a]

@interface WJBarChartViewController () <CPTBarPlotDelegate, CPTBarPlotDataSource>
{
    NSArray *_dataSource;
}
@property (nonatomic, strong) CPTGraphHostingView *hostingView;

@end

@implementation WJBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"柱状图";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.view addSubview:self.hostingView];

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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_hostingView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 先获取_hostingView.hostedGraph，如果为nil才去进行CPTGraph的初始化，同时进行plot和坐标轴的设置
    CPTGraph *graph = _hostingView.hostedGraph;
    if (!graph) {
        [self setPlot];
    }
    else {
        graph.frame = _hostingView.bounds;
    }
}

- (void)setPlot {
    // 设置坐标轴和刻度尺线的style
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0;
    // 设置坐标轴标题、刻度值文本的style
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.color = [CPTColor orangeColor];
    textStyle.fontSize = 20;
    // 刻度值的数据显示格式
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;

    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    // CPTGraph 主题 有：kCPTDarkGradientTheme、kCPTPlainBlackTheme、kCPTPlainWhiteTheme、kCPTSlateTheme、kCPTStocksTheme这几种，主要是设置颜色风格
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    graph.frame = _hostingView.bounds;
    // CPTGraph 的边距设置
    graph.paddingTop = 10;
    graph.paddingBottom = 10;
    graph.paddingLeft = 10;
    graph.paddingRight = 10;
    // plotAreaFrame的边距设置
    graph.plotAreaFrame.paddingTop = 30;
    graph.plotAreaFrame.paddingBottom = 50;
    graph.plotAreaFrame.paddingLeft = 50;
    graph.plotAreaFrame.paddingRight = 10;
    graph.plotAreaFrame.cornerRadius = 0;
    graph.plotAreaFrame.borderLineStyle = lineStyle;     // 边框线风格，nil表示没有设置边框
    graph.titleTextStyle = textStyle;     // 标题风格
    graph.title = @"柱状图";               // 图表标题
    _hostingView.hostedGraph = graph;

    // 设置plotSpace
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    // 设置x,y轴的显示范围     x:0~20, y:0~40
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@0 length:@20];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@0 length:@40];

    // 坐标轴
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    // x 轴：为坐标系的 x 轴
    CPTXYAxis *xOriginPoint = axisSet.xAxis;
    xOriginPoint.labelOffset = 0;     // 刻度值与坐标轴之间的偏移量
    xOriginPoint.labelFormatter = numberFormatter;     // 刻度值的数据格式
    //x 轴：线型设置
    xOriginPoint.axisLineStyle = lineStyle;
    // 长刻度线：线型设置
    xOriginPoint.majorTickLineStyle = lineStyle;
    xOriginPoint.majorTickLength = 5;          // 长刻度线的长度
    xOriginPoint.majorIntervalLength = @2;     // 长刻度线的跨度
    // 短刻度线：线型设置
    xOriginPoint.minorTickLineStyle = lineStyle;
    xOriginPoint.minorTickLength = 2.5;        // 短刻度线的长度
    xOriginPoint.minorTicksPerInterval = 1;    // 短刻度线数量
    xOriginPoint.orthogonalPosition = @0;      // 坐标轴起始值
    xOriginPoint.title = @"x 轴";              // 坐标轴名称
    //y 轴：为坐标系的 y 轴
    CPTXYAxis *yOriginPoint = axisSet.yAxis;
    yOriginPoint.labelOffset = 0;     // 刻度值与坐标轴之间的偏移量
    yOriginPoint.labelFormatter = numberFormatter;     // 刻度值的数据格式
    //y 轴：线型设置
    yOriginPoint.axisLineStyle = lineStyle;
    // 长刻度线：线型设置
    yOriginPoint.majorTickLineStyle = lineStyle;
    yOriginPoint.majorTickLength = 5;          // 长刻度线的长度
    yOriginPoint.majorIntervalLength = @5;     // 长刻度线的跨度
    // 短刻度线：线型设置
    yOriginPoint.minorTickLineStyle = lineStyle;
    yOriginPoint.minorTickLength = 2.5;        // 短刻度线的长度
    yOriginPoint.minorTicksPerInterval = 1;    // 短刻度线数量
    yOriginPoint.orthogonalPosition = @0;      // 坐标轴起始值
    yOriginPoint.title = @"y 轴";              // 坐标轴名称

    // 柱状条边框y线style
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor redColor];
    // 初始化plot，传入柱状图的主题色和柱状条的方向(是否为横向柱状条)
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:BarChartDefaultColor(1.0) horizontalBars:NO];
    barPlot.barWidth = @1;                   // 柱状图的柱宽
    barPlot.barOffset = @0.0;                // 柱状图的柱子向左偏移： 1.0
    barPlot.barCornerRadius = 2.0;           // 柱状图的柱子圆角
    barPlot.lineStyle = borderLineStyle;     // 设置柱状图柱条边框线风格
    barPlot.identifier = @"BarChart";        // 柱状图的标识
    barPlot.dataSource = self;
    barPlot.delegate = self;
    [graph addPlot:barPlot];
}

- (CPTGraphHostingView *)hostingView {
    if (!_hostingView) {
        _hostingView = [[CPTGraphHostingView alloc] init];
    }
    return _hostingView;
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
    fillGradient.angle = -90.0;     // 渐变色的方向，水平向右为0度，顺时针方向为负方向，逆时针方向为正方向
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
