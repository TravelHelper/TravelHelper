//
//  YBZSendRewardViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

//发送悬赏（用户）

#import "YBZSendRewardViewController.h"
#import "SelectPhoto.h"
#import "YBZMyRewardViewController.h"
#import "YBZRewardChooseLanguageViewController.h"
#import "YBZTagClassifyViewController.h"
#import "YBZRewardMoneyViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFSecurityPolicy.h"
#import "NSString+SZYKit.h"
#import "WebAgent.h"
#define kMaxTitleWordNumbers 15
#define kMaxContentWordNumbers 45
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kMargin        kScreenWidth*0.03
#define kL             kScreenWidth*0.06
#define positionImg    @"http://127.0.0.1/TravelHelper/upload.php"
@interface YBZSendRewardViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    CGFloat keyBoardEndY;
}
@property(nonatomic,strong)SelectPhoto *selectPhoto;
@property(nonatomic,strong)UIImageView *userIconImageV;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UITextView *titleTextView;
@property(nonatomic,strong)UILabel *fengeLabel;

@property(nonatomic,strong)UITextView *contentTextView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UILabel *titleCharacterNumberLabel;//UILabel统计可输入字符字数
@property(nonatomic,strong)UILabel *contentCharacterNumberLabel;//UILabel统计可输入字符字数
@property(nonatomic,strong)UIButton *picBtn;
@property(nonatomic,strong)UIButton *tagBtn;
@property(nonatomic,strong)UIButton *moneyBtn;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *seletLanguageBtn;
@property(nonatomic,strong)UIButton *seletTagBtn;
@property(nonatomic,strong)UILabel *tishiLabel;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)NSString *pictureUrl;
@property(nonatomic,strong)UILabel *returnLanguage;
@property(nonatomic,strong)UILabel *returnTagLabel;
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong) UILabel *alertLabel;
@property(nonnull,strong) NSString *imageName;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong)UILabel *returnMoneyLabel;

@end

@implementation YBZSendRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentTextView.hidden = NO;
    self.contentTextView.delegate = self;
    [self.titleTextView becomeFirstResponder];//弹出键盘
    //定制导航栏
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0f/255.0f green:221.0f/255.0f blue:1.0f/255.0f alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnIClick)];

    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_15,NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.title = @"发布悬赏";
    
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.bottomView];
    [self.mainScrollView addSubview:self.titleTextView];
    [self.mainScrollView addSubview:self.contentTextView];
    [self.mainScrollView addSubview:self.seletTagBtn];
    [self.mainScrollView addSubview:self.seletLanguageBtn];
    [self.contentTextView addSubview:self.tishiLabel];
    [self.titleTextView addSubview:self.titleLabel];
    [self.mainScrollView addSubview:self.fengeLabel];
    [self.mainScrollView addSubview:self.titleCharacterNumberLabel];
    [self.mainScrollView addSubview:self.contentCharacterNumberLabel];

    self.selectPhoto = [[SelectPhoto alloc]init];
    self.selectPhoto.selfController = self;
    self.selectPhoto.avatarImageView = self.userIconImageV;
    
    // 观察者方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendUrl:) name:@"sendUrl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhotoImage:) name:@"changePhotoImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLanguage:) name:@"sendLanguage"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMoney:) name:@"sendMoney"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTag:) name:@"sendTag"object:nil];

   
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - 键盘事件

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_titleTextView resignFirstResponder];
    [_contentTextView resignFirstResponder];
}

