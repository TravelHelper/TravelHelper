//
//  NIChengViewController.m
//  YBZTravel
//
//  Created by sks on 16/7/15.
//  Copyright © 2016年 ZYQ. All rights reserved.
//

#import "NIChengViewController.h"
#import "FreeTravelViewController.h"


@interface NIChengViewController ()
@property (nonatomic, strong) UITextField *nickNameChange;


@end

@implementation NIChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nickNameChange];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:238/255.0 blue:244/255.0 alpha:1];
    self.title  = @"昵称";
    
    //添加保存按钮
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(selectrightAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //修改字体颜色
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];

}

#pragma mark - getters
-(UITextField *)nickNameChange
{
    if (!_nickNameChange) {
        _nickNameChange = [[UITextField alloc]initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 50)];
        _nickNameChange.backgroundColor = [UIColor whiteColor];
        //设置左偏移
        _nickNameChange.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        //设置显示模式为永远显示(默认不显示)
        _nickNameChange.leftViewMode = UITextFieldViewModeAlways;
        //删除按钮
        _nickNameChange.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _nickNameChange.keyboardType = UIKeyboardTypeEmailAddress;
        if ([_nicheng  isEqual: @""]) {
            _nickNameChange.placeholder = @"昵称";
        }else{
            _nickNameChange.text = self.nicheng;
        }
        
    }
    return _nickNameChange;
}

#pragma mark - selectrightAction
-(void)selectrightAction
{
    NSString *nickNameValue = _nickNameChange.text;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nickNameValue,@"昵称", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserInfoNickName" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
