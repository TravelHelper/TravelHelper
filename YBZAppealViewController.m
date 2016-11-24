//
//  YBZAppealViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/24.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZAppealViewController.h"
#import "MBProgressHUD+XMG.h"
#import "UIAlertController+SZYKit.h"

@interface YBZAppealViewController ()
@property (nonatomic ,strong) UITextView *submitTF;

@end

@implementation YBZAppealViewController{

    NSString *selfTitle;
    NSString *backMoney;
    NSString *rewardID;
}



- (instancetype)initWithTitle:(NSString *)title AndMoney:(NSString *)money AndrewardID:(NSString *)reward_ID
{
    self = [super init];
    if (self) {
        selfTitle = title;
        backMoney = money;
        rewardID = reward_ID;
        self.title = selfTitle;
        self.view.backgroundColor=UIColorFromRGB(0xF8F8F8);
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    self.submitTF = [[UITextView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.02, SCREEN_WIDTH*0.013+64, SCREEN_WIDTH*0.958, SCREEN_WIDTH*0.37)];
    self.submitTF.backgroundColor = [UIColor whiteColor];
    self.submitTF.editable = YES;
    self.submitTF.font = [UIFont boldSystemFontOfSize:20];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //设置边框宽度
    self.submitTF.layer.borderWidth = 1.0;
    //设置边框颜色
    self.submitTF.layer.borderColor = [UIColor grayColor].CGColor;
    //设置圆角
    self.submitTF.layer.cornerRadius = 5.0;
    [self.view addSubview:self.submitTF];
    
    UIButton *submitB = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-85, SCREEN_WIDTH*0.394+64, 75, 30)];
    submitB.backgroundColor = [UIColor orangeColor];
    [submitB setTitle:@"提交" forState:UIControlStateNormal];
    [submitB addTarget:self action:@selector(appealWrong) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:submitB];
}


-(void)appealWrong{
    if(self.submitTF.text.length == 0){
        
        [UIAlertController showAlertAtViewController:self title:@"提交失败" message:@"提交内容不能为空，请详细说明申请退款原因，若查明属实，将返还付款的80%" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
            
        }];
        
    }
    
    else{
        
        [WebAgent uploadAppealInfoWithRewardID:rewardID appealInfo:self.submitTF.text money:backMoney success:^(id responseObject) {
            
            [UIAlertController showAlertAtViewController:self title:@"提交成功" message:@"提交申诉成功，系统会参考您的退款原因，若查明属实，将返还付款的80%" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];

        } failure:^(NSError *error) {
            [UIAlertController showAlertAtViewController:self title:@"提交失败" message:@"网络错误，请重新提交申请退款原因，若查明属实，将返还付款的80%" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
            }];

        }];
        

    }
    
}






@end
