//
//  ExchangeViewController.m
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "ExchangeViewController.h"
#define kScreenWith  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLeftButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];;
    self.title = @"兑换劵";
    
    UITextField *exchangeText =[[UITextField alloc] initWithFrame:CGRectMake(kScreenWith*0.032, kScreenWith*0.098+64, kScreenWith*0.934, kScreenWith*0.131)];
    exchangeText.backgroundColor = [UIColor whiteColor];
    exchangeText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    exchangeText.leftViewMode = UITextFieldViewModeAlways;
    exchangeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    exchangeText.keyboardType = UIKeyboardTypeEmailAddress;
    exchangeText.placeholder = @"请输入8位兑换码，区分大小写";
    exchangeText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:exchangeText];
    
    //立即兑换
    UIButton *immediatelyExchangeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWith*0.065, kScreenWith*0.282+64, kScreenWith*0.855, kScreenWith*0.118)];
    [immediatelyExchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    [immediatelyExchangeButton.layer setMasksToBounds:YES];
    [immediatelyExchangeButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    immediatelyExchangeButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:immediatelyExchangeButton];
    
    UILabel *getExchange = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWith*0.032, kScreenWith*0.440+64, kScreenWith*0.296, kScreenWith*0.052)];
    getExchange.text = @"如何获取兑换码：";
    [getExchange setNumberOfLines:0];
    getExchange.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:getExchange];
    
    UILabel *getExchangeText = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWith*0.032, kScreenWith*0.513+64, kScreenWith*0.934, kScreenWith*0.2)];
    getExchangeText.text = @"我们会不定期的举行一些运营活动，届时就会有兑换码砸向幸运的你啦～";
    getExchangeText.lineBreakMode = NSLineBreakByWordWrapping;
    [getExchangeText setNumberOfLines:0];
    [self.view addSubview:getExchangeText];
    
    
    
    
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
