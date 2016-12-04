//
//  YBZPrepareViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZPrepareViewController.h"
#import "FeedBackViewController.h"
#import "UIAlertController+SZYKit.h"
#import "YBZTargetWaitingViewController.h"
#import "MBProgressHUD+XMG.h"

@interface YBZPrepareViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBZPrepareViewController{

    NSDictionary *dataInfo;
    NSString *chatType;
    UILabel *firstLabel;
    CGRect firstLabelFrame;
    UILabel *secondLabel;
    CGRect secondLabelFrame;
    UILabel *thirdLabel;
    CGRect thirdLabelFrame;
    UILabel *forthLabel;
    CGRect forthLabelFrame;
    UILabel *firstState;
    UILabel *secondState;
    UILabel *thirdState;
    UILabel *forthState;
    UILabel *firstTime;
    UILabel *secondTime;
    UILabel *thirdTime;
    UILabel *forthTime;
    UIView *firstLine;
    UIView *secondLine;
    UIView *thirdLine;
    UIButton *firstBtn;
    UIButton *secondBtn;
    UIButton *thirdBtn;
    UIButton *forthBtn;
    UITableView *thirdStateTableView;
    int proceedState;
    int countDownTime;
    NSTimer *countDownTimer;
    NSString *userName;
    BOOL needPush;
    NSString *secondTimeInfo;
    NSTimer *nowTimer;
    int nowTimerNum;
    int fullTime;
    long fullTimeTime;
    long nowTimeNum;
    BOOL canClick;
    
    
    
}

- (instancetype)initWithType:(NSString *)type AndState:(NSString *)state AndInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        dataInfo = info;
        if ([info[@"success"] isEqualToString:@"success"]) {
            needPush = YES;
        }else{
            needPush = NO;
        }
        if (![dataInfo[@"iden"] isEqualToString:@"USER"]) {
            canClick = NO;
        }else{
            canClick = YES;
            }
        NSString *custom_time = dataInfo[@"custom_time"];
        NSString *duration = dataInfo[@"duration"];
        long customTime = [self changeTimeToSecond:custom_time];
        int  a= [[duration substringWithRange:NSMakeRange(0,2)] intValue];
        int b = [[duration substringWithRange:NSMakeRange(3, 2)]intValue];
        float addTime = a*3600+b*60;
        fullTimeTime = customTime + addTime;
        NSString *timeNow = [self getNowTime];
        nowTimeNum = [self changeTimeToSecond:timeNow];

        
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changViewWithState) name:@"changViewWithState" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTableViewData:) name:@"changeTableViewData" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishCustomTranslate) name:@"finishCustomTranslate" object:nil];

        nowTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nowTimerClick:) userInfo:nil repeats:YES];
        [nowTimer fire];

        

        
        [WebAgent getNameWithID:dataInfo[@"user_name"] success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *name = dict[@"name"];
            userName = name;
            if (proceedState != 1) {
                secondState.text = [NSString stringWithFormat:@"%@ 已进入准备页面",name];
            }
        } failure:^(NSError *error) {
            
        }];
        if ([type isEqualToString:@"语音"]) {
            chatType = @"语音呼叫";
        }else if ([type isEqualToString:@"视频"]){
            chatType = @"视频呼叫";
        }
            
        if ([state isEqualToString:@"0001"]) {
            proceedState = 1;
        }else if ([state isEqualToString:@"0002"]) {
            proceedState = 2;
        }else if ([state isEqualToString:@"0003"]) {
            proceedState = 3;
        }else if ([state isEqualToString:@"0004"]) {
            proceedState = 4;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"准备";
    [self addAllControls];
    
//    if (hasKye.length != 0) {
//        NSDictionary *infodic = [userinfo dictionaryForKey:dataInfo[@"mission_id"]];
//        secondTimeInfo = infodic[@"second_time"];
//    }else{
//        secondTimeInfo = @"对方未进入";
//    }
}



