//
//  AnswerTransViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/11.
//  Copyright © 2016年 ZYQ. All rights reserved.
//

#import "YBZDetailViewController.h"
#import "MessageInfoCell.h"
#import "MessageInfoCellData.h"

#import "UnfoldCell.h"
#import "UnfoldModel.h"
#import "UnfoldFrameModel.h"

#import "AFNetworking.h"

#define kScreenWidth self.view.bounds.size.width
#define margin 10

@interface YBZDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UnfoldCellDelegate>

@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSDictionary *myData;

//cell1
@property (nonatomic, strong)UILabel *askLableOne;
@property (nonatomic, strong)UILabel *asklableTwo;

//cell2
@property (nonatomic,strong)NSMutableArray *dataArray;

//cell3
@property (nonatomic, strong)UIImageView *askImage;
@property (nonatomic, strong)UILabel *askLastTime;
@property (nonatomic, strong)UILabel *answerPersonNum;

//cell4
@property (nonatomic, strong)UIImageView *lableImage;
@property (nonatomic, strong)UILabel *languageLable;
@property (nonatomic, strong)UIButton *changeButton;

@end

@implementation YBZDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    //修改返回键图标
    //隐藏标签栏
    
    self.tabBarController.tabBar.hidden = YES;
    //[self initLoadData];
    //[self dictionaryData];
    [self initTableView];
    [self.view addSubview:self.backBtn];
    [self loadDataFromWebTwo];
    
}

//-(void)dictionaryData:(NSString *)reward_id
/*-(void)dictionaryData
 {
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
 NSDictionary *paramDict = @{@"reward_id":@"0000"};
 [manager POST:@"http://127.0.0.1/TravelHelper/index.php/Home/Reward/rewardInformation" parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
 //do nothing
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 //链接成功
 NSData *data = [[NSData alloc]initWithData:responseObject];
 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 self.myData = dic;
 NSLog(@"%@",dic);
 //NSLog(@"%@",dic[@"data"][@"user_nickname"]);
 NSLog(@"%@",dic[@"data"][1][@"answer_text"]);
 NSLog(@"%lu",(unsigned long)dic.count);
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 //链接失败
 NSLog(@"%@",error);
 }];
 
 }*/
#pragma mark - 自定义返回键
-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 20, 20);
        //_backBtn.backgroundColor = [UIColor whiteColor];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_backBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return _backBtn;
}

#pragma mark - 添加UITableView并签署协议
-(void)initTableView{
    self.dataArr = [NSMutableArray array];
    //_mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    UITableView *mainTableView = [[UITableView alloc]init];
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    mainTableView.frame = self.view.bounds;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.allowsSelection = NO;
}

