//
//  MeMoneyViewController.m
//  Moneybag
//
//  Created by sks on 16/8/2.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "MeMoneyViewController.h"
#import "YBZBaseViewController.h"
#import "ExchangeViewController.h"
#import "IncomeViewController.h"
#import "ExpenseViewController.h"
#define kScreenWindth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface MeMoneyViewController ()

@end

@implementation MeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftButton];
    
    UIImage *goldImg = [UIImage imageNamed:@"gold"];
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1];
    self.title = @"我的游币";
    
    UILabel *myYouBi = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+0.018*kScreenHeight,self.view.bounds.size.width, 0.111*kScreenHeight)];
    myYouBi.backgroundColor = [UIColor whiteColor];
    
    UIImageView *moneyImg = [[UIImageView alloc]initWithImage:goldImg];
    moneyImg.frame =CGRectMake(0.04*kScreenWindth, 64+0.058*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth);
    
    UILabel *myYouBiLable = [[UILabel alloc] initWithFrame:CGRectMake(0.13*kScreenWindth, 64+0.0565*kScreenHeight,0.23*kScreenWindth, 0.037*kScreenHeight)];
    myYouBiLable.text = @"我的游币 :";
    
    NSString *moneyText = @"325";
    CGSize size = [moneyText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    UILabel *moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0.35*kScreenWindth, 64+0.05655*kScreenHeight,size.width, size.height)];
    NSMutableAttributedString *moneystr = [[NSMutableAttributedString alloc] initWithString:moneyText];
    [moneystr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,moneyText.length)];
    [moneyLable setAttributedText:moneystr] ;
    
    UIButton *youBiRechargeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWindth*0.7, 64+0.05*kScreenHeight, 0.23*kScreenWindth, 0.056*kScreenHeight)];
    
    [youBiRechargeButton.layer setBorderWidth:3.0];
    youBiRechargeButton.layer.borderColor=[UIColor redColor].CGColor;
    
    [youBiRechargeButton setTitle:@"游币充值" forState:UIControlStateNormal];
    [youBiRechargeButton setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [youBiRechargeButton addTarget:self action:@selector(youBiRechargeClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:myYouBi];
    [self.view addSubview:moneyImg];
    [self.view addSubview:myYouBiLable];
    [self.view addSubview:moneyLable];
    [self.view addSubview:youBiRechargeButton];
    
    //兑换券
    UIButton *exchangeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64+0.15*kScreenHeight, self.view.bounds.size.width, 0.062*kScreenHeight)];
    exchangeButton.backgroundColor = [UIColor whiteColor];
    [exchangeButton addTarget:self action:@selector(exchangeClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *exchangeImg = [[UILabel alloc]initWithFrame:CGRectMake(0.04*kScreenWindth, 64+0.17*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    exchangeImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *exchangeLable = [[UILabel alloc]initWithFrame:CGRectMake(0.13*kScreenWindth, 64+0.163*kScreenHeight, 0.14*kScreenWindth, 0.037*kScreenHeight)];
    exchangeLable.text = @"兑换券";
    
    UILabel *exchangeNumber = [[UILabel alloc]initWithFrame:CGRectMake(0.88*kScreenWindth, 64+0.17*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    exchangeNumber.text = @"1";
    
    UILabel *exchangeBoultImg = [[UILabel alloc] initWithFrame:CGRectMake(0.93*kScreenWindth, 64+0.17*kScreenHeight, 0.05*kScreenWindth,0.05*kScreenWindth )];
    exchangeBoultImg.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:exchangeButton];
    [self.view addSubview:exchangeImg];
    [self.view addSubview:exchangeLable];
    [self.view addSubview:exchangeNumber];
    [self.view addSubview:exchangeBoultImg];
    
    //游币收入
    UIButton *youBiIncomeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64+0.22*kScreenHeight, self.view.bounds.size.width, 0.062*kScreenHeight)];
    youBiIncomeButton.backgroundColor = [UIColor whiteColor];
    [youBiIncomeButton addTarget:self action:@selector(youBiIncomeClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *youBiIncomeImg = [[UILabel alloc]initWithFrame:CGRectMake(0.04*kScreenWindth, 64+0.24*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    youBiIncomeImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *youBiIncomeLable = [[UILabel alloc]initWithFrame:CGRectMake(0.13*kScreenWindth, 64+0.235*kScreenHeight, 0.2*kScreenWindth, 0.037*kScreenHeight)];
    youBiIncomeLable.text = @"游币收入";
    
    UILabel *youBiIncomeNumber = [[UILabel alloc]initWithFrame:CGRectMake(0.88*kScreenWindth, 64+0.24*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    youBiIncomeNumber.text = @"1";
    
    UILabel *youBiIncomeBoultImg = [[UILabel alloc] initWithFrame:CGRectMake(0.93*kScreenWindth, 64+0.24*kScreenHeight, 0.05*kScreenWindth,0.05*kScreenWindth )];
    youBiIncomeBoultImg.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:youBiIncomeButton];
    [self.view addSubview:youBiIncomeImg];
    [self.view addSubview:youBiIncomeLable];
    [self.view addSubview:youBiIncomeNumber];
    [self.view addSubview:youBiIncomeBoultImg];

    //游币支出
    UIButton *youBiExpenseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64+0.29*kScreenHeight, self.view.bounds.size.width, .062*kScreenHeight)];
    youBiExpenseButton.backgroundColor = [UIColor whiteColor];
    [youBiExpenseButton addTarget:self action:@selector(youBiExpenseClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *youBiExpenseImg = [[UILabel alloc]initWithFrame:CGRectMake(0.04*kScreenWindth, 64+0.305*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    youBiExpenseImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *youBiExpenseLable = [[UILabel alloc]initWithFrame:CGRectMake(0.13*kScreenWindth, 64+0.3*kScreenHeight, 0.2*kScreenWindth, 0.037*kScreenHeight)];
    youBiExpenseLable.text = @"游币支出";
    
    UILabel *youBiExpenseNumber = [[UILabel alloc]initWithFrame:CGRectMake(0.88*kScreenWindth, 64+0.31*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    youBiExpenseNumber.text = @"1";
    
    UILabel *youBiExpenseBoultImg = [[UILabel alloc] initWithFrame:CGRectMake(0.93*kScreenWindth, 64+0.31*kScreenHeight, 0.05*kScreenWindth,0.05*kScreenWindth )];
    youBiExpenseBoultImg.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:youBiExpenseButton];
    [self.view addSubview:youBiExpenseImg];
    [self.view addSubview:youBiExpenseLable];
    [self.view addSubview:youBiExpenseNumber];
    [self.view addSubview:youBiExpenseBoultImg];

    
    
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

#pragma mark - 充值跳转
-(void)youBiRechargeClick
{
    
    
    
}

#pragma mark - 兑换券跳转
-(void)exchangeClick
{
    ExchangeViewController *exchangVC = [[ExchangeViewController alloc] init];
    [self.navigationController pushViewController:exchangVC animated:YES];

    
    
}

#pragma mark - 收入跳转
-(void)youBiIncomeClick
{
    IncomeViewController *incomeVC = [[IncomeViewController alloc]init];
    [self.navigationController pushViewController:incomeVC animated:YES];
    
    
}

#pragma mark - 支出跳转
-(void)youBiExpenseClick
{
    
    ExpenseViewController *expenseVC = [[ExpenseViewController alloc]init];
    [self.navigationController pushViewController:expenseVC animated:YES];
    
}
@end
