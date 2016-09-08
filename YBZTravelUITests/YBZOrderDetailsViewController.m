//
//  YBZOrderDetailsViewController.m
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/3.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZOrderDetailsViewController.h"
#import "GTStarsScore.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "YBZOrderDetailsView.h"
@interface YBZOrderDetailsViewController ()<GTStarsScoreDelegate>
@property (nonatomic,strong) UIImageView *infoImageView;
@property (nonatomic,strong) UILabel *namelabel;
@property (nonatomic,strong) GTStarsScore *starsView;
@property (nonatomic,strong) UILabel *orderlabel;
@property (nonatomic,strong) UILabel *ordernumberlabel;
@property (nonatomic,strong) YBZOrderDetailsView *orderview;
@property (nonatomic,strong) UILabel *thankendlabel;
@end

@implementation YBZOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infoImageView];
    [self.view addSubview:self.namelabel];
    
    [self.view addSubview:self.starsView];
    [self.starsView setToValue:0.5];//设置分值
    [self.starsView toRemoveGesture];
    [self.view addSubview:self.orderlabel];
    [self.view addSubview:self.ordernumberlabel];
    [self.view addSubview:self.orderview];
    [self.view addSubview:self.thankendlabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.infoImageView.frame = CGRectMake(50, 114, 60, 60);
    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/8, SCREEN_WIDTH/8));
        make.top.equalTo(self.view).with.offset(94);
        make.left.equalTo(self.view).with.offset(30);
    }];

    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.top.equalTo(self.view).with.offset(100);
        make.left.equalTo(self.infoImageView).with.offset(10+SCREEN_WIDTH/8);

    }];
    [self.orderlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(SCREEN_HEIGHT/3.5);
    }];
    [self.ordernumberlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 15));
        make.top.equalTo(self.view).with.offset(110);
        make.left.equalTo(self.starsView).with.offset(85);
    }];
    
    self.orderview.frame = CGRectMake(0, SCREEN_HEIGHT/2.6, SCREEN_WIDTH ,SCREEN_HEIGHT/2.5);
    
    [self.thankendlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 35));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-30);
    }];
    
}

-(UIImageView *)infoImageView
{
    if(!_infoImageView)
    {
        _infoImageView = [[UIImageView alloc] init];
        _infoImageView.layer.masksToBounds = YES;
        _infoImageView.layer.cornerRadius = SCREEN_WIDTH/16;
        NSString *str = @"http://img1.imgtn.bdimg.com/it/u=262236517,3881457924&fm=206&gp=0.jpg";
        NSURL *url = [NSURL URLWithString:str];
        [_infoImageView sd_setImageWithURL:url];
    }
    return _infoImageView;
}

-(UILabel *)namelabel
{
    if(!_namelabel)
    {
        _namelabel = [[UILabel alloc] init];
        //_namelabel.backgroundColor = [UIColor redColor];
        _namelabel.text = @"天空蔚蓝";
    }
    return _namelabel;
}

-(UILabel *)orderlabel
{
    if(!_orderlabel)
    {
        _orderlabel = [[UILabel alloc] init];
        //_orderlabel.backgroundColor = [UIColor lightGrayColor];
        _orderlabel.layer.cornerRadius = 5;
        _orderlabel.textColor = [UIColor lightGrayColor];
        _orderlabel.textAlignment = NSTextAlignmentCenter;
        _orderlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _orderlabel.layer.borderWidth = 1.0;
        _orderlabel.text = @"订单状态，已完成";
    }
    return _orderlabel;
}

-(UILabel *)ordernumberlabel
{
    if(!_ordernumberlabel)
    {
        _ordernumberlabel = [[UILabel alloc] init];
        _ordernumberlabel.layer.borderWidth = 1.0;
        //_ordernumberlabel.backgroundColor = [UIColor lightGrayColor];
        _ordernumberlabel.text = @"75单";
        _ordernumberlabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _ordernumberlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ordernumberlabel;
}

-(UILabel *)thankendlabel
{
    if(!_thankendlabel)
    {
        _thankendlabel = [[UILabel alloc] init];
        //_thankendlabel.backgroundColor = [UIColor greenColor];
        _thankendlabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _thankendlabel.text = @"感谢您的评价，我们会继续努力的";
        _thankendlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thankendlabel;
}

-(YBZOrderDetailsView *)orderview
{
    if(!_orderview)
    {
        _orderview = [[YBZOrderDetailsView alloc] init];
        _orderview.backgroundColor = [UIColor whiteColor];
    }
    return _orderview;
}

-(GTStarsScore *)starsView{
    if(!_starsView){
        _starsView=[[GTStarsScore alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 108, 40, 14)];
        _starsView.delegate=self;
    }
    return _starsView;
}

- (void)starsScore:(GTStarsScore *)starsScore valueChange:(CGFloat)value
{
    NSLog(@"%f",value);
}

@end
