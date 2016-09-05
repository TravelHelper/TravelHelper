//
//  YBZRewardHallViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//



//悬赏大厅（译员）

#import "YBZRewardHallViewController.h"
#import "NSString+SZYKit.h"
#import "Model.h"
#import "Btn_TableView.h"
#import "WebAgent.h"
#import "YBZTranslatorDetailViewController.h"
#import "YBZTranslatorAnswerViewController.h"
#import "YBZDetailViewController.h"
#import "YBZSendRewardViewController.h"
#import "RewardCell.h"

#define kScreenWith        [UIScreen mainScreen].bounds.size.width
#define kSelectFontSize    [UIScreen mainScreen].bounds.size.width*0.04
#define kTitleFontSize     [UIScreen mainScreen].bounds.size.width*0.042
#define kContentFontSize   [UIScreen mainScreen].bounds.size.width*0.035
// 角度转弧度
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180
// 弧度转角度
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)

//颜色rgb
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface YBZRewardHallViewController ()<UITableViewDelegate,UITableViewDataSource,Btn_TableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>


@property (strong ,nonatomic) Btn_TableView *m_btn_tableView1;
@property (nonatomic ,strong) Btn_TableView *m_btn_tableView2;
@property (nonatomic ,strong) Btn_TableView *m_btn_tableView3;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,strong) UIButton *cancelBtn;

@property (nonatomic ,strong) UILabel *alertLabel;
@property (nonatomic ,strong) UILabel *stateLabel;
@property (nonatomic ,strong) UILabel *languageLabel;
@property (nonatomic ,strong) UILabel *timeLabel;

@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) UIView  *navView;
@property (nonatomic ,strong) UITextField *searchTextField;


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
@property (nonatomic ,strong) NSString *select2;//取下拉列表
@property (nonatomic ,strong) NSString *countPeople;

@end

@implementation YBZRewardHallViewController{
    NSString *user_ID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    user_ID = user_id[@"user_id"];
    self.dataArr = [NSMutableArray array];
    [self loadDataFromWeb];
//    [self.navigationController.navigationBar addSubview:self.navView];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    self.title = @"悬赏大厅";
   
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.navView];
    [self addNameAndJiantou];
   
    [self.searchTextField addTarget:self action:@selector(textFieldOnFouce:) forControlEvents:UIControlEventTouchDown];
    [self.searchTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel:) name:@"setTextALabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel2:) name:@"setTextALabel2" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{

    [self loadDataFromWeb];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)addNameAndJiantou{
    self.m_btn_tableView1 = [[Btn_TableView alloc] initWithFrame:CGRectMake(0, 64+kScreenWith*0.11, kScreenWith*0.333, kScreenWith*0.1)];
    self.m_btn_tableView2 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.333, 64+kScreenWith*0.11, kScreenWith*0.333, kScreenWith*0.1)];
    self.m_btn_tableView3 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.666, 64+kScreenWith*0.11, kScreenWith*0.333, kScreenWith*0.1)];
    
    self.m_btn_tableView1.delegate_Btn_TableView = self;
    self.m_btn_tableView2.delegate_Btn_TableView = self;
    self.m_btn_tableView3.delegate_Btn_TableView = self;
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.3333, kScreenWith*0.088)];
    _stateLabel.text = @"金额排序";
    _stateLabel.backgroundColor = [UIColor whiteColor];
    _stateLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _languageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.3333, kScreenWith*0.088)];
    _languageLabel.text = @"语言筛选";
    _languageLabel.backgroundColor = [UIColor whiteColor];
    _languageLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _languageLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.3333, kScreenWith*0.088)];
    _timeLabel.text = @"时间排序";
    _timeLabel.backgroundColor = [UIColor whiteColor];

    _timeLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _stateJiantouView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith*0.25, kScreenWith*0.024, kScreenWith*0.03, kScreenWith*0.03)];
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
    self.m_btn_tableView1.m_TableViewData = @[@"由高到低",@"由低到高"];
    self.m_btn_tableView2.m_TableViewData = @[@"英文",@"中文",@"韩文",@"日文",@"泰文",@"法文",@"俄文"];
    self.m_btn_tableView3.m_TableViewData = @[@"由早到晚",@"由晚到早"];
    [self.m_btn_tableView1 addViewData];
    [self.m_btn_tableView2 addViewData];
    [self.m_btn_tableView3 addViewData];
    [self.view addSubview:self.m_btn_tableView1];
    [self.view addSubview:self.m_btn_tableView2];
    [self.view addSubview:self.m_btn_tableView3];
}
//第三步：处理通知
-(void)setTextALabel:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.select = [textDic objectForKey:@"条件"];
    if ([self.select isEqualToString:@"由高到低"] || [self.select isEqualToString:@"由低到高"] ) {
        [self loadMoneyDataFromWeb];
        [self.mainTableView reloadData];
    }
    else if ([self.select isEqualToString:@"由早到晚"] || [self.select isEqualToString:@"由晚到早"] ) {
        [self loadTimeDataFromWeb];
        [self.mainTableView reloadData];
    }
    else{
        [self loadLanguageDataFromWeb];
        [self.mainTableView reloadData];
    }
}
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

//第四步：移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setTextALabel" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setTextALabel2" object:nil];

}

#pragma mark - 加载数据

