//
//  YBZCustomPublishViewController.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/10/31.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZCustomPublishViewController.h"
#import "YBZOtherViewController.h"
#import "YBZCustomView.h"


@interface YBZCustomPublishViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIView   *contentView;
@property (nonatomic,strong) UIButton *languageBtn;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UIButton *scenceBtn;
@property (nonatomic,strong) UIDatePicker *timePicker;

@end

@implementation YBZCustomPublishViewController
{
    bool emptyMark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    emptyMark=true;
    self.view.backgroundColor=UIColorFromRGB(0xF2F2F2);
    self.title=@"定制翻译";
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.contentView];
    
    [self setLabel];
    [self setBtn];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.contentTextView resignFirstResponder];

}


-(void)setLabel{

    CGFloat left=0.05*SCREEN_WIDTH;
    
    YBZCustomView *languageView=[[YBZCustomView alloc]initWithFrame:CGRectMake(left, SCREEN_HEIGHT*0.05, SCREEN_WIDTH/2-left, SCREEN_HEIGHT*0.07) AndTitle:@"语种选择"];
    [self.contentView addSubview:languageView];
    YBZCustomView *needView=[[YBZCustomView alloc]initWithFrame:CGRectMake(left, SCREEN_HEIGHT*0.12+5, SCREEN_WIDTH/2-left, SCREEN_HEIGHT*0.07) AndTitle:@"需求内容"];
    [self.contentView addSubview:needView];
    YBZCustomView *groundView=[[YBZCustomView alloc]initWithFrame:CGRectMake(left, SCREEN_HEIGHT*0.19+10, SCREEN_WIDTH/2-left, SCREEN_HEIGHT*0.07) AndTitle:@"翻译场景"];
    [self.contentView addSubview:groundView];
    YBZCustomView *timeView=[[YBZCustomView alloc]initWithFrame:CGRectMake(left, SCREEN_HEIGHT*0.3+10, SCREEN_WIDTH/2-left, SCREEN_HEIGHT*0.07) AndTitle:@"预约时间"];
    [self.contentView addSubview:timeView];
    YBZCustomView *lengthView=[[YBZCustomView alloc]initWithFrame:CGRectMake(left, SCREEN_HEIGHT*0.37+15, SCREEN_WIDTH/2-left, SCREEN_HEIGHT*0.07) AndTitle:@"需用时长"];
    [self.contentView addSubview:lengthView];
    YBZCustomView *goldView=[[YBZCustomView alloc]initWithFrame:CGRectMake(left, SCREEN_HEIGHT*0.44+20, SCREEN_WIDTH/2-left, SCREEN_HEIGHT*0.07) AndTitle:@"支付金额"];
    [self.contentView addSubview:goldView];

}
-(void)setBtn{

    CGFloat right=0.05*SCREEN_WIDTH;
    self.languageBtn.frame=CGRectMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.05, SCREEN_WIDTH/2-right, SCREEN_HEIGHT*0.07);
    [self.contentView addSubview:self.languageBtn];
    self.contentTextView.frame=CGRectMake(SCREEN_WIDTH*0.55, SCREEN_HEIGHT*0.13+5, SCREEN_WIDTH/2-right, SCREEN_HEIGHT*0.07);
    [self.contentView addSubview:self.contentTextView];
    self.scenceBtn.frame=CGRectMake(SCREEN_WIDTH*0.55, SCREEN_HEIGHT*0.19+10, SCREEN_WIDTH/2-right, SCREEN_HEIGHT*0.07);
    [self.contentView addSubview:self.scenceBtn];
    

}


-(void)viewWillAppear:(BOOL)animated{


    self.sendBtn.frame=CGRectMake(0, SCREEN_HEIGHT*0.8, SCREEN_WIDTH, SCREEN_HEIGHT*0.1);
    
}
-(UIView *)contentView{

    if(!_contentView){
    
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT*0.8-64)];
        
    }
    return _contentView;
    
}


