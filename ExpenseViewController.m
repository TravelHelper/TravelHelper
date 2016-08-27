//
//  ExpenseViewController.m
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "ExpenseViewController.h"
#import "Information.h"
#import "CellInformation.h"
#import "InformationTableViewCell.h"

#define kScreenWindth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
@interface ExpenseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *mainTableView;
@property (nonatomic , strong) NSArray *dataArray;
@end
@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDateFromWeb];
    [self initLeftButton];
    
    UIImage *goldImg = [UIImage imageNamed:@"gold"];
    self.view.backgroundColor = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1];;
    self.title = @"游币支出";
    
    //当天收入
    UILabel *todayExpenseLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kScreenWindth/2-1, 0.14*kScreenHeight)];
    todayExpenseLable.backgroundColor =[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    
    UILabel *todayText = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+10, kScreenWindth/2, 25)];
    todayText.text = @"当天支出";
    todayText.textAlignment = NSTextAlignmentCenter;
    
    UILabel *todayMoneyLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWindth/4-20, 64+10+25+10, 20, 20)];
    NSString *todayMoneyText = @"3";
    NSMutableAttributedString *todayMoneystr = [[NSMutableAttributedString alloc] initWithString:todayMoneyText];
    [todayMoneystr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,todayMoneyText.length)];
    [todayMoneyLable setAttributedText:todayMoneystr] ;

    
    UIImageView *todayMoneyImg = [[UIImageView alloc]initWithImage:goldImg];
    todayMoneyImg.frame =CGRectMake(kScreenWindth/4+5, 64+10+25+10, 20, 20);
    
    [self.view addSubview:todayExpenseLable];
    [self.view addSubview:todayText];
    [self.view addSubview:todayMoneyLable];
    [self.view addSubview:todayMoneyImg];
    
    //总计收入
    UILabel *allIncomeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWindth/2, 64, kScreenWindth/2, 0.14*kScreenHeight)];
    allIncomeLable.backgroundColor =[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    
    UILabel *allText = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWindth/2, 64+10, kScreenWindth/2, 25)];
    allText.text = @"总计支出";
    allText.textAlignment = NSTextAlignmentCenter;
    
    UILabel *allMoneyLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWindth/2+kScreenWindth/4-45, 64+10+25+10, 50, 20)];
    NSString *allMoneyText = @"5000";
    NSMutableAttributedString *allMoneystr = [[NSMutableAttributedString alloc] initWithString:allMoneyText];
    [allMoneystr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,allMoneyText.length)];
    [allMoneyLable setAttributedText:allMoneystr] ;
    
    UIImageView *allMoneyImg = [[UIImageView alloc]initWithImage:goldImg];
    allMoneyImg.frame =CGRectMake(kScreenWindth/2+kScreenWindth/4+15, 64+10+25+10, 20, 20);
    
    [self.view addSubview:allIncomeLable];
    [self.view addSubview:allText];
    [self.view addSubview:allMoneyLable];
    [self.view addSubview:allMoneyImg];
    
    //表示图
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+1+0.14*kScreenHeight, kScreenWindth, kScreenHeight)];
    self.mainTableView.sectionHeaderHeight = 10;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
}


#pragma mark - 返回箭头
-(void)initLeftButton
{
    //左上角的按钮
    UIButton *boultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [boultButton setImage:[UIImage imageNamed:@"boult"] forState:UIControlStateNormal];
    [boultButton addTarget:self action:@selector(interpretClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:boultButton];
}

#pragma mark - 页面跳转
- (void)interpretClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据源
-(void)loadDateFromWeb
{
    //系统时间
    NSDate *sendDate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *morelocationString = [dateformatter stringFromDate:sendDate];
    
    Information *infomation1 = [[Information alloc] initWitTitleText:@"每日任务：移动端签到" time:morelocationString youBi:@"+3"];
    Information *infomation2 = [[Information alloc] initWitTitleText:@"每日任务：分享到微信朋友圈或QQ空间" time:morelocationString youBi:@"+5"];
    Information *infomation3 = [[Information alloc] initWitTitleText:@"每日任务：移动端签到" time:morelocationString youBi:@"+3"];
    Information *infomation4 = [[Information alloc] initWitTitleText:@"每日任务：分享到微信朋友圈或QQ空间" time:morelocationString youBi:@"+5"];
    
    self.dataArray = @[infomation1,infomation2,infomation3,infomation4];
    
}

#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InformationTableViewCell";
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"InformationTableViewCell" owner:nil options:nil].lastObject;
        
        Information *information = self.dataArray[indexPath.section];
        
        CellInformation *cellInformation = [[CellInformation alloc] initWithInformation:information];
        [cell setCellData:information CellInformation:cellInformation];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
}


#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Information *information = self.dataArray[indexPath.row];
    CellInformation *cellInformation =[[CellInformation alloc] initWithInformation:information];
    return cellInformation.cellHeight;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

#pragma mark - 尾部
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
@end
