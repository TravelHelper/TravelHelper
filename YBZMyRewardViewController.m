//
//  YBZRewardHallViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//


//我的悬赏（用户）
#import "YBZMyRewardViewController.h"
#import "Model.h"
#import "Btn_TableView.h"
#import "WebAgent.h"
#import "YBZTranslatorDetailViewController.h"
#import "YBZSendRewardViewController.h"
#import "UIAlertController+SZYKit.h"
#import "YBZDetailViewController.h"
#import "RewardCell.h"
#define kScreenWith  [UIScreen mainScreen].bounds.size.width
#define kSelectFontSize    [UIScreen mainScreen].bounds.size.width*0.04
#define kTitleFontSize     [UIScreen mainScreen].bounds.size.width*0.042
#define kContentFontSize   [UIScreen mainScreen].bounds.size.width*0.035
// 角度转弧度
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180
// 弧度转角度
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)

@interface YBZMyRewardViewController ()<UITableViewDelegate,UITableViewDataSource,Btn_TableViewDelegate>


@property (nonatomic ,strong) UIButton *rightBtn;

@property (nonatomic ,strong) UILabel *alertLabel;
@property (nonatomic ,strong) UILabel *stateLabel;
@property (nonatomic ,strong) UILabel *languageLabel;
@property (nonatomic ,strong) UILabel *timeLabel;

@property (nonatomic ,strong) NSMutableArray *dataArr;

@property (nonatomic ,strong) UIView  *textV;
@property (nonatomic ,strong) UIImageView *backgroundImageView;
@property (nonatomic ,strong) UIImageView *stateJiantouView;
@property (nonatomic ,strong) UIImageView *languageJiantouView;
@property (nonatomic ,strong) UIImageView *timeJiantouView;

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UILabel *imgLabel;
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *moneyLabel;

@property (nonatomic ,strong) NSString *select;//取选择的排序名称
@property (nonatomic ,strong) NSString *select2;
@property (nonatomic ,strong) NSString *countPeople;

@end

@implementation YBZMyRewardViewController{
    NSString *user_ID;
    NSMutableArray *middleArr;
    NSMutableArray *languageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    user_ID = user_id[@"user_id"];
    self.dataArr = [[NSMutableArray alloc]init];
//    [self loadDataFromWeb];
    self.view.backgroundColor = myRewardBackgroundColor;

    self.title = @"我的悬赏";


    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.mainTableView];


    [self getThreeOrderButton];


    //数据内容

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel:) name:@"setTextALabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel2:) name:@"setTextALabel2" object:nil];
    //右键头
    UIImageView *editImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [editImage setImage:[UIImage imageNamed:@"add"]];
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [_rightBtn addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addSubview:editImage];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

-(void)viewWillAppear:(BOOL)animated{

    [self loadDataFromWeb:@"all"];
}

-(void)viewWillDisappear:(BOOL)animated{

}

//生成三个排序按钮
-(void)getThreeOrderButton{

    NSArray *titleArr = @[@"状态排序",@"语言筛选",@"时间排序"];
    for (int i=0 ; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH/3*i, 64, SCREEN_WIDTH/3, 0.05*SCREEN_HEIGHT);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x1D8FD2) forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

-(void)searchBtnClick:(UIButton *)sender{

    switch (sender.tag) {
        case 100:
            NSLog(@"100");
            [self changeSelectedAndShowViewWithTag:100 AndSender:sender];
            break;
        case 101:
            NSLog(@"101");
            [self changeSelectedAndShowViewWithTag:101 AndSender:sender];
            break;
        case 102:
            NSLog(@"102");
            [self changeSelectedAndShowViewWithTag:102 AndSender:sender];
            break;
        default:
            break;
    }
}


-(void)changeSelectedAndShowViewWithTag:(int)tag AndSender:(UIButton *)sender{
    
    if (sender.selected == YES) {
        [self clearOtherBtn];
    }else{
        [self clearOtherBtn];
        sender.selected = YES;
        [self addChooseViewWithTag:tag];
    }
    
}

