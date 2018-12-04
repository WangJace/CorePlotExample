//
//  WJMultipleBarChartViewController.m
//  CorePlotExample
//
//  Created by 王傲云 on 2018/12/3.
//  Copyright © 2018 WangJace. All rights reserved.
//

#import "WJMultipleBarChartViewController.h"
#import <CorePlot.h>
#import <Masonry.h>

#define BarChart1Color(a) [CPTColor colorWithComponentRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:a]
#define BarChart2Color(a) [CPTColor colorWithComponentRed:45/255.0 green:66/255.0 blue:135/255.0 alpha:a]

@interface WJMultipleBarChartViewController ()<CPTBarPlotDelegate, CPTBarPlotDataSource>
{
    NSArray *_dataSource;
}
@property (nonatomic, strong) CPTGraphHostingView *hostingView;

@end

@implementation WJMultipleBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Mutiple Bar Chart";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.view addSubview:self.hostingView];
    
    _dataSource = @[
                    @[
                        @{ @"x" : @2, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @4, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @6, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @8, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @10, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @12, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @14, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @16, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @18, @"y" : @(arc4random()%35+5) }
                    ],
                    @[
                        @{ @"x" : @2, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @4, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @6, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @8, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @10, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @12, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @14, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @16, @"y" : @(arc4random()%35+5) },
                        @{ @"x" : @18, @"y" : @(arc4random()%35+5) }
                    ]];
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
    borderLineStyle.lineColor = BarChart1Color(1.0);
    // 初始化plot，传入柱状图的主题色和柱状条的方向(是否为横向柱状条)
    CPTBarPlot *barPlot1 = [CPTBarPlot tubularBarPlotWithColor:BarChart1Color(1.0) horizontalBars:NO];
    barPlot1.barWidth = @0.5;                 // 柱状图的柱宽
    barPlot1.barOffset = @-0.25;              // 柱状图的柱子向左偏移
    barPlot1.barCornerRadius = 2.0;           // 柱状图的柱子圆角
    barPlot1.lineStyle = borderLineStyle;     // 设置柱状图柱条边框线风格
    barPlot1.identifier = @"BarChart0";       // 柱状图的标识符
    barPlot1.dataSource = self;
    barPlot1.delegate = self;
    [graph addPlot:barPlot1];
    
    // 柱状条边框y线style
    borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = BarChart2Color(1.0);
    // 初始化plot，传入柱状图的主题色和柱状条的方向(是否为横向柱状条)
    CPTBarPlot *barPlot2 = [CPTBarPlot tubularBarPlotWithColor:BarChart2Color(1.0) horizontalBars:NO];
    barPlot2.barWidth = @0.5;                 // 柱状图的柱宽
    barPlot2.barOffset = @0.25;               // 柱状图的柱子向左偏移
    barPlot2.barCornerRadius = 2.0;           // 柱状图的柱子圆角
    barPlot2.lineStyle = borderLineStyle;     // 设置柱状图柱条边框线风格
    barPlot2.identifier = @"BarChart1";       // 柱状图的标识符
    barPlot2.dataSource = self;
    barPlot2.delegate = self;
    [graph addPlot:barPlot2];
    
    // 图例样式设置
    NSMutableArray *plots = [NSMutableArray array];
    for (int i = 0; i < graph.allPlots.count; i++) {
        CPTBarPlot *barPlot = graph.allPlots[i];
        
        CPTBarPlot *plot = [[CPTBarPlot alloc] init];
        if (i == 0) {
            plot.fill = [CPTFill fillWithColor:BarChart1Color(1.0)];
        }
        else {
            plot.fill = [CPTFill fillWithColor:BarChart2Color(1.0)];
        }
        plot.lineStyle = barPlot.lineStyle;
        plot.backgroundColor = barPlot.backgroundColor;
        plot.identifier = [NSString stringWithFormat:@"BarPlot%d", i];
        [plots addObject:plot];
    }
    // 图例初始化 只有把plots 替换为 graph.allPlots 数据源方法的设置图例名称才会生效
    CPTLegend *legend = [CPTLegend legendWithPlots:plots];
    legend.numberOfRows = plots.count;     // 图例的行数
    legend.numberOfColumns = 1;            // 图例的列数
    legend.fill = [CPTFill fillWithColor:[CPTColor clearColor]];     // 图例的背景色
    textStyle.fontSize = 18;
    textStyle.color = [CPTColor blackColor];
    legend.textStyle = textStyle;     // 设置图例的文本风格
    graph.legend = legend;            // 设置graph的图例
    graph.legendAnchor = CPTRectAnchorTopRight;     // 设置图例的位置
    graph.legendDisplacement = CGPointMake(-20, -20);     // 设置图例视图的位置
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
    NSString *plotId = (NSString *)plot.identifier;
    NSInteger idIndex = [[[plotId componentsSeparatedByString:@"BarChart"] lastObject] integerValue];
    return ((NSArray *)_dataSource[idIndex]).count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSString *plotId = (NSString *)plot.identifier;
    NSInteger idIndex = [[[plotId componentsSeparatedByString:@"BarChart"] lastObject] integerValue];
    NSDictionary *dic = _dataSource[idIndex][idx];
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
    NSString *plotId = (NSString *)barPlot.identifier;
    if ([plotId isEqualToString:@"BarChart0"]) {
        return [CPTFill fillWithColor:BarChart1Color(1.0)];
    }
    else {
        return [CPTFill fillWithColor:BarChart2Color(1.0)];
    }
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx {
    // 柱条数值标注
    NSString *plotId = (NSString *)plot.identifier;
    NSInteger idIndex = [[[plotId componentsSeparatedByString:@"BarChart"] lastObject] integerValue];
    NSDictionary *dic = _dataSource[idIndex][idx];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[[NSString alloc] initWithFormat:@"%@", dic[@"y"]]];
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.color = [CPTColor blackColor];
    textStyle.fontSize = 10;
    textStyle.textAlignment = CPTAlignmentCenter;
    textLayer.textStyle = textStyle;
    return textLayer;
}

#pragma mark - CPTBarPlotDelegate
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx
{
    NSLog(@"index = %lu", (unsigned long)idx);
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
