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

@property (strong ,nonatomic) Btn_TableView *m_btn_tableView1;
@property (nonatomic ,strong) Btn_TableView *m_btn_tableView2;
@property (nonatomic ,strong) Btn_TableView *m_btn_tableView3;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    user_ID = user_id[@"user_id"];
    self.dataArr = [[NSMutableArray alloc]init];
    [self loadDataFromWeb];
    self.view.backgroundColor = myRewardBackgroundColor;

    self.title = @"我的悬赏";


    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.mainTableView];

    self.m_btn_tableView1 = [[Btn_TableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith*0.333, kScreenWith*0.094)];
    self.m_btn_tableView2 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.333, 64, kScreenWith*0.333, kScreenWith*0.094)];
    self.m_btn_tableView3 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.666, 64, kScreenWith*0.333, kScreenWith*0.094)];
    
    self.m_btn_tableView1.delegate_Btn_TableView = self;
    self.m_btn_tableView2.delegate_Btn_TableView = self;
    self.m_btn_tableView3.delegate_Btn_TableView = self;
    //按钮状态
    [self addNameAndJiantou];
    //数据内容
    self.m_btn_tableView1.m_TableViewData = @[@"解决",@"未解决"];
    self.m_btn_tableView2.m_TableViewData = @[@"英文",@"中文",@"韩文",@"日文",@"泰文",@"法文",@"俄文"];
    self.m_btn_tableView3.m_TableViewData = @[@"由早到晚",@"由晚到早"];

    
    [self.m_btn_tableView1 addViewData];
    [self.m_btn_tableView2 addViewData];
    [self.m_btn_tableView3 addViewData];
    [self.view addSubview:self.m_btn_tableView1];
    [self.view addSubview:self.m_btn_tableView2];
    [self.view addSubview:self.m_btn_tableView3];
    
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

    [self loadDataFromWeb];
}


-(void)addNameAndJiantou{
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.29, kScreenWith*0.082)];
    _stateLabel.text = @"状态排序";
    _stateLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _languageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.32, kScreenWith*0.082)];
    _languageLabel.text = @"语言筛选";
    _languageLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _languageLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.32, kScreenWith*0.082)];
    _timeLabel.text = @"时间排序";
    _timeLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _stateJiantouView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith*0.23, kScreenWith*0.024, kScreenWith*0.03, kScreenWith*0.03)];
    _languageJiantouView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith*0.25, kScreenWith*0.022, kScreenWith*0.03, kScreenWith*0.03)];
    _timeJiantouView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith*0.25, kScreenWith*0.022, kScreenWith*0.03, kScreenWith*0.03)];
    [_stateJiantouView setImage:[UIImage imageNamed:@"下_黑_箭头"]];
    _stateLabel.textColor = [UIColor blackColor];
    [_languageJiantouView setImage:[UIImage imageNamed:@"下_黑_箭头"]];
    _languageLabel.textColor = [UIColor blackColor];
    [_timeJiantouView setImage:[UIImage imageNamed:@"下_黑_箭头"]];
    _timeLabel.textColor = [UIColor blackColor];
    [self.m_btn_tableView1 addSubview:_stateLabel];
    [self.m_btn_tableView1 addSubview:_stateJiantouView];
    [self.m_btn_tableView2 addSubview:_languageLabel];
    [self.m_btn_tableView2 addSubview:_languageJiantouView];
    [self.m_btn_tableView3 addSubview:_timeLabel];
    [self.m_btn_tableView3 addSubview:_timeJiantouView];
}
//第三步：处理通知
-(void)setTextALabel2:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.select2 = [textDic objectForKey:@"文本"];
    NSLog(@"%@",self.select2);

    if (!self.m_btn_tableView1.m_btnpanduan&!self.m_btn_tableView2.m_btnpanduan&!self.m_btn_tableView3.m_btnpanduan) {
        [self.m_btn_tableView1.m_btn setUserInteractionEnabled:YES];
        [self.m_btn_tableView2.m_btn setUserInteractionEnabled:YES];
        [self.m_btn_tableView3.m_btn setUserInteractionEnabled:YES];
        [_stateJiantouView setImage:[UIImage imageNamed:@"下_黑_箭头"]];
        _stateLabel.textColor = [UIColor blackColor];
        [_languageJiantouView setImage:[UIImage imageNamed:@"下_黑_箭头"]];
        _languageLabel.textColor = [UIColor blackColor];
        [_timeJiantouView setImage:[UIImage imageNamed:@"下_黑_箭头"]];
        _timeLabel.textColor = [UIColor blackColor];
        
    }
    if (self.m_btn_tableView1.m_btnpanduan) {
        [self.m_btn_tableView2.m_btn setUserInteractionEnabled:NO];
        [self.m_btn_tableView3.m_btn setUserInteractionEnabled:NO];
        [_stateJiantouView setImage:[UIImage imageNamed:@"下_灰_箭头"]];
        _stateLabel.textColor = [UIColor colorWithRed:0.0/255.0f green:129.0/255.0f blue:204.0/255.0f alpha:0.9];
    }
    if (self.m_btn_tableView2.m_btnpanduan) {
        [self.m_btn_tableView1.m_btn setUserInteractionEnabled:NO];
        [self.m_btn_tableView3.m_btn setUserInteractionEnabled:NO];
        [_languageJiantouView setImage:[UIImage imageNamed:@"下_灰_箭头"]];
        _languageLabel.textColor = [UIColor colorWithRed:0.0/255.0f green:129.0/255.0f blue:204.0/255.0f alpha:0.9];
    }
    if (self.m_btn_tableView3.m_btnpanduan) {
        [self.m_btn_tableView1.m_btn setUserInteractionEnabled:NO];
        [self.m_btn_tableView2.m_btn setUserInteractionEnabled:NO];
        [_timeJiantouView setImage:[UIImage imageNamed:@"下_灰_箭头"]];
        _timeLabel.textColor = [UIColor colorWithRed:0.0/255.0f green:129.0/255.0f blue:204.0/255.0f alpha:0.9];
    }
}

