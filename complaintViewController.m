//
//  complaintViewController.m
//  YBZTravel
//
//  Created by sks on 16/7/26.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "complaintViewController.h"
#import "WebAgent.h"

#define kScreenWith  [UIScreen mainScreen].bounds.size.width

@interface complaintViewController ()
@property (nonatomic, strong) UITextView *complaintText;
@property (nonatomic, strong) NSString *targetId;

@end

@implementation complaintViewController





- (instancetype)initWithTargetId:(NSString *)targetId
{
    self = [super init];
    if (self) {
        self.targetId=targetId;
    }
    return self;
}




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
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(selectrightAction)];
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
    [self resignFirstResponder];
    
    if([self.complaintText.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"举报信息不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

    }else{
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"举报" message:@"是否提交举报信息？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        NSLog(@"aaaa");
        NSLog(@"%@",self.complaintText.text);
        NSDate *answerTime=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *locationString=[dateformatter stringFromDate:answerTime];
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *userIDDictionary = [userdefault objectForKey:@"user_id"];
        NSString *userID=userIDDictionary[@"user_id"];
        
//        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
        [WebAgent UpdateUsertipoffWithMseeageId:mseeage_id TranslatorId:self.targetId reporterId:userID report_text:self.complaintText.text report_time:locationString success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //        NSDictionary *info = dic[@"user_info"];
            
            NSString *need=dic[@"data"];
            
            NSLog(@"%@",need);
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"举报成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];

        } failure:^(NSError *error) {
            
        }];
//        [WebAgent UpdateUsertipoffWithTranslatorId:self.targetId reporterId:userID report_text:self.complaintText.text report_time:locationString success:^(id responseObject) {
//            NSData *data = [[NSData alloc] initWithData:responseObject];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            
//            //        NSDictionary *info = dic[@"user_info"];
//            
//            NSString *need=dic[@"data"];
//            
//            NSLog(@"%@",need);
//            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"举报成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//
//        } failure:^(NSError *error) {
//            
//        }];

        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:nil];

    
    
    
    
    }
    
}

-(void)backAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