//end+hide
- (void) hideContentViewPoint:(NSNotification *)notification{ NSDictionary *userInfo = [notification userInfo];
    
    // 得到键盘隐藏后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{ [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         _bottomView.center = CGPointMake(_bottomView.center.x,kScreenHeight - self.bottomView.bounds.size.height+kScreenHeight*0.060);
                        }];
}
//begin+show
- (void) changeContentViewPoint:(NSNotification *)notification{ NSDictionary *userInfo = [notification userInfo];
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardEndY = value.CGRectValue.origin.y;
    // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    //添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{ [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         _bottomView.center = CGPointMake(_bottomView.center.x, keyBoardEndY - _bottomView.bounds.size.height/2.0);
                         _seletLanguageBtn.center = CGPointMake(_seletLanguageBtn.center.x, keyBoardEndY - _bottomView.bounds.size.height - kScreenWidth*0.24);
                         _seletTagBtn.center = CGPointMake(_seletLanguageBtn.center.x, _seletLanguageBtn.center.y-kScreenHeight*0.026-10);
                         _userIconImageV.center = CGPointMake(_userIconImageV.center.x, keyBoardEndY - _bottomView.bounds.size.height-kScreenHeight*0.2);
                     }];
}

#pragma mark - 协议方法：当textView的内容改变时调用

-(void)textViewDidChange:(UITextView *)textView{
    
    if (_contentTextView.text.length == 0) {
        self.tishiLabel.text = @"填写需要翻译的内容描述(35字以内)";
    }else{
        self.tishiLabel.text = @"";
    }
    
    if (_titleTextView.text.length == 0) {
        self.titleLabel.text = @"悬赏标题(15字以内)";
    }else{
        self.titleLabel.text = @"";
    }
    
    if(self.titleTextView.text.length>kMaxTitleWordNumbers){
        self.titleTextView.text = [self.titleTextView.text substringToIndex:kMaxTitleWordNumbers];
    }
    if(self.contentTextView.text.length>kMaxContentWordNumbers){
        self.contentTextView.text = [self.contentTextView.text substringToIndex:kMaxContentWordNumbers];
    }
    self.titleCharacterNumberLabel.text = [NSString stringWithFormat:@"%ld",kMaxTitleWordNumbers - self.titleTextView.text.length];
    self.contentCharacterNumberLabel.text = [NSString stringWithFormat:@"%ld",kMaxContentWordNumbers - self.contentTextView.text.length];
}
#pragma mark - getters

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*2);
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.indicatorStyle=UIScrollViewKeyboardDismissModeNone;
    }
    return _mainScrollView;
}

-(UILabel *)fengeLabel{
    if (!_fengeLabel) {
        _fengeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.025, CGRectGetMaxY(self.titleTextView.frame)+2, kScreenWidth*0.95, kScreenWidth*0.002)];
        _fengeLabel.backgroundColor = [UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1];
    }
    return _fengeLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kScreenWidth*0.03, self.view.bounds.size.width*0.8, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"悬赏标题(15字以内)";
        _titleLabel.font = FONT_15;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.enabled = NO;
        
    }
    return _titleLabel;
}
-(UILabel *)tishiLabel{
    
    if(!_tishiLabel){
        
        _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,0, self.view.bounds.size.width, 40)];
        _tishiLabel.backgroundColor = [UIColor clearColor];
        _tishiLabel.text = @"填写需要翻译的内容描述（45字以内）";
        _tishiLabel.font = FONT_14;
        _tishiLabel.textColor = [UIColor grayColor];
        _tishiLabel.enabled = NO;
    }
    return _tishiLabel;
}

-(UITextView *)titleTextView{
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(kMargin, kScreenWidth*0.02,  kScreenWidth-kMargin*2, kScreenHeight*0.065)];
        _titleTextView.delegate = self;
        _titleTextView.font = FONT_20;
        _titleTextView.keyboardType = UIKeyboardTypeDefault;
        _titleTextView.returnKeyType = UIReturnKeySend;
    }
    return _titleTextView;
}

