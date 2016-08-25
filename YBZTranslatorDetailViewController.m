//
//  YBZTranslatorDetailViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//


//详情（译员）
#import "YBZTranslatorDetailViewController.h"
#import "YBZTranslatorAnswerViewController.h"
#import "WebAgent.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMarginTopLeftBottom kScreenHeight / 46 //屏幕上下左边距
#define kMarginRight kScreenHeight / 69 //屏幕右边距
#define kMarginTopWidthPrevious kScreenHeight / 69 //控件之间的间隔
#define kOpenButtonHeight kScreenHeight * 16 / 690 //展开按钮的高度
#define kShowLinesNums 2 //问题详细内容显示的行数
#define kBackgroundColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] //页面灰色背景色
#define kTextColor [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1] //页面文字颜色

@interface YBZTranslatorDetailViewController ()

@property(nonatomic,strong) UIView *topContainer; //questionLabel,contentLabel,openButton的容器控件
@property(nonatomic,strong) UILabel *questionLabel; //显示问题
@property(nonatomic,strong) UILabel *contentLabel; //显示问题具体内容
@property(nonatomic,assign) CGFloat contentLabelHeight;
@property(nonatomic,assign) CGFloat oneLineHeight;
@property(nonatomic,strong) UIButton *openButton; //问题label下的展开按钮
@property(nonatomic,strong) UIImageView *openButtonArrowImage; // 展开按钮上的箭头
@property(nonatomic,assign) BOOL *isShowOpenButton; //是否显示展开按钮
@property(nonatomic,assign) BOOL *isOpen; //问题label的展开状体

@property(nonatomic,strong) UIView *contentView; //容器控件
@property(nonatomic,strong) UIImageView *imageView; //与问题有关的图片控件
@property(nonatomic,strong) UILabel *timeLabel; //显示回答时间
@property(nonatomic,strong) UILabel *answerPeopleNumLabel; //显示回答人数
@property(nonatomic,strong) UIView *lineLabel; //较细灰色分割线
@property(nonatomic,strong) UIImageView *languageImageView; //语言label旁的图片
@property(nonatomic,strong) UILabel *languageLabel; //显示语言
@property(nonatomic,strong) UILabel *moneyLabel; //显示悬赏金额
@property(nonatomic,strong) UIView *lineLabel1; //较粗灰色分割线
@property(nonatomic,strong) UIButton *bottomBtn; //最底部的翻译按钮
@property (nonatomic,strong) NSString *answer;
@property (nonatomic,strong) UIImage *photoImg;
@property (nonatomic,strong) NSDictionary *decidesStr;
@end

@implementation YBZTranslatorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"详   情";

    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.topContainer];
    [self.view addSubview:self.bottomBtn];
    
    
    self.isOpen = NO;
    
    
}





#pragma mark -容器控件,问题label和详细内容label的get方法
-(UIView *)topContainer{
    
    if(!_topContainer){
        
        _topContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight * 42 / 69)];
        _topContainer.backgroundColor = [UIColor whiteColor];
        
        [_topContainer addSubview:self.questionLabel];
        [_topContainer addSubview:self.contentLabel];
        [_topContainer addSubview:self.contentView];
        
        if(self.isShowOpenButton){
            [_topContainer addSubview:self.openButton];
        }
    }
    return _topContainer;
    
}


