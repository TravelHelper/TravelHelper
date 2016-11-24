//
//  YBZRestMoneyViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZRestMoneyViewController.h"
#import "YBZRechagrgeViewController.h"
#import "YBZMoneyDetailsViewController.h"


@interface YBZRestMoneyViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *moneyBtn;
@property (nonatomic, strong) UIButton *beanBtn;
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) UIView *beanView;
@property (nonatomic, strong) UIView *separateView;

@end

@implementation YBZRestMoneyViewController{

    NSArray *moneyArr;
    NSArray *beanArr;
    NSMutableArray *moneyInArray;
    NSMutableArray *moneyOutArray;
    NSMutableArray *beanInArray;
    NSMutableArray *beanOutArray;
    NSString *moneyRest;
    NSString *beanRest;
    NSDictionary *dic;
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        dic = dict;
        moneyInArray = [NSMutableArray array];
        moneyOutArray = [NSMutableArray array];
        beanInArray = [NSMutableArray array];
        beanOutArray = [NSMutableArray array];
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
        self.title = @"余额";
        [self loadDataFromWeb];
        [self setFrame];
        [self addAllControls];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)loadDataFromWeb{
        moneyRest = dic[@"data"][@"money"];
        beanRest = dic[@"data"][@"bean"];
        moneyArr =dic[@"data"][@"money_info"];
        beanArr =dic[@"data"][@"bean_info"];
        if (moneyArr.count != 0) {
            for (int i=0; i<moneyArr.count; i++) {
                if ([moneyArr[i][@"money_deal_type"] isEqualToString:@"in"]) {
                    [moneyInArray addObject:moneyArr[i]];
                }else if ([moneyArr[i][@"money_deal_type"] isEqualToString:@"out"]) {
                    [moneyOutArray addObject:moneyArr[i]];
                }
            }
        }
        if (beanArr.count != 0) {
            for (int i=0; i<beanArr.count; i++) {
                if ([beanArr[i][@"bean_deal_type"] isEqualToString:@"in"]) {
                    [beanInArray addObject:beanArr[i]];
                }else if ([beanArr[i][@"bean_deal_type"] isEqualToString:@"out"]) {
                    [beanOutArray addObject:beanArr[i]];
                }
            }
        }
        
        
        [self addMoneyViewControlsWithMoney:moneyRest];
        [self addBeanViewControlsWithBean:beanRest];
        

}


-(void)setFrame{

    self.topView.frame = CGRectMake(0 , 64, SCREEN_WIDTH, 0.073*SCREEN_HEIGHT);
    self.moneyBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, self.topView.bounds.size.height);
    self.beanBtn.frame = CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.topView.bounds.size.height);
    self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.124*SCREEN_WIDTH)/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.124*SCREEN_WIDTH, 0.0052*SCREEN_HEIGHT);
    self.moneyView.frame = CGRectMake(0, 64+self.topView.bounds.size.height + 0.0026*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(64+self.topView.bounds.size.height + 0.0052*SCREEN_HEIGHT));
    self.beanView.frame = CGRectMake(0, 64+self.topView.bounds.size.height + 0.0026*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(64+self.topView.bounds.size.height + 0.0052*SCREEN_HEIGHT));
    
}


-(void)addAllControls{

    [self.view addSubview:self.topView];
    [self.topView addSubview:self.separateView];
    [self.view addSubview:self.moneyView];

}

-(void)clearView{

    [self.moneyView removeFromSuperview];
    [self.beanView removeFromSuperview];
}