-(UIButton *)sendBtn{

    if(!_sendBtn){
    
        _sendBtn=[[UIButton alloc]init];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:0.048*SCREEN_WIDTH]];
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor=UIColorFromRGB(0xffd703);
        
    }
    return _sendBtn;
}
-(UIButton *)languageBtn{

    if(!_languageBtn){
    
        _languageBtn=[[UIButton alloc]init];
        [_languageBtn addTarget:self action:@selector(languageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_languageBtn.titleLabel setFont:[UIFont systemFontOfSize:0.04*SCREEN_WIDTH]];
        [_languageBtn setTitle:@"选择语种" forState:UIControlStateNormal];
        [_languageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_languageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0.1*SCREEN_WIDTH, 2, 0)];
    
    }
    return _languageBtn;

}

-(UITextView *)contentTextView{

    if(!_contentTextView){
    
        _contentTextView=[[UITextView alloc]init];
        
        _contentTextView.delegate=self;
        _contentTextView.backgroundColor=[UIColor clearColor];
        _contentTextView.font=[UIFont systemFontOfSize:0.04*SCREEN_WIDTH];
        _contentTextView.returnKeyType = UIReturnKeyDefault;//return键的类型
        _contentTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _contentTextView.textAlignment = NSTextAlignmentCenter; //文本显示的位置默认为居左
        _contentTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        _contentTextView.textColor = [UIColor grayColor];
        _contentTextView.text=@"请描述翻译内容";
        
    
    }
    return _contentTextView;

}


-(UIButton *)scenceBtn{
    
    if(!_scenceBtn){
        
        _scenceBtn=[[UIButton alloc]init];
        [_scenceBtn addTarget:self action:@selector(scenceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_scenceBtn.titleLabel setFont:[UIFont systemFontOfSize:0.04*SCREEN_WIDTH]];
        [_scenceBtn setTitle:@"场景选择" forState:UIControlStateNormal];
        [_scenceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _scenceBtn.backgroundColor=[UIColor clearColor];
        
    }
    return _scenceBtn;
}

-(UIDatePicker *)timePicker{

    if(!_timePicker){
    
        _timePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(20, 100, 300, 200)];
        _timePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        
    }
    return _timePicker;

}

-(void)scenceBtnClick{

    NSLog(@"选择场景");
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"选择场景" message:@"选择翻译环境" preferredStyle:    UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"语音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.scenceBtn setTitle:@"语音" forState:UIControlStateNormal];
        [self.scenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.scenceBtn setTitle:@"视频" forState:UIControlStateNormal];
        [self.scenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)sendBtnClick{

    NSLog(@"发布了");

}
-(void)languageBtnClick{

    NSLog(@"选择语言");
    YBZOtherViewController *vc = [[YBZOtherViewController alloc]init];
    vc.chooseLanguageArr = [NSMutableArray array];
//    [vc.chooseLanguageArr addObjectsFromArray:_chooseLanguageArr];
    
    [vc setAddLanguageBlock:^(NSString *string) {
//        [_chooseLanguageArr addObject:string];
        [self.languageBtn setTitle:string forState:UIControlStateNormal];
        [self.languageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSLog(@"%@",string);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textViewDidChange:(UITextView *)textView{

    NSLog(@"%@",textView.text);
    if([textView.text isEqualToString:@""]){
        emptyMark=true;
    }else{
        emptyMark=false;
    }


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.contentTextView resignFirstResponder];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    textView.textAlignment = NSTextAlignmentLeft;
    if(emptyMark==true){
        
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
        
        
    }

}
- (void)textViewDidEndEditing:(UITextView *)textView{

    textView.textAlignment = NSTextAlignmentCenter;
    if(emptyMark==true){
    
        textView.text=@"请描述翻译内容";;
        textView.textColor=[UIColor grayColor];
        
    }
    
}

@end
