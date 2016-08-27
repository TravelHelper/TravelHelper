//
//  YBZOtherViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/8/4.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZOtherViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface YBZOtherViewController ()
@property (nonatomic,strong) UILabel  *headLabel;
@property (nonatomic,strong) UIButton *MeiyuBtn;
@property (nonatomic,strong) UIButton *HanYuBtn;
@property (nonatomic,strong) UIButton *BoLanBtn;
@property (nonatomic,strong) UIButton *XiBanYaBtn;
@property (nonatomic,strong) UIButton *TaiYuBtn;
@property (nonatomic,strong) UIButton *ALaBoBtn;
@property (nonatomic,strong) UIButton *EYuBtn;
@property (nonatomic,strong) UIButton *PuTaoYaBtn;
@property (nonatomic,strong) UIButton *XiLaBtn;
@property (nonatomic,strong) UIButton *DanMaiBtn;
@property (nonatomic,strong) UIButton *FenLanBtn;
@property (nonatomic,strong) UIButton *JieKeBtn;
@property (nonatomic,strong) UIButton *RuiDianBtn;
@property (nonatomic,strong) UIButton *XiongYaLiBtn;
@property (nonatomic,strong) UIButton *HeLanBtn;
@property (nonatomic,strong) UIButton *yesBtn;
@property (nonatomic,strong) UIButton *returnBtn;
@property (nonatomic,strong) NSMutableArray *allLangage;



@end

@implementation YBZOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headLabel];
    [self.view addSubview:self.MeiyuBtn];
    [self.view addSubview:self.HanYuBtn];
    [self.view addSubview:self.BoLanBtn];
    [self.view addSubview:self.XiBanYaBtn];
    [self.view addSubview:self.TaiYuBtn];
    [self.view addSubview:self.ALaBoBtn];
    [self.view addSubview:self.EYuBtn];
    [self.view addSubview:self.PuTaoYaBtn];
    [self.view addSubview:self.DanMaiBtn];
    [self.view addSubview:self.FenLanBtn];
    [self.view addSubview:self.JieKeBtn];
    [self.view addSubview:self.RuiDianBtn];
    [self.view addSubview:self.XiongYaLiBtn];
    [self.view addSubview:self.HeLanBtn];
    [self.view addSubview:self.XiLaBtn];
    [self.view addSubview:self.yesBtn];
    [self.view addSubview:self.returnBtn];
    self.view.backgroundColor = UIColorFromRGB(0xffd703);
    //注册观察者
}
    // Do any additional setup after loading the view.