-(void)addMoneyViewControlsWithMoney:(NSString *)money{

    NSString *string = [NSString stringWithFormat:@"我的嗨币：%@",money];
    NSUInteger length = money.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,length)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"充值嗨币"forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.frame = CGRectMake(SCREEN_WIDTH-0.0306*SCREEN_WIDTH-0.214*SCREEN_WIDTH, (0.128*SCREEN_HEIGHT-0.0514*SCREEN_HEIGHT)/2, 0.214*SCREEN_WIDTH, 0.0514*SCREEN_HEIGHT);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 0.0026*SCREEN_HEIGHT;
    [btn addTarget:self action:@selector(pushRechargeView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setBackgroundImage:[UIImage imageNamed:@"右侧选择箭头"] forState:UIControlStateNormal];
    pushBtn.frame = CGRectMake(SCREEN_WIDTH-0.0612*SCREEN_WIDTH-0.0306*SCREEN_WIDTH, (0.073*SCREEN_HEIGHT-0.0612*SCREEN_WIDTH)/2, 0.0612*SCREEN_WIDTH, 0.0612*SCREEN_WIDTH);
    UIButton *pushBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn2 setBackgroundImage:[UIImage imageNamed:@"右侧选择箭头"] forState:UIControlStateNormal];
    pushBtn2.frame = CGRectMake(SCREEN_WIDTH-0.0612*SCREEN_WIDTH-0.0306*SCREEN_WIDTH, (0.073*SCREEN_HEIGHT-0.0612*SCREEN_WIDTH)/2, 0.0612*SCREEN_WIDTH, 0.0612*SCREEN_WIDTH);
    [self getViewWithPicName:@"钱币详情" TitleText:str needBtn:btn needHub:NO WithTarget:nil AndX:0 AndY:0.0026*SCREEN_HEIGHT AndHeight:0.1284*SCREEN_HEIGHT addIntoView:self.moneyView];
    NSMutableAttributedString *outstr =  [[NSMutableAttributedString alloc] initWithString:@"支出明细"];;
    [self getViewWithPicName:@"支出明细" TitleText:outstr needBtn:pushBtn needHub:YES WithTarget:@selector(outPutMoneyDetails) AndX:0 AndY:0.1455*SCREEN_HEIGHT AndHeight:0.073*SCREEN_HEIGHT addIntoView:self.moneyView];
    NSMutableAttributedString *inputStr =  [[NSMutableAttributedString alloc] initWithString:@"收入明细"];;
    [self getViewWithPicName:@"收入明细" TitleText:inputStr needBtn:pushBtn2 needHub:YES WithTarget:@selector(inPutMoneyDetails) AndX:0 AndY:0.2211*SCREEN_HEIGHT AndHeight:0.073*SCREEN_HEIGHT addIntoView:self.moneyView];
}


-(void)addBeanViewControlsWithBean:(NSString *)bean{
    
        NSString *string = [NSString stringWithFormat:@"我的嗨豆：%@",bean];
        NSUInteger length = bean.length;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,length)];
        [self getViewWithPicName:@"开心豆" TitleText:str needBtn:nil needHub:NO WithTarget:nil AndX:0 AndY:0.0026*SCREEN_HEIGHT AndHeight:0.1284*SCREEN_HEIGHT addIntoView:self.beanView];
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setBackgroundImage:[UIImage imageNamed:@"右侧选择箭头"] forState:UIControlStateNormal];
    pushBtn.frame = CGRectMake(SCREEN_WIDTH-0.0612*SCREEN_WIDTH-0.0306*SCREEN_WIDTH, (0.073*SCREEN_HEIGHT-0.0612*SCREEN_WIDTH)/2, 0.0612*SCREEN_WIDTH, 0.0612*SCREEN_WIDTH);
    UIButton *pushBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn2 setBackgroundImage:[UIImage imageNamed:@"右侧选择箭头"] forState:UIControlStateNormal];
    pushBtn2.frame = CGRectMake(SCREEN_WIDTH-0.0612*SCREEN_WIDTH-0.0306*SCREEN_WIDTH, (0.073*SCREEN_HEIGHT-0.0612*SCREEN_WIDTH)/2, 0.0612*SCREEN_WIDTH, 0.0612*SCREEN_WIDTH);

    NSMutableAttributedString *outstr =  [[NSMutableAttributedString alloc] initWithString:@"支出明细"];;
    [self getViewWithPicName:@"支出明细" TitleText:outstr needBtn:pushBtn needHub:YES WithTarget:@selector(outPutBeanDetails) AndX:0 AndY:0.1455*SCREEN_HEIGHT AndHeight:0.073*SCREEN_HEIGHT addIntoView:self.beanView];
    NSMutableAttributedString *inputStr =  [[NSMutableAttributedString alloc] initWithString:@"收入明细"];;
    [self getViewWithPicName:@"收入明细" TitleText:inputStr needBtn:pushBtn2 needHub:YES WithTarget:@selector(inPutBeanDetails) AndX:0 AndY:0.2211*SCREEN_HEIGHT AndHeight:0.073*SCREEN_HEIGHT addIntoView:self.beanView];
}


