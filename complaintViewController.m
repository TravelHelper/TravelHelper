//
//  complaintViewController.m
//  YBZTravel
//
//  Created by sks on 16/7/26.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "complaintViewController.h"
#define kScreenWith  [UIScreen mainScreen].bounds.size.width

@interface complaintViewController ()
@property (nonatomic, strong) UITextView *complaintText;


@end

@implementation complaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    self.complaintText = [[UITextView alloc]initWithFrame:CGRectMake(kScreenWith*0.02, kScreenWith*0.013+64, kScreenWith*0.958, kScreenWith*0.37)];
    self.complaintText.backgroundColor = [UIColor whiteColor];
    self.complaintText.font = [UIFont boldSystemFontOfSize:20];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //设置边框宽度
    self.complaintText.layer.borderWidth = 1.0;
    //设置边框颜色
    self.complaintText.layer.borderColor = [UIColor grayColor].CGColor;
    //设置圆角
    self.complaintText.layer.cornerRadius = 5.0;
    
    //    self.complaintText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //    self.complaintText.leftViewMode = UITextFieldViewModeAlways;
    //    self.complaintText.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    self.complaintText.keyboardType = UIKeyboardTypeEmailAddress;
    //    self.complaintText.placeholder = @"投诉";
    
    [self.view addSubview:self.complaintText];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title  = @"投诉";
    //添加保存按钮
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(selectrightAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //自定义返回键
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 30);
    // backBtn.backgroundColor = [UIColor blackColor];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [backBtn setImage:[UIImage imageNamed:@"boult"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}



-(void)selectrightAction
{
    
    NSString *comlaintValue = self.complaintText.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"complaintText" object:nil
                                                      userInfo:@{@"投诉":comlaintValue}];

    
    [self.navigationController popViewControllerAnimated:YES];
  
}

-(void)backAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
