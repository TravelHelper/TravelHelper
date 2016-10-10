//
//  YBZRegisterViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZRegisterViewController.h"
#import "UITextField+Validator.h"
#import "AFViewShaker.h"
#import "UIBarButtonItem+YBZBarButtonItem.h"
#import "AFNetworking.h"
#import "WebAgent.h"
#import "NSString+SZYKit.h"
#import "YBZChooseTranslatorViewController.h"
#import "JPUSHService.h"
#import "MBProgressHUD+XMG.h"
#import <SMS_SDK/SMSSDK.h>

#import "ZLCWebView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//注册页111
@interface YBZRegisterViewController ()<UITextFieldDelegate,ZLCWebViewDelegate>
@property(nonatomic,strong) NSTimer         *timer;
@property(nonatomic,strong) UIImageView     *phoneImageView;
@property(nonatomic,strong)UIImageView      *pswImageView;
@property(nonatomic,strong)UIImageView      *confirmPswImageView;
@property(nonatomic,strong) UITextField     *enderCodeTextField;   //输入验证码
@property(nonatomic,strong) UIButton        *getCodeBtn;   //获取验证码
@property(nonatomic,strong) UIImageView     *otherImageView;
@property(nonatomic,strong) UIButton        *putCodeBtn;
@property(nonatomic,strong) UITextField     *phoneTextField;
@property(nonatomic,strong) UIImageView     *userImageView;
@property(nonatomic,strong) UITextField     *userTextField;
@property(nonatomic,strong) UITextField     *pswTextField;
@property(nonatomic,strong) UITextField     *confirmPswTextField;
@property(nonatomic,strong) UIButton        *finishRegBtn;
@property(nonatomic,strong) UIImageView     *getCodeImageView;
@property(nonatomic,strong) AFViewShaker    *userShaker;
@property(nonatomic,strong) AFViewShaker    *pswShaker;

@property (nonatomic, strong) ZLCWebView *needWeb;
@property (nonatomic, strong) UIView *loadWebView;
@property (nonatomic, strong) UILabel *userProtocol;
@property (nonatomic, strong) UIView   *hubView;

@end
@implementation YBZRegisterViewController{

    int mark;
    int countDown;
//    MBProgressHUD *HUD;
}

static NSString * userStr;

- (void)viewDidLoad {
     [super viewDidLoad];
     [self.view addSubview:self.userTextField];
     [self.view addSubview:self.pswTextField];
     [self.view addSubview:self.confirmPswTextField];
     [self.view addSubview:self.phoneImageView];
     [self.view addSubview:self.pswImageView];
     [self.view addSubview:self.confirmPswImageView];
     [self.view addSubview:self.finishRegBtn];
     [self.view addSubview:self.enderCodeTextField];
     [self.view addSubview:self.otherImageView];
     [self.view addSubview:self.phoneTextField];
     [self.view addSubview:self.getCodeImageView];
     [self.view addSubview:self.getCodeBtn];
     [self.view addSubview:self.userProtocol];
     //   [self.view addSubview:self.putCodeBtn];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturn) name:@"needTopop" object:nil];
     self.userShaker = [[AFViewShaker alloc]initWithView:self.phoneTextField];
     self.pswShaker = [[AFViewShaker alloc]initWithView:self.pswTextField];
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"return" target:self action:@selector(leftMenuClick) width:ScreenWidth*0.043 height:ScreenHeight*0.024];
     }
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        [self.phoneTextField resignFirstResponder];
    }
    if (textField == self.pswTextField) {
        [self.pswTextField resignFirstResponder];
    }
    if (textField == self.confirmPswTextField) {
        [self.confirmPswTextField resignFirstResponder];
    }
    if (textField == self.userTextField){
        [self.userTextField resignFirstResponder];
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    mark=1;
    countDown = 59;

}

