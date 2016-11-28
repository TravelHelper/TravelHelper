//
//  YBZPrepareViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 2016/11/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZPrepareViewController.h"
#import "UIAlertController+SZYKit.h"

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
    
}

- (instancetype)initWithType:(NSString *)type AndState:(NSString *)state AndInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        dataInfo = @{@"user_name":@"嘟嘟嘟嘟",@"first_time":@"2016-11-28 14:47:22",@"custom_time":@"15:00:00",@"duration":@"1"};
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
//    countDownTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        countDownTime = countDownTime-1;
//        if (countDownTime == 0) {
//            [countDownTimer invalidate];
//            [firstBtn setTitle:@"手动提醒对方" forState:UIControlStateNormal];
//        }else{
//            NSString *string = [NSString stringWithFormat:@"请%d秒后重试",countDownTime];
//            [firstBtn setTitle:string forState:UIControlStateNormal];
//        }
//        
//    }];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"准备";
    [self addAllControls];



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
    thirdState.text = [NSString stringWithFormat:@"开始定制                %@",dataInfo[@"time"]];
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
    secondTime = [[UILabel alloc]init];
    secondTime.textColor = UIColorFromRGB(0xC7C7C7);
    secondTime.backgroundColor = [UIColor clearColor];
    secondTime.textAlignment = NSTextAlignmentLeft;
    secondTime.numberOfLines = 0;
    secondTime.text = @"2016-11-26 16:30:59";
    secondTime.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(secondLabelFrame)+0.0089*SCREEN_HEIGHT, SCREEN_WIDTH/3*2, 0.03175*SCREEN_WIDTH);
    secondTime.font = [UIFont systemFontOfSize:0.03175*SCREEN_WIDTH];
    [self.view addSubview:secondTime];

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
    
    forthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forthBtn.frame = CGRectMake(firstLabelFrame.origin.x+0.0635*SCREEN_WIDTH+0.0794*SCREEN_WIDTH, CGRectGetMaxY(forthLabelFrame)+0.0181*SCREEN_HEIGHT, firstState.bounds.size.width, 0.0457*SCREEN_HEIGHT);
    [forthBtn setTitle:@"立刻评价" forState:UIControlStateNormal];
    [forthBtn setTitleColor:UIColorFromRGB(0xF3D129) forState:UIControlStateNormal];
    forthBtn.layer.masksToBounds = YES;
    forthBtn.layer.cornerRadius = 0.04*SCREEN_WIDTH;
    forthBtn.layer.borderColor = UIColorFromRGB(0xF3D129).CGColor;
    forthBtn.layer.borderWidth = 0.004*SCREEN_WIDTH;
    [forthBtn addTarget:self action:@selector(forthBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
            secondState.text = [NSString stringWithFormat: @"%@ 已进入准备页面",dataInfo[@"user_name"]];
            thirdLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            forthLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            thirdState.textColor = UIColorFromRGB(0xCBCBCB);
            forthState.textColor = UIColorFromRGB(0xCBCBCB);
            thirdLine.backgroundColor = UIColorFromRGB(0xC7C7C7);
            break;
        case 3:
            [self.view addSubview:secondBtn];
            [self.view addSubview:thirdBtn];
            [self.view addSubview:thirdStateTableView];
            secondState.text = [NSString stringWithFormat: @"%@ 已进入准备页面",dataInfo[@"user_name"]];
            thirdState.text = @"开始定制";
            forthLabel.backgroundColor = UIColorFromRGB(0xC7C7C7);
            forthState.textColor = UIColorFromRGB(0xCBCBCB);
            break;
        case 4:
            secondState.text = [NSString stringWithFormat: @"%@ 已进入准备页面",dataInfo[@"user_name"]];
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
//    countDownTime = 5;
//    firstBtn.userInteractionEnabled=NO;
//    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
    

//    [countDownTimer fire];
    proceedState = proceedState +1;
    [self clearAllControls];
    [self addAllControls];
}

-(void)secondBtnClick{
    if (proceedState == 2) {
        proceedState = proceedState +1;
        [self clearAllControls];
        [self addAllControls];
        [UIAlertController showAlertAtViewController:self title:@"测试" message:@"假装这是一个呼叫事件" confirmTitle:@"好的" confirmHandler:^(UIAlertAction *action) {
            
        }];
    }else{
        [UIAlertController showAlertAtViewController:self title:@"测试" message:@"假装这是一个呼叫事件" confirmTitle:@"好的" confirmHandler:^(UIAlertAction *action) {
           
        }];
    }


}

-(void)thirdBtnClick{
    
    proceedState = proceedState +1;
    [self clearAllControls];
    [self addAllControls];

}

-(void)forthBtnClick{

    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"评价成功~即将返回首页" confirmTitle:@"好的" confirmHandler:^(UIAlertAction *action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

}

#pragma mark -----delegate-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [self addViewInCell:cell WithInfo:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 0.066*SCREEN_HEIGHT;
}


-(void)addViewInCell:(UITableViewCell *)cell WithInfo:(NSDictionary *)info{
    
    NSString *sender = @"USER";
    NSString *eventType = @"发起";
    NSString *time = @"2016-11-28 01:27:44";
    NSString *string;
    if ([sender isEqualToString:@"USER"]) {
        if ([eventType isEqualToString:@"发起"]) {
            if ([chatType isEqualToString:@"语音"]) {
                string = @"您 发起了语音呼叫";
            }else{
                string = @"您 发起了视频呼叫";
            }
        }else{
            if ([chatType isEqualToString:@"语音"]) {
                string = @"您 结束了语音呼叫";
            }else{
                string = @"您 结束了视频呼叫";
            }

        }
    }else{
        if ([eventType isEqualToString:@"发起"]) {
            if ([chatType isEqualToString:@"语音"]) {
                string = [NSString stringWithFormat: @"%@ 发起了语音呼叫",dataInfo[@"user_name"]];
            }else{
                string = [NSString stringWithFormat: @"%@ 发起了视频呼叫",dataInfo[@"user_name"]];
            }
        }else{
            if ([chatType isEqualToString:@"语音"]) {
                string = [NSString stringWithFormat: @"%@ 结束了语音呼叫",dataInfo[@"user_name"]];
            }else{
                string = [NSString stringWithFormat: @"%@ 结束了视频呼叫",dataInfo[@"user_name"]];
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



@end