-(void)addChooseViewWithTag:(int)tag{

    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    switch (tag) {
        case 100:
            view.frame = CGRectMake(0, 64+0.05*SCREEN_HEIGHT, SCREEN_WIDTH/3, 2*0.05*SCREEN_HEIGHT);
            view.tag = 1000;
            [self getBtnWithTag:1000 AndView:view];
            break;
        case 101:
            view.frame = CGRectMake(SCREEN_WIDTH/3, 64+0.05*SCREEN_HEIGHT, SCREEN_WIDTH/3, languageArr.count*0.05*SCREEN_HEIGHT);
            view.tag = 1001;
            [self getBtnWithTag:1001 AndView:view];

            break;
        case 102:
            view.frame = CGRectMake(SCREEN_WIDTH/3*2, 64+0.05*SCREEN_HEIGHT, SCREEN_WIDTH/3, 2*0.05*SCREEN_HEIGHT);
            view.tag = 1002;
            [self getBtnWithTag:1002 AndView:view];

            break;
        default:
            break;
    }
    [self.view addSubview:view];

}

-(void)getBtnWithTag:(int)tag AndView:(UIView *)view{

    if (tag == 1000) {
        NSArray *titleArr = @[@"已完成",@"未完成"];
        for (int i=0; i<2; i++) {
            UIButton *moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moneyBtn.frame = CGRectMake(0, view.bounds.size.height/2*i, view.bounds.size.width, view.bounds.size.height/2);
            [moneyBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            moneyBtn.titleLabel.font = FONT_13;
            moneyBtn.backgroundColor = [UIColor whiteColor];
            [moneyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            moneyBtn.tag = i+200;
            [moneyBtn addTarget:self action:@selector(orderDataWithState:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:moneyBtn];
        }
    }
        if (tag == 1001) {

            for (int i=0; i<languageArr.count; i++) {
                UIButton *languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                languageBtn.frame = CGRectMake(0, view.bounds.size.height/languageArr.count*i, view.bounds.size.width, view.bounds.size.height/languageArr.count);
                [languageBtn setTitle:languageArr[i] forState:UIControlStateNormal];
                languageBtn.titleLabel.font = FONT_13;
                languageBtn.backgroundColor = [UIColor whiteColor];
                [languageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [languageBtn addTarget:self action:@selector(chooseDataWithLanguage:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:languageBtn];
            }
        }

    if (tag == 1002) {
        NSArray *titleArr = @[@"从早到晚",@"从晚到早"];
        for (int i=0; i<2; i++) {
            UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            timeBtn.frame = CGRectMake(0, view.bounds.size.height/2*i, view.bounds.size.width, view.bounds.size.height/2);
            [timeBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            timeBtn.titleLabel.font = FONT_13;
            timeBtn.backgroundColor = [UIColor whiteColor];
            [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            timeBtn.tag = i+300;
            [timeBtn addTarget:self action:@selector(orderDataWithTime:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:timeBtn];
        }
    }
    
}

-(void)clearOtherBtn{

    for (UIButton *btn in self.view.subviews) {
        switch (btn.tag) {
            case 100:
                btn.selected = NO;
                break;
            case 101:
                btn.selected = NO;

                break;
            case 102:
                btn.selected = NO;

                break;
            default:
                break;
        }
    }
    for (UIView *view in self.view.subviews) {
        switch (view.tag) {
            case 1000:
                [view removeFromSuperview];
                break;
            case 1001:
                [view removeFromSuperview];
                
                break;
            case 1002:
                [view removeFromSuperview];
                
                break;
            default:
                break;
        }
    }

}


-(void)orderDataWithState:(UIButton *)sender{

    [sender.superview removeFromSuperview];
    [self clearOtherBtn];
    if (sender.tag == 200) {

        NSMutableArray *arr = self.dataArr;
        NSMutableArray *midArr = [[NSMutableArray alloc]init];
        for (int i=(int)arr.count-1; i>=0 ; i--) {
            if ([arr[i][@"proceed_state"] isEqualToString:@"1"]) {
                [midArr addObject:arr[i]];
                [self.dataArr removeObjectAtIndex:i];
            }
        }
        [midArr addObjectsFromArray:self.dataArr];
        
        [self.dataArr removeAllObjects];
        self.dataArr = midArr;
        NSLog(@"2222222222222");
    }else if (sender.tag == 201){
        
        NSMutableArray *arr = self.dataArr;
        NSMutableArray *midArr = [[NSMutableArray alloc]init];

        for (int i=(int)arr.count-1; i>=0 ; i--) {
            if ([arr[i][@"proceed_state"] isEqualToString:@"0"]) {
                [midArr addObject:arr[i]];
                [self.dataArr removeObjectAtIndex:i];
            }
        }
        [midArr addObjectsFromArray:self.dataArr];
        [self.dataArr removeAllObjects];
        self.dataArr = midArr;
        NSLog(@"333333333333");
    }
    
    [self.mainTableView reloadData];
}

-(void)chooseDataWithLanguage:(UIButton *)sender{

    [sender.superview removeFromSuperview];
    [self clearOtherBtn];
    [self loadDataFromWeb:sender.titleLabel.text];
    [self.mainTableView reloadData];
}

-(void)orderDataWithTime:(UIButton *)sender{

    [sender.superview removeFromSuperview];
    [self clearOtherBtn];
    if (sender.tag == 300) {
        for (int i=0; i<self.dataArr.count; i++) {
            for (int j=0; j<self.dataArr.count-1; j++) {
                NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
                NSDateFormatter *format = [[NSDateFormatter alloc]init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [format setTimeZone:destinationTimeZone];
                NSDate *firstDate = [[NSDate alloc]init];
                firstDate = [format dateFromString:self.dataArr[j][@"release_time"]];
                NSDate *secondDate = [[NSDate alloc]init];
                secondDate = [format dateFromString:self.dataArr[j+1][@"release_time"]];
                NSTimeInterval first = [firstDate timeIntervalSince1970]*1;
                NSTimeInterval second = [secondDate timeIntervalSince1970]*1;

                
                
                if (first>second) {
                    NSDictionary *dict = self.dataArr[j];
                    self.dataArr[j] = self.dataArr[j+1];
                    self.dataArr[j+1] = dict;
                }
            }
        }
    }else if (sender.tag == 301){
        for (int i=0; i<self.dataArr.count; i++) {
            for (int j=0; j<self.dataArr.count-1; j++) {
                NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
                NSDateFormatter *format = [[NSDateFormatter alloc]init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [format setTimeZone:destinationTimeZone];
                NSDate *firstDate = [[NSDate alloc]init];
                firstDate = [format dateFromString:self.dataArr[j][@"release_time"]];
                NSDate *secondDate = [[NSDate alloc]init];
                secondDate = [format dateFromString:self.dataArr[j+1][@"release_time"]];
                NSTimeInterval first = [firstDate timeIntervalSince1970]*1;
                NSTimeInterval second = [secondDate timeIntervalSince1970]*1;
                
                
                
                if (first<second) {
                    NSDictionary *dict = self.dataArr[j];
                    self.dataArr[j] = self.dataArr[j+1];
                    self.dataArr[j+1] = dict;
                }
            }
        }
    }
    [self.mainTableView reloadData];
    
}




//第三步：处理通知
-(void)setTextALabel2:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.select2 = [textDic objectForKey:@"文本"];
    NSLog(@"%@",self.select2);

  }

//第三步：处理通知
-(void)setTextALabel:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.select = [textDic objectForKey:@"文本"];
    NSLog(@"%@",self.select);
//    [self loadDataFromWeb];
}
//第四步：移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setTextALabel" object:nil];
}


#pragma mark - 返回箭头
-(void)leftButton{

}


#pragma mark - 页面跳转
-(void)interpretClick{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)loadDataFromWeb:(NSString *)language{

    [WebAgent myRewardrewardID:user_ID AndLanguage:language success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"asd%@",dic);
        NSArray *reward_info = dic[@"reward_info"];

        if (reward_info.count != 0) {
            [self.dataArr removeAllObjects];
            for (int i=0; i<reward_info.count; i++) {
                [self.dataArr addObject:reward_info[i]];
            }
            if ([language isEqualToString:@"all"]) {
                languageArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *dict in self.dataArr) {
                    NSString *language = dict[@"language"];
                    if (languageArr.count != 0) {
                        BOOL hasLanguage = NO;
                        for (NSString *str in languageArr) {
                            if ([str isEqualToString:language]) {
                                hasLanguage = YES;
                            }
                        }
                        if (hasLanguage == NO) {
                            [languageArr addObject:language];
                        }
                    }else{
                        [languageArr addObject:language];
                    }
                }

            }
                        dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
            });
            

        }else{
            [UIAlertController showAlertAtViewController:self title:@"提示" message:@"您还没有发布任何悬赏，快点击右上角去发布吧~！" cancelTitle:@"放弃" confirmTitle:@"确定" cancelHandler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            } confirmHandler:^(UIAlertAction *action) {
                YBZSendRewardViewController *sendRewardVC = [[YBZSendRewardViewController alloc]init];
                [self.navigationController pushViewController:sendRewardVC animated:YES];
            }];
        }

        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        CGSize size = [@"网络错误" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
        
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width) / 2, 500, size.width + 10, size.height + 6)];
        
        self.alertLabel.backgroundColor = [UIColor blackColor];
        self.alertLabel.layer.cornerRadius = 5;
        
        //将UiLabel设置圆角 此句不可少
        self.alertLabel.layer.masksToBounds = YES;
        self.alertLabel.alpha = 0.8;
        self.alertLabel.text = @"网络错误";
        self.alertLabel.font = [UIFont systemFontOfSize:14];
        [self.alertLabel setTextAlignment:NSTextAlignmentCenter];
        self.alertLabel.textColor = [UIColor whiteColor];
        [self.mainTableView addSubview:self.alertLabel];

        //设置动画
        [UIView animateWithDuration:2 animations:^{
            self.alertLabel.alpha = 0;
        } completion:^(BOOL finished) {
            //将警告Label透明后 在进行删除
            [self.alertLabel removeFromSuperview];
        }];
    }];
}
-(void)changeOrientationNinty:(UIView *)view
{
    view.transform  = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90));
}

#pragma mark - 表视图协议

//控制表视图的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


//控制每一行使用什么样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.dataArr[indexPath.row];
    RewardCell *cell = [[RewardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RewardCell" AndModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//控制行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kScreenWith*0.288;
}
//点击行之后的响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==self.mainTableView){
        NSDictionary *aa = self.dataArr[indexPath.row];
        YBZDetailViewController *detailVC = [[YBZDetailViewController alloc]init];
        NSLog(@"--------------->%@",aa);
        detailVC.reward_id = aa[@"reward_id"];

        [self.navigationController pushViewController:detailVC animated:YES];
        
        
    }  
    
}
-(void)searchprogram{
    YBZSendRewardViewController *sendRewardVC = [[YBZSendRewardViewController alloc]init];
    [self.navigationController pushViewController:sendRewardVC animated:YES];
}

- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _backgroundImageView.image = [UIImage imageNamed:@"backgroundImage"];
        
    }
    return _backgroundImageView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.139*SCREEN_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-0.225*SCREEN_HEIGHT+20) style:UITableViewStylePlain];
        [_mainTableView registerClass:[RewardCell class] forCellReuseIdentifier:@"RewardCell"];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = YES;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
    }
    return _mainTableView;
}


@end