#pragma mark - 响应事件
//-(void)putCodeBtnClick{
//    //提交验证码
//}
-(void)leftMenuClick{
    //[self  dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getCodeBtnClick{
    if ([self.phoneTextField isNotEmpty]) {
        if ([self.phoneTextField validatePhoneNumber]) {
            [self.getCodeBtn setEnabled:NO];
            //获取验证码
            [WebAgent userPhone:self.phoneTextField.text success:^(id responseObject) {
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *str2 = dic[@"user_info"][@"user_phone"];
                NSString *str1 = self.phoneTextField.text;
                
                if ([str1 isEqualToString:str2]) {
                    [self showMssage:@"您已经注册" becomeFirstResponder:nil];
                    [self.getCodeBtn setEnabled:YES];
                }else{
                    //获取验证码
                    
                    
                    
                    
                    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                        if (!error) {
                            NSLog(@"获取验证码成功");
                            
                            [MBProgressHUD showSuccess:@"获取成功"];
                        }else{
                            NSLog(@"获取验证码失败");
                            //手机震动
//                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                            [MBProgressHUD showError:@"请确认您输入的手机号"];
                        }
                        
                    }];
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
//                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//                    NSDictionary *paramDict = @{@"code":self.enderCodeTextField.text,
//                                                @"user_phone":self.phoneTextField.text};
                    
//                    [manager POST:[NSString stringWithFormat:@"%@User/getValidateAndFamilyPhoneInfo",API_HOST]  parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
//                        //do nothing
//                    }
//                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                              
//                              NSData *data = [[NSData alloc]initWithData:responseObject];
//                              NSDictionary *str= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                              userStr = str[@"code"];
//                              NSString *phoneStr = str[@"user_phone"];
//                              phoneStr = self.phoneTextField.text;
//                              NSLog(@"%@",str);
//                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                              NSLog(@"error----->%@",error);
//                          }];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
                }
            } failure:^(NSError *error) {
                //数据库回调失败
            }];
            // self.getCodeBtn.userInteractionEnabled = YES;
        }else{
            [self showMssage:@"请输入11位有效手机号" becomeFirstResponder:_phoneTextField];
        }
    }else{
        [self.userShaker shake];
    }
    
}
-(void)onTimer{
    if (countDown > 0) {
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds后获取",countDown] forState:UIControlStateDisabled];
        countDown--;
    }
    if (countDown == 0 ) {
        countDown = 59;
        [_timer invalidate];
        _timer = nil;
        [self.getCodeBtn setTitle:@"60s后获取" forState:UIControlStateDisabled];
        [self.getCodeBtn setTitle:@"可以发送" forState:UIControlStateNormal];
        [self.getCodeBtn setEnabled:YES];
        [self.getCodeBtn setBackgroundColor:[UIColor clearColor]];
    }
}
//-(void)toReturn{
//
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//    
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.pswTextField resignFirstResponder];
    [self.confirmPswTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    [self.enderCodeTextField resignFirstResponder];
}
-(void)finishRegBtnClick{
    
    if(mark==1){
    
    if ([self.phoneTextField isNotEmpty]) {
        if ([self.pswTextField isNotEmpty]) {
            if ([self.phoneTextField validatePhoneNumber]) {
                if ([self.pswTextField validatePassWord]) {
                    
                    if ([_pswTextField.text isEqualToString: _confirmPswTextField.text]) {
                        NSString *str1 = self.enderCodeTextField.text;
                        
                        
                        
                        
                        
                        
                        [SMSSDK commitVerificationCode:str1 phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
                            if (!error) {
                                
                                [MBProgressHUD showSuccess:@"验证成功"];
                                
                                NSString *user_id = [NSString stringOfUUID];
                                NSString * strid = [user_id stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                                
                                [MBProgressHUD showSuccess:@"正在为您注册中 请等待"];
                                
                                [WebAgent userPhone:self.phoneTextField.text userPsw:self.pswTextField.text userName:self.userTextField.text userID:strid  success:^(id responseObject) {
                                    //成功
                                    mark=0;
                                    NSDictionary *useridDic = @{@"user_id":strid};
                                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                    [userDefaults setObject:useridDic forKey:@"user_id"];
                                    
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"setTextALabel" object:nil];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:nil];
                                    
                                    
                                    
                                    
                                    [WebAgent updateUserLoginState:strid success:^(id responseObject) {
                                        NSData *data = [[NSData alloc]initWithData:responseObject];
                                        NSDictionary *str= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                        
                                        NSString *isLogin = str[@"state"];
                                        NSLog(@"%@",isLogin);
                                        
                                        
                                        [JPUSHService setTags:nil alias:strid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
                                         {
                                             
                                             NSLog(@"isrescode----%d, itags------%@,ialias--------%@",iResCode,iTags,iAlias);
                                         }];
                                        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                                        NSDictionary *dict = @{@"user_loginState":@"1"};
                                        [userinfo setObject:dict forKey:@"user_loginState"];
                                        
                                        
                                        
                                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                            //                                [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                            //                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLogin" object:nil];
                                            [MBProgressHUD showSuccess:@"正在努力为您跳转界面中"];
                                            
                                            
                                            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLogin" object:nil];
                                            }];
                                            
                                            
                                            
                                        }];
                                        [alertVC addAction:okAction];
                                        [self presentViewController:alertVC animated:YES completion:nil];
                                    }
                                                           failure:^(NSError *error) {
                                                               NSLog(@"原本222222222的错误%@",error);
                                                           }];
                                    
                                    
                                    
                                    
                                    
                                
                                } failure:^(NSError *error) {
                                    //失败
                                    [MBProgressHUD showError:@"注册失败，请检查网络"];
                                }];
                                

                                    
                                
                                
                            }else{
                                NSLog(@"验证失败:%@",error);
                                //手机震动
//                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                [MBProgressHUD showError:@"请检查验证码是否正确"];
                            }
                        }];

                        
                        
                        
                                    
                        
                        
                        
//                        if ([str1 isEqualToString:userStr]) {
//                            //                            //注册
//
//                            
//                            
//                            
//                                                  }else{
//
//                            [self showMssage:@"验证码错误" becomeFirstResponder:nil];
//                        }
                        
                    }else{
                        [self showMssage:@"密码和确认密码不一致" becomeFirstResponder:nil];
                    }
                    
                }else{
                    [self showMssage:@"请输入有效密码" becomeFirstResponder:_pswTextField];
                }
            }else{
                [self showMssage:@"请输入11位有效手机号" becomeFirstResponder:_phoneTextField];
            }
        }else{
            [self.pswShaker shake];
        }
    }else{
        [self.userShaker shake];
        
    }
    }
    
}
-(void)showMssage:(NSString *)msg becomeFirstResponder:(UITextField *)textField{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (textField) {
            [textField becomeFirstResponder];
        }
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - getters

-(UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.backgroundColor = UIColorFromRGB(0xffffff);
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
        _phoneTextField.frame = CGRectMake(0,ScreenHeight*0.118,ScreenWidth * 0.6, ScreenHeight*0.066);
        _phoneTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth*0.156,ScreenHeight*0.066)];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
        imgUser.frame = CGRectMake(ScreenWidth*0.050, ScreenHeight*0.019, ScreenWidth*0.046, ScreenHeight*0.026);
        [_phoneTextField.leftView addSubview:imgUser];
    }
    return _phoneTextField;
}
-(UIImageView *)otherImageView{
    if (!_otherImageView) {
        _otherImageView = [[UIImageView alloc]init];
        _otherImageView.frame = CGRectMake(ScreenWidth*0.7,ScreenHeight*0.118,ScreenWidth*0.3, ScreenHeight*0.066);
//        _otherImageView.backgroundColor = [UIColor blueColor];
//        [_otherImageView addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherImageView;
}
-(UIImageView *)getCodeImageView{
    if (!_getCodeImageView) {
        _getCodeImageView = [[UIImageView alloc]init];
        [_getCodeImageView setImage:[UIImage imageNamed:@"forget_password_btn"]];
        _getCodeImageView.frame = CGRectMake(ScreenWidth*0.72, ScreenHeight*0.127,ScreenWidth*0.25, ScreenHeight*0.048);
    }
    return _getCodeImageView;
}
-(UIButton *)getCodeBtn{
    
    if (!_getCodeBtn) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = FONT_12;
        [_getCodeBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        //        [_getCodeBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        _getCodeBtn.frame = CGRectMake( ScreenWidth*0.746, ScreenHeight*0.13,ScreenWidth*0.192, ScreenHeight*0.041);
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _getCodeBtn;
}
-(UITextField *)enderCodeTextField{
    if (!_enderCodeTextField) {
        _enderCodeTextField = [[UITextField alloc]init];
        _enderCodeTextField.backgroundColor = [UIColor whiteColor];
        _enderCodeTextField.placeholder = @"获取验证码";
        _enderCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _enderCodeTextField.frame = CGRectMake(0, CGRectGetMaxY(self.phoneTextField.frame)+2, [UIScreen mainScreen].bounds.size.width, ScreenHeight*0.065);
        _enderCodeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth*0.156,ScreenHeight*0.066)];
        _enderCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_shield"]];
        imgUser.frame = CGRectMake(ScreenWidth*0.050, ScreenHeight*0.019, ScreenWidth*0.046, ScreenHeight*0.026);
        [_enderCodeTextField.leftView addSubview:imgUser];
    }
    return _enderCodeTextField;
}
//-(UIButton *)putCodeBtn{
//    if (!_putCodeBtn) {
//        _putCodeBtn = [[UIButton alloc]init];
//        _putCodeBtn.backgroundColor = UIColorFromRGB(0x63B8FF);
//        [_putCodeBtn setTitle:@"提交验证码" forState:UIControlStateNormal];
//        _putCodeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-110, 160,100, 40);
//        [_putCodeBtn addTarget:self action:@selector(putCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _putCodeBtn;
//}
-(UITextField *)userTextField{
    if (!_userTextField) {
        _userTextField = [[UITextField alloc]init];
        _userTextField.backgroundColor = [UIColor whiteColor];
        _userTextField.placeholder = @"请输入用户名";
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userTextField.keyboardType = UIKeyboardTypeDefault;
        _userTextField.delegate = self;
        _userTextField.frame = CGRectMake(0,CGRectGetMaxY(self.enderCodeTextField.frame)+2, [UIScreen mainScreen].bounds.size.width, ScreenHeight*0.066);
        _userTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth*0.156,ScreenHeight*0.066)];
        _userTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forget_password_acount"]];
        imgUser.frame = CGRectMake(ScreenWidth*0.050, ScreenHeight*0.019, ScreenWidth*0.046, ScreenHeight*0.026);
        [_userTextField.leftView addSubview:imgUser];
    }
    return _userTextField;
}
-(UITextField *)pswTextField{
    if (!_pswTextField) {
        _pswTextField = [[UITextField alloc]init];
        _pswTextField.backgroundColor = [UIColor whiteColor];
        _pswTextField.placeholder = @"请输入密码";
        [_pswTextField setSecureTextEntry:YES];
        _pswTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _pswTextField.delegate = self;
        _pswTextField.frame = CGRectMake(0,CGRectGetMaxY(self.userTextField.frame)+2, [UIScreen mainScreen].bounds.size.width, ScreenHeight*0.066);
        _pswTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth*0.156,ScreenHeight*0.066)];
        _pswTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forget_password_lock"]];
        imgUser.frame = CGRectMake(ScreenWidth*0.050, ScreenHeight*0.019, ScreenWidth*0.046, ScreenHeight*0.026);
        [_pswTextField.leftView addSubview:imgUser];
    }
    return _pswTextField;
}
-(UITextField *)confirmPswTextField{
    if (!_confirmPswTextField) {
        _confirmPswTextField = [[UITextField alloc]init];
        _confirmPswTextField.backgroundColor = [UIColor whiteColor];
        _confirmPswTextField.placeholder = @"确认密码";
        [_confirmPswTextField setSecureTextEntry:YES];
        _confirmPswTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _confirmPswTextField.delegate = self;
        _confirmPswTextField.frame = CGRectMake(0,CGRectGetMaxY(self.pswTextField.frame)+2,[UIScreen mainScreen].bounds.size.width,ScreenHeight*0.066);
        _confirmPswTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth*0.156,ScreenHeight*0.066)];
        _confirmPswTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forget_password_key"]];
        imgUser.frame = CGRectMake(ScreenWidth*0.050, ScreenHeight*0.019, ScreenWidth*0.046, ScreenHeight*0.026);
        [_confirmPswTextField.leftView addSubview:imgUser];
        
    }
    return _confirmPswTextField;
}