/*-(void)initLoadData
 {
 self.dataArray = [NSMutableArray array];
 NSArray *array  = @[@"Apple is supplying this information to help you plan for the adoption of the technologies and programming interfaces described herein for use on Apple-branded products. This information is subject to change, and software implemented according to this document should be tested with final operating system software and final documentation. Newer versions of this document may be provided with future betas of the API or technology."];
 
 for (NSString *str in array) {
 UnfoldModel *model = [[UnfoldModel alloc]init];
 model.contenxt = str;
 model.isUnflod = NO;//给出初始值
 
 UnfoldFrameModel *frameModel = [[UnfoldFrameModel alloc]init];
 frameModel.model = model;
 [self.dataArray addObject:frameModel];
 }
 
 }*/


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 数据源方法 接受数据
-(void)loadDataFromWebTwo{
    //网络接口
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramDict = @{@"reward_id":@"0000"};
    [manager POST:@"http://127.0.0.1/TravelHelper/index.php/Home/Reward/rewardInformation" parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        //do nothing
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //链接成功
        self.dataArr = [NSMutableArray array];
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.myData = dic;
        NSLog(@"%@",dic);
        //NSLog(@"%@",dic[@"data"][@"user_nickname"]);
        NSLog(@"%@",dic[@"data"][1][@"answer_text"]);
        NSLog(@"%lu",(unsigned long)dic.count);
        
        NSArray *arr=dic[@"data"];
        
        for (int i = 0; i < arr.count; i++) {
            //        NSString *data;
            //        NSString *dataA;
            //        NSString *str = [NSString stringWithFormat:@"%d",i];
            //        dataA = [data stringByAppendingString:str];
            MessageInfoCellData *data1 = [[MessageInfoCellData alloc]initWithimagePath:@""answerNickname:@"" answerWord:dic[@"data"][i][@"answer_text"] lastTime:@"" acceptOrnot:@""];
            NSLog(@"%@",data1);
            [self.dataArr addObject:data1];
        }
        
        
        
        
        [self.mainTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //链接失败
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - 表视图协议
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) {
        number = 4;
    }
    
    if(section == 1){
        number = 1;
    }
    return number;
    
}

//分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

//设置header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
//样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1,创建cell
    static NSString *ID = @"cell";
    UnfoldCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:ID];
    static NSString *cellIdentified = @"MessageInfoCell.h";
    MessageInfoCell *customCell=[tableView dequeueReusableCellWithIdentifier:cellIdentified];
    //static NSString *cellIdentifier = @"SectionTableViewCell";
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//最右边>号
    if ( section == 0 && row == 0) {
        
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _askLableOne = [[UILabel alloc]initWithFrame:CGRectMake(margin, 0, 40, 40)];
        _askLableOne.text = @"问:";
        _askLableOne.textColor = [UIColor cyanColor];
        _askLableOne.textAlignment = NSTextAlignmentLeft;
        _askLableOne.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        
        _asklableTwo = [[UILabel alloc]initWithFrame:CGRectMake(40+margin, 0,kScreenWidth - 40 - 2*margin , 40)];
        _asklableTwo.text = @"请帮我翻译这个广告牌子";
        _asklableTwo.font = [UIFont fontWithName:@"Helvetica-Oblique" size:20];
        [cell addSubview:self.askLableOne];
        [cell addSubview:self.asklableTwo];
    }
    
    
    if ( section == 0 && row == 1){
        
        cellTwo = [[UnfoldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID ];
        
    }
    
    if ( section == 0 && row == 2){
        
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        _askImage = [[UIImageView alloc]initWithFrame:CGRectMake(margin, 0, 120, 120)];
        _askImage.backgroundColor = [UIColor grayColor];
        
        _askLastTime = [[UILabel alloc]initWithFrame:CGRectMake(margin, 130,60, 20)];
        _askLastTime.text = @"3分钟前";
        _askLastTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        _askLastTime.textColor = [UIColor grayColor];
        _answerPersonNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-margin-40, 130, 60,20)];
        _answerPersonNum.text = @"1人回答";
        _answerPersonNum.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        _answerPersonNum.textColor = [UIColor grayColor];
        [cell addSubview:self.askImage];
        [cell addSubview:self.askLastTime];
        [cell addSubview:_answerPersonNum];
        
    }
    if ( section == 0 && row == 3){
        
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _lableImage = [[UIImageView alloc]initWithFrame:CGRectMake(margin, 15, 20, 20)];
        _lableImage.backgroundColor = [UIColor orangeColor];
        
        _languageLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 60, 30)];
        _languageLable.text = @"英文";
        _languageLable.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
        _languageLable.textColor = [UIColor grayColor];
        
        _changeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 90, 10, 80, 30)];
        [_changeButton setTitle:@"修改标签" forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
        [_changeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchDown];
        
        [cell addSubview:self.lableImage];
        [cell addSubview:self.languageLable];
        [cell addSubview:self.changeButton];
    }
    
    if ( section == 1 ){
        
        MessageInfoCellData *data = [[MessageInfoCellData alloc]init];
        data.imagePath = self.dataArray[row][@"reward_url"];
//        data.answerNickname = self.dataArr[row][@""];
        customCell = [[MessageInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentified setCellData:data];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    if (section == 0 && row!= 1) {
        return cell;
    }
    if (section == 0 && row== 1) {
        UnfoldFrameModel *frameModel = self.dataArray[0];
        cellTwo.frameModel = frameModel;
        cellTwo.delegate = self;
        return cellTwo;
    }
    else{
        return customCell;
    }
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger height = 0;
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if ( section == 0 && row == 0) {
        height = 40;
    }
    if ( section == 0 && row == 1) {
        UnfoldFrameModel *frameModel = self.dataArray[0];
        height = frameModel.cellH;
    }
    if ( section == 0 && row == 2) {
        height = 160;
    }
    if ( section == 0 && row == 3) {
        height = 50;
    }
    if ( section == 1 ) {
        height = 140;
    }
    return height;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath
{
    //    NSInteger section = indexPath.section;
    //    NSUInteger row = indexPath.row;
    //    if ( section == 0 && row == 0) {
    //
    //        [self intoUserDetailInfoClick];
    //
    //    }
    
}

-(void)changeButtonClick{
    
    
}
-(void)UnfoldCellDidClickUnfoldBtn:(UnfoldFrameModel *)frameModel
{
    NSInteger index = [self.dataArray indexOfObject:frameModel];
    UnfoldModel *model = frameModel.model;
    model.isUnflod = !model.isUnflod;
    frameModel.model = model;//这句话很关键，要把值设置回来，因为其setModel方法中会重新计算frame
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