-(UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.titleTextView.frame)+kScreenHeight*0.01, kScreenWidth-kMargin*2, kScreenHeight*0.13)];
        _contentTextView.delegate = self;
        _contentTextView.font = FONT_14;
        _contentTextView.keyboardType = UIKeyboardTypeDefault;
        _contentTextView.returnKeyType = UIReturnKeySend;
    }
    return _contentTextView;
}
// UILabel统计可输入字符字数get方法
-(UILabel *)titleCharacterNumberLabel{
    
    if(!_titleCharacterNumberLabel){
        
        _titleCharacterNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleTextView.frame)-kMargin,CGRectGetMaxY(self.titleTextView.frame)-kL-kMargin,kL,kL)];
        _titleCharacterNumberLabel.font = FONT_12;
        _titleCharacterNumberLabel.backgroundColor = [UIColor clearColor];
        _titleCharacterNumberLabel.text = [NSString stringWithFormat:@"%i",kMaxTitleWordNumbers];
        _titleCharacterNumberLabel.textColor = [UIColor lightGrayColor];
    }
    return  _titleCharacterNumberLabel;
}
// UILabel统计可输入字符字数get方法
-(UILabel *)contentCharacterNumberLabel{
    
    if(!_contentCharacterNumberLabel){
        
        _contentCharacterNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.contentTextView.frame)-kMargin,CGRectGetMaxY(self.contentTextView.frame)-kL-kMargin,kL,kL)];
        _contentCharacterNumberLabel.backgroundColor = [UIColor clearColor];
        _contentCharacterNumberLabel.font = FONT_12;
        _contentCharacterNumberLabel.text = [NSString stringWithFormat:@"%i",kMaxContentWordNumbers];
        _contentCharacterNumberLabel.textColor = [UIColor lightGrayColor];
    }
    return  _contentCharacterNumberLabel;
}

