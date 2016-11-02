//
//  YBZCountDownViewController.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/10/28.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZCountDownViewController.h"
#import "YBZVideocontentViewController.h"

@interface YBZCountDownViewController ()
    @property(nonatomic,strong) UILabel *timeCountLabel;
    @property(nonatomic,strong) NSTimer *countTimer;
    @property(nonatomic,strong)UIButton *finishBtn;
@end

@implementation YBZCountDownViewController{

    int countNum;
    NSString *userchar;
    NSString *targetChar;
    
}

- (instancetype)initWithUserId:(NSString *)userId
                      targetId:(NSString *)targetId
                      countNum:(int)count
{
    self = [super init];
    if (self) {
        userchar=userId;
        targetChar=targetId;
        countNum=count;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    countNum=60;
    // Do any additional setup after loading the view.
    UIBarButtonItem *callBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"呼叫" style:UIBarButtonItemStylePlain target:self action:@selector(callClick)];
    
    self.navigationItem.rightBarButtonItem = callBtnItem;
    
    [self.view addSubview:self.timeCountLabel];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.timeCountLabel.frame=CGRectMake(50, 100, 200, 50);
    self.countTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(UILabel *)timeCountLabel{
    
    if(!_timeCountLabel){
        
        _timeCountLabel=[[UILabel alloc]init];
        _timeCountLabel.backgroundColor=[UIColor orangeColor];
        NSString *contentStr=[NSString stringWithFormat:@"%d",countNum];
        _timeCountLabel.text=contentStr;
    }
    return _timeCountLabel;
}
-(UIButton *)finishBtn{

    if(!_finishBtn){
    
        _finishBtn=[[UIButton alloc]init];
        [_finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.titleLabel.text=@"结束定制";
        
    }
    return _finishBtn;

}

-(void)finishBtnClick{

   NSLog(@"结束定制");
    
}


-(void)callClick{
    
    NSLog(@"呼叫");
    YBZVideocontentViewController *videoVC = [[YBZVideocontentViewController alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
    
}
-(void)timeFireMethod{

    countNum--;
    if(countNum==0){
        NSLog(@"运行一次");
        
        
        
        [self.countTimer invalidate];
    }
    
    NSString *contentStr=[NSString stringWithFormat:@"%d",countNum];
    self.timeCountLabel.text=contentStr;


}


@end
