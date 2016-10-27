//
//  YBZTranslatorAnswerViewController.m
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

//回答（译员）
#import "YBZTranslatorAnswerViewController.h"
#define INTERVAL_KEYBOARD  10
#define kAnimationDuration 0.3f
#define kViewHeight        50

@interface YBZTranslatorAnswerViewController()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,strong) UIButton *pictureButton;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) UILabel *placeholderLabel;

@property (nonatomic,assign) CGFloat keyboardHeight;
@property (strong,nonatomic) UIImage *image;
@property (nonatomic,strong) NSString *isEmpty;

@end

@implementation YBZTranslatorAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = myRewardBackgroundColor;
    [self.view addSubview:self.pictureView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.imageView];
    self.title = @"回  答";
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.submitButton];
    
    //添加键盘的监听事件
    //    //注册通知,监听键盘弹出事件
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - textview
-(UITextView *)textView
{
    if(!_textView)
    {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 100)];
        _textView.delegate = self;
        _textView.scrollEnabled = YES;//当文字超过视图的边框时是否允许滑动，默认为“YES”
        _textView.editable = YES;//是否允许编辑内容，默认为“YES”
        _textView.font = [UIFont systemFontOfSize:16];
        
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
        self.placeholderLabel.text = @"请在此处输入您回答的内容...";
        self.placeholderLabel.textColor = [UIColor colorWithRed:225.0f/255.0 green:225.0f/255.0 blue:225.0f/255.0 alpha:1];
        self.placeholderLabel.enabled = NO;
        [_textView addSubview:self.placeholderLabel];

    }
    return _textView;
}
#pragma mark - 底部图片
-(UIView *)pictureView
{
    if(!_pictureView)
    {
        _pictureView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        lineView.backgroundColor = [UIColor colorWithRed:225.0f/255.0 green:225.0f/255.0 blue:225.0f/255.0 alpha:1];
        [_pictureView addSubview:lineView];
        
        UIImageView *choosePicture = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 10 , 40, 33)];
        UIImage *image = [UIImage imageNamed:@"回答"];
        choosePicture.image = image;
        //image点击事件
        [choosePicture setUserInteractionEnabled:YES];
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePictureClick)];
        [choosePicture addGestureRecognizer:click];
        [_pictureView addSubview:choosePicture];
    }
    return _pictureView;
}
-(void)choosePictureClick
{
    NSLog(@"kai kai kai ");
    self.imageView.hidden = NO;
}
-(UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _imageView.hidden = YES;
        [_imageView setImage:self.previewImg];
        _imageView.backgroundColor = [UIColor colorWithRed:107/255.0 green:107/255.0 blue:99/255.0 alpha:0.8];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        //image点击事件
        [_imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
        [_imageView addGestureRecognizer:click];
    }
    return _imageView;
}
-(void)imageViewClick
{
    if(self.imageView.hidden == NO)
    {
        self.imageView.hidden = YES;
        NSLog(@"guan guan guan ");
    }
}
#pragma mark - 取消按钮及点击事件
-(UIBarButtonItem *)backButton
{
    if(!_backButton)
    {
        UIButton *backBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        backBtn.titleLabel.font = FONT_14;
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    }
    return _backButton;
}
-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 提交按钮、点击事件以及提交接口
-(UIButton *)submitButton
{
    if(!_submitButton)
    {
        _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = FONT_14;
        _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
-(void)submitClick
{
    if(self.textView.text.length == 0)
    {
        self.isEmpty = @"YES";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"内容不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        
        self.isEmpty = @"NO";
        NSDate *answerTime=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *locationString=[dateformatter stringFromDate:answerTime];
        
        
        
        //    [dateformatter release];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        NSLog(@"-------------------->%@",self.rewardID);
        [WebAgent uploadreward_id:self.rewardID user_id:user_id[@"user_id"] reward_text:self.textView.text answer_time:locationString success:^(id responseObject) {
            NSLog(@"Success");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提交成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            
            NSDictionary *answerChange = @{@"answer_change":self.reward_id};
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:answerChange forKey:@"1"];
            
        } failure:^(NSError *error) {
            NSLog(@"------------------> %@",error);
        }];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if([self.isEmpty isEqualToString:@"YES"])
        {
            NSLog(@"");
        }
        else
        {
            [self.textView resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(self.textView.text.length == 0)
    {
        self.placeholderLabel.text = @"请在此处输入您翻译的内容...";
    }
    else
    {
        self.placeholderLabel.text = @"";
    }
}
#pragma mark - 键盘事件
//键盘弹出时
-(void)keyboardWillShow:(NSNotification *)notification
{
    //当图片显示时，点击输入框、空白或图片本身 图片消失
    if(self.imageView.hidden == NO)
    {
        self.imageView.hidden = YES;
    }
    //获取键盘高度
    CGRect keyboardRect = [[[notification userInfo]objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]
                                        doubleValue];
    [UIView animateWithDuration:0.5 animations:^{
        self.pictureView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
    }];
    
}
//键盘消失时
-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   [UIView animateWithDuration:0.5 animations:^{
       self.pictureView.transform = CGAffineTransformIdentity;
   }];
}
//点击空白 keyboard消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //当图片显示时，点击输入框、空白或图片本身 图片消失
    if(self.imageView.hidden == NO)
    {
        self.imageView.hidden = YES;
    }
    
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