-(UIButton *)picBtn{
    if (!_picBtn) {
        UIImage *img = [UIImage imageNamed:@"reward_pic"];
        _picBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.167, kScreenHeight*0.017, kScreenWidth*0.073, kScreenWidth*0.073)];
        [_picBtn setImage:img forState:UIControlStateNormal];
        [_picBtn addTarget:self action:@selector(picBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _picBtn;
}
-(UIButton *)tagBtn{
    if (!_tagBtn) {
        UIImage *img = [UIImage imageNamed:@"reward_tag"];
        _tagBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.468, kScreenHeight*0.017, kScreenWidth*0.073, kScreenWidth*0.073)];
        [_tagBtn setImage:img forState:UIControlStateNormal];
        [_tagBtn addTarget:self action:@selector(tagBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagBtn;
}
-(UIButton *)moneyBtn{
    if (!_moneyBtn) {
        UIImage *img = [UIImage imageNamed:@"reward_money"];
        _moneyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.769, kScreenHeight*0.017, kScreenWidth*0.073, kScreenWidth*0.073)];
        [_moneyBtn setImage:img forState:UIControlStateNormal];
        [_moneyBtn addTarget:self action:@selector(moneyBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moneyBtn;
}
-(UILabel *)returnMoneyLabel{
    if (!_returnMoneyLabel) {
        _returnMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.moneyBtn.frame), CGRectGetMinY(self.moneyBtn.frame), kScreenWidth*0.07, kScreenWidth*0.07)];
        _returnMoneyLabel.textColor = [UIColor redColor];
        _returnMoneyLabel.font = FONT_13;
    }
    return _returnMoneyLabel;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.915, kScreenWidth, kScreenHeight*0.085)];
        _bottomView.backgroundColor  = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f  blue:249.0f/255.0f  alpha:1];
        [_bottomView addSubview:self.picBtn];
        [_bottomView addSubview:self.tagBtn];
        [_bottomView addSubview:self.moneyBtn];
        [_bottomView addSubview:self.returnMoneyLabel];
    }
    
    return _bottomView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        UIImage *img = [UIImage imageNamed:@"back"];
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.1, kScreenWidth*0.1)];
        [_backBtn setImage:img forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnIClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

-(UIButton *)seletTagBtn{
    if (!_seletTagBtn) {
        UIImage *img = [UIImage imageNamed:@"tag"];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0234*kScreenWidth, 0, kScreenWidth*0.04, kScreenHeight*0.026)];
        [imgV setImage:img];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.07, 0, kScreenWidth*0.166, kScreenHeight*0.026)];
        label.text = @"标签内容";
        label.font = FONT_12;
        label.textColor = [UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1];
        _returnTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+2, 0,0.1*kScreenWidth, kScreenHeight*0.026)];
        _seletTagBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.seletLanguageBtn.frame), CGRectGetMinY(self.seletLanguageBtn.frame)-kScreenHeight*0.026-10, kScreenWidth*0.4+5, kScreenHeight*0.026)];
        _returnTagLabel.font = FONT_12;
        _returnTagLabel.textColor = [UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1];
        [_seletTagBtn addSubview:imgV];
        [_seletTagBtn addSubview:label];
        [_seletTagBtn addSubview:_returnTagLabel];
        _seletTagBtn.backgroundColor = [UIColor clearColor];
    }
    return _seletTagBtn;
}
-(UIButton *)seletLanguageBtn{
    if (!_seletLanguageBtn) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0234*kScreenWidth, 0, kScreenWidth*0.04, kScreenHeight*0.026)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.07, 0, kScreenWidth*0.166, kScreenHeight*0.026)];
        NSString *a = @"意大利语huuhu";
        CGSize size = [a sizeWithAttributes:@{NSFontAttributeName:FONT_12}];
        _returnLanguage = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 0,size.width, kScreenHeight*0.026)];
        _returnLanguage.textColor = [UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1];
        label.text = @"语种选择:";
        label.font = FONT_12;
        label.textColor = [UIColor colorWithRed:132.0/255.0f green:132.0/255.0f blue:132.0/255.0f alpha:1];
        _seletLanguageBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.043, kScreenHeight*0.5, kScreenWidth*0.4+5, kScreenHeight*0.026)];
                [_seletLanguageBtn addTarget:self action:@selector(seletLanguageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _returnLanguage.font = FONT_12;

        [_seletLanguageBtn addSubview:imgV];
        [_seletLanguageBtn addSubview:label];
        [_seletLanguageBtn addSubview:_returnLanguage];
        [_seletLanguageBtn setImage:[UIImage imageNamed:@"languagebtn"] forState:UIControlStateNormal];
        
    }
    return _seletLanguageBtn;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(cancelPic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(UIImageView *)userIconImageV
{
    if (!_userIconImageV) {
        _userIconImageV = [[UIImageView alloc]init];
        _userIconImageV.userInteractionEnabled = YES;
        _userIconImageV.backgroundColor = [UIColor whiteColor];
    }
    return _userIconImageV;
}
#pragma mark - 发送upload

-(void)sendBtnIClick{
    if (self.userIconImageV.image) {
        
        UIImage *image=self.userIconImageV.image;
        NSString *urlc = [NSString stringWithFormat:@"%@",positionImg];
        NSURL *URL = [NSURL URLWithString:urlc];
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc]init];
        [securityPolicy setAllowInvalidCertificates:YES];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager setSecurityPolicy:securityPolicy];
        [manager POST:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            self.imageName = [NSString stringOfUUID];
            [formData appendPartWithFileData:data name:@"file" fileName:self.imageName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"--------------->%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------->%@",error);
        }];
        
    }
    //网络接口
    // 测试数据
    self.returnMoneyLabel.text = @"20";
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];

    if (!self.titleTextView.text || !self.contentTextView.text || !self.returnMoneyLabel.text || !self.returnLanguage.text || !self.imageName)
    {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请补全内容" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
       
    }
    else{
        if (!self.returnTagLabel.text) {
            self.returnTagLabel.text = @"无";
        }
        NSLog(@"--------------->%@",self.titleTextView.text);
        NSLog(@"--------------->%@",self.contentTextView.text);
        NSLog(@"--------------->%@",self.returnLanguage.text);
        NSLog(@"------------->%@",self.returnTagLabel.text);
        [WebAgent sendRewardRewardID:user_id[@"user_id"]
                         rewardTitle:self.titleTextView.text
                          rewardText:self.contentTextView.text
                           rewardUrl:self.imageName
                         rewardMoney:self.returnMoneyLabel.text
                      rewardLanguage:self.returnLanguage.text
                           rewardtag:self.returnTagLabel.text
                             success:^(id responseObject) {
                            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
             NSLog(@"－－－－－－－success");
                                 
        } failure:^(NSError *error) {
            
            NSLog(@"----------->%@",error);
            CGSize size = [@"网络错误" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
            self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width) / 2, 500, size.width + 10, size.height + 6)];
            self.alertLabel.backgroundColor = [UIColor blackColor];
            self.alertLabel.layer.cornerRadius = 5;
            self.alertLabel.layer.masksToBounds = YES;
            self.alertLabel.alpha = 0.8;
            self.alertLabel.text = @"网络错误";
            self.alertLabel.font = [UIFont systemFontOfSize:14];
            [self.alertLabel setTextAlignment:NSTextAlignmentCenter];
            self.alertLabel.textColor = [UIColor whiteColor];
            [self.view addSubview:self.alertLabel];
            [UIView animateWithDuration:2 animations:^{
                self.alertLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [self.alertLabel removeFromSuperview];
            }];
        }];
    }
}
#pragma mark - 响应事件
//picture
-(void)changePhotoImage:(NSNotification *)noti{
    UIImage *image = noti.userInfo[@"image"];
    self.userIconImageV.image = image;
    self.userIconImageV.frame = CGRectMake(kScreenWidth-(image.size.width/image.size.height*kScreenHeight*0.15)-kScreenWidth*0.04,kScreenHeight*0.3,image.size.width/image.size.height*kScreenHeight*0.15,kScreenHeight*0.15);
    self.cancelBtn.frame = CGRectMake(image.size.width/image.size.height*kScreenHeight*0.15-kScreenWidth*0.05, 0, kScreenWidth*0.05, kScreenWidth*0.05);
    [self.userIconImageV addSubview:self.cancelBtn];
}

