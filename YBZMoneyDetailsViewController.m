//
//  YBZMoneyDetailsViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/20.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMoneyDetailsViewController.h"

@interface YBZMoneyDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *weekBtn;

@property (nonatomic, strong) UIView *separateView;
@property (nonatomic, strong) UITableView *detailsTableView;


@end

@implementation YBZMoneyDetailsViewController{

    NSString *detailsType;
    NSDictionary *detailsInfo;
    NSMutableArray *infoArr;
}

- (instancetype)initWithTitle:(NSString *)title AndType:(NSString *)type AndInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.title = title;
        detailsType = type;
        detailsInfo = dict;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
     
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMainViewWithInfo:detailsInfo];
    
}


-(void)getMainViewWithInfo:(NSDictionary *)info{

    self.topView.frame = CGRectMake(0 , 64, SCREEN_WIDTH, 0.1024*SCREEN_HEIGHT);
    self.weekBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, self.topView.bounds.size.height);
    self.allBtn.frame = CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.topView.bounds.size.height);
    self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.212*SCREEN_WIDTH)/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.212*SCREEN_WIDTH, 0.0026*SCREEN_HEIGHT);
    self.detailsTableView.frame = CGRectMake(0, 64+self.topView.bounds.size.height + 0.0026*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(64+self.topView.bounds.size.height + 0.0026*SCREEN_HEIGHT));
    NSString *weekStr;
    NSString *allStr;
    if ([detailsType isEqualToString:@"bean"]) {
        weekStr = [NSString stringWithFormat:@"本周:%d豆",32];
        allStr = [NSString stringWithFormat:@"总计:%d豆",250];
    }else if ([detailsType isEqualToString:@"money"]){
        weekStr = [NSString stringWithFormat:@"本周:%d币",32];
        allStr = [NSString stringWithFormat:@"总计:%d币",250];
    }
    [self.weekBtn setTitle:weekStr forState:UIControlStateNormal];
    [self.allBtn setTitle:allStr forState:UIControlStateNormal];
    [self.topView addSubview:self.separateView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.detailsTableView];

}



#pragma mark -----delegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    [self addViewInCell:cell WithInfo:nil];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 0.0853*SCREEN_HEIGHT;
}


-(void)addViewInCell:(UITableViewCell *)cell WithInfo:(NSDictionary *)info{

    NSString *date = @"2016-11-21";
    NSString *time = @"22:05";
    NSString *moneyStr;
    if ([detailsType isEqualToString:@"bean"]) {
        moneyStr = [NSString stringWithFormat:@"%@嗨豆",@"+10"];
    }else if ([detailsType isEqualToString:@"money"]){
        moneyStr = [NSString stringWithFormat:@"%@嗨币",@"+10"];
    }
    NSString *getWayStr = @"口语即时";
    UILabel *dateLabel = [self getLabelWithStr:date color:[UIColor blackColor] position:@"left" AndY:0.017*SCREEN_HEIGHT font:0.0455*SCREEN_WIDTH];
    UILabel *timeLabel = [self getLabelWithStr:time color:[UIColor grayColor] position:@"left" AndY:0.091*SCREEN_WIDTH font:0.0303*SCREEN_WIDTH];
    UILabel *moneyLabel = [self getLabelWithStr:moneyStr color:[UIColor blackColor] position:@"right" AndY:0.017*SCREEN_HEIGHT font:0.0455*SCREEN_WIDTH];
    UILabel *getWayLabel = [self getLabelWithStr:getWayStr color:[UIColor grayColor] position:@"right" AndY:0.091*SCREEN_WIDTH font:0.0303*SCREEN_WIDTH];
    [cell addSubview:dateLabel];
    [cell addSubview:timeLabel];
    [cell addSubview:moneyLabel];
    [cell addSubview:getWayLabel];
    
}

-(UILabel *)getLabelWithStr:(NSString *)string color:(UIColor*)color position:(NSString *)position AndY:(CGFloat)Y font:(CGFloat)font{

    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0.061*SCREEN_WIDTH, Y, SCREEN_WIDTH-2*0.061*SCREEN_WIDTH, font);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = string;
    label.font = [UIFont systemFontOfSize:font];
    if ([position isEqualToString:@"left"]) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if ([position isEqualToString:@"right"]){
        label.textAlignment = NSTextAlignmentRight;
    }
    
    return label;
    
}



#pragma mark -----onclick-----

-(void)weekBtnClick:(UIButton *)sender{
    
    sender.selected = YES;
    self.allBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.212*SCREEN_WIDTH)/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.212*SCREEN_WIDTH, 0.0026*SCREEN_HEIGHT);
    }];
    
}

-(void)allBtnClick:(UIButton *)sender{
    
    sender.selected = YES;
    self.weekBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.212*SCREEN_WIDTH)/2+SCREEN_WIDTH/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.212*SCREEN_WIDTH, 0.0026*SCREEN_HEIGHT);
    }];
}

#pragma mark -----getters-----

-(UIView *)topView{
    
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:self.weekBtn];
        [_topView addSubview:self.allBtn];
    }
    return  _topView;
}

-(UIButton *)weekBtn{
    
    if (!_weekBtn) {
        _weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weekBtn addTarget:self action:@selector(weekBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_weekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_weekBtn setTitleColor:UIColorFromRGB(0xFED802) forState:UIControlStateSelected];
        _weekBtn.selected = YES;
    }
    return _weekBtn;
}

-(UIButton *)allBtn{
    
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allBtn setTitleColor:UIColorFromRGB(0xFED802) forState:UIControlStateSelected];
    }
    return _allBtn;
}

-(UIView *)separateView{
    
    if (!_separateView) {
        _separateView = [[UIView alloc]init];
        _separateView.backgroundColor = UIColorFromRGB(0xFED802);
    }
    return _separateView;
}


-(UITableView *)detailsTableView{
        
        if (!_detailsTableView) {
            _detailsTableView = [[UITableView alloc]init];
            _detailsTableView.backgroundColor = [UIColor whiteColor];
            _detailsTableView.allowsSelection = NO;
            _detailsTableView.dataSource=self;
            _detailsTableView.delegate=self;
            _detailsTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
            
        }
        return _detailsTableView;
 
}



@end
