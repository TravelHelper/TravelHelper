//
//  YBZMoneyBagViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/16.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMoneyBagViewController.h"
#import "MeMoneyViewController.h"
#define kScreenWindth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface YBZMoneyBagViewController ()
@property (nonatomic ,strong)UILabel *youBiLable;

@end

@implementation YBZMoneyBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLeftButton];
    self.title = @"电子钱包";
    
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1];
    
    UIImage *goldImg = [UIImage imageNamed:@"gold"];
    CGFloat width = self.view.bounds.size.width;
    CGFloat threeWidth = (width - 6)/3;
    CGFloat twoWidth = width/2;
    CGFloat threeLableWidth = width/6;
    CGFloat twoLableWidth = width/4;
    //游币
    UIButton *youBiButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, threeWidth, 0.11*kScreenHeight)];
    youBiButton.backgroundColor = [UIColor whiteColor];
    [youBiButton addTarget:self action:@selector(youBiClick) forControlEvents:UIControlEventTouchUpInside];
    
    //UIImageView *youBiImg = [[UIImageView alloc]initWithImage:goldImg];
    //youBiImg.frame =CGRectMake(threeLableWidth-15, 64+15, 30, 30);
    
    UILabel *youBiImg = [[UILabel alloc]initWithFrame:CGRectMake(0.14*kScreenWindth, 64+0.033*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    youBiImg.backgroundColor = [UIColor purpleColor];
    
    self.youBiLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+0.08*kScreenHeight, threeWidth, 0.018*kScreenHeight)];
    NSString *money = @"100";
    NSString *youBiText = [NSString stringWithFormat:@"%@%@",money,@"游币"];
    NSMutableAttributedString *youBistr = [[NSMutableAttributedString alloc] initWithString:youBiText];
    [youBistr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,money.length)];
    [self.youBiLable setAttributedText:youBistr] ;
    
    self.youBiLable.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:youBiButton];
    [self.view addSubview:youBiImg];
    [self.view addSubview:self.youBiLable];
    
    //充值提现
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(threeWidth+1, 64, threeWidth, 0.11*kScreenHeight)];
    payButton.backgroundColor = [UIColor whiteColor];
    [payButton addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *payImg = [[UILabel alloc]initWithFrame:CGRectMake(0.46*kScreenWindth,64+0.033*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    //UIImageView *payImg = [[UIImageView alloc]initWithFrame:CGRectMake(threeWidth+2+threeLableWidth-15, 64+15, 30, 30)];
    payImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *payLable = [[UILabel alloc]initWithFrame:CGRectMake(threeWidth+1, 64+0.08*kScreenHeight, threeWidth, 0.018*kScreenHeight)];
    NSString *payText = @"充值提现";
    payLable.text = payText;
    payLable.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:payButton];
    [self.view addSubview:payImg];
    [self.view addSubview:payLable];
    
    //规则
    UIButton *ruleButton = [[UIButton alloc] initWithFrame:CGRectMake((threeWidth+1)*2, 64, threeWidth, 0.11*kScreenHeight)];
    ruleButton.backgroundColor = [UIColor whiteColor];
    [ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *ruleImg = [[UILabel alloc]initWithFrame:CGRectMake(0.8*kScreenWindth,64+0.033*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    //UIImageView *payImg = [[UIImageView alloc]initWithFrame:CGRectMake((threeWidth+2)*2+threeLableWidth-15, 64+15, 30, 30)];
    ruleImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *ruleLable = [[UILabel alloc]initWithFrame:CGRectMake((threeWidth+1)*2, 64+0.08*kScreenHeight, threeWidth, 0.018*kScreenHeight)];
    NSString *ruleText = @"规则";
    ruleLable.text = ruleText;
    ruleLable.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:ruleButton];
    [self.view addSubview:ruleImg];
    [self.view addSubview:ruleLable];
    
    
    //每日任务
    UILabel *dailyQuestLable = [[UILabel alloc] initWithFrame:CGRectMake(0,64+0.11*kScreenHeight , self.view.bounds.size.width,0.077*kScreenHeight)];
    dailyQuestLable.text = @"   每日任务";
    dailyQuestLable.backgroundColor =  [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1];
    [self.view addSubview:dailyQuestLable];
    
    //签到
    UIButton *signInButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64+0.11*kScreenHeight+0.077*kScreenHeight, twoWidth, 0.24*kScreenHeight)];
    [signInButton addTarget:self action:@selector(signInClick) forControlEvents:UIControlEventTouchUpInside];
    signInButton.backgroundColor = [UIColor whiteColor];
    
    UILabel *signInImg = [[UILabel alloc] initWithFrame:CGRectMake(twoLableWidth-0.08*kScreenWindth, 64+0.11*kScreenHeight+0.077*kScreenHeight+0.03*kScreenHeight, 0.16*kScreenWindth, 0.16*kScreenWindth)];
    signInImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *signInLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+0.32*kScreenHeight, twoWidth, 0.022*kScreenHeight)];
    NSString *signInText = @"签到";
    signInLable.text = signInText;
    signInLable.textAlignment = UITextAlignmentCenter;
    
    UIImageView *moneyImg = [[UIImageView alloc]initWithImage:goldImg];
    moneyImg.frame =CGRectMake(0.2*kScreenWindth, 64+0.35*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth);
    
    UILabel *moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(0.28*kScreenWindth, 64+0.35*kScreenHeight, 0.05*kScreenHeight, 0.05*kScreenWindth)];
    NSString *moneyText =@"3";
    NSMutableAttributedString *moneystr = [[NSMutableAttributedString alloc] initWithString:moneyText];
    [moneystr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,moneyText.length)];
    [moneyLable setAttributedText:moneystr] ;
    
    [self.view addSubview:signInButton];
    [self.view addSubview:signInImg];
    [self.view addSubview:signInLable];
    [self.view addSubview:moneyImg];
    [self.view addSubview:moneyLable];
    
    //分享
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(twoWidth, 64+0.11*kScreenHeight+0.077*kScreenHeight, twoWidth, 0.24*kScreenHeight)];
    shareButton.backgroundColor = [UIColor whiteColor];
    
    UILabel *shareImg = [[UILabel alloc] initWithFrame:CGRectMake(0.63*kScreenWindth, 64+0.11*kScreenHeight+0.077*kScreenHeight+0.03*kScreenHeight, 0.16*kScreenWindth, 0.16*kScreenWindth)];
    shareImg.backgroundColor = [UIColor purpleColor];
    
    UILabel *shareLable = [[UILabel alloc]initWithFrame:CGRectMake(0.53*kScreenWindth, 0.314*kScreenHeight+64, 0.35*kScreenWindth, 0.1*kScreenHeight)];
    NSString *shareText = @"分享到微信朋友圈或QQ空间";
    shareLable.text = shareText;
    shareLable.textAlignment = UITextAlignmentCenter;
    shareLable.lineBreakMode = NSLineBreakByWordWrapping;
    [shareLable setNumberOfLines:0];
    
    UIImageView *shareMoneyImg = [[UIImageView alloc]initWithImage:goldImg];
    shareMoneyImg.frame =CGRectMake(0.67*kScreenWindth, 64+0.4*kScreenHeight, 0.05*kScreenWindth, 0.05*kScreenWindth);
    
    UILabel *shareMoneyLable = [[UILabel alloc]initWithFrame:CGRectMake(0.74*kScreenWindth, 0.4*kScreenHeight+64, 0.05*kScreenWindth, 0.05*kScreenWindth)];
    NSString *shareMoneyText =@"5";
    NSMutableAttributedString *shareMoneystr = [[NSMutableAttributedString alloc] initWithString:shareMoneyText];
    [shareMoneystr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,shareMoneyText.length)];
    [shareMoneyLable setAttributedText:shareMoneystr] ;
    
    [self.view addSubview:shareButton];
    [self.view addSubview:shareImg];
    [self.view addSubview:shareLable];
    [self.view addSubview:shareMoneyImg];
    [self.view addSubview:shareMoneyLable];
    
}

