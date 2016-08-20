//
//  PersonalSignatureVC.m
//  框架搭建
//
//  Created by sks on 16/7/15.
//  Copyright © 2016年 AlexianAnn. All rights reserved.
//
//Begin 个性签名文本框的设置
#import "PersonalSignatureVC.h"

#define kViewVerticleMargin self.view.bounds.size.height * 7 /730
#define kTextViewVerticleMargin self.view.bounds.size.height *5 /730
#define kinputCharacterNumberLabelWidth 30
#define kinputCharacterNumberLabelHeight 30
#define kMaxWordNumbers 30 //最大输入字数

@interface PersonalSignatureVC ()<UITextViewDelegate>
{
    Boolean   is;
}
@property(nonatomic,strong)UIView *myView;//灰色背景UIView
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,strong)UITextView *individualSignatureTV;//个性签名输入框
@property(nonatomic,strong)UILabel *inputCharacterNumberLabel;//UILabel统计可输入字符字数
@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)UILabel *tishiLabel;

@end

@implementation PersonalSignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myView];
    [self.view addSubview:self.individualSignatureTV];
    [self.view addSubview:self.inputCharacterNumberLabel];
    [self.individualSignatureTV addSubview:self.tishiLabel];
    
    self.individualSignatureTV.delegate = self;
    self.individualSignatureTV.hidden = NO;
    self.individualSignatureTV.delegate = self;
    
    //添加保存按钮
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(UILabel *)tishiLabel{
    
    if(!_tishiLabel){
        
        _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,9, self.view.bounds.size.width, 20)];
        _tishiLabel.backgroundColor = [UIColor clearColor];
        if ([self.qianming  isEqual: @""]) {
            _tishiLabel.text = @"请输入个性签名";
        }else{
            _tishiLabel.text = @"";
        }
        _tishiLabel.font = [UIFont systemFontOfSize:20];
        _tishiLabel.textColor = [UIColor grayColor];
        _tishiLabel.enabled = NO;
    }
    return _tishiLabel;
}

-(UILabel *)lineLabel{
    
    if(!_lineLabel){
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, self.view.bounds.size.width, 5)];
        _lineLabel.backgroundColor = [UIColor whiteColor];
    }
    return _lineLabel;
}

#pragma mark -UIViewget方法
-(UIView *)myView{
    
    if (!_myView) {
        
        self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-kViewVerticleMargin)];
        self.myView.backgroundColor = [UIColor colorWithRed:239/255.0 green:238/255.0 blue:244/255.0 alpha:1];
        [self.myView addSubview:self.lineLabel];
    }
    return _myView;
    
}

-(void)clickSaveBtnAction
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeSignature" object:nil userInfo:@{@"个性签名":self.individualSignatureTV.text}];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITextView *)individualSignatureTV{
    
    if(!_individualSignatureTV){
        
        _individualSignatureTV = [[UITextView alloc]initWithFrame:CGRectMake(0, self.myView.frame.origin.y+kTextViewVerticleMargin+kViewVerticleMargin, self.view.bounds.size.width, self.view.bounds.size.height *85 / 730)];
        _individualSignatureTV.backgroundColor = [UIColor whiteColor];
        _individualSignatureTV.font = [UIFont systemFontOfSize:20];
        if (![self.qianming  isEqual: @""]) {
            _individualSignatureTV.text = self.qianming;
        }
    }
    return _individualSignatureTV;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.individualSignatureTV resignFirstResponder];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    
    self.individualSignatureTV.text = textView.text;
    
    if (self.individualSignatureTV.text.length == 0) {
        self.tishiLabel.text = @"请输入个性签名";
    }else{
        self.tishiLabel.text = @"";
    }
    
    
    if(self.individualSignatureTV.text.length>kMaxWordNumbers){
        
        self.individualSignatureTV.text = [self.individualSignatureTV.text substringToIndex:30];
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"最多可输入30个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [alert show];
        return;
    }
    
    self.inputCharacterNumberLabel.text = [NSString stringWithFormat:@"%ld",kMaxWordNumbers - self.individualSignatureTV.text.length];
}
//End



#pragma mark -UILabel统计可输入字符字数get方法
-(UILabel *)inputCharacterNumberLabel{
    
    if(!_inputCharacterNumberLabel){
        
        self.inputCharacterNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.individualSignatureTV.bounds.size.width-self.view.bounds.size.width * 18 / 410-20, self.individualSignatureTV.frame.origin.y+self.individualSignatureTV.bounds.size.height-self.view.bounds.size.height *8 / 730-20, kinputCharacterNumberLabelWidth, kinputCharacterNumberLabelHeight)];
        self.inputCharacterNumberLabel.backgroundColor = [UIColor clearColor];
        self.inputCharacterNumberLabel.text = [NSString stringWithFormat:@"%i",kMaxWordNumbers];
        self.inputCharacterNumberLabel.textAlignment = NSTextAlignmentCenter;
        self.inputCharacterNumberLabel.textColor = [UIColor lightGrayColor];
        
        
    }
    return  _inputCharacterNumberLabel;
}



@end