-(void)loadDataFromWeb{
        
    [WebAgent getRewardHallInfo:user_ID success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![dic[@"data"] isKindOfClass:[NSString class]]) {
            self.dataArr = dic[@"data"];
        }else{
            self.dataArr = nil;
        }
        [self.mainTableView reloadData];
        
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
}

-(void)loadMoneyDataFromWeb{
    [WebAgent money:@"money" success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"select--money------------->%@",dic);
        NSArray *descMoney = dic[@"data"];
        [self.dataArr removeAllObjects];
        if ([self.select isEqualToString:@"由高到低"]) {
            for (int i = 0 ; i < descMoney.count; i++) {
                [self.dataArr addObject:descMoney[i]];
                [self.mainTableView reloadData];
            }
        }
        if ([self.select isEqualToString:@"由低到高"]) {
            for (int i = 0 ; i < descMoney.count; i++) {
                [self.dataArr addObject:descMoney[descMoney.count-i-1] ];
                [self.mainTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self errorAction];
    }];
}

-(void)loadLanguageDataFromWeb{
    
    [WebAgent language:self.select success:^(id responseObject) {
        
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"select--language------------->%@",dic);
        NSArray *languageArr = dic[@"data"];
        [self.dataArr removeAllObjects];
        
        for (int i = 0 ; i < languageArr.count; i++) {
                [self.dataArr addObject:languageArr[i]];
                [self.mainTableView reloadData];
        }
      
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self errorAction];
    }];
}

-(void)loadTimeDataFromWeb{
    [WebAgent time:@"time" success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"select---time------------>%@",dic);
        NSArray *descTime = dic[@"data"];
        [self.dataArr removeAllObjects];
        if ([self.select isEqualToString:@"由早到晚"]) {
            for (int i = 0 ; i < descTime.count; i++) {
                [self.dataArr addObject:descTime[i]];
                [self.mainTableView reloadData];
            }
        }
        if ([self.select isEqualToString:@"由晚到早"]) {
            for (int i = 0 ; i < descTime.count; i++) {
                [self.dataArr addObject:descTime[descTime.count - i-1]];
                [self.mainTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self errorAction];
    }];
}

-(void)searchDataFromWeb{
    
    [WebAgent searchContent:self.searchTextField.text success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *searchResualt = dic[@"data"];
        [self.dataArr removeAllObjects];
        for (int i = 0 ; i < searchResualt.count; i++) {
                [self.dataArr addObject:searchResualt[i]];
                [self.mainTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self errorAction];
    }];
}

#pragma mark - 点击事件
-(void)changeOrientationNinty:(UIView *)view
{
    view.transform  = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90));
}
-(void)cancelBtnClick{
    self.searchTextField.frame = CGRectMake(kScreenWith*0.03, kScreenWith*0.02, UIScreenWidth*0.94, kScreenWith*0.08);
    self.searchTextField.placeholder = @"搜索感兴趣的话题、分类、电影、歌曲、书籍、国家等🔍";
    [self.searchTextField resignFirstResponder];
    [self.cancelBtn removeFromSuperview];
    
}
#pragma mark - error
-(void)errorAction{
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
}


#pragma mark - UITextField事件捕捉
- (void)textFieldOnFouce:(UITextField *)theTextField{
       self.searchTextField.frame = CGRectMake(kScreenWith*0.03, kScreenWith*0.02, UIScreenWidth*0.8, kScreenWith*0.08);
       self.searchTextField.placeholder = @"🔍搜索";
       [self.navView addSubview:self.cancelBtn];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textField.text----->%@",self.searchTextField.text);
    [self searchDataFromWeb];
    [self.mainTableView reloadData];
}

#pragma mark - 表视图协议

//控制表视图的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr != nil) {
        return self.dataArr.count;
    }else{
        return 0;
    }

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

        YBZTranslatorDetailViewController *detailVC = [[YBZTranslatorDetailViewController alloc]init];
        NSLog(@"--------------->%@",aa);
        detailVC.reward_id = aa[@"reward_id"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - getter
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenWidth*0.86, kScreenWith*0.04, kScreenWith*0.09, kScreenWith*0.04)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelBtn;
}
-(UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWith, 64)];
        _navView.backgroundColor =[UIColor whiteColor];
        [_navView addSubview:self.searchTextField];
    }
    return _navView;
}
-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWith*0.03, kScreenWith*0.02, UIScreenWidth*0.94, kScreenWith*0.08)];
        _searchTextField.placeholder = @"     搜索感兴趣的话题、分类、电影、语言等🔍";
        _searchTextField.backgroundColor = [UIColor whiteColor];
        _searchTextField.layer.borderColor = [UIColor grayColor].CGColor;
        _searchTextField.layer.borderWidth = 0.3;
        _searchTextField.font = FONT_12;
        _searchTextField.delegate = self;
        [_searchTextField.layer setMasksToBounds:YES];
        [_searchTextField.layer setCornerRadius:8.0];//设置矩形四个圆角半径
    }
    return _searchTextField;
}
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _backgroundImageView.image = [UIImage imageNamed:@"backgroundImage"];
        

    }
    return _backgroundImageView;
    
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenWith*0.35, self.view.bounds.size.width, self.view.bounds.size.height-0.225*SCREEN_HEIGHT+20) style:UITableViewStylePlain];
        [_mainTableView registerClass:[RewardCell class] forCellReuseIdentifier:@"RewardCell"];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = YES;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
