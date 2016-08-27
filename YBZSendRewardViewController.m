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

#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kMargin        kScreenWidth*0.03
#define positionImg    @"http://127.0.0.1/TravelHelper/upload.php"
@interface YBZSendRewardViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)SelectPhoto *selectPhoto;
@property(nonatomic,strong)UIImageView *userIconImageV;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UITextView *titleTextView;

@property(nonatomic,strong)UITextView *contentTextView;

@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIButton *picBtn;
@property(nonatomic,strong)UIButton *tagBtn;
@property(nonatomic,strong)UIButton *moneyBtn;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *seletLanguageBtn;
@property(nonatomic,strong)UIButton *seletMoneyBtn;
@property(nonatomic,strong)UILabel *tishiLabel;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)NSString *pictureUrl;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *returnLanguage;
@property(nonatomic,strong)UILabel *returnMoney;
@property(nonatomic,strong)NSString *tag;
@property (nonatomic ,strong) UILabel *alertLabel;
@property (nonnull,strong) NSString *imageName;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation YBZSendRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.contentTextView.hidden = NO;
    self.contentTextView.delegate = self;
    
    //定制导航栏
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0f/255.0f green:221.0f/255.0f blue:1.0f/255.0f alpha:1];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnIClick)];

    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.title = @"发布悬赏";
    
    
    
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.bottomView];
    [self.mainScrollView addSubview:self.titleTextView];
    [self.mainScrollView addSubview:self.contentTextView];
    [self.mainScrollView addSubview:self.seletMoneyBtn];
    [self.mainScrollView addSubview:self.seletLanguageBtn];
    [self.contentTextView addSubview:self.tishiLabel];
    [self.titleTextView addSubview:self.titleLabel];
    

    self.selectPhoto = [[SelectPhoto alloc]init];
    self.selectPhoto.selfController = self;
    self.selectPhoto.avatarImageView = self.userIconImageV;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhotoImage:) name:@"changePhotoImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideContentViewPoint:) name:UIKeyboardWillHideNotification object:nil];
    
    // 观察者方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLanguage:) name:@"sendLanguage"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMoney:) name:@"sendMoney"object:nil];

    //自定义返回键
//     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_titleTextView resignFirstResponder];
    [_contentTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegete
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_titleTextView resignFirstResponder];
    [_contentTextView resignFirstResponder];
    

}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.21, 0, kScreenWidth*0.05, kScreenWidth*0.05)];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(cancelPic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
//picture
-(void)changePhotoImage:(NSNotification *)noti{
    UIImage *image = noti.userInfo[@"image"];
    self.userIconImageV.image = image;
    
    
    
    [self.userIconImageV addSubview:self.cancelBtn];
}

-(void)cancelPic{
    self.userIconImageV.image = nil;
    [self.cancelBtn removeFromSuperview];
}

-(UIImageView *)userIconImageV
{
    if (!_userIconImageV) {
        _userIconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*0.7,CGRectGetMaxY(self.contentTextView.frame)+10,kScreenWidth*0.26,kScreenWidth*0.27)];
        _userIconImageV.userInteractionEnabled = YES;
        _userIconImageV.backgroundColor = [UIColor whiteColor];
    }
    return _userIconImageV;
}

