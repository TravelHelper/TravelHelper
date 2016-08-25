//
//  AnswerTransViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/11.
//  Copyright © 2016年 ZYQ. All rights reserved.
//


//详情（用户）
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

//可变cell
@property (nonatomic, strong)NSArray *numberOfCell;
@property (nonatomic, strong)NSMutableArray *textCell;
@end

@implementation YBZDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    //修改返回键图标
    //隐藏标签栏
    
    self.tabBarController.tabBar.hidden = YES;
    [self initLoadData];
    //[self dictionaryData];
    [self initTableView];
    [self.view addSubview:self.backBtn];
    [self loadDataFromWebTwo];
    
}

#pragma mark - 添加UITableView并签署协议
-(void)initTableView{
    self.dataArr = [NSMutableArray array];
    UITableView *mainTableView = [[UITableView alloc]init];
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    mainTableView.frame = self.view.bounds;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.allowsSelection = NO;
}


//返回首页
-(void)backToRoot{

    [self.navigationController popViewControllerAnimated:YES];
}



-(void)initLoadData
{
    self.dataArray = [NSMutableArray array];
    NSArray *array  = @[self.data[@"text"]];
    
    for (NSString *str in array) {
        UnfoldModel *model = [[UnfoldModel alloc]init];
        model.contenxt = str;
        model.isUnflod = NO;//给出初始值
        
        UnfoldFrameModel *frameModel = [[UnfoldFrameModel alloc]init];
        frameModel.model = model;
        [self.dataArray addObject:frameModel];
    }
    
}





#pragma mark - 数据源方法 接受数据
-(void)loadDataFromWebTwo{
    //网络接口
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *paramDict = @{@"reward_id":@"wqwwd"};
    [manager POST:@"http://127.0.0.1/TravelHelper/index.php/Home/Reward/rewardInformation" parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        //do nothing
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //链接成功
        self.dataArr = [NSMutableArray array];
        self.textCell = [NSMutableArray array];
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.myData = dic;
        NSLog(@"%@",dic);
        //NSLog(@"%@",dic[@"data"][@"user_nickname"]);
        NSLog(@"%@",dic[@"data"][1][@"answer_text"]);
        NSLog(@"%lu",(unsigned long)dic.count);
        
        NSArray *arr=dic[@"data"];
        NSNumber *aNumber = [NSNumber numberWithInteger:arr.count];
        self.numberOfCell = @[aNumber];
        for (int i = 0; i < arr.count; i++) {
            MessageInfoCellData *data1 = [[MessageInfoCellData alloc]initWithimagePath:@""answerNickname:@"壁咚" answerWord:dic[@"data"][i][@"answer_text"] lastTime:@"" acceptOrnot:dic[@"data"][i][@"proceed_state"]];
            NSLog(@"%@",data1);
            [self.dataArr addObject:data1];
            [self.textCell addObject:dic[@"data"][i][@"answer_text"]];
            NSLog(@"%lu",(unsigned long)self.textCell.count);
        }
        [self.mainTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //链接失败
        NSLog(@"%@",error);
    }];
    
    
    // MessageInfoCellData *data1 = [[MessageInfoCellData alloc]initWithimagePath:@"" answerNickname:@"--" answerWord:@"--" lastTime:@"--" acceptOrnot:@"--"];
    //self.dataArr = @[data1];
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
        NSInteger anInteger = [self.numberOfCell[0] integerValue];
        number = anInteger;
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
        _asklableTwo.text = self.data[@"title"];
        _asklableTwo.font = [UIFont fontWithName:@"Helvetica-Oblique" size:20];
        [cell addSubview:self.askLableOne];
        [cell addSubview:self.asklableTwo];
    }
    
    
    if ( section == 0 && row == 1){
        
        cellTwo = [[UnfoldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID ];
        
    }
    
    if ( section == 0 && row == 2){
        
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
        _askImage = [[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, 120, 120)];
        _askImage.backgroundColor = [UIColor grayColor];
        
        _askLastTime = [[UILabel alloc]initWithFrame:CGRectMake(margin, 140,60, 20)];
        _askLastTime.text = self.data[@"time"];
        _askLastTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        _askLastTime.textColor = [UIColor grayColor];
        _answerPersonNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-margin-60, 140, 60,20)];
        //字符串拼接,判断回答人数
        NSInteger anInteger = [self.numberOfCell[0] integerValue];
        //[NSString stringWithFormat: @"%ld", (long)anInteger];
        NSString *text = [[NSString stringWithFormat: @"%ld", (long)anInteger] stringByAppendingString:@"人回答"];
        _answerPersonNum.text = text;
        _answerPersonNum.textAlignment = NSTextAlignmentRight;
        _answerPersonNum.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        _answerPersonNum.textColor = [UIColor grayColor];
        [cell addSubview:self.askImage];
        [cell addSubview:self.askLastTime];
        [cell addSubview:_answerPersonNum];
        
    }
    if ( section == 0 && row == 3){
        
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _lableImage = [[UIImageView alloc]initWithFrame:CGRectMake(margin, 18, 12, 12)];
        //_lableImage.backgroundColor = [UIColor orangeColor];
        UIImage *image = [UIImage imageNamed:@"lable"];
        _lableImage.image = image;
        _languageLable = [[UILabel alloc]initWithFrame:CGRectMake(26, 10, 60, 30)];
        _languageLable.text = @"英文";
        _languageLable.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
        _languageLable.textColor = [UIColor grayColor];
        
        _changeButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 90, 10, 80, 30)];
        [_changeButton setTitle:@"修改标签" forState:UIControlStateNormal];
        
        _changeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _changeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
        [_changeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _changeButton.titleLabel.textAlignment =NSTextAlignmentRight;
        [_changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchDown];
        
        [cell addSubview:self.lableImage];
        [cell addSubview:self.languageLable];
        [cell addSubview:self.changeButton];
    }
    
    if ( section == 1 ){
        
        MessageInfoCellData *data = self.dataArr[row];
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
        height = 170;
    }
    if ( section == 0 && row == 3) {
        height = 50;
    }
    if ( section == 1 ) {
        for (int i = 0; i < self.textCell.count; i++) {
            CGSize sizeToFit = [self.textCell[i] sizeWithFont:[UIFont systemFontOfSize:16]
                                            constrainedToSize:CGSizeMake(334, CGFLOAT_MAX)
                                                lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
            //  NSLog(@"%ld",(long)height);
            row = i;
            height = 110 + sizeToFit.height;
        }
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
    //NSInteger index = [self.dataArray indexOfObject:frameModel];
    UnfoldModel *model = frameModel.model;
    model.isUnflod = !model.isUnflod;
    frameModel.model = model;//这句话很关键，要把值设置回来，因为其setModel方法中会重新计算frame
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
