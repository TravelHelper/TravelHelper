//
//  YBZMyOrderViewController.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/2.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMyOrderViewController.h"
#import "YBZMyOrderTableViewCell.h"
#import "YBZMyOrderModel.h"
#import "YBZOrderDetailsViewController.h"
#define TABBAR_TITLE_FONT [UIFont systemFontOfSize:18.f]
#define NAV_TAB_BAR_HEIGHT 50
#define NAV_TAB_BAR_Width  SCREEN_WIDTH
@interface YBZMyOrderViewController ()<UIScrollViewDelegate>
//滚动视图
@property(strong,nonatomic)UIScrollView *myScrollView;
//滚动下划线
@property(strong,nonatomic)UIView *line;
//所有的Button集合
@property(nonatomic,strong)NSMutableArray  *items;
//所有的Button的宽度集合
@property(nonatomic,copy)NSArray *itemsWidth;
//被选中前面的宽度合（用于计算是否进行超过一屏，没有一屏则进行平分）
@property(nonatomic,assign)CGFloat selectedTitlesWidth;

@property (nonatomic,strong) UITableView *myordertableview;
@property (nonatomic,strong) NSMutableArray *myorderarr;

@end

@implementation YBZMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self loaddatefromweb];
    //初始化数组
    if (!self.myTitleArray) {
        self.myTitleArray=@[@"全部",@"口语即时",@"悬赏交易",@"定制翻译"];
    }
    
    self.items=[[NSMutableArray alloc]init];
    self.itemsWidth=[[NSArray alloc]init];
    
    //初始化滚动
    if (!self.myScrollView) {
        self.myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, NAV_TAB_BAR_Width, NAV_TAB_BAR_HEIGHT)];
        self.myScrollView.backgroundColor=[UIColor whiteColor];
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.myScrollView];
    }
    
    //赋值跟计算滚动
    _itemsWidth = [self getButtonsWidthWithTitles:self.myTitleArray];
    CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
    self.myScrollView.contentSize = CGSizeMake(contentWidth, 0);
    self.currentIndex=0;
    [self.view addSubview:self.myordertableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.myordertableview.frame = CGRectMake(0, 64+NAV_TAB_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-(64+NAV_TAB_BAR_HEIGHT));
}
//网络调用
-(void)loaddatefromweb
{
    self.myorderarr = [NSMutableArray array];
    YBZMyOrderModel *order1 = [[YBZMyOrderModel alloc] init];
    order1.infostr = @"口语即时交易";
    order1.completestr = @"已完成";
    order1.timestr = @"2016/07/03  12:30";
    [self.myorderarr addObject:order1];
    
    YBZMyOrderModel *order2 = [[YBZMyOrderModel alloc] init];
    order2.infostr = @"发布悬赏交易";
    order2.completestr = @"已完成";
    order2.timestr = @"2016/08/12  12:10";
    [self.myorderarr addObject:order2];
    
    
    YBZMyOrderModel *order3 = [[YBZMyOrderModel alloc] init];
    order3.infostr = @"定制翻译交易";
    order3.completestr = @"已完成";
    order3.timestr = @"2016/08/12  15:10";
    [self.myorderarr addObject:order3];
}

-(UITableView *)myordertableview
{
    if(!_myordertableview)
    {
        _myordertableview = [[UITableView alloc] init];
        _myordertableview.delegate = self;
        _myordertableview.dataSource = self;
        //_myordertableview.backgroundColor = [UIColor orangeColor];
    }
    return _myordertableview;
}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    _selectedTitlesWidth = 0;
    for (NSString *title in titles)
    {
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : TABBAR_TITLE_FONT} context:nil].size;
        CGFloat eachButtonWidth = size.width + 20.f;
        _selectedTitlesWidth += eachButtonWidth;
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
    }
    if (_selectedTitlesWidth < NAV_TAB_BAR_Width) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:NAV_TAB_BAR_Width / titles.count];
        for (int index = 0; index < titles.count; index++) {
            [widths addObject:width];
        }
    }
    return widths;
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    for (NSInteger index = 0; index < widths.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, [widths[index] floatValue], NAV_TAB_BAR_HEIGHT);
        button.titleLabel.font = TABBAR_TITLE_FONT;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:self.myTitleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:button];
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
    }
    
    if (widths.count) {
        [self showLineWithButtonWidth:[widths[0] floatValue]];
    }
    return buttonX;
}


- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    UIButton *button = nil;
    button = _items[currentIndex];
    [button setTitleColor:UIColorFromRGB(0xffd703) forState:UIControlStateNormal];
    CGFloat offsetX = button.center.x - NAV_TAB_BAR_Width * 0.5;
    CGFloat offsetMax = _selectedTitlesWidth - NAV_TAB_BAR_Width;
    if (offsetX < 0 || offsetMax < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    [self.myScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    [UIView animateWithDuration:.2f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentIndex] floatValue] - 4.0f, _line.frame.size.height);
    }];
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, NAV_TAB_BAR_HEIGHT - 3.0f, width - 4.0f, 3.0f)];
    _line.backgroundColor = [UIColor yellowColor];
    [self.myScrollView addSubview:_line];
}

- (void)cleanData
{
    [_items removeAllObjects];
    [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    self.currentIndex=index;
    
    if ([self.delegate respondsToSelector:@selector(itemDidSelectedWithIndex:)]) {
        [self.delegate itemDidSelectedWithIndex:index];
    }
    
    //修改选中跟没选中的Button字体颜色
    for (int i=0; i<_items.count; i++) {
        if (i==index) {
            [button setTitleColor:UIColorFromRGB(0xffd703) forState:UIControlStateNormal];
        }
        else
        {
            [_items[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    if (index==0) {
        NSLog(@"全部");
        
    }
    if (index==1) {
        NSLog(@"口语即时");
        
    }
    if (index==2) {
        NSLog(@"悬赏交易");
        
    }
    if (index==3) {
        NSLog(@"定制翻译");
        
    }
    if (index==4) {
        NSLog(@"自由行");
        
    }
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
    }];
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myorderarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kcellname = @"name1";
    YBZMyOrderTableViewCell *cell =(YBZMyOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kcellname];
        cell = [[YBZMyOrderTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:kcellname];
        
        [cell setCellDate:self.myorderarr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YBZOrderDetailsViewController *orderdetailsVC = [[YBZOrderDetailsViewController alloc] init];
    [self.navigationController pushViewController:orderdetailsVC animated:YES];
}
@end