//第三步：处理通知
-(void)setTextALabel:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.select = [textDic objectForKey:@"文本"];
    NSLog(@"%@",self.select);
    [self loadDataFromWeb];
    [self.mainTableView reloadData];
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

-(void)loadDataFromWeb{

    [WebAgent myRewardrewardID:user_ID success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"asd%@",dic);
        NSArray *reward_info = dic[@"reward_info"];
//        NSLog(@"有%lu条数据",(unsigned long)reward_info.count);
        int j=0;
        int i=0;
        
        [self.dataArr removeAllObjects];
        if ([reward_info isEqual:@""]) {
            NSLog(@"没有你的数据");
        }else{
            for (i = 0 ; i < reward_info.count; i++) {
                NSDictionary *reward_infoS = reward_info[i];
                NSString *language = reward_infoS[@"language"];
                NSString *proceed_state = reward_infoS[@"proceed_state"];
                if ([self.select  isEqual: @"解决"]) {
                    if ([proceed_state isEqual:@"1"]) {
                        [self.dataArr addObject:reward_info[i]];
                        NSLog(@"1111%@",self.dataArr);
                        [self.mainTableView reloadData];
                    }
                }
                if ([self.select  isEqual: @"未解决"]) {
                    if ([proceed_state isEqual:@"0"]) {
                        [self.dataArr addObject:reward_info[i]];
                        NSLog(@"1111%@",self.dataArr);
                        [self.mainTableView reloadData];
                    }
                }
                if ([language isEqual:self.select]) {
                    
                    [self.dataArr addObject:reward_info[i]];
                    NSLog(@"%@",self.dataArr);
                    [self.mainTableView reloadData];
                }
                if(!self.select){
                    [self.dataArr addObject:reward_info[i]];
                    
                    [self.mainTableView reloadData];
                }
                else{
                    j++;
                    if(j==i){
                        NSLog(@"未查到相关数据");
                        [self.dataArr removeAllObjects];
                        [self.mainTableView reloadData];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未查到相关数据" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
        }
        [self.mainTableView reloadData];
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
