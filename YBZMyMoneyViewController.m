//
//  YBZMyMoneyViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMyMoneyViewController.h"
#import "YBZRestMoneyViewController.h"
#import "YBZRechagrgeViewController.h"
#import "YBZRuleViewController.h"

@interface YBZMyMoneyViewController ()


@property (nonatomic, strong) UIButton *restMoneyBtn;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *ruleBtn;



@end

@implementation YBZMyMoneyViewController{

    NSArray *labelTextArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllControlsFrame];
    [self addAllControls];
    
}

-(void)addAllControls{
    
    self.view.backgroundColor = UIColorFromRGB(0XF8F8F8);
    self.title = @"电子钱包";
    labelTextArr = @[@"余额",@"充值",@"规则"];
    [self getThreeBtnView];
    [self getMissionLabelAndView];
}

-(void)setAllControlsFrame{
    
    
}

-(void)getMissionLabelAndView{

    UILabel *missionLable = [[UILabel alloc]initWithFrame:CGRectMake(0.03125*SCREEN_WIDTH , 0.255*SCREEN_HEIGHT, 0.5*SCREEN_WIDTH, 0.04375*SCREEN_WIDTH)];
    missionLable.text = @"每日任务";
    missionLable.textColor = UIColorFromRGB(0x747474);
    missionLable.textAlignment = NSTextAlignmentLeft;
    missionLable.font = [UIFont systemFontOfSize:0.04375*SCREEN_WIDTH];
    [self.view addSubview:missionLable];
    UIView *missionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.307*SCREEN_HEIGHT, SCREEN_WIDTH, 0.237*SCREEN_HEIGHT)];
    missionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:missionView];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(0.2*SCREEN_WIDTH, 0.148*missionView.bounds.size.height, 0.14*SCREEN_WIDTH, 0.14*SCREEN_WIDTH);
    [signBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [missionView addSubview:signBtn];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0.66*SCREEN_WIDTH, 0.148*missionView.bounds.size.height, 0.14*SCREEN_WIDTH, 0.14*SCREEN_WIDTH);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [missionView addSubview:shareBtn];
    
}


-(void)getThreeBtnView{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.1124*SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    for (int i=0; i<2; i++) {
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*(i+1), 0.1875*view.bounds.size.height, 0.004*SCREEN_WIDTH, 0.625*view.bounds.size.height)];
        grayView.backgroundColor = UIColorFromRGB(0XF8F8F8);
        [view addSubview:grayView];
    }
    
    [self setThreeBtnsFrameInView:view];
    [self addThreeHubBtn:view];
    
}

-(void)setThreeBtnsFrameInView:(UIView *)view{
    
    self.restMoneyBtn.frame = CGRectMake((SCREEN_WIDTH/3-0.039*SCREEN_WIDTH)/2, 0.035*SCREEN_HEIGHT, 0.039*SCREEN_WIDTH, 0.039*SCREEN_WIDTH);
    self.rechargeBtn.frame = CGRectMake(SCREEN_WIDTH/3+(SCREEN_WIDTH/3-0.039*SCREEN_WIDTH)/2, 0.035*SCREEN_HEIGHT, 0.039*SCREEN_WIDTH, 0.039*SCREEN_WIDTH);
    self.ruleBtn.frame = CGRectMake(2*SCREEN_WIDTH/3+(SCREEN_WIDTH/3-0.039*SCREEN_WIDTH)/2, 0.035*SCREEN_HEIGHT, 0.039*SCREEN_WIDTH, 0.039*SCREEN_WIDTH);
    [view addSubview:self.rechargeBtn];
    [view addSubview:self.restMoneyBtn];
    [view addSubview:self.ruleBtn];
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(SCREEN_WIDTH/3*i, 0.586*view.bounds.size.height, SCREEN_WIDTH/3, 0.171875*view.bounds.size.height);
        label.text = labelTextArr[i];
        label.font = [UIFont systemFontOfSize:0.171875*view.bounds.size.height];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x747474);
        [view addSubview:label];
        
    }
    
}

-(void)addThreeHubBtn:(UIView *)view{

    for (int i=0; i<3; i++) {
        UIButton *hubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hubBtn setBackgroundColor:[UIColor clearColor]];
        hubBtn.frame = CGRectMake(SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, view.bounds.size.height);
        switch (i) {
            case 0:
                [hubBtn addTarget:self action:@selector(restMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 1:
                [hubBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 2:
                [hubBtn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
                
            default:
                break;
        }
        [view addSubview:hubBtn];
    }
}

#pragma mark =====ONCLICK=====
-(void)restMoneyBtnClick:(UIButton *)sender{

    NSLog(@"rest");
    YBZRestMoneyViewController *restMoneyVC = [[YBZRestMoneyViewController alloc]init];
    [self.navigationController pushViewController:restMoneyVC animated:YES];
}

-(void)rechargeBtnClick:(UIButton *)sender{
    
    NSLog(@"rechage");
    YBZRechagrgeViewController *rechageVC = [[YBZRechagrgeViewController alloc]init];
    [self.navigationController pushViewController:rechageVC animated:YES];

}

-(void)ruleBtnClick:(UIButton *)sender{
    
    NSLog(@"rule");
    YBZRuleViewController *ruleVC = [[YBZRuleViewController alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

-(void)shareBtnClick:(UIButton *)sender{
    
    NSLog(@"share");

    
}
-(void)signBtnClick:(UIButton *)sender{
    
    NSLog(@"sign");
    
    
}




#pragma mark =====GETTERS=====

-(UIButton *)restMoneyBtn{

    if (!_restMoneyBtn) {
        _restMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_restMoneyBtn setBackgroundImage:[UIImage imageNamed:@"钱币"] forState:UIControlStateNormal];
        [_restMoneyBtn addTarget:self action:@selector(restMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restMoneyBtn;
}

-(UIButton *)rechargeBtn{
    
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setBackgroundImage:[UIImage imageNamed:@"充值"] forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

-(UIButton *)ruleBtn{
    
    if (!_ruleBtn) {
        _ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ruleBtn setBackgroundImage:[UIImage imageNamed:@"规则"] forState:UIControlStateNormal];
        [_ruleBtn addTarget:self action:@selector(ruleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ruleBtn;
}




@end
