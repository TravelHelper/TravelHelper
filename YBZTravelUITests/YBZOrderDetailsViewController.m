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

@interface YBZOrderDetailsViewController ()<GTStarsScoreDelegate>
@property (nonatomic,strong) UIImageView *infoImageView;
@property (nonatomic,strong) UILabel *namelabel;
@property (nonatomic,strong) GTStarsScore *starsView;
@property (nonatomic,strong)  UILabel *orderlabel;
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
        make.top.equalTo(self.view).with.offset(200);
    }];
    
}

-(UIImageView *)infoImageView
{
    if(!_infoImageView)
    {
        _infoImageView = [[UIImageView alloc] init];
        _infoImageView.backgroundColor = [UIColor greenColor];
        _infoImageView.layer.cornerRadius = SCREEN_WIDTH/16;
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
        _orderlabel.layer.cornerRadius = 10;
        _orderlabel.textColor = [UIColor lightGrayColor];
        _orderlabel.textAlignment = NSTextAlignmentCenter;
        _orderlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _orderlabel.layer.borderWidth = 2.0;
        _orderlabel.text = @"订单状态，已完成";
    }
    return _orderlabel;
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
    
}

@end