#pragma mark - getter
-(NSMutableArray *)allLangage{
    if (!_allLangage) {
        _allLangage = [[NSMutableArray alloc]init];
    }
    return _allLangage;
}
-(UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-80, 20, 200, 50)];
        _headLabel.text = @"语   言   选   择";
        _headLabel.font = [UIFont systemFontOfSize:25];
    }
    return _headLabel;
}
-(UIButton *)MeiyuBtn{
    if (!_MeiyuBtn) {
        _MeiyuBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7, CGRectGetMaxY(self.headLabel.frame)+30, 50, 50)];
        [_MeiyuBtn setImage:[UIImage imageNamed:@"美国"] forState:UIControlStateNormal];
        [_MeiyuBtn addTarget:self action:@selector(MeiyuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_MeiyuBtn setSelected:YES];
    }
    return _MeiyuBtn;
}
-(UIButton *)HanYuBtn{
    if (!_HanYuBtn) {
        _HanYuBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*3,  CGRectGetMaxY(self.headLabel.frame)+30, 50, 50)];
        [_HanYuBtn setImage:[UIImage imageNamed:@"韩国"] forState:UIControlStateNormal];
        [_HanYuBtn addTarget:self action:@selector(HanYuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_HanYuBtn setSelected:YES];
    }
    return _HanYuBtn;
}
-(UIButton *)BoLanBtn{
    if (!_BoLanBtn) {
        _BoLanBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*5, CGRectGetMaxY(self.headLabel.frame)+30 , 50, 50)];
        [_BoLanBtn setImage:[UIImage imageNamed:@"波兰"] forState:UIControlStateNormal];
        [_BoLanBtn addTarget:self action:@selector(BoLanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_BoLanBtn setSelected:YES];

    }
    return _BoLanBtn;
}
-(UIButton *)XiBanYaBtn{
    if (!_XiBanYaBtn) {
        _XiBanYaBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7, CGRectGetMaxY(self.HanYuBtn.frame)+30, 50, 50)];
        [_XiBanYaBtn setImage:[UIImage imageNamed:@"西班牙"] forState:UIControlStateNormal];
        [_XiBanYaBtn addTarget:self action:@selector(XiBanYaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_XiBanYaBtn setSelected:YES];

    }
    return _XiBanYaBtn;
}
-(UIButton *)TaiYuBtn{
    if (!_TaiYuBtn) {
        _TaiYuBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*3, CGRectGetMaxY(self.HanYuBtn.frame)+30, 50, 50)];
        [_TaiYuBtn setImage:[UIImage imageNamed:@"泰国"] forState:UIControlStateNormal];
        [_TaiYuBtn addTarget:self action:@selector(TaiYuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_TaiYuBtn setSelected:YES];

    }
    return _TaiYuBtn;
}
-(UIButton *)ALaBoBtn{
    if (!_ALaBoBtn) {
        _ALaBoBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*5, CGRectGetMaxY(self.HanYuBtn.frame)+30 , 50, 50)];
        [_ALaBoBtn setImage:[UIImage imageNamed:@"沙特阿拉伯"] forState:UIControlStateNormal];
            [_ALaBoBtn addTarget:self action:@selector(ALaBoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ALaBoBtn setSelected:YES];

    }
    return _ALaBoBtn;
}
-(UIButton *)EYuBtn{
    if (!_EYuBtn) {
        _EYuBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7, CGRectGetMaxY(self.XiBanYaBtn.frame)+30, 50, 50)];
        [_EYuBtn setImage:[UIImage imageNamed:@"俄罗斯"] forState:UIControlStateNormal];
      [_EYuBtn addTarget:self action:@selector(EYuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_EYuBtn setSelected:YES];

    }
    return _EYuBtn;
}
-(UIButton *)PuTaoYaBtn{
    if (!_PuTaoYaBtn) {
        _PuTaoYaBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*3, CGRectGetMaxY(self.XiBanYaBtn.frame)+30, 50, 50)];
        [_PuTaoYaBtn setImage:[UIImage imageNamed:@"葡萄牙"] forState:UIControlStateNormal];
        [_PuTaoYaBtn addTarget:self action:@selector(PuTaoYaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_PuTaoYaBtn setSelected:YES];

    }
    return _PuTaoYaBtn;
}
-(UIButton *)XiLaBtn{
    if (!_XiLaBtn) {
        _XiLaBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*5, CGRectGetMaxY(self.XiBanYaBtn.frame)+30 , 50, 50)];
        [_XiLaBtn setImage:[UIImage imageNamed:@"希腊"] forState:UIControlStateNormal];
        [_XiLaBtn addTarget:self action:@selector(XiLaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_XiLaBtn setSelected:YES];


    }
    return _XiLaBtn;
}







-(UIButton *)HeLanBtn{
    if (!_HeLanBtn) {
        _HeLanBtn =  [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7, CGRectGetMaxY(self.XiLaBtn.frame)+30, 50, 50)];
        [_HeLanBtn setImage:[UIImage imageNamed:@"荷兰"] forState:UIControlStateNormal];
        [_HeLanBtn addTarget:self action:@selector(HeLanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_HeLanBtn setSelected:YES];
        
        
    }
    return _HeLanBtn;
}

