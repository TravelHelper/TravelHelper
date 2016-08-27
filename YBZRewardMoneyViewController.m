//
//  YBZRewardMoneyViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

//悬赏金额（用户）
#import "YBZRewardMoneyViewController.h"
#import "WebAgent.h"
#import "TopView.h"
#import "BottomView.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface YBZRewardMoneyViewController ()

@property (nonatomic , strong) TopView *topView;
@property (nonatomic , strong) BottomView *bottomView;

@property (nonatomic , strong) UIButton *tiXianBut;
@property (nonatomic , strong) UILabel  *alertLabel;
//@property (nonatomic,strong) UIView     *backView;


@end

@implementation YBZRewardMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏标题
    self.title = @"悬赏金额";
    //设置导航栏标题大小和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:244 / 255.0 alpha:1];
    //_backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenW , kScreenH)];
    //_backView.backgroundColor =[UIColor colorWithRed:239 / 255.0 green:238 / 255.0 blue:244 / 255.0 alpha:1];
    self.topView = [[TopView alloc]init];
    self.topView.frame = CGRectMake(15, 65, [UIScreen mainScreen].bounds.size.width - 30,[UIScreen mainScreen].bounds.size.height*0.076);
    self.bottomView = [[BottomView alloc]init];
    self.bottomView.frame = CGRectMake(15,CGRectGetMaxY(self.topView.frame)+10, [UIScreen mainScreen].bounds.size.width - 30,[UIScreen mainScreen].bounds.size.height*0.31);
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tiXianBut];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textAction) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textAction) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.bottomView.getAllBut addTarget:self action:@selector(getAllButClick) forControlEvents:UIControlEventTouchUpInside];
   
    
}

#pragma mark - 重写 getAllBut 按钮的单击事件
-(void)getAllButClick
{
    if ([self.bottomView.moneyTextField.text  isEqual: @""]) {
        [self.tiXianBut setEnabled:NO];
    }else{
        [self.tiXianBut setEnabled:YES];
    }
}

#pragma mark - 实现监听事件
-(void)textAction
{
    if ([self.bottomView.moneyTextField.text  isEqual: @""]) {
        [self.tiXianBut setEnabled:NO];
        [_tiXianBut setTitle:@"悬赏" forState:UIControlStateNormal];
        _tiXianBut.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:218 / 255.0 blue:0 / 255.0 alpha:1];

    }else{
        [_tiXianBut setTitle:@"确定" forState:UIControlStateNormal];
        _tiXianBut.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:218 / 255.0 blue:0 / 255.0 alpha:1];
        [self.tiXianBut setEnabled:YES];
    }
    
    //将字符串转换成int类型
    NSInteger textField = [self.bottomView.moneyTextField.text intValue];
    NSInteger label = [self.bottomView.allMoneyLabel.text intValue];
    if (textField > label) {
        self.bottomView.alertLabel.hidden = NO;
    }else{
        self.bottomView.alertLabel.hidden = YES;
        
    }
}

#pragma mark - 控件的getters方法
-(UIButton *)tiXianBut
{
    if (!_tiXianBut) {
        _tiXianBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _tiXianBut.frame = CGRectMake(0,CGRectGetMaxY(self.bottomView.frame)+30, [UIScreen mainScreen].bounds.size.width, 50);

        [_tiXianBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_tiXianBut setTitle:@"悬赏" forState:UIControlStateNormal];
        self.tiXianBut.backgroundColor = [UIColor yellowColor];
        [_tiXianBut addTarget:self action:@selector(tiXianButClick) forControlEvents:UIControlEventTouchUpInside];
        //若将该语句添加到该段代码之前 无效
        [_tiXianBut setEnabled:NO];
    }
    return _tiXianBut;
}


#pragma mark - 按钮点击事件
-(void)tiXianButClick
{
    if (self.bottomView.alertLabel.hidden == YES) {
        NSLog(@"确定");
        NSString *money = self.bottomView.moneyTextField.text;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMoney" object:nil userInfo:@{@"money":money}];
        
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        CGSize size = [@"游币账户余额不足" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width) / 2, CGRectGetMaxY(self.bottomView.frame)-40, size.width + 10, size.height + 6)];
        self.alertLabel.backgroundColor = [UIColor clearColor];
        self.alertLabel.layer.cornerRadius = 5;
        //将UiLabel设置圆角 此句不可少
        self.alertLabel.layer.masksToBounds = YES;
        self.alertLabel.alpha = 0.8;
        self.alertLabel.text = @"游币账户余额不足";
        self.alertLabel.font = [UIFont systemFontOfSize:14];
        [self.alertLabel setTextAlignment:NSTextAlignmentCenter];
        self.alertLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.alertLabel];
        
        //设置动画
        [UIView animateWithDuration:2 animations:^{
            self.alertLabel.alpha = 0;
        } completion:^(BOOL finished) {
            //将警告Label透明后 在进行删除
            [self.alertLabel removeFromSuperview];
        }];
    }
}

@end