-(UILabel *)questionLabel{
    
    if(!_questionLabel){
        
        NSString *str = @"问:";
        NSString *str1 = [self.data objectForKey:@"title"];
        str = [str stringByAppendingString:str1];
        CGFloat width = kScreenWidth - kMarginTopLeftBottom - kMarginRight;
        CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        
        _questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginTopLeftBottom, kMarginTopLeftBottom, width, size.height)];
        _questionLabel.textAlignment = NSTextAlignmentLeft;
        _questionLabel.font = [UIFont systemFontOfSize:20];
        _questionLabel.numberOfLines = 0;
        
        NSString *title = @"问:";
        NSMutableAttributedString *styledText = [[NSMutableAttributedString alloc]initWithString:str];
        NSDictionary *attributes = @{ NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:188/255.0 blue:243/255.0 alpha:1]};
        NSRange nameRange = [str rangeOfString:title];
        [styledText setAttributes:attributes range:nameRange];
        _questionLabel.attributedText = styledText;
        
        
    }
    return _questionLabel;
    
}
-(UILabel *)contentLabel{
    
    if(!_contentLabel){

        NSString *str = [self.data objectForKey:@"text"];
        self.contentLabelHeight = [str boundingRectWithSize:CGSizeMake(self.questionLabel.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        self.oneLineHeight = [@"这是一行" boundingRectWithSize:CGSizeMake(self.questionLabel.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        if((self.contentLabelHeight / self.oneLineHeight) <= kShowLinesNums){
            
            _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginTopLeftBottom, self.questionLabel.frame.origin.y + self.questionLabel.bounds.size.height, self.questionLabel.bounds.size.width, self.contentLabelHeight)];
            self.isShowOpenButton = NO;
            
        }else{
            
            _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginTopLeftBottom, self.questionLabel.frame.origin.y + self.questionLabel.bounds.size.height, self.questionLabel.bounds.size.width, self.oneLineHeight * kShowLinesNums)];
            self.isShowOpenButton = YES;
            
        }
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = kTextColor;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = str;
        
        
    }
    
    return _contentLabel;
}
#pragma mark -展开按钮设置
-(UIButton *)openButton{
    
    if(!_openButton){
        
        CGFloat width = 50;
        _openButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentLabel.frame.origin.x + self.contentLabel.bounds.size.width - width,self.contentLabel.frame.origin.y + self.contentLabel.bounds.size.height, width, kOpenButtonHeight)];
        _openButton.backgroundColor = kBackgroundColor;;
        [_openButton setTitleColor:kTextColor forState:UIControlStateNormal];
        _openButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _openButton.layer.cornerRadius = 1;
        [_openButton setTitle:@"展开" forState:UIControlStateNormal];
        _openButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_openButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _openButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0 ,0);
        
        [_openButton addSubview:self.openButtonArrowImage];
    }
    return _openButton;
}
-(void)openButtonClick{
    
    CGFloat changeHeight = (self.contentLabelHeight / self.oneLineHeight - kShowLinesNums) * self.oneLineHeight;
    
    if(_isOpen){
        
        self.topContainer.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight * 42 / 69);
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.bounds.size.width, self.contentLabel.bounds.size.height - changeHeight);
        self.openButton.frame = CGRectMake(self.openButton.frame.origin.x,self.contentLabel.frame.origin.y + self.contentLabel.bounds.size.height, self.openButton.bounds.size.width, kOpenButtonHeight);
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentLabel.frame.origin.y + self.contentLabel.bounds.size.height + kMarginTopWidthPrevious*2, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        self.openButtonArrowImage.image = [UIImage imageNamed:@"arrow"];
       // [_openButton setTitle:@"收起" forState:UIControlStateSelected];
        [_openButton setTitle:@"展开" forState:UIControlStateNormal];
        self.isOpen = NO;
        
    }else{
        
        self.topContainer.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight * 42 / 69 + changeHeight);
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.bounds.size.width, self.contentLabel.bounds.size.height + changeHeight);
        self.openButton.frame = CGRectMake(self.openButton.frame.origin.x,self.contentLabel.frame.origin.y + self.contentLabel.bounds.size.height, self.openButton.bounds.size.width, kOpenButtonHeight);
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + changeHeight, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        self.openButtonArrowImage.image = [UIImage imageNamed:@"arrow1"];
        [_openButton setTitle:@"收起" forState:UIControlStateNormal];
        self.isOpen = YES;
        
    }
    
}
-(UIImageView *)openButtonArrowImage{
    
    if(!_openButtonArrowImage){
        
        CGFloat width = 10;
        CGFloat height = 10;
        _openButtonArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.openButton.bounds.size.width - width - 1, (self.openButton.bounds.size.height - height) / 2, width, height)];
        _openButtonArrowImage.image = [UIImage imageNamed:@"arrow"];
        
        
    }
    return _openButtonArrowImage;
}