#pragma mark - 签到跳转
-(void)signInClick
{
    static int i = 1;
    if (i == 1) {
        i=i+1;
        UIImage *img = [UIImage imageNamed:@"singin"];
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWindth-img.size.width)*0.5, (kScreenHeight-img.size.height)*0.5, img.size.width, img.size.height)];
        view.backgroundColor = [UIColor redColor];
        [view setImage:img];
        NSArray *viewArr = [[NSArray alloc]initWithObjects:view,nil];
        [self.view addSubview:view];
        
        for (UIImageView *view in viewArr) {
            [UIImageView animateWithDuration:5 delay:3 options:UIViewAnimationOptionTransitionNone animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished) {
                [UIImageView animateWithDuration:2 animations:^{
                    view.alpha = 0;
                }];
            }];
            
        }
        NSString *money = @"103";
        NSString *youBiText = [NSString stringWithFormat:@"%@%@",money,@"游币"];
        NSMutableAttributedString *youBistr = [[NSMutableAttributedString alloc] initWithString:youBiText];
        [youBistr addAttribute:NSForegroundColorAttributeName value:    [UIColor redColor] range:NSMakeRange(0,money.length)];
        [self.youBiLable setAttributedText:youBistr] ;
        
    }
    
    
}

#pragma mark - 规则跳转
-(void)ruleClick
{
    
    
    
}

#pragma mark - 游币跳转
-(void)youBiClick
{
    
    MeMoneyViewController *meMoneyVC = [[MeMoneyViewController alloc]init];
    [self.navigationController pushViewController:meMoneyVC animated:YES];
    
}

#pragma mark - 提现跳转
-(void)payClick
{
    
    
    
}

#pragma mark - 页面跳转
-(void)initLeftButton
{
    //左上角的按钮
    UIButton *boultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [boultButton setImage:[UIImage imageNamed:@"boult"] forState:UIControlStateNormal];
    [boultButton addTarget:self action:@selector(interpretClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:boultButton];
}

@end