-(UIButton *)DanMaiBtn{
    if (!_DanMaiBtn) {
        _DanMaiBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*3, CGRectGetMaxY(self.XiLaBtn.frame)+30, 50, 50)];
        [_DanMaiBtn setImage:[UIImage imageNamed:@"丹麦"] forState:UIControlStateNormal];
        [_DanMaiBtn addTarget:self action:@selector(DanMaiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_DanMaiBtn setSelected:YES];


    }
    return _DanMaiBtn;
}
-(UIButton *)FenLanBtn{
    if (!_FenLanBtn) {
        _FenLanBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*5, CGRectGetMaxY(self.XiLaBtn.frame)+30 , 50, 50)];
        [_FenLanBtn setImage:[UIImage imageNamed:@"芬兰"] forState:UIControlStateNormal];
        [_FenLanBtn addTarget:self action:@selector(FenLanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_FenLanBtn setSelected:YES];


    }
    return _FenLanBtn;
}
-(UIButton *)JieKeBtn{
    if (!_JieKeBtn) {
        _JieKeBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7, CGRectGetMaxY(self.FenLanBtn.frame)+30, 50, 50)];
        [_JieKeBtn setImage:[UIImage imageNamed:@"捷克"] forState:UIControlStateNormal];
        [_JieKeBtn addTarget:self action:@selector(JieKeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_JieKeBtn setSelected:YES];


    }
    return _JieKeBtn;
}
-(UIButton *)RuiDianBtn{
    if (!_RuiDianBtn) {
        _RuiDianBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*3, CGRectGetMaxY(self.FenLanBtn.frame)+30, 50, 50)];
        [_RuiDianBtn setImage:[UIImage imageNamed:@"瑞典"] forState:UIControlStateNormal];
        [_RuiDianBtn addTarget:self action:@selector(RuiDianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_RuiDianBtn setSelected:YES];


    }
    return _RuiDianBtn;
}
-(UIButton *)XiongYaLiBtn{
    if (!_XiongYaLiBtn) {
        _XiongYaLiBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/7*5, CGRectGetMaxY(self.FenLanBtn.frame)+30 , 50, 50)];
        [_XiongYaLiBtn setImage:[UIImage imageNamed:@"匈牙利"] forState:UIControlStateNormal];
        [_XiongYaLiBtn addTarget:self action:@selector(XiongYaLiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_XiongYaLiBtn setSelected:YES];


    }
    return _XiongYaLiBtn;
}
-(UIButton *)yesBtn{
    if (!_yesBtn) {
        _yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-70, 100, 50)];
        _yesBtn.backgroundColor = [UIColor whiteColor];
        [_yesBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_yesBtn addTarget:self action:@selector(yesBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _yesBtn;
}
-(UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, [UIScreen mainScreen].bounds.size.height-70, 100, 50)];
        _returnBtn.backgroundColor = [UIColor whiteColor];
        [_returnBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(returnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}
#pragma mark - 响应事件
-(void)MeiyuBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"MeiYu"];
        [_MeiyuBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"MeiYu"];
        _MeiyuBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)HanYuBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"HanYu"];
        [_HanYuBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"HanYu"];
        _HanYuBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)BoLanBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"BoLanYu"];
        [_BoLanBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"BoLanYu"];
        _BoLanBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)XiBanYaBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"XiBanYa"];
        [_XiBanYaBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"XiBanYa"];
        _XiBanYaBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)TaiYuBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"TaiYu"];
        [_TaiYuBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"TaiYu"];
        _TaiYuBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)ALaBoBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"ALaBoYu"];
        [_ALaBoBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"ALaBoYu"];
        _ALaBoBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)EYuBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"EYu"];
        [_EYuBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"EYu"];
        _EYuBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)PuTaoYaBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"PuTaoYaYu"];
        [_PuTaoYaBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"PuTaoYaYu"];
        _PuTaoYaBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)DanMaiBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"DanMaiYu"];
        [_DanMaiBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"DanMaiYu"];
        _DanMaiBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)FenLanBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"FenLanYu"];
        [_FenLanBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"FenLanYu"];
        _FenLanBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)JieKeBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"JieKeYu"];
        [_JieKeBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"JieKeYu"];
        _JieKeBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)RuiDianBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"RuiDianYu"];
        [_RuiDianBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"RuiDianYu"];
        _RuiDianBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)XiongYaLiBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"XiongYaLiYu"];
        [_XiongYaLiBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"XiongYaLiYu"];
        _XiongYaLiBtn.backgroundColor = [UIColor grayColor];
    }
    
}
//[self.view addSubview:self.HeLanBtn];
//[self.view addSubview:self.XiLaBtn];
-(void)HeLanBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"HeLanYu"];
        [_HeLanBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"HeLanYu"];
        _HeLanBtn.backgroundColor = [UIColor grayColor];
    }
    
}
-(void)XiLaBtnClick:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        [self.allLangage removeObject:@"XiLaYu"];
        [_XiLaBtn setBackgroundColor:[UIColor clearColor]];
    }else{
        //实现打勾的方法
        [self.allLangage addObject:@"XiLaYu"];
        _XiLaBtn.backgroundColor = [UIColor grayColor];
    }
    
}

-(void)yesBtnClick{
    //发出信号
       NSLog(@"%@",self.allLangage);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendData" object:self userInfo:@{@"data":self.allLangage}];
 
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)returnBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