-(void)getViewWithPicName:(NSString *)name TitleText:(NSMutableAttributedString *)title needBtn:(UIButton *)btn needHub:(BOOL)needHub WithTarget:(SEL)selector AndX:(CGFloat)X AndY:(CGFloat)Y AndHeight:(CGFloat)Height addIntoView:(UIView *)backView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(X, Y, SCREEN_WIDTH, Height)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    imageView.frame = CGRectMake(0.0306*SCREEN_WIDTH, (view.bounds.size.height-0.06*SCREEN_WIDTH)/2, 0.06*SCREEN_WIDTH, 0.06*SCREEN_WIDTH);
    [view addSubview:imageView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.1223*SCREEN_WIDTH, 0, SCREEN_WIDTH, view.bounds.size.height)];
    titleLabel.attributedText = title;
    titleLabel.font = [UIFont systemFontOfSize:0.043*SCREEN_WIDTH];
    if (btn) {
        [view addSubview:btn];
    }
    [view addSubview:titleLabel];
    if (needHub) {
        UIButton *hub = [UIButton buttonWithType:UIButtonTypeCustom];
        hub.frame = CGRectMake(0, 0, SCREEN_WIDTH, view.bounds.size.height);
        [hub addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        hub.backgroundColor = [UIColor clearColor];
        [view addSubview:hub];
    }
    
    [backView addSubview:view];
}



#pragma mark -----onclick------
-(void)moneyBtnClick:(UIButton *)sender{

    sender.selected = YES;
    [self clearView];
    [self.view addSubview:self.moneyView];
    self.beanBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.124*SCREEN_WIDTH)/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.124*SCREEN_WIDTH, 0.0052*SCREEN_HEIGHT);
    }];
}

-(void)beanBtnClick:(UIButton *)sender{

    sender.selected = YES;
    self.moneyBtn.selected = NO;
    [self clearView];
    [self.view addSubview:self.beanView];
    [UIView animateWithDuration:0.3 animations:^{
        self.separateView.frame = CGRectMake((SCREEN_WIDTH/2- 0.124*SCREEN_WIDTH)/2+SCREEN_WIDTH/2, self.topView.bounds.size.height-0.0026*SCREEN_HEIGHT, 0.124*SCREEN_WIDTH, 0.0052*SCREEN_HEIGHT);
    }];
}

-(void)pushRechargeView{

    YBZRechagrgeViewController *vc = [[YBZRechagrgeViewController alloc]initWithMoney:moneyRest];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)outPutMoneyDetails{

    YBZMoneyDetailsViewController *vc = [[YBZMoneyDetailsViewController alloc]initWithTitle:@"嗨币支出" AndType:@"money" AndInfo:moneyOutArray];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)inPutMoneyDetails{
    
    YBZMoneyDetailsViewController *vc = [[YBZMoneyDetailsViewController alloc]initWithTitle:@"嗨币收入" AndType:@"money" AndInfo:moneyInArray];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)outPutBeanDetails{

    YBZMoneyDetailsViewController *vc = [[YBZMoneyDetailsViewController alloc]initWithTitle:@"嗨豆支出" AndType:@"bean" AndInfo:beanOutArray ];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)inPutBeanDetails{
    
    YBZMoneyDetailsViewController *vc = [[YBZMoneyDetailsViewController alloc]initWithTitle:@"嗨豆收入" AndType:@"bean" AndInfo:beanInArray];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -----getters-----
-(UIView *)topView{

    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:self.moneyBtn];
        [_topView addSubview:self.beanBtn];
    }
    return  _topView;
}

-(UIButton *)moneyBtn{

    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyBtn setTitle:@"嗨币" forState:UIControlStateNormal];
        [_moneyBtn addTarget:self action:@selector(moneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:UIColorFromRGB(0xFED802) forState:UIControlStateSelected];
        _moneyBtn.selected = YES;
    }
    return _moneyBtn;
}

-(UIButton *)beanBtn{
    
    if (!_beanBtn) {
        _beanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beanBtn setTitle:@"嗨豆" forState:UIControlStateNormal];
        [_beanBtn addTarget:self action:@selector(beanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_beanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_beanBtn setTitleColor:UIColorFromRGB(0xFED802) forState:UIControlStateSelected];
    }
    return _beanBtn;
}


-(UIView *)separateView{

    if (!_separateView) {
        _separateView = [[UIView alloc]init];
        _separateView.backgroundColor = UIColorFromRGB(0xFED802);
    }
    return _separateView;
}

-(UIView *)moneyView{

    if (!_moneyView) {
        _moneyView = [[UIView alloc]init];
        _moneyView.backgroundColor = [UIColor clearColor ];
    }
    return _moneyView;
}

-(UIView *)beanView{
    
    if (!_beanView) {
        _beanView = [[UIView alloc]init];
        _beanView.backgroundColor = [UIColor clearColor];
    }
    return _beanView;
}

@end
