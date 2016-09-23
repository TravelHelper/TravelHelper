//
//  ViewController.m
//  Evaluate
//
//  Created by sks on 16/7/13.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "FeedBackViewController.h"
#import "PeoPle.h"
#import "EvaluatePeopleCell.h"
#import "CellFrameInfo.h"
#import "GTStarsScore.h"
#import "AFNetworking.h"
#import "WebAgent.h"
#import "YBZInterpretViewController.h"
#import "complaintViewController.h"
#import "NSString+SZYKit.h"
#import "UIAlertController+SZYKit.h"
#import "MBProgressHUD+XMG.h"

#define kScreenWindth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface FeedBackViewController ()<GTStarsScoreDelegate>
//@property (nonatomic , strong) UITableView *mainTabViwe;
@property (nonatomic, strong)   UIView *infoView;
@property (nonatomic , strong) NSArray *dataArr;
@property (nonatomic , strong) UIImageView *userIconImageV;
//@property (nonatomic , strong) NSString *translator_id;
@property (nonatomic , strong) NSString *user_id;
@property (nonatomic , strong) NSString *evaluate_infotext;
@property (nonatomic , strong) NSString *target_id;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) GTStarsScore *starView;
@property (nonatomic, strong) UIButton *tipoffBtn;
@property (nonatomic, strong) UIButton *alphaBtn;

@property (nonatomic, strong) UIButton *orderBtn;


@end

@implementation FeedBackViewController{

    float starValue;
    MBProgressHUD *HUD;
}


- (instancetype)initWithtargetID:(NSString *)targetID
{
    self = [super init];
    if (self) {
        self.target_id=targetID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"口语即时评价";
    [self.view addSubview:self.infoView];
    [self.infoView addSubview:self.userIconImageV];
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.starView];
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.tipoffBtn];
    [self.view addSubview:self.alphaBtn];
//    [self.view addSubview:self.orderBtn];
    //加载数据
    [self loadDateFromWeb];
    [self initLeftButton];
    
    //背景色
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *str=[NSString stringWithFormat:@"%@.jpg",self.target_id];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/TravelHelper/uploadimg/%@",serviseId,str];
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    UIImage *headImg=[[UIImage alloc]init];
    headImg=[UIImage imageWithData:data];
    if(headImg){
        [self.userIconImageV setImage:headImg];
        //            self.headImageView.image=headImg;
    }else{
        headImg = [UIImage imageNamed:@"translator"];
        [self.userIconImageV setImage:headImg];
        //            self.headImageView.image=headImg;
    }

}



- (void)starsScore:(GTStarsScore *)starsScore valueChange:(CGFloat)value{
    
    
    starValue=value/2;
    
    
    if(starValue>0.4){
        
        starValue=0.5;
        [self.starView setToValue:starValue*2];
    }else if(starValue>0.3){
        starValue=0.4;
        [self.starView setToValue:starValue*2];
    }else if(starValue>0.2){
        starValue=0.3;
        [self.starView setToValue:starValue*2];
    }
    else if(starValue>0.1){
        starValue=0.2;
        [self.starView setToValue:starValue*2];
    }else if(starValue>0.05){
        starValue=0.1;
        [self.starView setToValue:starValue*2];
    }else{
        starValue=0;
        [self.starView setToValue:0];
    }
    
    NSLog(@"%lf",starValue);
    
}


#pragma mark - 投诉跳转
//-(void)complaintClick
//{
//    complaintViewController *comVC = [[complaintViewController alloc]init];
//    [self.navigationController pushViewController:comVC animated:YES];
//}

-(void)initLeftButton
{
   
    //左上角的按钮
    UIButton *boultButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.08*kScreenWindth, 0.08*kScreenWindth)];
    [boultButton setImage:[UIImage imageNamed:@"toback"] forState:UIControlStateNormal];
    [boultButton addTarget:self action:@selector(interpretClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:boultButton];
}

#pragma mark - 评价跳转
//- (void)elalateClick
//{
//    //系统时间
//    NSDate *sendDate = [NSDate date];
//    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *translation_id = [NSString stringOfUUID];
//    
//    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
//    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
//    self.user_id = user_id[@"user_id"];
//    
//
//    
//    if (self.evaluate_infotext != nil)
//    {
//        
//        [WebAgent translator_id:self.translator_id valuator_id:self.user_id evaluate_infostar:value  evaluate_infotext:self.evaluate_infotext translation_id:translation_id  success:^(id responseObject) {
//            
//        
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error);
//            
//        
//        }];
//    }
//    else
//    {
//    [WebAgent translator_id:self.translator_id valuator_id:user_id[@"user_id"] evaluate_infostar:value  evaluate_infotext:@"" translation_id:translation_id success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        
//    }];
//    
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}
#pragma mark - 箭头跳转
- (void)interpretClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}