-(void)viewWillAppear:(BOOL)animated{

    if (needPush == YES && proceedState ==2) {
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        NSDictionary *dict = [userinfo objectForKey:dataInfo[@"mission_id"]];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSString *time = [self getNowTime];
        [dictionary setObject:time forKey:@"second_time"];
        [userinfo setObject:dictionary forKey:dataInfo[@"mission_id"]];
        secondTime.text = time;
        [WebAgent sendRemoteNotificationsWithuseId:dataInfo[@"user_name"] WithsendMessage:@"对方已经进入准备页面，即将开始您的定制翻译" WithType:@"9001" WithSenderID:user_id[@"user_id"] WithMessionID:dataInfo[@"mission_id"] WithLanguage:@"" success:^(id responseObject) {
            NSLog(@"success");

        } failure:^(NSError *error) {
            
        }];
    }
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userinfo dictionaryForKey:dataInfo[@"mission_id"]];
    if (dic == nil) {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:array forKey:@"call_info"];
        [userinfo setObject:dictionary forKey:dataInfo[@"mission_id"]];
    }else if (dic != nil && (proceedState == 3||proceedState == 4)){
        [thirdStateTableView reloadData];
    }
    
    
    [WebAgent updateStateWithCustomID:dataInfo[@"mission_id"] success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)addAllControls{
    [self getFourNumberLabel];
    [self getFourStateLabel];
    [self getThreeLineWithState];
    [self getFourTimeLabel];
    [self getFourButton];
    [self changeFrameWithState:proceedState];
}

