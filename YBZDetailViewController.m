//
//  YBZDetailViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZDetailViewController.h"
#import "AnswerCell.h"
#import "WebAgent.h"
#import "YBZRewardDetailModel.h"

@interface YBZDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIView *splitView;
}

//标题内容的View
@property (nonatomic, strong) UIView *contentView;
//回答的tableview
@property (nonatomic, strong) UITableView *answerTableView;
//底部提示label
@property (nonatomic, strong) UILabel *bottomAlertLabel;
//数据模型
@property (nonatomic, strong) YBZRewardDetailModel *rewardDetailModel;
//标题View
@property (nonatomic, strong) UIView *titleView;
//内容Label
@property (nonatomic, strong) UILabel *contentLabel;
//悬赏图片
@property (nonatomic, strong) UIImageView *rewardImageView;
//时间Label
@property (nonatomic, strong) UILabel *timeLabel;
//人数label
@property (nonatomic, strong) UILabel *answerNumLabel;


@end

@implementation YBZDetailViewController{

    CGSize sizeOfPic;
    UIImageView *tagImage;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置背景色
    self.view.backgroundColor = UIColorFromRGB(0xEFEFEF);
    //设置标题
    self.title = @"悬赏详情";
    [self loadDataFromWeb];

    
}


#pragma mark -----WebAgent-----
-(void)loadDataFromWeb{

    [WebAgent rewardDetial:self.reward_id success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = dic[@"data"][0];
        NSMutableArray *arr = dict[@"answer_list"];
        NSUInteger i;
        if ([arr isKindOfClass:[NSString class]] ) {
            i=0;
        }else{
            i=arr.count;
        }
        NSString *str;
        if (![dict[@"reward_tag"]isEqualToString:@""]) {
            str = [NSString stringWithFormat:@"%@、%@",dict[@"language"] ,dict[@"reward_tag"]];
        }else{
            str = dict[@"language"];
        }
        _rewardDetailModel = [[YBZRewardDetailModel alloc]initWithTitle:dict[@"reward_title"] AndContent:dict[@"reward_text"] AndImageUrl:dict[@"reward_pic_url"] AndTime:dict[@"release_time"]  AndTag:str AndNumber:i AndAnswerList:arr AndState:dict[@"proceed_state"]];
        NSLog(@"1");
        [self setAllControlsFrame];
        [self addAllControls];

    } failure:^(NSError *error) {
        
    }];
}



#pragma mark ----Set Frame-----
-(void)setAllControlsFrame{

    self.contentView.frame = CGRectMake(0, 0.1*SCREEN_HEIGHT, SCREEN_WIDTH, 0.41*SCREEN_HEIGHT);
    self.answerTableView.frame = CGRectMake(0, 0.525*SCREEN_HEIGHT, SCREEN_WIDTH, 0.385*SCREEN_HEIGHT);
    self.bottomAlertLabel.frame = CGRectMake(0, 0.925*SCREEN_HEIGHT, SCREEN_WIDTH, 0.075*SCREEN_HEIGHT);
    self.titleView.frame = CGRectMake(0, 0.00*SCREEN_HEIGHT, SCREEN_WIDTH, 0.034*SCREEN_HEIGHT);
    CGSize textLabelSize;
    NSString *info = self.contentLabel.text;
    textLabelSize = [info boundingRectWithSize:CGSizeMake(0.932*SCREEN_WIDTH, 0.077*SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.034*SCREEN_WIDTH]} context:nil].size;
    self.contentLabel.frame = CGRectMake(0.034*SCREEN_WIDTH, 0.058*SCREEN_HEIGHT, 0.932*SCREEN_WIDTH, textLabelSize.height);
    self.rewardImageView.frame = CGRectMake(0.034*SCREEN_WIDTH, 0.136*SCREEN_HEIGHT, 0.145*SCREEN_HEIGHT/sizeOfPic.height*sizeOfPic.width, 0.145*SCREEN_HEIGHT);
    self.timeLabel.frame = CGRectMake(0.034*SCREEN_WIDTH, 0.3*SCREEN_HEIGHT, SCREEN_WIDTH/3, 0.017*SCREEN_HEIGHT);
    self.answerNumLabel.frame = CGRectMake(2*SCREEN_WIDTH/3, 0.3*SCREEN_HEIGHT, SCREEN_WIDTH/3-0.034*SCREEN_WIDTH, 0.017*SCREEN_HEIGHT);
}



#pragma mark ----- AddControl-----
-(void)addAllControls{

    [self.view addSubview:self.contentView];
    [self.view addSubview:self.answerTableView];
    [self.view addSubview:self.bottomAlertLabel];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.rewardImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.answerNumLabel];
}