-(void)cancelPic{
    self.userIconImageV.image = nil;
    [self.cancelBtn removeFromSuperview];
}
//返回
-(void)backBtnIClick{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

//选图片
-(void)picBtnClickEvent{
    [self.selectPhoto createActionSheetWithView];
    [self.mainScrollView addSubview:self.userIconImageV];
}

//标签
-(void)tagBtnClickEvent{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returntag:) name:@"returntag" object:nil];
    YBZTagClassifyViewController *tagClassifyVC = [[YBZTagClassifyViewController alloc]init];
    [self.navigationController pushViewController:tagClassifyVC animated:YES];
}
//观察者
//第三步：处理通知
-(void)returntag:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.tag = [textDic objectForKey:@"tag"];
    NSLog(@"------------>%@",self.tag);
}

//悬赏
-(void)moneyBtnClickEvent{
    YBZRewardMoneyViewController *rewardMoneyVC = [[YBZRewardMoneyViewController alloc]init];
    [self.navigationController pushViewController:rewardMoneyVC animated:YES];
}

//语言
-(void)seletLanguageBtnClick{
    YBZRewardChooseLanguageViewController *languageVC = [[YBZRewardChooseLanguageViewController alloc]init];
    [self.navigationController pushViewController:languageVC animated:YES];
}

#pragma mark -观察者－发送通知

-(void)sendUrl:(NSNotification *)noti{
    NSDictionary *textDic = [noti userInfo];
    self.pictureUrl = [textDic objectForKey:@"url"];
}

-(void)sendLanguage:(NSNotification *)noti{
    NSDictionary *texDic = [noti userInfo];
    self.returnLanguage.text = [texDic objectForKey:@"language"];
}

-(void)sendMoney:(NSNotification *)noti{
    NSDictionary *texDic = [noti userInfo];
    self.returnMoneyLabel.text = [texDic objectForKey:@"money"];
}
-(void)sendTag:(NSNotification *)noti{
    NSDictionary *texDic = [noti userInfo];
    self.returnTagLabel.text = [texDic objectForKey:@"tag"];
//    CGSize labelSize=[self.returnTagLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*0.3, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.returnTagLabel.font} context:nil].size;
    [self.returnTagLabel sizeToFit];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendUrl" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendLanguage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendMoney" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendTag" object:nil];


}




@end