-(void)getFourFrameWithState:(int)state{

    
    switch (state) {
        case 1:
            firstLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 64+0.0756*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            secondLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.4420*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            thirdLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.621*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            forthLabelFrame = CGRectMake(0.127*SCREEN_WIDTH,0.8*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            break;
        case 2:
            firstLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 64+0.0756*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            secondLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.288*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            thirdLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.503*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            forthLabelFrame = CGRectMake(0.127*SCREEN_WIDTH,0.8897*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            break;
        case 3:
            firstLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 64+0.0756*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            secondLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.288*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            thirdLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.503*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            forthLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.8897*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            break;
        case 4:
            firstLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 64+0.0756*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            secondLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.288*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            thirdLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.419*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            forthLabelFrame = CGRectMake(0.127*SCREEN_WIDTH, 0.703*SCREEN_HEIGHT, 0.0794*SCREEN_WIDTH, 0.0794*SCREEN_WIDTH);
            break;
            
        default:
            break;
    }
}




-(void)getFourNumberLabel{
    [self getFourFrameWithState:proceedState];
    firstLabel = [[UILabel alloc]init];
    firstLabel.textColor = [UIColor whiteColor];
    firstLabel.backgroundColor = UIColorFromRGB(0xF3D129);
    firstLabel.layer.masksToBounds = YES;
    firstLabel.layer.cornerRadius = 0.0794*SCREEN_WIDTH/2;
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.text = @"1";
    firstLabel.frame = firstLabelFrame;
    firstLabel.font = [UIFont systemFontOfSize:0.0794*SCREEN_WIDTH*0.8];
    [self.view addSubview:firstLabel];
    secondLabel = [[UILabel alloc]init];
    secondLabel.textColor = [UIColor whiteColor];
    secondLabel.backgroundColor = UIColorFromRGB(0xF3D129);
    secondLabel.layer.masksToBounds = YES;
    secondLabel.layer.cornerRadius = 0.0794*SCREEN_WIDTH/2;
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.text = @"2";
    secondLabel.frame = secondLabelFrame;
    secondLabel.font = [UIFont systemFontOfSize:0.0794*SCREEN_WIDTH*0.8];
    [self.view addSubview:secondLabel];
    thirdLabel = [[UILabel alloc]init];
    thirdLabel.textColor = [UIColor whiteColor];
    thirdLabel.backgroundColor = UIColorFromRGB(0xF3D129);
    thirdLabel.layer.masksToBounds = YES;
    thirdLabel.layer.cornerRadius = 0.0794*SCREEN_WIDTH/2;
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.text = @"3";
    thirdLabel.frame = thirdLabelFrame;
    thirdLabel.font = [UIFont systemFontOfSize:0.0794*SCREEN_WIDTH*0.8];
    [self.view addSubview:thirdLabel];
    forthLabel = [[UILabel alloc]init];
    forthLabel.textColor = [UIColor whiteColor];
    forthLabel.backgroundColor = UIColorFromRGB(0xF3D129);
    forthLabel.layer.masksToBounds = YES;
    forthLabel.layer.cornerRadius = 0.0794*SCREEN_WIDTH/2;
    forthLabel.textAlignment = NSTextAlignmentCenter;
    forthLabel.text = @"4";
    forthLabel.frame = forthLabelFrame;
    forthLabel.font = [UIFont systemFontOfSize:0.0794*SCREEN_WIDTH*0.8];
    [self.view addSubview:forthLabel];
    
}

-(void)getFourStateLabel{

    firstState = [[UILabel alloc]init];
    firstState.textColor = [UIColor blackColor];
    firstState.backgroundColor = [UIColor clearColor];
    firstState.textAlignment = NSTextAlignmentLeft;
    firstState.numberOfLines = 0;
    firstState.text = @"您已进入准备页面，请耐心等候对方进入…";
    firstState.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, firstLabelFrame.origin.y-(0.0712*SCREEN_HEIGHT-0.0794*SCREEN_WIDTH)/2, 0.603*SCREEN_WIDTH, 0.0712*SCREEN_HEIGHT);
    firstState.font = [UIFont systemFontOfSize:0.0407*SCREEN_WIDTH];
    [self.view addSubview:firstState];
    secondState = [[UILabel alloc]init];
    secondState.textColor = [UIColor blackColor];
    secondState.backgroundColor = [UIColor clearColor];
    secondState.textAlignment = NSTextAlignmentLeft;
    secondState.text = @"等待对方进入等候页面…";
    secondState.frame = CGRectMake(secondLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, secondLabelFrame.origin.y-(0.0712*SCREEN_HEIGHT-0.0794*SCREEN_WIDTH)/2, 0.603*SCREEN_WIDTH, 0.0712*SCREEN_HEIGHT);
    secondState.font = [UIFont systemFontOfSize:0.0407*SCREEN_WIDTH];
    [self.view addSubview:secondState];
    thirdState = [[UILabel alloc]init];
    thirdState.textColor = [UIColor blackColor];
    thirdState.backgroundColor = [UIColor clearColor];
    thirdState.textAlignment = NSTextAlignmentLeft;
    NSString *time =dataInfo[@"custom_time"];
    NSArray *arr = [time componentsSeparatedByString:@" "];
    thirdState.text = [NSString stringWithFormat:@"开始定制                %@",arr[1]];
    thirdState.frame = CGRectMake(thirdLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, thirdLabelFrame.origin.y-(0.0712*SCREEN_HEIGHT-0.0794*SCREEN_WIDTH)/2, 0.603*SCREEN_WIDTH, 0.0712*SCREEN_HEIGHT);
    thirdState.font = [UIFont systemFontOfSize:0.0407*SCREEN_WIDTH];
    [self.view addSubview:thirdState];
    forthState = [[UILabel alloc]init];
    forthState.textColor = [UIColor blackColor];
    forthState.backgroundColor = [UIColor clearColor];
    forthState.textAlignment = NSTextAlignmentLeft;
    forthState.text = @"完成定制";
    forthState.frame = CGRectMake(forthLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, forthLabelFrame.origin.y-(0.0712*SCREEN_HEIGHT-0.0794*SCREEN_WIDTH)/2, 0.603*SCREEN_WIDTH, 0.0712*SCREEN_HEIGHT);
    forthState.font = [UIFont systemFontOfSize:0.0407*SCREEN_WIDTH];
    [self.view addSubview:forthState];
    
}


-(void)getThreeLineWithState{

    firstLine  = [[UIView alloc]init];
    secondLine  = [[UIView alloc]init];
    thirdLine  = [[UIView alloc]init];

    firstLine.frame = CGRectMake(firstLabelFrame.origin.x+(firstLabelFrame.size.width-0.0068*SCREEN_WIDTH)/2, CGRectGetMaxY(firstLabelFrame), 0.0068*SCREEN_WIDTH, secondLabelFrame.origin.y - CGRectGetMaxY(firstLabelFrame));
    secondLine.frame = CGRectMake(firstLabelFrame.origin.x+(firstLabelFrame.size.width-0.0068*SCREEN_WIDTH)/2, CGRectGetMaxY(secondLabelFrame), 0.0068*SCREEN_WIDTH, thirdLabelFrame.origin.y - CGRectGetMaxY(secondLabelFrame));
    thirdLine.frame = CGRectMake(firstLabelFrame.origin.x+(firstLabelFrame.size.width-0.0068*SCREEN_WIDTH)/2, CGRectGetMaxY(thirdLabelFrame), 0.0068*SCREEN_WIDTH, forthLabelFrame.origin.y - CGRectGetMaxY(thirdLabelFrame));
    firstLine.backgroundColor = UIColorFromRGB(0xF3D129);
    secondLine.backgroundColor = UIColorFromRGB(0xF3D129);
    thirdLine.backgroundColor = UIColorFromRGB(0xF3D129);
    [self.view addSubview:firstLine];
    [self.view addSubview:secondLine];
    [self.view addSubview:thirdLine];
    
}

-(void)getFourTimeLabel{

    firstTime = [[UILabel alloc]init];
    firstTime.textColor = UIColorFromRGB(0xC7C7C7);
    firstTime.backgroundColor = [UIColor clearColor];
    firstTime.textAlignment = NSTextAlignmentLeft;
    firstTime.numberOfLines = 0;
    firstTime.text = dataInfo[@"first_time"];
    firstTime.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(firstLabelFrame)+0.0089*SCREEN_HEIGHT, SCREEN_WIDTH/3*2, 0.03175*SCREEN_WIDTH);
    firstTime.font = [UIFont systemFontOfSize:0.03175*SCREEN_WIDTH];
    [self.view addSubview:firstTime];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    //    NSString *hasKye = [userinfo stringForKey:dataInfo[@"mission_id"]];
    NSDictionary *hasKye=[userinfo objectForKey:dataInfo[@"mission_id"]];
    NSDictionary *dictinfo = [NSDictionary dictionaryWithDictionary:hasKye];
    if ([dictinfo objectForKey:@"second_time"])
    {
        NSDictionary *infodic = [userinfo dictionaryForKey:dataInfo[@"mission_id"]];
        secondTimeInfo = infodic[@"second_time"];
    }else{
        if (proceedState == 2) {
            NSString *nowTime = [self getNowTime];
            NSUserDefaults *userDfault = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userDfault objectForKey:dataInfo[@"mission_id"]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dict setValue:nowTime forKey:@"second_time"];
            [userDfault setObject:dict forKey:dataInfo[@"mission_id"]];
            secondTimeInfo = nowTime;
        }
    }
    secondTime = [[UILabel alloc]init];
    secondTime.textColor = UIColorFromRGB(0xC7C7C7);
    secondTime.backgroundColor = [UIColor clearColor];
    secondTime.textAlignment = NSTextAlignmentLeft;
    secondTime.numberOfLines = 0;
    secondTime.text = secondTimeInfo;
    secondTime.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(secondLabelFrame)+0.0089*SCREEN_HEIGHT, SCREEN_WIDTH/3*2, 0.03175*SCREEN_WIDTH);
    secondTime.font = [UIFont systemFontOfSize:0.03175*SCREEN_WIDTH];


}

