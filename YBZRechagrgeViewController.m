//
//  YBZRechagrgeViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZRechagrgeViewController.h"
#import "UIAlertController+SZYKit.h"
#import <StoreKit/StoreKit.h>
#import "SVProgressHUD.h"


@interface YBZRechagrgeViewController ()<SKProductsRequestDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UIButton *rechargeBtn;

@property (nonatomic,strong) NSArray *profuctIdArr;
@property (nonatomic,copy) NSString *currentProId;


@end

@implementation YBZRechagrgeViewController{

    NSDictionary *dict;
    NSDictionary *uploadInfo;
    NSString *money;
    NSArray *moneybiArr;
    NSArray *moneymoneyArr;
}

- (instancetype)initWithMoney:(NSString *)myMoney{
    self = [super init];
    if (self) {
        money = myMoney;
        self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
        self.title = @"充值";
        
        [self.view addSubview:self.contentView];
        [self addMoneyViewControlsWithMoney:money];
        [self getRechargeCenterViewWithInfo:dict];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.profuctIdArr = @[@"06",@"12",@"30",@"98",@"128",@"328"];
    moneybiArr = @[@"60",@"126",@"315",@"1078",@"1472",@"3772"];
    moneymoneyArr = @[@"6",@"12",@"30",@"98",@"128",@"328"];
    
}

-(void)addMoneyViewControlsWithMoney:(NSString *)moneystr{
    
    NSString *string = [NSString stringWithFormat:@"我的嗨币：%@",moneystr ];
    NSUInteger length = money.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,length)];
    
    [self getViewWithPicName:@"钱币详情" TitleText:str needBtn:nil needHub:NO WithTarget:nil AndX:0 AndY:64+0.0026*SCREEN_HEIGHT AndHeight:0.1284*SCREEN_HEIGHT addIntoView:self.view];
    
    
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


-(void)getRechargeCenterViewWithInfo:(NSDictionary *)info{

    [self getControlsWithInfo:info AndRow:3 AndNumberOfControls:6];
}

-(void)getControlsWithInfo:(NSDictionary *)info
                     AndRow:(CGFloat)row AndNumberOfControls:(int)number{

    for (int i=0; i<number; i++) {
        UIView *view = [[UIView alloc]init];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.0026*SCREEN_WIDTH;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.tag = 500+i;
        CGFloat width = (SCREEN_WIDTH-row*0.2845*SCREEN_WIDTH)/(row+1);
        CGFloat count;
        if ((i+1)%3 == 0) {
            count = 3;
        }else{
            count = (i+1)%3;
        }
        view.frame = CGRectMake(count*width+(count-1)*0.2845*SCREEN_WIDTH, ((int)(i/row)+1)*width+(int)(i/row)*0.1724*SCREEN_WIDTH, 0.2845*SCREEN_WIDTH, 0.1724*SCREEN_WIDTH);
        UILabel *moneyLabel = [[UILabel alloc]init];
        NSString *str =moneybiArr[i];
        int strint = [str intValue];
        [moneyLabel setText:[NSString stringWithFormat:@"%d嗨币",strint]];
        moneyLabel.textColor = [UIColor blackColor];
        moneyLabel.frame = CGRectMake(0, 0.0193*SCREEN_HEIGHT, view.bounds.size.width, 0.0289*SCREEN_HEIGHT);
        moneyLabel.font = [UIFont systemFontOfSize:0.043*SCREEN_WIDTH];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        UILabel *saleLabel = [[UILabel alloc]init];
        NSString *str2 =moneymoneyArr[i];
        int strint2 = [str2 intValue];
        [saleLabel setText:[NSString stringWithFormat:@"%d元",strint2]];
        saleLabel.textColor = [UIColor blackColor];
        saleLabel.frame = CGRectMake(0, 0.0578*SCREEN_HEIGHT, view.bounds.size.width, 0.0293*SCREEN_WIDTH);
        saleLabel.font = [UIFont systemFontOfSize:0.0293*SCREEN_WIDTH];
        saleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:moneyLabel];
        [view addSubview:saleLabel];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
        [btn setBackgroundColor:[UIColor clearColor]];
        [view addSubview:btn];
        [self.contentView addSubview:view];
        
    }
    
}



#pragma mark -----onclick-----
-(void)chooseMoney:(UIButton *)sender{

    UIView *view = sender.superview;
    [self clearView:view.superview];
    view.layer.borderColor = UIColorFromRGB(0xFED802).CGColor;
    uploadInfo = @{@"money":[NSString stringWithFormat:@"%ld",view.tag-500]};
}

-(void)clearView:(UIView *)view{

    for (UIView *subview in view.subviews) {
        if (subview.tag>=500) {
            subview.layer.borderColor = [UIColor grayColor].CGColor;
        }
    }
}





#pragma mark -----getters-----
-(UIView *)contentView{

    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+2*0.0026*SCREEN_HEIGHT+0.1284*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (64+2*0.0026*SCREEN_HEIGHT+0.1284*SCREEN_HEIGHT))];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:self.rechargeBtn];
    }
    return _contentView;
}


-(UIButton *)rechargeBtn{

    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rechargeBtn.backgroundColor = UIColorFromRGB(0xFED802);
        [_rechargeBtn addTarget:self action:@selector(gotoRecharge:) forControlEvents:UIControlEventTouchUpInside];
        _rechargeBtn.frame = CGRectMake(0.0379*SCREEN_WIDTH, 0.607*SCREEN_HEIGHT, SCREEN_WIDTH-2*0.0379*SCREEN_WIDTH, 0.0867*SCREEN_HEIGHT);
        }
    return _rechargeBtn;
}



//-(void)gotoRecharge:(UIButton*)sender{
//    
//    NSLog(@"gotoRecharge:%@",uploadInfo[@"money"]);
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"恭喜您！充值成功！" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//        
//    }];
//    
//}

- (void)gotoRecharge:(UIButton *)button
{
    NSLog(@"gotoRecharge:%@",uploadInfo[@"money"]);
    int a = [uploadInfo[@"money"]intValue];
    NSString *product = self.profuctIdArr[a];
    _currentProId = product;
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:product];
    }else{
        NSLog(@"不允许程序内付费");
    }
}

//请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        [SVProgressHUD dismiss];
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_currentProId]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    [SVProgressHUD dismiss];
    NSLog(@"------------反馈信息结束-----------------");
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)dealloc{
    //    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