#pragma mark -contentView展开按钮下方所有视图集合
-(UIView *)contentView{
    
    if(!_contentView){
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(kMarginTopLeftBottom, self.contentLabel.frame.origin.y + self.contentLabel.bounds.size.height + kMarginTopWidthPrevious * 2, self.contentLabel.bounds.size.width, self.topContainer.bounds.size.height - self.contentLabel.frame.origin.y - self.contentLabel.bounds.size.height - kMarginTopWidthPrevious*2)];
        [_contentView addSubview:self.imageView];
        [_contentView addSubview:self.timeLabel];
        [_contentView addSubview:self.answerPeopleNumLabel];
        [_contentView addSubview:self.lineLabel];
        [_contentView addSubview:self.languageImageView];
        [_contentView addSubview:self.languageLabel];
        [_contentView addSubview:self.moneyLabel];
        [_contentView addSubview:self.lineLabel1];
        [_contentView addSubview:self.showAnswerLabel];
        
    }
    return _contentView;
    
}
-(UIImage *)photoImg{
    if (!_photoImg) {
        _photoImg = [[UIImage alloc]init];
    }
    return _photoImg;
}
-(UIImageView *)imageView{
    
    if(!_imageView){
        _imageView = [[UIImageView alloc]init];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth * 92 / 370, kScreenHeight * 95 / 690)];
        NSString *photo = self.data[@"reward_url"];
        NSString *str = [NSString stringWithFormat:@"%@.jpg",photo];
        NSString *url = [NSString stringWithFormat:@"http://%@/travelhelper/uploadimg/%@",serviseId,str];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        _photoImg = [UIImage imageWithData:data];
        
        if (_photoImg) {
            [_imageView setImage:_photoImg];
        }else{
        [self.imageView setImage:[UIImage imageNamed:@"ProfilePhoto"]];

        }
      //  NSString *imageUrl = [self.data objectForKey:@"url"];
       // NSURL *url = [NSURL URLWithString:imageUrl];
    // [self.imageView setImageWithURL:url];
    }
    
    return _imageView;
}

-(UILabel *)timeLabel{
    
    if(!_timeLabel){
        
        NSString *str = [self.data objectForKey:@"time"];
        //自适应高度
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.bounds.size.height + kMarginTopWidthPrevious, size.width, size.height)];
        
        
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = kTextColor;
        _timeLabel.text = [self.data objectForKey:@"time"];
        
    }
    return _timeLabel;
}


-(UILabel *)answerPeopleNumLabel{
    
    if(!_answerPeopleNumLabel){
        NSString *strCount = [NSString stringWithFormat: @"%@", self.countPeople];
        NSString *str = @"人能回答";
        str = [strCount stringByAppendingString:str];
        NSLog(@"---------------->%@",str);
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        _answerPeopleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width  - size.width, self.timeLabel.frame.origin.y, size.width, size.height)];
        _answerPeopleNumLabel.font = [UIFont systemFontOfSize:10];
        _answerPeopleNumLabel.textColor = kTextColor;
        _answerPeopleNumLabel.text = str;
        
    }
    return _answerPeopleNumLabel;
}



-(UIView *)lineLabel{
    
    if(!_lineLabel){
        
        _lineLabel = [[UIView alloc]initWithFrame:CGRectMake(0, self.timeLabel.frame.origin.y + self.timeLabel.bounds.size.height + kMarginTopWidthPrevious, self.topContainer.bounds.size.width - kMarginTopLeftBottom - kMarginRight, 2)];
        _lineLabel.backgroundColor = kBackgroundColor;
        
    }
    return _lineLabel;
}

-(UIImageView *)languageImageView{
    
    if(!_languageImageView){
        
        CGFloat width = 10;
        CGFloat height = 10;
        _languageImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.languageLabel.frame.origin.y + self.languageLabel.bounds.size.height / 2 - height / 2, width, height)];
        _languageImageView.image = [UIImage imageNamed:@"label"];
        _languageImageView.contentMode = UIViewContentModeScaleAspectFit;
        _languageImageView.clipsToBounds  = YES;
        
    }
    return _languageImageView;
}


