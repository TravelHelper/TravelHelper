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
#import "YBZRulesViewController.h"
#import "WebAgent.h"
#import "MBProgressHUD+XMG.h"

@interface YBZMyMoneyViewController ()


@property (nonatomic, strong) UIButton *restMoneyBtn;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *ruleBtn;



@end

@implementation YBZMyMoneyViewController{

    NSArray *labelTextArr;
    NSString *signNumber;
    NSString *userID;
    BOOL canClick;
    BOOL allowSign;
    NSDictionary *pushDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    signNumber = @"5";
    [self addAllControls];
    
}

-(void)loadDataFromWeb{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    userID = user_id[@"user_id"];
    [WebAgent getMoneyNumber:user_id[@"user_id"] success:^(id responseObject) {
        canClick = YES;
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"allow"]isEqualToString: @"0"]) {
            allowSign = NO;
        }else if([dic[@"allow"]isEqualToString: @"1"]){
            allowSign = YES;
        }
        signNumber = dic[@"data"];
        [self getMissionLabelAndView];


    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误，数据加载失败" toView:self.view];
        canClick = NO;
    }];
    
    [WebAgent restMoneyInfoWithUserID:user_id[@"user_id"] success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        pushDic = [[NSDictionary alloc]initWithDictionary:dic];
        
    } failure:^(NSError *error) {
        
    }];
    

    
}


-(void)addAllControls{
    
    self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    self.title = @"电子钱包";
    labelTextArr = @[@"余额",@"充值",@"规则"];
    [self getThreeBtnView];
    [self loadDataFromWeb];

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
    
    [self addShareAndSignBtn:missionView];
    [self addMoneyImageView:missionView AndNumber:signNumber];
    
    
}

-(void)addShareAndSignBtn:(UIView *)missionView{
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(0.23*SCREEN_WIDTH, 0.148*missionView.bounds.size.height, 0.14*SCREEN_WIDTH, 0.14*SCREEN_WIDTH);
    signBtn.tag = 200;

    [signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [signBtn setBackgroundImage:[UIImage imageNamed:@"签到"] forState:UIControlStateNormal];
    [missionView addSubview:signBtn];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0.63*SCREEN_WIDTH, 0.148*missionView.bounds.size.height, 0.14*SCREEN_WIDTH, 0.14*SCREEN_WIDTH);
    shareBtn.tag = 201;

    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [missionView addSubview:shareBtn];
    
    UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.23*SCREEN_WIDTH, 0.443*missionView.bounds.size.height, 0.14*SCREEN_WIDTH, 0.14*SCREEN_WIDTH)];
    signLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    signLabel.textColor = UIColorFromRGB(0x747474);
    signLabel.textAlignment = NSTextAlignmentCenter;
    if (allowSign == YES) {
        signLabel.text = @"签到";
    }else{
        signLabel.text = @"已签到";
    }
    signLabel.tag = 100;
    [missionView addSubview:signLabel];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.63*SCREEN_WIDTH, 0.443*missionView.bounds.size.height, 0.14*SCREEN_WIDTH, 0.14*SCREEN_WIDTH)];
    shareLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    shareLabel.textColor = UIColorFromRGB(0x747474);
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = @"分享";
    shareLabel.tag = 101;
    [missionView addSubview:shareLabel];
}


-(void)addMoneyImageView:(UIView *)view AndNumber:(NSString *)number{

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0.255*SCREEN_WIDTH,0.73*view.bounds.size.height, 0.045*SCREEN_WIDTH, 0.045*SCREEN_WIDTH)];
    imgView.image = [UIImage imageNamed:@"增加钱币"];
    [view addSubview:imgView];
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0.655*SCREEN_WIDTH, 0.73*view.bounds.size.height, 0.045*SCREEN_WIDTH, 0.045*SCREEN_WIDTH)];
    imgView2.image = [UIImage imageNamed:@"增加钱币"];
    [view addSubview:imgView2];
    
    UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.305*SCREEN_WIDTH,0.725*view.bounds.size.height, 0.045*SCREEN_WIDTH, 0.045*SCREEN_WIDTH)];
    signLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    signLabel.textColor = [UIColor redColor];
    signLabel.text = number;
    signLabel.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:signLabel];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.705*SCREEN_WIDTH,0.725*view.bounds.size.height, 0.045*SCREEN_WIDTH, 0.045*SCREEN_WIDTH)];
    shareLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    shareLabel.textColor = [UIColor redColor];
    shareLabel.text = @"5";
    shareLabel.textAlignment = NSTextAlignmentLeft;
    
    [view addSubview:shareLabel];
    
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