//end+hide
- (void) hideContentViewPoint:(NSNotification *)notification{ NSDictionary *userInfo = [notification userInfo];
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    // 得到键盘隐藏后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{ [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                        // _bottomView.center = CGPointMake(_bottomView.center.x, keyBoardEndY + _bottomView.bounds.size.height/2.0);
                         _bottomView.center = CGPointMake(_bottomView.center.x,kScreenHeight - self.bottomView.bounds.size.height+kScreenHeight*0.060);
                         _seletMoneyBtn.center = CGPointMake(_seletMoneyBtn.center.x,[UIScreen mainScreen].bounds.size.height * 0.485-64);
                         _seletLanguageBtn.center = CGPointMake(_seletLanguageBtn.center.x, CGRectGetMaxY(self.seletMoneyBtn.frame)+10);
                         
                         // keyBoardEndY的坐标包括了状态栏的高度，要减去
                     }];
}
//begin+show
- (void) changeContentViewPoint:(NSNotification *)notification{ NSDictionary *userInfo = [notification userInfo];
    
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    //添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{ [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         _bottomView.center = CGPointMake(_bottomView.center.x, keyBoardEndY - _bottomView.bounds.size.height/2.0);
                //_bottomView.center = CGPointMake(_bottomView.center.x,kScreenHeight - self.bottomView.bounds.size.height);
                         _seletMoneyBtn.center = CGPointMake(_seletMoneyBtn.center.x,CGRectGetMaxY(self.contentTextView.frame)+20);
                         // keyBoardEndY的坐标包括了状态栏的高度，要减去
                         _seletLanguageBtn.center = CGPointMake(_seletMoneyBtn.center.x, CGRectGetMaxY(self.seletMoneyBtn.frame)+10);
                     }];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, self.view.bounds.size.width*0.8, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"您的问题";
        _titleLabel.font = FONT_15;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.enabled = NO;
        
    }
    return _titleLabel;
}
-(UILabel *)tishiLabel{
    
    if(!_tishiLabel){
        
        _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,8, self.view.bounds.size.width, 20)];
        _tishiLabel.backgroundColor = [UIColor clearColor];
        _tishiLabel.text = @"请输入内容";
        _tishiLabel.font = FONT_14;
        _tishiLabel.textColor = [UIColor grayColor];
        _tishiLabel.enabled = NO;
    }
    return _tishiLabel;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (_contentTextView.text.length == 0) {
        self.tishiLabel.text = @"请输入内容";
    }else{
        self.tishiLabel.text = @"";
    }
    if (_titleTextView.text.length == 0) {
        self.titleLabel.text = @"您的问题";
    }else{
        self.titleLabel.text = @"";
    }
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
//TextField
-(UITextView *)titleTextView{
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(kMargin, kScreenWidth*0.02,  kScreenWidth*0.6, kScreenHeight*0.10)];
        _titleTextView.delegate = self;
        _titleTextView.font = FONT_14;
        _titleTextView.layer.borderColor = UIColor.grayColor.CGColor;
        _titleTextView.layer.borderWidth = 1;
        _titleTextView.layer.cornerRadius = 6;
        _titleTextView.layer.masksToBounds = YES;
        _titleTextView.keyboardType = UIKeyboardTypeDefault;
        _titleTextView.returnKeyType = UIReturnKeySend;
    }
    return _titleTextView;
}
//TextView
-(UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.titleTextView.frame)+kScreenHeight*0.034, kScreenWidth*0.6, kScreenHeight*0.13)];
        _contentTextView.delegate = self;
        _contentTextView.font = FONT_14;
        _contentTextView.layer.borderColor = UIColor.grayColor.CGColor;
        _contentTextView.layer.borderWidth = 1;
        _contentTextView.layer.cornerRadius = 6;
        _contentTextView.layer.masksToBounds = YES;

        _contentTextView.keyboardType = UIKeyboardTypeDefault;
    }
    return _contentTextView;
}
-(UIButton *)picBtn{
    if (!_picBtn) {
        UIImage *img = [UIImage imageNamed:@"pic"];
        _picBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.167, kScreenHeight*0.017, kScreenWidth*0.073, kScreenWidth*0.073)];
        [_picBtn setImage:img forState:UIControlStateNormal];
        [_picBtn addTarget:self action:@selector(picBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _picBtn;
}
-(UIButton *)tagBtn{
    if (!_tagBtn) {
        UIImage *img = [UIImage imageNamed:@"tag"];
        _tagBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.468, kScreenHeight*0.017, kScreenWidth*0.073, kScreenWidth*0.073)];
        [_tagBtn setImage:img forState:UIControlStateNormal];
        [_tagBtn addTarget:self action:@selector(tagBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagBtn;
}
-(UIButton *)moneyBtn{
    if (!_moneyBtn) {
        UIImage *img = [UIImage imageNamed:@"money1"];
        _moneyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.769, kScreenHeight*0.017, kScreenWidth*0.073, kScreenWidth*0.073)];
        [_moneyBtn setImage:img forState:UIControlStateNormal];
        [_moneyBtn addTarget:self action:@selector(moneyBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moneyBtn;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.915, kScreenWidth, kScreenHeight*0.085)];
        _bottomView.backgroundColor  = [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f  blue:249.0f/255.0f  alpha:1];
        [_bottomView addSubview:self.picBtn];
        [_bottomView addSubview:self.tagBtn];
        [_bottomView addSubview:self.moneyBtn];
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

-(UIButton *)seletMoneyBtn{
    if (!_seletMoneyBtn) {
        UIImage *img = [UIImage imageNamed:@"gezhi"];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0234*kScreenWidth, 0, kScreenWidth*0.04, kScreenHeight*0.026)];
        [imgV setImage:img];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.07, 0, kScreenWidth*0.166, kScreenHeight*0.026)];
        label.text = @"悬赏金额:";
        label.font = FONT_12;
        _returnMoney = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 0,0.1*kScreenWidth, kScreenHeight*0.026)];
        _seletMoneyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.043, kScreenHeight*0.38, kScreenWidth*0.4+5, kScreenHeight*0.026)];
        _returnMoney.font = [UIFont systemFontOfSize:15];
        [_seletMoneyBtn addSubview:imgV];
        [_seletMoneyBtn addSubview:label];
        [_seletMoneyBtn addSubview:_returnMoney];
        _seletMoneyBtn.backgroundColor = [UIColor whiteColor];
        [_seletMoneyBtn.layer setMasksToBounds:YES];
        [_seletMoneyBtn.layer setCornerRadius:8.0];
        [_seletMoneyBtn.layer setBorderWidth:1.0];
        [_seletMoneyBtn addTarget:self action:@selector(seletMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seletMoneyBtn;
}
-(UIButton *)seletLanguageBtn{
    if (!_seletLanguageBtn) {
        UIImage *img = [UIImage imageNamed:@"gezhi"];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0234*kScreenWidth, 0, kScreenWidth*0.04, kScreenHeight*0.026)];
        [imgV setImage:img];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.07, 0, kScreenWidth*0.166, kScreenHeight*0.026)];
        NSString *a = @"意大利语huuhu";
        CGSize size = [a sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _returnLanguage = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 0,size.width, kScreenHeight*0.026)];
        label.text = @"语种选择:";
        label.font = FONT_12;
        _seletLanguageBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*0.043, kScreenHeight*0.415, kScreenWidth*0.4+5, kScreenHeight*0.026)];
        [_seletLanguageBtn addTarget:self action:@selector(seletLanguageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _returnLanguage.font = [UIFont systemFontOfSize:15];

        [_seletLanguageBtn addSubview:imgV];
        [_seletLanguageBtn addSubview:label];
        [_seletLanguageBtn addSubview:_returnLanguage];
        _seletLanguageBtn.backgroundColor = [UIColor whiteColor];
        [_seletLanguageBtn.layer setMasksToBounds:YES];
        [_seletLanguageBtn.layer setCornerRadius:8.0];
        [_seletLanguageBtn.layer setBorderWidth:1.0];
    }
    return _seletLanguageBtn;
}
#pragma mark - 响应事件
//发送
-(void)sendBtnIClick{
    
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
    
    
//    self.userIconImageV.image = image;
//    if(image)
    
    
    //网络接口
    //观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendUrl:) name:@"sendUrl" object:nil];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *myDictionary = [userinfo dictionaryForKey:@"user_id"];

    
    NSLog(@"--------------->%@",self.titleTextView.text);
    if ([myDictionary[@"user_id"] isEqualToString:@""]&[self.titleTextView.text isEqualToString:@""]&[self.contentTextView.text isEqualToString:@""]&[self.pictureUrl isEqualToString:@""]&[self.returnMoney.text isEqualToString:@""]&[self.returnLanguage.text isEqualToString:@""])
    
    
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"------------>未登录");
        }];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
     
        //myDictionary[@"user_id"]
    }else{
        NSLog(@"------------->%@,%@,%@",self.returnMoney.text,self.returnLanguage.text,self.tag);
        [WebAgent sendRewardRewardID:@"111" rewardTitle:self.titleTextView.text rewardText:self.contentTextView.text rewardUrl:self.imageName rewardMoney:self.returnMoney.text rewardLanguage:self.returnLanguage.text rewardtag:self.tag success:^(id responseObject) {
            
            NSLog(@"发送成功");
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            NSLog(@"----------->%@",error);
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
            
            
            [self.view addSubview:self.alertLabel];
            
            
            
            
            
            //设置动画
            
            
            [UIView animateWithDuration:2 animations:^{
                
                
                self.alertLabel.alpha = 0;
                
                
            } completion:^(BOOL finished) {
                
                
                //将警告Label透明后 在进行删除
                
                
                [self.alertLabel removeFromSuperview];
                
                
            }];

        }];

    }
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
-(void)seletMoneyBtnClick{
    YBZRewardMoneyViewController *rewardMoneyVC = [[YBZRewardMoneyViewController alloc]init];
    [self.navigationController pushViewController:rewardMoneyVC animated:YES];

}
//语言
-(void)seletLanguageBtnClick{
    YBZRewardChooseLanguageViewController *languageVC = [[YBZRewardChooseLanguageViewController alloc]init];
    [self.navigationController pushViewController:languageVC animated:YES];
}
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
    self.returnMoney.text = [texDic objectForKey:@"money"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendUrl" object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendLanguage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"returntag" object:nil];


}




@end