-(UIButton *)finishRegBtn{
    if (!_finishRegBtn) {
        _finishRegBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishRegBtn.backgroundColor = UIColorFromRGB(0xffd703);
        [_finishRegBtn setTitle:@"完成注册" forState:UIControlStateNormal];
        [_finishRegBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        _finishRegBtn.frame = CGRectMake(0, CGRectGetMaxY(self.confirmPswTextField.frame)+ScreenHeight*0.123, [UIScreen mainScreen].bounds.size.width, ScreenHeight*0.081);
        [_finishRegBtn addTarget:self action:@selector(finishRegBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _finishRegBtn;
}


-(UILabel *)userProtocol{
    
    if (!_userProtocol) {
        _userProtocol = [[UILabel alloc]init];
//        _userProtocol.textAlignment=UITextAlignmentCenter;
        _userProtocol.frame=CGRectMake(0, CGRectGetMaxY(self.confirmPswTextField.frame)+ScreenHeight*0.023, [UIScreen mainScreen].bounds.size.width, ScreenHeight*0.081);
        NSString *string = [NSString stringWithFormat:@"我已阅读《用户保密协议》"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(5,6)];
        
        _userProtocol.attributedText = str;
        //        _userProtocol.textColor = [UIColor blackColor];
        _userProtocol.font = [UIFont systemFontOfSize:0.039*SCREEN_WIDTH];
        _userProtocol.textAlignment = NSTextAlignmentCenter;
        _userProtocol.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UIlabelClick)];
        
        [_userProtocol addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _userProtocol;
}



-(void)UIlabelClick{
    
    NSLog(@"aa");
    [self.view addSubview:self.hubView];
    
    float Width=SCREEN_WIDTH*2/3;
    float height=SCREEN_HEIGHT/2;
    
    self.loadWebView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/4, Width, height)];
    
    
    self.needWeb = [[ZLCWebView alloc]initWithFrame:CGRectMake(0, 0, Width, height)];
    [self.needWeb setProgressFrame:0];
    [self.needWeb loadURLString:@"http://139.224.44.36/ConfidentialityAgreement.html"];
    self.needWeb.delegate = self;
    [self.loadWebView addSubview:self.needWeb];
    [self.view addSubview:self.loadWebView];
    
    
    
}

- (void)zlcwebViewDidStartLoad:(ZLCWebView *)webview
{
    
    NSLog(@"页面开始加载");
}

- (void)zlcwebView:(ZLCWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}
- (void)zlcwebView:(ZLCWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"页面加载完成");
    //    [MBProgressHUD hideHUD];
}

- (void)zlcwebView:(ZLCWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
    //    [MBProgressHUD hideHUD];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView *)hubView{
    if (!_hubView){
        _hubView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hubView.backgroundColor = [UIColor blackColor];
        _hubView.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
        [_hubView addGestureRecognizer:tap];
    }
    return _hubView;
}
-(void)hideView{
    
    [self.loadWebView removeFromSuperview];
    [self.hubView removeFromSuperview];
    
}




@end