#pragma mark - 数据源
-(void)loadDateFromWeb
{
//    self.translator_id = @"7777";
    [WebAgent user_id:self.target_id success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *info = dic[@"user_info"];
        
        NSString *name=info[@"user_nickname"];
        
        [self.nameLabel setText:name];
//
//        PeoPle *people1 = [[PeoPle alloc] initWitAvaterImageName:[self setPeopleImage:@"photo"] nickName:info[@"user_nickname"] complaint:@"投诉"];
//        self.dataArr = @[people1];
        
      
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    
}

-(void)sendClick{

    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
    
    
    NSString *stringFloat = [NSString stringWithFormat:@"%.1f",starValue*10];
    
    
    
//    NSString *messageContent=[NSString stringWithFormat:@"当前评价分数为:%@颗星星，是否确认？",stringFloat];
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:messageContent cancelTitle:@"确定" confirmTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
    [MBProgressHUD showMessage:@"评价中..."];
        [WebAgent UpdateUserMessageWithID:mseeage_id andStar:stringFloat andMoney:@"0" success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"评价成功！正在为您返回主页"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"评价失败,请检查网络"];
        }];
        
        
        
        
        
//    } confirmHandler:^(UIAlertAction *action) {
//        
//    }];
    
    
    
    
  }

-(void)tipoffClick{

    complaintViewController *comVC = [[complaintViewController alloc]initWithTargetId:self.target_id];
    [self.navigationController pushViewController:comVC animated:YES];
    
}

-(void)alphaBtnClick{

    NSLog(@"1");

}

-(void)orderClick{

    NSLog(@"预约");

}

////第三步：处理通知
//-(void)complaintText:(NSNotification *)noti{
//    NSDictionary *textDic = [noti userInfo];
//    self.evaluate_infotext = [textDic objectForKey:@"投诉"];
//}
//第四步：移除通知
-(void)dealloc{
    //    free((__bridge void *)(self.textALabel));
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"complaintText" object:nil];
}

-(UIView *)infoView{

    if(!_infoView){
        _infoView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.062+64, self.view.bounds.size.width, 80)];
        _infoView.backgroundColor=[UIColor whiteColor];
    }
    return _infoView;
}
-(UIImageView *)userIconImageV{

    if(!_userIconImageV){
    
        _userIconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
        _userIconImageV.layer.masksToBounds=YES;
        _userIconImageV.layer.cornerRadius=50/2.0f;
        _userIconImageV.layer.borderWidth=1.0f;
        _userIconImageV.layer.borderColor=[[UIColor whiteColor] CGColor];
        _userIconImageV.backgroundColor=[UIColor orangeColor];
//        self.userIconImageV.image = [UIImage imageNamed:imag];
    
    }
    return _userIconImageV;
}

-(UILabel *)nameLabel{

    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 15, 100, 50)];
//        _nameLabel.backgroundColor=[UIColor orangeColor];
    }
    return _nameLabel;
}

-(UIButton *)sendBtn{
    
    if(!_sendBtn){
    
        _sendBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.062+64+150, self.view.bounds.size.width, 60)];
        _sendBtn.backgroundColor=UIColorFromRGB(0xffd703);
//        _sendBtn.titleLabel.text=@"提交评价";
//        _sendBtn.titleLabel.textColor=[UIColor blackColor];
//        _sendBtn.titleLabel.font=[UIFont systemFontOfSize:22.5];
        [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=[UIFont systemFontOfSize:22.5];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
    }
    return  _sendBtn;

}

-(GTStarsScore *)starView{

    if(!_starView){
    
        _starView=[[GTStarsScore alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-0.4*self.view.bounds.size.width, 25, 0, 0.04*self.view.bounds.size.height)];
        _starView.delegate=self;
        
    }
    return _starView;
    
}

-(UIButton *)tipoffBtn{

    if(!_tipoffBtn){
    
        _tipoffBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-0.2*self.view.bounds.size.width, kScreenHeight*0.062+24, 80, 40)];
        [_tipoffBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [_tipoffBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_tipoffBtn addTarget:self action:@selector(tipoffClick) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
    return _tipoffBtn;
    
}

-(UIButton *)alphaBtn{

    if(!_alphaBtn){
    
        _alphaBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, kScreenHeight*0.062+64, 170, 80)];
        _alphaBtn.backgroundColor=[UIColor clearColor];
        [_alphaBtn addTarget:self action:@selector(alphaBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _alphaBtn;

}

-(UIButton *)orderBtn{

    if(!_orderBtn){
        _orderBtn=[[UIButton alloc]initWithFrame:CGRectMake(300, 400, 100, 50)];
        [_orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
        _orderBtn.backgroundColor=[UIColor orangeColor];
    }
    return _orderBtn;

}

@end