-(UILabel *)languageLabel{
    
    if(!_languageLabel){
        
        NSString *str = [self.data objectForKey:@"language"];
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _languageLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginTopLeftBottom, self.lineLabel.frame.origin.y + self.lineLabel.bounds.size.height + kMarginTopWidthPrevious, size.width, size.height)];
        _languageLabel.font = [UIFont systemFontOfSize:15];
        _languageLabel.textColor = kTextColor;
        _languageLabel.textAlignment = NSTextAlignmentLeft;
        _languageLabel.text = str;
    }
    return _languageLabel;
}
-(void)setLanguageLabelFrame:(NSString *)labelText{
    
    CGSize size = [labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.languageLabel.frame = CGRectMake(kMarginTopLeftBottom, self.languageLabel.frame.origin.y, size.width, size.height);
    
}


-(UILabel *)moneyLabel{
    
    if(!_moneyLabel){
        
        NSString *str = [@"悬赏金额：" stringByAppendingString:[self.data objectForKey:@"money"]];
        str = [str stringByAppendingString:@" 游币"];
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width - size.width, self.languageLabel.frame.origin.y + self.languageLabel.bounds.size.height / 2 - size.height / 2, size.width, size.height)];
        _moneyLabel.font = [UIFont systemFontOfSize:10];
        _moneyLabel.textColor = kTextColor;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.text = str;
        
    }
    return _moneyLabel;
    
}
-(void)setMomeyLabelFrame:(NSString *)labelText{
    
    CGSize size = [labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    self.moneyLabel.frame = CGRectMake(self.contentView.bounds.size.width - size.width, self.moneyLabel.frame.origin.y, size.width, size.height);
    
}


-(UIView *)lineLabel1{
    
    if(!_lineLabel1){
        
        _lineLabel1 = [[UIView alloc]initWithFrame:CGRectMake(-(kMarginTopLeftBottom - 2), self.languageLabel.frame.origin.y + self.languageLabel.bounds.size.height + kMarginTopWidthPrevious, kScreenWidth - 4, kScreenHeight *15 / 690)];
        _lineLabel1.backgroundColor = kBackgroundColor;
        
    }
    return _lineLabel1;
}
-(UIButton *)bottomBtn{
    
    if(!_bottomBtn){
        
        CGFloat height = kScreenHeight * 55 / 690;
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
        _bottomBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:221/255.0 blue:0 alpha:1];
        [_bottomBtn setTitle:@"我来翻译" forState:UIControlStateNormal];
        
        [_bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottomBtn;
}
-(UILabel *)showAnswerLabel{
    
    if(!_showAnswerLabel){
        
        _showAnswerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lineLabel1.frame.origin.y + self.lineLabel1.bounds.size.height, self.contentView.bounds.size.width, kScreenHeight * 13 / 69)];
        _showAnswerLabel.numberOfLines = 0;
        
    }
    return _showAnswerLabel;
}
-(void)bottomBtnClick{

    NSString *reward_id =  self.data[@"reward_id"];
    //本地取
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.decidesStr = [userDefaults dictionaryForKey:@"answer"];
    NSString *answer_change = self.decidesStr[@"reward_id"];
    
    NSLog(@"------------------->%@",answer_change);
        YBZTranslatorAnswerViewController *answerVC = [[YBZTranslatorAnswerViewController alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTextALabel:) name:@"answer" object:nil];
        answerVC.previewImg  = _photoImg;
        answerVC.reward_id = reward_id;
        answerVC.rewardID = [self.data objectForKey:@"reward_id"];
        [self.navigationController pushViewController:answerVC animated:nil];
 
}
//第三步：处理通知
-(void)setTextALabel:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.answer = [textDic objectForKey:@"answer"];
    _showAnswerLabel.text = self.answer;
}
//第四步：移除通知
-(void)dealloc{
    //    free((__bridge void *)(self.textALabel));
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"answer" object:nil];
}
@end