#pragma mark -----TableViewDelegate-----


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _rewardDetailModel.answerArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _rewardDetailModel.answerArr[indexPath.row];
    [dict setValue:_rewardDetailModel.rewardState forKey:@"proceed_state"];
    AnswerCell *cell = [[AnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" Model:dict];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict = _rewardDetailModel.answerArr[indexPath.row];
    [dict setValue:_rewardDetailModel.rewardState forKey:@"proceed_state"];
        AnswerCell *cell = [[AnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" Model:dict];
    return cell;
}



#pragma mark -----getters-----

-(UIView *)contentView{

    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        splitView = [[UIView alloc]initWithFrame:CGRectMake(0.034*SCREEN_WIDTH, 0.34*SCREEN_HEIGHT, SCREEN_WIDTH-0.068*SCREEN_WIDTH, 0.0034*SCREEN_HEIGHT)];
        splitView.backgroundColor = myRewardBackgroundColor;
        tagImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag00"]];
        tagImage.frame = CGRectMake(0.034*SCREEN_WIDTH, 0.365*SCREEN_HEIGHT, 0.034*SCREEN_WIDTH, 0.034*SCREEN_WIDTH);
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.077*SCREEN_WIDTH, 0.363*SCREEN_HEIGHT, 0.9*SCREEN_WIDTH, 0.02*SCREEN_HEIGHT)];
        if (_rewardDetailModel.rewardTag != nil && ![_rewardDetailModel.rewardTag isEqualToString:@""]) {
            tagLabel.text = _rewardDetailModel.rewardTag;
        }else{
            tagLabel.text = @"";
        }
        tagLabel.font = [UIFont systemFontOfSize:0.02*SCREEN_HEIGHT];
        tagLabel.textColor = [UIColor grayColor];
        [_contentView addSubview:tagLabel];
        [_contentView addSubview:tagImage];
        [_contentView addSubview:splitView];
        
    }
    return _contentView;
}


-(UITableView *)answerTableView{

    if (!_answerTableView) {
        _answerTableView = [[UITableView alloc]init];
        [_answerTableView registerClass:[AnswerCell class] forCellReuseIdentifier:@"Cell"];
        _answerTableView.backgroundColor = [UIColor whiteColor];
//        _answerTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _answerTableView.allowsSelection = NO;
        _answerTableView.dataSource=self;
        _answerTableView.delegate=self;
        _answerTableView.showsVerticalScrollIndicator = NO;
        _answerTableView.tableFooterView = [[UIView alloc]init];
    }
    return _answerTableView;
}

-(UILabel *)bottomAlertLabel{

    if (!_bottomAlertLabel) {
        _bottomAlertLabel = [[UILabel alloc]init];
        _bottomAlertLabel.text = @"   正在为您寻找答案，请耐心等待！";
        _bottomAlertLabel.font = [UIFont systemFontOfSize:0.044*SCREEN_WIDTH];
        _bottomAlertLabel.textColor = [UIColor grayColor];
        _bottomAlertLabel.textAlignment = NSTextAlignmentLeft;
        _bottomAlertLabel.backgroundColor = [UIColor whiteColor];
    }
    return _bottomAlertLabel;
}

-(UIView *)titleView{

    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        UILabel *ask = [[UILabel alloc]initWithFrame:CGRectMake(0.034*SCREEN_WIDTH, 0.017*SCREEN_HEIGHT, SCREEN_WIDTH, 0.034*SCREEN_HEIGHT)];
        ask.text = @"问：";
        ask.textColor = UIColorFromRGB(0x2BB6ED);
        ask.textAlignment = NSTextAlignmentLeft;
        ask.font = [UIFont systemFontOfSize:0.05*SCREEN_WIDTH];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.134*SCREEN_WIDTH, 0.017*SCREEN_HEIGHT, 0.832*SCREEN_WIDTH, 0.034*SCREEN_HEIGHT)];
        titleLabel.text = _rewardDetailModel.rewardTitle;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:0.05*SCREEN_WIDTH];

        [_titleView addSubview:ask];
        [_titleView addSubview:titleLabel];
        
    }
    return _titleView;
}

-(UILabel *)contentLabel{

    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = _rewardDetailModel.rewardContent;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:0.038*SCREEN_WIDTH];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(UIImageView *)rewardImageView{

    if (!_rewardImageView) {
        _rewardImageView = [[UIImageView alloc]init];
        NSURL *url = [NSURL URLWithString:_rewardDetailModel.rewardImageName];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        if (img != nil) {
            _rewardImageView.image = img;
            sizeOfPic = img.size;
        }else{
            UIImage *image = [UIImage imageNamed:@"img"];
            _rewardImageView.image = image;
            sizeOfPic = image.size;
        }
        _rewardImageView.backgroundColor = [UIColor blackColor];
    }
    return _rewardImageView;
}

-(UILabel *)timeLabel{

    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = _rewardDetailModel.rewardTime;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    }
    return _timeLabel;
}


-(UILabel *)answerNumLabel{

    if (!_answerNumLabel) {
        _answerNumLabel = [[UILabel alloc]init];
        _answerNumLabel.text = [NSString stringWithFormat:@"%lu人回答",(unsigned long)_rewardDetailModel.answerPeopleNum];
        _answerNumLabel.textAlignment = NSTextAlignmentRight;
        _answerNumLabel.textColor = [UIColor grayColor];
        _answerNumLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    }
    return _answerNumLabel;
}



@end