-(UIView *)chooseToShare{
    
    UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 0.653*SCREEN_WIDTH)];
    chooseView.tag = 1000;
    chooseView.backgroundColor =UIColorFromRGB(0XF8F8F8);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.035*SCREEN_HEIGHT)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"   分享到：";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor grayColor];
    [chooseView addSubview:label];
    NSArray *arr = @[@"新浪微博",@"空间",@"微信好友",@"朋友圈"];
    NSArray *titleArr= @[@"新浪微博",@"QQ空间",@"微信好友",@"朋友圈"];
    for (int i=0; i<arr.count; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 0.15*SCREEN_WIDTH;
        CGFloat sep = (SCREEN_WIDTH-4*0.15*SCREEN_WIDTH)/8;
       btn.frame = CGRectMake(sep*(2*i+1)+i*width,0.102*SCREEN_HEIGHT,width,width);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [chooseView addSubview:btn];
        if (i==0) {
            [btn addTarget:self action:@selector(shareToQFriend) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1){
            [btn addTarget:self action:@selector(shareToQZone) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==2){
            [btn addTarget:self action:@selector(shareToVFriend) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [btn addTarget:self action:@selector(shareToVZone) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(sep*(2*i+1)+i*width,0.2*SCREEN_HEIGHT,width,0.034*SCREEN_WIDTH)];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        
        [chooseView addSubview:label];
    }
    
    return chooseView;
}

-(void)shareToQFriend{
   NSLog(@"shareToQFriend");
}

-(void)shareToQZone{
    NSLog(@"shareToQZone");
}

-(void)shareToVFriend{
    NSLog(@"shareToVFriend");
}

-(void)shareToVZone{
    NSLog(@"shareToVZone");
}

#pragma mark =====ONCLICK=====
-(void)restMoneyBtnClick:(UIButton *)sender{

    NSLog(@"rest");
    YBZRestMoneyViewController *restMoneyVC = [[YBZRestMoneyViewController alloc]initWithDict:pushDic];
    [self.navigationController pushViewController:restMoneyVC animated:YES];
}

-(void)rechargeBtnClick:(UIButton *)sender{
    
    NSLog(@"rechage");
    YBZRechagrgeViewController *rechageVC = [[YBZRechagrgeViewController alloc]initWithMoney:pushDic[@"data"][@"money"]];
    
    [self.navigationController pushViewController:rechageVC animated:YES];

}

-(void)ruleBtnClick:(UIButton *)sender{
    
    NSLog(@"rule");
    YBZRulesViewController *ruleVC = [[YBZRulesViewController alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

-(void)shareBtnClick:(UIButton *)sender{
    
    NSLog(@"share");
    if (sender.selected == NO) {
        UIView *view = [self chooseToShare];
        [self.view addSubview:view];
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, -0.653*SCREEN_WIDTH);
        }];
        sender.selected = YES;
    }else if(sender.selected == YES){

        [self removeShareView];
        sender.selected = NO;
    }

    
}


-(void)removeShareView{

    for (UIView *view in self.view.subviews) {
        if (view.tag == 1000) {
            [UIView animateWithDuration:0.3 animations:^{
                view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}


-(void)signBtnClick:(UIButton *)sender{

    if (canClick == NO) {
        [MBProgressHUD showError:@"网络错误，请重新加载界面" toView:self.view];
    }else{
        [WebAgent signDays:userID money:signNumber success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *success = dic[@"data"];
            NSString *str = dic[@"msg"];
            if (allowSign == YES) {
                if ([success isEqualToString:@"0"]) {
                    [MBProgressHUD showError:str toView:self.view];
                }else if ([success isEqualToString:@"1"]){
                    [MBProgressHUD showSuccess:str toView:self.view];
                    allowSign = NO;
                    for (UILabel *label in sender.superview.subviews) {
                        if (label.tag == 100) {
                            label.text = @"已签到";
                        }
                    }
                }
            }else{
                [MBProgressHUD showError:str toView:self.view];
            }

        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"签到失败，请重试！" toView:self.view];
        }];
        
    }
    
    
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
