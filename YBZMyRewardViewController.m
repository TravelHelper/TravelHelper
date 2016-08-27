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
#define kScreenWith  [UIScreen mainScreen].bounds.size.width
// 角度转弧度
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180
// 弧度转角度
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)




@interface YBZMyRewardViewController ()<UITableViewDelegate,UITableViewDataSource,Btn_TableViewDelegate>

@property (strong , nonatomic) Btn_TableView* m_btn_tableView1;
@property (nonatomic ,strong) Btn_TableView *m_btn_tableView2;
@property (nonatomic ,strong) Btn_TableView *m_btn_tableView3;
@property (nonatomic ,strong) UIButton *rightBtn;


@property (nonatomic ,strong) UILabel *alertLabel;

@property (nonatomic ,strong) NSMutableArray *dataArr;


@property (nonatomic ,strong) UIView  *textV;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UILabel *imgLabel;
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *moneyLabel;


@property (nonatomic ,strong) NSString *select;//取选择的排序名称
@property (nonatomic ,strong) NSString *select2;
@property (nonatomic,strong) NSString *countPeople;


@end

@implementation YBZMyRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self loadDataFromWeb];
    self.view.backgroundColor = myRewardBackgroundColor;
    self.mainTableView.backgroundColor = myRewardBackgroundColor;
    self.title = @"我的悬赏";
    
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenWith*0.09, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.mainTableView];
    
    
    
    self.m_btn_tableView1 = [[Btn_TableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith*0.333, kScreenWith*0.094)];
    self.m_btn_tableView2 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.333, 64, kScreenWith*0.333, kScreenWith*0.094)];
    self.m_btn_tableView3 = [[Btn_TableView alloc] initWithFrame:CGRectMake(kScreenWith*0.666, 64, kScreenWith*0.333, kScreenWith*0.094)];
    
    self.m_btn_tableView1.delegate_Btn_TableView = self;
    self.m_btn_tableView2.delegate_Btn_TableView = self;
    self.m_btn_tableView3.delegate_Btn_TableView = self;
    //按钮名字
    self.m_btn_tableView1.m_Btn_Name = @"状态排序";
    self.m_btn_tableView2.m_Btn_Name = @"语言筛选";
    self.m_btn_tableView3.m_Btn_Name = @"时间排序";
    
    //数据内容
    self.m_btn_tableView1.m_TableViewData = @[@"解决",@"未解决"];
    self.m_btn_tableView2.m_TableViewData = @[@"英文",@"中文",@"法文",@"俄文"];
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
    //    [_rightBtn addTarget:self selfaction:@selector(searchprogram)forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addSubview:editImage];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

//第三步：处理通知
-(void)setTextALabel2:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.select2 = [textDic objectForKey:@"文本"];
    NSLog(@"%@",self.select2);
    //    [self loadDataFromWeb];
    //   [self.mainTableView reloadData];
    if (!self.m_btn_tableView1.m_btnpanduan&!self.m_btn_tableView2.m_btnpanduan&!self.m_btn_tableView3.m_btnpanduan) {
        [self.m_btn_tableView1.m_btn setUserInteractionEnabled:YES];
        [self.m_btn_tableView2.m_btn setUserInteractionEnabled:YES];
        [self.m_btn_tableView3.m_btn setUserInteractionEnabled:YES];
        
    }
    if (self.m_btn_tableView1.m_btnpanduan) {
        [self.m_btn_tableView2.m_btn setUserInteractionEnabled:NO];
        [self.m_btn_tableView3.m_btn setUserInteractionEnabled:NO];
    }
    if (self.m_btn_tableView2.m_btnpanduan) {
        [self.m_btn_tableView1.m_btn setUserInteractionEnabled:NO];
        [self.m_btn_tableView3.m_btn setUserInteractionEnabled:NO];
    }
    if (self.m_btn_tableView3.m_btnpanduan) {
        [self.m_btn_tableView1.m_btn setUserInteractionEnabled:NO];
        [self.m_btn_tableView2.m_btn setUserInteractionEnabled:NO];
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


#pragma mark - 页面跳转
-(void)interpretClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)loadDataFromWeb{
    [WebAgent myRewardrewardID:@"111" success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"asd%@",dic);
        NSArray *reward_info = dic[@"reward_info"];
        NSLog(@"有%lu条数据",(unsigned long)reward_info.count);
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
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        
        CGSize size = [@"网络错误" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
        
        
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width) / 2, 500, size.width + 10, size.height + 6)];
        
        
        //self.tiXianBut.frame.origin.y + 80
        
        
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
    NSDictionary *aa = self.dataArr[indexPath.row];
    NSString *time = aa[@"release_time"];
    NSString *title = aa[@"reward_title"];
    NSString *text = aa[@"reward_text"];
    NSString *url = aa[@"reward_url"];
    NSString *money = aa[@"reward_money"];
    NSString *state = aa[@"proceed_state"];
    NSString *rewardID = aa[@"reward_id"];
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
    
    
    self.textV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWith*0.048,kScreenWith*0.013,kScreenWith*0.902,kScreenWith*0.262)];
    self.textV.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:53.0f/255.0f blue:77.0f/255.0f alpha:1];
    self.textV.layer.cornerRadius = 5.0;
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.035, kScreenWith*0.017, kScreenWith*0.6, kScreenWith*0.059)];
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.titleLabel setTextColor:[UIColor colorWithRed:238.0f/255.0f green:204.0f/255.0f blue:69.0f/255.0f alpha:1]];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.035, kScreenWith*0.076, kScreenWith*0.582, kScreenWith*0.108)];
    self.contentLabel.text = text;
    [self.contentLabel setTextColor:[UIColor whiteColor]];
    self.contentLabel.numberOfLines = 2;
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.035, kScreenWith*0.194, kScreenWith*0.17, kScreenWith*0.04)];
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
    
    
    if(url){
        UIImage* image = [UIImage imageNamed:@"tu"];
        UIImageView *tu   = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateImg.frame)+10, kScreenWith*0.017,27,27)];
        [tu setImage:image];
        [self.textV addSubview:tu];
        
    }

    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.205, kScreenWith*0.194, kScreenWith*0.245, kScreenWith*0.04)];
    [self.dateLabel setTextColor:[UIColor whiteColor]];
    self.dateLabel.font = FONT_14;
    self.dateLabel.text = time;
    [self.dateLabel setNumberOfLines:0];
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWith*0.62, kScreenWith*0.194, kScreenWith*0.148, kScreenWith*0.04)];
    self.moneyLabel.text = money;
    [self.moneyLabel setTextColor:[UIColor redColor]];
    
    
    
    
    
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
        // NSString *reward_id = aa[@""]

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