-(void)getFourButton{

    firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(firstTime.frame)+0.0581*SCREEN_HEIGHT, firstState.bounds.size.width, 0.0457*SCREEN_HEIGHT);
    [firstBtn setTitle:@"手动提醒对方" forState:UIControlStateNormal];
    [firstBtn setTitleColor:UIColorFromRGB(0xF3D129) forState:UIControlStateNormal];
    firstBtn.layer.masksToBounds = YES;
    firstBtn.layer.cornerRadius = 0.04*SCREEN_WIDTH;
    firstBtn.layer.borderColor = UIColorFromRGB(0xF3D129).CGColor;
    firstBtn.layer.borderWidth = 0.004*SCREEN_WIDTH;
    [firstBtn addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(secondTime.frame)+0.0381*SCREEN_HEIGHT, firstState.bounds.size.width, 0.0457*SCREEN_HEIGHT);
    [secondBtn setTitle:chatType forState:UIControlStateNormal];
    [secondBtn setTitleColor:UIColorFromRGB(0xF3D129) forState:UIControlStateNormal];
    secondBtn.layer.masksToBounds = YES;
    secondBtn.layer.cornerRadius = 0.04*SCREEN_WIDTH;
    secondBtn.layer.borderColor = UIColorFromRGB(0xF3D129).CGColor;
    secondBtn.layer.borderWidth = 0.004*SCREEN_WIDTH;
    [secondBtn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addThirdStateTableView];
    
    thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdBtn.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(thirdStateTableView.frame)+0.0181*SCREEN_HEIGHT, firstState.bounds.size.width, 0.0457*SCREEN_HEIGHT);
    [thirdBtn setTitle:@"完成定制" forState:UIControlStateNormal];
    [thirdBtn setTitleColor:UIColorFromRGB(0xF3D129) forState:UIControlStateNormal];
    thirdBtn.layer.masksToBounds = YES;     thirdBtn.layer.cornerRadius = 0.04*SCREEN_WIDTH;
    thirdBtn.layer.borderColor = UIColorFromRGB(0xF3D129).CGColor;
    thirdBtn.layer.borderWidth = 0.004*SCREEN_WIDTH;
    [thirdBtn addTarget:self action:@selector(thirdBtnClick) forControlEvents:UIControlEventTouchUpInside];

    if ([dataInfo[@"iden"] isEqualToString:@"USER"]) {
        forthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forthBtn.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(forthLabelFrame)+0.0181*SCREEN_HEIGHT, firstState.bounds.size.width, 0.0457*SCREEN_HEIGHT);
        [forthBtn setTitle:@"立刻评价" forState:UIControlStateNormal];
        [forthBtn setTitleColor:UIColorFromRGB(0xF3D129) forState:UIControlStateNormal];
        forthBtn.layer.masksToBounds = YES;
        forthBtn.layer.cornerRadius = 0.04*SCREEN_WIDTH;
        forthBtn.layer.borderColor = UIColorFromRGB(0xF3D129).CGColor;
        forthBtn.layer.borderWidth = 0.004*SCREEN_WIDTH;
        [forthBtn addTarget:self action:@selector(forthBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        forthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forthBtn.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(forthLabelFrame)+0.0181*SCREEN_HEIGHT, firstState.bounds.size.width, 0.0457*SCREEN_HEIGHT);
        [forthBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [forthBtn setTitleColor:UIColorFromRGB(0xF3D129) forState:UIControlStateNormal];
        forthBtn.layer.masksToBounds = YES;
        forthBtn.layer.cornerRadius = 0.04*SCREEN_WIDTH;
        forthBtn.layer.borderColor = UIColorFromRGB(0xF3D129).CGColor;
        forthBtn.layer.borderWidth = 0.004*SCREEN_WIDTH;
        [forthBtn addTarget:self action:@selector(forthBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    
}

-(void)addThirdStateTableView{

    thirdStateTableView = [[UITableView alloc]initWithFrame:CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(thirdLabelFrame), 0.603*SCREEN_WIDTH, 0.2224*SCREEN_HEIGHT)];
    thirdStateTableView.backgroundColor = [UIColor whiteColor];
    thirdStateTableView.allowsSelection = NO;
    thirdStateTableView.dataSource=self;
    thirdStateTableView.delegate=self;
    thirdStateTableView.separatorStyle = NO;
    thirdStateTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}



-(void)changeFrameWithState:(int)state{

    switch (state) {
        case 1:
            [self.view addSubview:firstBtn];
            secondLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            thirdLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            forthLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            secondState.textColor = UIColorFromRGB(0xCBCBCB);
            thirdState.textColor = UIColorFromRGB(0xCBCBCB);
            forthState.textColor = UIColorFromRGB(0xCBCBCB);
            secondLine.backgroundColor = UIColorFromRGB(0xC7C7C7);
            thirdLine.backgroundColor = UIColorFromRGB(0xC7C7C7);

            break;
        case 2:
            [self.view addSubview:secondBtn];

            [self.view addSubview:secondTime];
            secondState.text = [NSString stringWithFormat: @"%@ 已进入准备页面",userName];
            thirdLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            forthLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            thirdState.textColor = UIColorFromRGB(0xCBCBCB);
            forthState.textColor = UIColorFromRGB(0xCBCBCB);
            thirdLine.backgroundColor = UIColorFromRGB(0xC7C7C7);
            
            break;
        case 3:
            [self.view addSubview:secondBtn];
            [self.view addSubview:thirdBtn];
            [self.view addSubview:secondTime];

            [self.view addSubview:thirdStateTableView];
            secondState.text = [NSString stringWithFormat: @"%@ 已进入准备页面",userName];
            thirdState.text = @"开始定制";
            forthLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            forthState.textColor = UIColorFromRGB(0xCBCBCB);
            break;
        case 4:
            secondState.text = [NSString stringWithFormat: @"%@ 已进入准备页面",userName];
            thirdState.text = @"开始定制";
            
            [self.view addSubview:thirdStateTableView];
            [self.view addSubview:forthBtn];
            forthState.text = @"结束并评价";
            break;
        default:
            break;
    }
}

-(void)clearAllControls{

    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}


#pragma mark =====ONCLICK=====


-(void)nowTimerClick:(NSTimer *)timer{

    if (nowTimeNum >= fullTimeTime) {
        if (![dataInfo[@"iden"] isEqualToString:@"USER"]) {
            canClick = YES;
            [nowTimer invalidate];
        }
    }
    
}



-(void)timerClick:(NSTimer*)timer{
    countDownTime = countDownTime-1;
    if (countDownTime == 0) {
        [firstBtn setTitle:@"手动提醒对方" forState:UIControlStateNormal];
        firstBtn.userInteractionEnabled=YES;
        [countDownTimer invalidate];
    }else{

        NSString *string = [NSString stringWithFormat:@"请%d秒后重试",countDownTime];
        [firstBtn setTitle:string forState:UIControlStateNormal];
    }

}

-(void)firstBtnClick{
    countDownTime = 121;
    firstBtn.userInteractionEnabled=NO;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    [WebAgent sendRemoteNotificationsWithuseId:dataInfo[@"user_name"] WithsendMessage:@"您有一个定制订单即将开始，对方已进入等候页面，请尽快开始您的定制" WithType:@"9000" WithSenderID:user_id[@"user_id"] WithMessionID:dataInfo[@"mission_id"] WithLanguage:@"" success:^(id responseObject) {
        [countDownTimer fire];
    } failure:^(NSError *error) {
        
    }];
//    proceedState = proceedState +1;
//    [self clearAllControls];
//    [self addAllControls];
}

-(void)secondBtnClick{
    if (proceedState == 2) {
        [self callTarget];
    }else{
        [self callTarget];
    }
}

-(void)callTarget{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    
    [WebAgent chackStateWithCustomID:dataInfo[@"mission_id"] success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *state = dict[@"state"];
        if([state isEqualToString:@"SUCCESS"]){
            
            YBZTargetWaitingViewController *vc = [[YBZTargetWaitingViewController alloc]initWithUserId:user_id[@"user_id"] targetId:dataInfo[@"user_name"] andType:chatType andIsCall:YES andName:userName];
            vc.messionId = dataInfo[@"mission_id"];
            
            [self.navigationController presentViewController:vc animated:YES completion:^{
                if ([chatType isEqualToString:@"语音呼叫"]) {
                    [WebAgent sendRemoteNotificationsWithuseId:dataInfo[@"user_name"] WithsendMessage:@"您有一个语音呼叫" WithType:@"9002" WithSenderID:user_id[@"user_id"] WithMessionID:dataInfo[@"mission_id"] WithLanguage:@"语音呼叫" success:^(id responseObject) {
                        NSString *time = [self getNowTime];
                        NSDictionary *dict =@{@"sender":@"USER",@"eventType":@"发起",@"time":time};
                        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                        NSDictionary *dic = [userinfo objectForKey:dataInfo[@"mission_id"]];
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
                        NSArray *array = [dictionary objectForKey:@"call_info"];
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
                        [arr addObject:dict];
                        [dictionary setObject:arr forKey:@"call_info"];
                        [userinfo setObject:dictionary forKey:dataInfo[@"mission_id"]];
                        [thirdStateTableView reloadData];
                        if (proceedState == 2) {
                            [WebAgent changeProceedState:dataInfo[@"mission_id"] andProceed_state:@"0003" success:^(id responseObject) {
                                [self changViewWithState];
                            } failure:^(NSError *error) {
                                
                            }];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }else{
                    [WebAgent sendRemoteNotificationsWithuseId:dataInfo[@"user_name"] WithsendMessage:@"您有一个视频呼叫" WithType:@"9002" WithSenderID:user_id[@"user_id"] WithMessionID:dataInfo[@"mission_id"] WithLanguage:@"视频呼叫" success:^(id responseObject) {
                        NSString *time = [self getNowTime];
                        NSDictionary *dict =@{@"sender":@"USER",@"eventType":@"发起",@"time":time};
                        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                        NSDictionary *dic = [userinfo objectForKey:dataInfo[@"mission_id"]];
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
                        NSArray *array = [dictionary objectForKey:@"call_info"];
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
                        [arr addObject:dict];
                        [dictionary setObject:arr forKey:@"call_info"];
                        [userinfo setObject:dictionary forKey:dataInfo[@"mission_id"]];
                        [thirdStateTableView reloadData];
                        if (proceedState == 2) {
                            [WebAgent changeProceedState:dataInfo[@"mission_id"] andProceed_state:@"0003" success:^(id responseObject) {
                                
                            } failure:^(NSError *error) {
                                
                            }];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
                
            }];

        }else{
            
            [MBProgressHUD showNormalMessage:@"对方已呼叫，请接收"];
        
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)thirdBtnClick{
    if (canClick == NO) {
        [MBProgressHUD showError:@"抱歉，预计结束时间前您不能手动完成"];
    }else{
        NSString *str = dataInfo[@"iden"];
        if ([str isEqualToString:@"USER"]) {
            
        }
        [WebAgent changeProceedState:dataInfo[@"mission_id"] andProceed_state:@"0004" success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *str = dict[@"give_money"];
            if ([str isEqualToString:@"1"]) {
                [WebAgent getBiWithID:dataInfo[@"user_name"] andPurchaseCount:dataInfo[@"money"] andSource_id:@"0002" success:^(id responseObject) {
                    
                    
                    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *dic = [userinfo objectForKey:@"user_id"];
                    [WebAgent sendRemoteNotificationsWithuseId:dataInfo[@"user_name"] WithsendMessage:@"定制已完成" WithType:@"9009" WithSenderID:dic[@"user_id"] WithMessionID:dataInfo[@"mission_id"] WithLanguage:@"" success:^(id responseObject) {
                        proceedState = proceedState +1;
                        [self clearAllControls];
                        [self addAllControls];

                    } failure:^(NSError *error) {
                        
                    }];
                } failure:^(NSError *error) {
                    
                }];
            }
            
            
        } failure:^(NSError *error) {
            if ([dataInfo[@"iden"] isEqualToString:@"USER"]) {
                [MBProgressHUD showMessage:@"对方已退出，定制完成！"];
                proceedState = proceedState +1;
                [self clearAllControls];
                [self addAllControls];
            }else{
                [MBProgressHUD showMessage:@"对方已退出，定制完成！"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
        }];

    }


}

-(void)forthBtnClick{
    if ([dataInfo[@"iden"] isEqualToString:@"USER"]) {
        FeedBackViewController *vc = [[FeedBackViewController alloc]initWithtargetID:dataInfo[@"user_name"] AndmassageId:dataInfo[@"mission_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }




}

-(void)finishCustomTranslate{

    if ([dataInfo[@"iden"] isEqualToString:@"TRANS"]) {
        [MBProgressHUD showSuccess:@"定制完成！请核对嗨币是否到账"];
        proceedState = proceedState +1;
        [self clearAllControls];
        [self addAllControls];
    }else{
        [MBProgressHUD showSuccess:@"定制完成！请尽快评价"];
        proceedState = proceedState +1;
        [self clearAllControls];
        [self addAllControls];
    }

}


-(void)changViewWithState{

    proceedState = proceedState +1;
    [self clearAllControls];
    [self addAllControls];
}


#pragma mark -----delegate-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userinfo objectForKey:dataInfo[@"mission_id"]];
    NSArray *arr = [dic objectForKey:@"call_info"];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userinfo objectForKey:dataInfo[@"mission_id"]];
    NSArray *arr = [dic objectForKey:@"call_info"];
    [self addViewInCell:cell WithInfo:arr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 0.066*SCREEN_HEIGHT;
}


-(void)addViewInCell:(UITableViewCell *)cell WithInfo:(NSDictionary *)info{
    
    NSString *sender = info[@"sender"];
    NSString *eventType = info[@"eventType"];
    NSString *time = info[@"time"];
    NSString *string;
    if ([sender isEqualToString:@"USER"]) {
        if ([eventType isEqualToString:@"发起"]) {
            if ([chatType isEqualToString:@"语音呼叫"]) {
                string = @"您 发起了语音呼叫";
            }else{
                string = @"您 发起了视频呼叫";
            }
        }else{
            if ([chatType isEqualToString:@"语音呼叫"]) {
                string = @"您 结束了语音呼叫";
            }else{
                string = @"您 结束了视频呼叫";
            }

        }
    }else{
        if ([eventType isEqualToString:@"发起"]) {
            if ([chatType isEqualToString:@"语音呼叫"]) {
                string = [NSString stringWithFormat: @"%@ 发起了语音呼叫",userName];
            }else{
                string = [NSString stringWithFormat: @"%@ 发起了视频呼叫",userName];
            }
        }else{
            if ([chatType isEqualToString:@"语音呼叫"]) {
                string = [NSString stringWithFormat: @"%@ 结束了语音呼叫",userName];
            }else{
                string = [NSString stringWithFormat: @"%@ 结束了视频呼叫",userName];
            }
            
        }

    }
    UILabel *stringLabel = [self getLabelWithStr:string color:UIColorFromRGB(0xC7C7C7) position:@"left" AndY:0*SCREEN_HEIGHT font:0.03968*SCREEN_WIDTH];
    [cell addSubview:stringLabel];
    UILabel *timeLabel = [self getLabelWithStr:time color:UIColorFromRGB(0xC7C7C7) position:@"left" AndY:0.033*SCREEN_HEIGHT font:0.033*SCREEN_WIDTH];
    [cell addSubview:timeLabel];
    
}

-(UILabel *)getLabelWithStr:(NSString *)string color:(UIColor*)color position:(NSString *)position AndY:(CGFloat)Y font:(CGFloat)font{
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, Y, thirdStateTableView.bounds.size.width, font);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = string;
    label.font = [UIFont systemFontOfSize:font];
    if ([position isEqualToString:@"left"]) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if ([position isEqualToString:@"right"]){
        label.textAlignment = NSTextAlignmentRight;
    }
    
    return label;
    
}

-(NSString *)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}


-(NSString *)changeDateToString:(NSDate *)date{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}


-(long)changeTimeToSecond:(NSString *)time{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    NSLog(@"%@", date);
    long timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
    
}
-(void)changeTableViewData:(NSNotification *)notification{

    [thirdStateTableView reloadData];
    
}


-(NSString *)changeSecondToTime:(long)second{

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:confromTimesp];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}

@end
