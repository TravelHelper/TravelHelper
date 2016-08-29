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


@interface YBZRewardHallViewController ()<UITableViewDelegate,UITableViewDataSource,Btn_TableViewDelegate,UITextFieldDelegate>


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
    self.dataArr = [[NSMutableArray alloc]init];
    [self loadDataFromWeb];
//    [self.navigationController.navigationBar addSubview:self.navView];
    self.navigationController.navigationBar.clipsToBounds = YES;
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

-(void)addNameAndJiantou{
    self.m_btn_tableView1 = [[Btn_TableView alloc] initWithFrame:CGRectMake(0, 64+kScreenWith*0.11, kScreenWith*0.333, kScreenWith*0.1)];
    self.m_btn_tableView2 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.333, 64+kScreenWith*0.11, kScreenWith*0.333, kScreenWith*0.1)];
    self.m_btn_tableView3 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.666, 64+kScreenWith*0.11, kScreenWith*0.333, kScreenWith*0.1)];
    
    self.m_btn_tableView1.delegate_Btn_TableView = self;
    self.m_btn_tableView2.delegate_Btn_TableView = self;
    self.m_btn_tableView3.delegate_Btn_TableView = self;
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.3333, kScreenWith*0.088)];
    _stateLabel.text = @"金额排序";
    _stateLabel.backgroundColor = UIColorFromRGB(0xffd703);
    _stateLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _languageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.3333, kScreenWith*0.088)];
    _languageLabel.text = @"语言筛选";
    _languageLabel.backgroundColor = UIColorFromRGB(0xffd703);
    _languageLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    _languageLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith*0.3333, kScreenWith*0.088)];
    _timeLabel.text = @"时间排序";
    _timeLabel.backgroundColor = UIColorFromRGB(0xffd703);

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
        
        [WebAgent proceed_state:@"0" success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"select------------->%@",self.select);
            NSArray *reward_info = dic[@"reward_info"];
            NSLog(@"reward_info------------->%@",reward_info);
            [self.dataArr removeAllObjects];
            int i=0;
            if ([reward_info isEqual:@""]) {
                NSLog(@"----------------->没有需要解答的内容");
            }else{
                for (i = 0 ; i < reward_info.count; i++) {
                    [self.dataArr addObject:reward_info[i]];
                    [self.mainTableView reloadData];
                }
             }
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
                [self.dataArr addObject:descMoney[descMoney.count-i]];
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
                [self.dataArr addObject:descTime[descTime.count - i]];
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

    return self.dataArr.count;

}
//控制每一行使用什么样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aa = self.dataArr[indexPath.row];
    NSString *time = aa[@"release_time"];
    NSString *title = aa[@"reward_title"];
    NSString *text = aa[@"reward_text"];
    //    NSString *url = aa[@"reward_url"];
    NSString *money = aa[@"reward_money"];
    NSString *state = aa[@"proceed_state"];
    //    NSString *rewardID = aa[@"reward_id"];
    NSLog(@"------------->%@",title);
    UITableViewCell  *cell= [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if ([self.select2  isEqual: @"1"]) {
        self.mainTableView.allowsSelection=NO;
    }
    else{
        self.mainTableView.allowsSelection=YES;
    }
    
    self.textV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWith*0.048,kScreenWith*0.03,kScreenWith*0.902,kScreenWith*0.262)];
    self.textV.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:53.0f/255.0f blue:77.0f/255.0f alpha:1];
    self.textV.layer.cornerRadius = 5.0;
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.035, kScreenWith*0.017, kScreenWith*0.48, kScreenWith*0.059)];
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self.titleLabel setTextColor:[UIColor colorWithRed:238.0f/255.0f green:204.0f/255.0f blue:69.0f/255.0f alpha:1]];
    //内容
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"我的悬赏_图片"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, kScreenWith*0.05, kScreenWith*0.03);
    // 创建带有图片的富文本
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc] initWithString:text];
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    // 用label的attributedText属性来使用富文本
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.035, kScreenWith*0.076, kScreenWith*0.75, kScreenWith*0.108)];
    self.contentLabel.attributedText = attri;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
    //设置显示两行
    self.contentLabel.numberOfLines = 2;
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.032, kScreenWith*0.194, kScreenWith*0.18, kScreenWith*0.04)];
    [label1 setTextColor:[UIColor whiteColor]];
    label1.text = @"发布日期：";
    [label1 setNumberOfLines:0];
    label1.adjustsFontSizeToFitWidth = YES;
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.459, kScreenWith*0.194, kScreenWith*0.5, kScreenWith*0.04)];
    [label2 setTextColor:[UIColor whiteColor]];
    label2.text = @"悬赏金额：              游币";
    [label2 setNumberOfLines:0];
    label2.adjustsFontSizeToFitWidth = YES;
    UIImageView *stateImg = [[UIImageView alloc]init];
    stateImg.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, kScreenWith*0.017, 23,23);
    UILabel *answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+20,kScreenWith*0.037, 6, 10)];
    
    if ([state isEqualToString:@"1"]) {
        [stateImg setImage:[UIImage imageNamed:@"state1"]];
    }else{
        answerLabel.font = [UIFont systemFontOfSize:10];
        answerLabel.backgroundColor = [UIColor clearColor];
        answerLabel.text = @"5";
        answerLabel.textColor = [UIColor blackColor];
        [stateImg setImage:[UIImage imageNamed:@"state2"]];
    }
    
    
    UIImage* image = [UIImage imageNamed:@"right"];
    UIImageView *right   = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentLabel.frame)+5, kScreenWith*0.25, 18,23)];
    [right setImage:image];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.18, kScreenWith*0.194, kScreenWith*0.24, kScreenWith*0.04)];
    [self.dateLabel setTextColor:[UIColor whiteColor]];
    self.dateLabel.font = FONT_14;
    self.dateLabel.text = time;
    [self.dateLabel setNumberOfLines:0];
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.62, kScreenWith*0.194, kScreenWith*0.148, kScreenWith*0.04)];
    self.moneyLabel.text = money;
    [self.moneyLabel setTextColor:[UIColor redColor]];
    UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith*0.82, kScreenWith*0.09, kScreenWith*0.04, kScreenWith*0.06)];
    [imgV setImage:[UIImage imageNamed:@"右_白_箭头"]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.425, kScreenWith*0.199, kScreenWith*0.003, kScreenWith*0.034)];
    label.backgroundColor = [UIColor whiteColor];
    
    [self.textV addSubview:label];
    [self.textV addSubview:imgV];
    [self.textV addSubview:self.titleLabel];
    [self.textV addSubview:self.contentLabel];
    [self.textV addSubview:label1];
    [self.textV addSubview:label2];
    [self.textV addSubview:self.dateLabel];
    [self.textV addSubview:self.moneyLabel];
    [self.textV addSubview:right];
    [self.textV addSubview:stateImg];
    [self.textV addSubview:answerLabel];
    
    [cell addSubview:self.textV];
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
        _navView.backgroundColor = UIColorFromRGB(0xffd703);
        [_navView addSubview:self.searchTextField];
    }
    return _navView;
}
-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWith*0.03, kScreenWith*0.02, UIScreenWidth*0.94, kScreenWith*0.08)];
        _searchTextField.placeholder = @"搜索感兴趣的话题、分类、电影、歌曲、书籍、国家等🔍";
        _searchTextField.backgroundColor = [UIColor whiteColor];
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
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenWith*0.35, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
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
