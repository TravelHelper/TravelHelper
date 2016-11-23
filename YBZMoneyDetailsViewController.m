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
    NSMutableArray *detailsInfo;
    NSMutableArray *todayInfoArr;
    NSMutableArray *infoArr;
    int plusMoney;
    int plusMoneyAll;
    NSString *inoutType;
    NSMutableArray *middleArr;

}

- (instancetype)initWithTitle:(NSString *)title AndType:(NSString *)type AndInfo:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        self.title = title;
        detailsType = type;
        detailsInfo = array;
        todayInfoArr = [NSMutableArray array];
        middleArr = [NSMutableArray array];
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
        infoArr = [NSMutableArray array];
        [self getNeedDataWithArray:array];
     
        
        
    }
    return self;
}


-(void)getNeedDataWithArray:(NSMutableArray *)array{

    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    for (int i=0; i<array.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [infoArr addObject:dict];
    }
    if ([detailsType isEqualToString:@"bean"]) {
        if (array.count != 0) {
            for (int i=0; i<array.count; i++) {
                [infoArr[i] setObject:array[i][@"money_deal_source_name"] forKey:@"name"];
                [infoArr[i] setObject:array[i][@"bean_deal_money"] forKey:@"money"];
                NSArray *strarr = [array[i][@"bean_deal_time"]  componentsSeparatedByString:@" "];
                [infoArr[i] setObject:strarr[0] forKey:@"date"];

                plusMoneyAll = plusMoneyAll +[infoArr[i][@"money"]intValue];

                [infoArr[i] setObject:strarr[1] forKey:@"time"];
                inoutType = array[i][@"bean_deal_type"];
                if ([infoArr[i][@"date"] isEqualToString:locationString]) {
                    plusMoney = plusMoney + [infoArr[i][@"money"]intValue];
                    [todayInfoArr addObject:infoArr[i]];
                }

            }
        }
    }else if([detailsType isEqualToString:@"money"]){
        if (array.count != 0) {
            for (int i=0; i<array.count ; i++) {
                [infoArr[i] setObject:array[i][@"money_deal_source_name"] forKey:@"name"];
                [infoArr[i] setObject:array[i][@"money_deal_money"] forKey:@"money"];
                
                NSArray *strarr = [array[i][@"money_deal_time"]  componentsSeparatedByString:@" "];
                [infoArr[i] setObject:strarr[0] forKey:@"date"];
                [infoArr[i] setObject:strarr[1] forKey:@"time"];
                plusMoneyAll = plusMoneyAll +[infoArr[i][@"money"]intValue];
                inoutType = array[i][@"money_deal_type"];
                if ([infoArr[i][@"date"] isEqualToString:locationString]) {
                    plusMoney = plusMoney + [infoArr[i][@"money"]intValue];
                    [todayInfoArr addObject:infoArr];
                }
            }

        }
    }
    middleArr = todayInfoArr;
    [self getMainViewWithInfo:detailsInfo];

    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)getMainViewWithInfo:(NSMutableArray *)info{

    self.topView.frame = CGRectMake(0 , 64, SCREEN_WIDTH, 0.1024*SCREEN_HEIGHT);
    self.weekBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, self.topView.bounds.size.height);
    self.allBtn.frame = CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.topView.bounds.size.height);
    self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.212*SCREEN_WIDTH)/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.212*SCREEN_WIDTH, 0.0026*SCREEN_HEIGHT);
    self.detailsTableView.frame = CGRectMake(0, 64+self.topView.bounds.size.height + 0.0026*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(64+self.topView.bounds.size.height + 0.0026*SCREEN_HEIGHT));
    NSString *weekStr;
    NSString *allStr;
    if ([detailsType isEqualToString:@"bean"]) {
        weekStr = [NSString stringWithFormat:@"今日:%d豆",plusMoney];
        allStr = [NSString stringWithFormat:@"总计:%d豆",plusMoneyAll];
    }else if ([detailsType isEqualToString:@"money"]){
        weekStr = [NSString stringWithFormat:@"今日:%d币",plusMoney];
        allStr = [NSString stringWithFormat:@"总计:%d币",plusMoneyAll];
    }
    [self.weekBtn setTitle:weekStr forState:UIControlStateNormal];
    [self.allBtn setTitle:allStr forState:UIControlStateNormal];
    [self.topView addSubview:self.separateView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.detailsTableView];

}



#pragma mark -----delegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return middleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    [self addViewInCell:cell WithInfo:middleArr[indexPath.row]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 0.0853*SCREEN_HEIGHT;
}


-(void)addViewInCell:(UITableViewCell *)cell WithInfo:(NSDictionary *)info{

    NSString *date = info[@"date"];
    NSString *time = info[@"time"];
    
    NSString *moneyStr;
    if ([detailsType isEqualToString:@"bean"]) {
        if ([inoutType isEqualToString:@"in"]) {
            moneyStr = [NSString stringWithFormat:@"+%@嗨豆",info[@"money"]];
        }else{
            moneyStr = [NSString stringWithFormat:@"-%@嗨豆",info[@"money"]];
        }
//        moneyStr = [NSString stringWithFormat:@"%@嗨豆",@"+10"];
    }else if ([detailsType isEqualToString:@"money"]){
        if ([inoutType isEqualToString:@"in"]) {
            moneyStr = [NSString stringWithFormat:@"+%@嗨币",info[@"money"]];
        }else{
            moneyStr = [NSString stringWithFormat:@"-%@嗨币",info[@"money"]];
        }    }
    NSString *getWayStr = info[@"name"];
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
    middleArr = todayInfoArr;
    [self.detailsTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.212*SCREEN_WIDTH)/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.212*SCREEN_WIDTH, 0.0026*SCREEN_HEIGHT);
    }];
    
}

-(void)allBtnClick:(UIButton *)sender{
    
    sender.selected = YES;
    self.weekBtn.selected = NO;
    middleArr = infoArr;
    [self.detailsTableView reloadData];
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
