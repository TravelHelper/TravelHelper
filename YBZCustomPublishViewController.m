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
#import "WebAgent.h"
#import "MBProgressHUD+XMG.h"


@interface YBZCustomPublishViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIView   *contentView;
@property (nonatomic,strong) UIButton *languageBtn;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UIButton *scenceBtn;
@property (nonatomic,strong) UIDatePicker *timePicker;
@property (nonatomic,strong) UIButton *timeBtn;
@property (nonatomic,strong) UIView   *timeView;
@property (nonatomic,strong) UIDatePicker *longPicker;
@property (nonatomic,strong) UIButton *longBtn;
@property (nonatomic,strong) UIButton *priceLabel;

@end

@implementation YBZCustomPublishViewController
{
    bool emptyMark;
    NSString *orderTime;
    int timeLong;
    BOOL messageMark;
    int bidata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    messageMark=false;
    emptyMark=true;
    orderTime=@"";
    timeLong=0;
    self.view.backgroundColor=UIColorFromRGB(0xF2F2F2);
    self.title=@"定制翻译";
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.contentView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnPrice) name:@"returnPrice" object:nil];
    
    [self setLabel];
    [self setBtn];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.contentTextView resignFirstResponder];
    

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.timeBtn.frame=CGRectMake(SCREEN_WIDTH*0.55, SCREEN_HEIGHT*0.3+10, SCREEN_WIDTH/2-right, SCREEN_HEIGHT*0.07);
    [self.contentView addSubview:self.timeBtn];
    
    [self.view addSubview:self.timeView];
    [self.timeView addSubview:self.timePicker];
    [self.timeView addSubview:self.longPicker];
    self.timePicker.hidden=YES;
    self.longPicker.hidden=YES;
    self.longBtn.frame=CGRectMake(SCREEN_WIDTH*0.55, SCREEN_HEIGHT*0.37+15, SCREEN_WIDTH/2-right, SCREEN_HEIGHT*0.07);
    [self.contentView addSubview:self.longBtn];
    self.priceLabel.frame=CGRectMake(SCREEN_WIDTH*0.55, SCREEN_HEIGHT*0.44+20, SCREEN_WIDTH/2-right, SCREEN_HEIGHT*0.07);
    [self.contentView addSubview:self.priceLabel];
    

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
    
        _timePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 200)];
        _timePicker.datePickerMode = UIDatePickerModeDateAndTime;
        NSDate *nowDate=[NSDate date];
        _timePicker.minimumDate=nowDate;
//        [_timePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _timePicker.locale = locale;
        
        _timePicker.backgroundColor=[UIColor whiteColor];
    }
    return _timePicker;

}
-(UIDatePicker *)longPicker{

    if(!_longPicker){
        
        _longPicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 200)];
        _longPicker.datePickerMode = UIDatePickerModeCountDownTimer;
        NSDate *nowDate=[NSDate date];
        _longPicker.minimumDate=nowDate;
//        [_longPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _longPicker.locale = locale;
        
        _longPicker.backgroundColor=[UIColor whiteColor];
    }
    return _longPicker;


}

-(UIButton *)timeBtn{

    if(!_timeBtn){
    
        _timeBtn=[[UIButton alloc]init];
        [_timeBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_timeBtn.titleLabel setFont:[UIFont systemFontOfSize:0.04*SCREEN_WIDTH]];
        [_timeBtn setTitle:@"选择预约时间" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _timeBtn.backgroundColor=[UIColor clearColor];

        
    }
    return _timeBtn;

}
-(UIButton *)longBtn{

    if(!_longBtn){
        
        _longBtn=[[UIButton alloc]init];
        [_longBtn addTarget:self action:@selector(longBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_longBtn.titleLabel setFont:[UIFont systemFontOfSize:0.04*SCREEN_WIDTH]];
        [_longBtn setTitle:@"选择预约时长" forState:UIControlStateNormal];
        [_longBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _longBtn.backgroundColor=[UIColor clearColor];
        
        
    }
    return _longBtn;


}

-(UIView *)timeView{

    if(!_timeView){
    
        _timeView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        _timeView.backgroundColor=[UIColor whiteColor];
        UIButton *timeClickBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 60, 30)];
        [timeClickBtn setTitle:@"确认" forState:UIControlStateNormal];
        [timeClickBtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
        [timeClickBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        timeClickBtn.backgroundColor=[UIColor clearColor];
        [_timeView addSubview:timeClickBtn];
        UIButton *cancelClickBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, 60, 30)];
        [cancelClickBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelClickBtn addTarget:self action:@selector(timeCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelClickBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cancelClickBtn.backgroundColor=[UIColor clearColor];
        [_timeView addSubview:cancelClickBtn];
    
    }
    return _timeView;

}
-(UIButton *)priceLabel{

    if(!_priceLabel){
    
        _priceLabel=[[UIButton alloc]init];
//        _priceLabel.enabled=NO;
//        [_priceLabel setTitle:@"请完善信息" forState:UIControlStateNormal];
        //    [_longBtn.titleLabel setFont:[UIFont systemFontOfSize:0.04*SCREEN_WIDTH]];
        [_priceLabel setTitle:@"请填写价格" forState:UIControlStateNormal];
        [_priceLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_priceLabel.titleLabel setFont:[UIFont systemFontOfSize:0.04*SCREEN_WIDTH]];
        [_priceLabel addTarget:self action:@selector(priceLabelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceLabel;

}

-(void)priceLabelClick{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    [WebAgent moneyDouCostWithID:user_id[@"user_id"] andCostCount:@"0" success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSString *str=dic[@"msg"];
        bidata=[dic[@"bidata"]intValue];
        
        
        UIAlertController *alertController;
        
        //    __block NSUInteger blockSourceType = 0;
        
        NSString *priceStr=[NSString stringWithFormat:@"当前游币余额:%d",bidata];
        
        alertController = [UIAlertController alertControllerWithTitle:@"价格填写" message:priceStr preferredStyle:    UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // 可以在这里对textfield进行定制，例如改变背景色
            
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.returnKeyType = UIReturnKeyDone;
            
            
        }];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
            UITextField *textField=alertController.textFields.firstObject;
            NSLog(@"%@",textField.text);
            //        NSString *tobicost=textField.text;
            
            if([textField.text isEqualToString:@""]){
                [MBProgressHUD showError:@"金额不能为空白"];
            }else{
                int resultInt=[textField.text intValue];
                if(resultInt>bidata){
                    [MBProgressHUD showError:@"悬赏不得大于游币余额"];
                }else{
                    [self.priceLabel setTitle:textField.text forState:UIControlStateNormal];
                    [self.priceLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                }
                
            }
            
           
            
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        

        
        
        
    } failure:^(NSError *error) {
        
    }];

    

    
}

-(void)longBtnClick{

    NSLog(@"long");
    if(self.longPicker.hidden==YES){
        if(self.timePicker.hidden==YES){
            self.longPicker.hidden=NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.timeView.transform=CGAffineTransformMakeTranslation(0,-200);
            }];
        }else{
            
            [UIView animateWithDuration:0.25 animations:^{
                self.timeView.transform=CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.timePicker.hidden=YES;
                self.longPicker.hidden=NO;
                [UIView animateWithDuration:0.25 animations:^{
                    self.timeView.transform=CGAffineTransformMakeTranslation(0,-200);
                }];
            }];
            
        }
        
    }

}
-(void)timeClick{

    
    if(self.timePicker.hidden==NO){
        NSLog(@"click");
        NSDate *select = [self.timePicker date]; // 获取被选中的时间
        NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
        selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // 设置时间和日期的格式
        NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
        [self.timeBtn setTitle:dateAndTime forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSLog(@"%@",dateAndTime);
        orderTime=dateAndTime;
    //    [UIView animateWithDuration:0.5 animations:^{
    //        self.timeView.transform=CGAffineTransformIdentity;
    //    }];
        [UIView animateWithDuration:0.5 animations:^{
            self.timeView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.timePicker.hidden=YES;
        }];
    }else{
    
        NSDate *select = [self.longPicker date]; // 获取被选中的时间
        NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
        selectDateFormatter.dateFormat = @"HH时mm分"; // 设置时间和日期的格式
        NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
        [self.longBtn setTitle:dateAndTime forState:UIControlStateNormal];
        [self.longBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSLog(@"%@",dateAndTime);
        //    [UIView animateWithDuration:0.5 animations:^{
        //        self.timeView.transform=CGAffineTransformIdentity;
        //    }];
        
//        NSTimeInterval timeInterval = [select timeIntervalSince1970];
//        NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
//        timeLong
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HHmm"];
        NSString *strDate = [dateFormatter stringFromDate:select];
//        [dateFormatter release];
        int intDate = [strDate intValue];
        int minute=intDate%100;
        int hour=(int)intDate/100;
        timeLong=hour*60+minute;
        
        NSLog(@"%d",timeLong);
//        record.m_time = (int)timeInterval;
//        NSLog(@"Date转整型-----%@", timeString);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.timeView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.longPicker.hidden=YES;
        }];
        
        

        
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"returnPrice" object:nil];
    
}
-(void)timeCancelClick{

    NSLog(@"qwe");
    if(self.timePicker.hidden==NO){
    
        [UIView animateWithDuration:0.5 animations:^{
            self.timeView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.timePicker.hidden=YES;
        }];
    }else{
    
        [UIView animateWithDuration:0.5 animations:^{
            self.timeView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.longPicker.hidden=YES;
        }];

    }
    
}

-(void)timeBtnClick{

    NSLog(@"timeClick");
    
    if(self.timePicker.hidden==YES){
        if(self.longPicker.hidden==YES){
            self.timePicker.hidden=NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.timeView.transform=CGAffineTransformMakeTranslation(0,-200);
            }];
        }else{
        
            [UIView animateWithDuration:0.25 animations:^{
                self.timeView.transform=CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.longPicker.hidden=YES;
                self.timePicker.hidden=NO;
                [UIView animateWithDuration:0.25 animations:^{
                    self.timeView.transform=CGAffineTransformMakeTranslation(0,-200);
                }];
            }];
            
        }
    
    }
//    -(void)move:(CGFloat)x{
//        if(x>0){
//            [UIView animateWithDuration:0.5 animations:^{
//                self.scrollView.transform=CGAffineTransformMakeTranslation(x,0);
//            }];
//        }
//        else{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.scrollView.transform=CGAffineTransformIdentity;
//            }];
//            //self.scrollView.transform=CGAffineTransformIdentity;
//        }
//    }
    
}

-(void)dateChanged:(id)sender{
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yy:MM:dd HH:mm:ss"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    NSLog(@"%@",dateAndTime);
    
}

-(void)scenceBtnClick{

    NSLog(@"选择场景");
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"选择场景" message:@"选择翻译环境" preferredStyle:    UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"语音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.scenceBtn setTitle:@"语音" forState:UIControlStateNormal];
        [self.scenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"returnPrice" object:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.scenceBtn setTitle:@"视频" forState:UIControlStateNormal];
        [self.scenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"returnPrice" object:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
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
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"returnPrice" object:nil];
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
    
    [UIView animateWithDuration:0.5 animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.timeView.transform=CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        self.timePicker.hidden=YES;
        self.longPicker.hidden=YES;
    }];

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
-(void)toReturnPrice{

//    float languageRatio=1.0;
//    float scenceRation=1.0;
//    float timeLongRation=1.0;
    int mark=0;
    if(![self.languageBtn.titleLabel.text isEqualToString:@"选择语种"]){
    
        if(![self.contentTextView.text isEqualToString:@"请描述翻译内容"]){
        
            if(![self.scenceBtn.titleLabel.text isEqualToString:@"场景选择"]){
            
                if([self.scenceBtn.titleLabel.text isEqualToString:@"语音"]){
                
//                    scenceRation=1.0;
                }else{
                
//                    scenceRation=1.5;
                }
                if(![orderTime isEqualToString:@""]){
                
                    if(timeLong!=0){
                    
//                        int resultPrice=timeLong*languageRatio*scenceRation*2;
//                        NSString *priceStr=[NSString stringWithFormat:@"%d游币",resultPrice];
////                        self.priceLabel.textColor=[UIColor redColor];
//                        [_priceLabel setTitle:priceStr forState:UIControlStateNormal];
//                        [_priceLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        
                        mark=1;
                    }
                    
                }
                
            }
            
        }
        
    }
    
    if(mark==1){
    
        messageMark=true;
        
    }else{
    
        messageMark=false;
    
    }

}



-(void)sendBtnClick{
    
    NSLog(@"发布了");
    [self toReturnPrice];
    
    if(messageMark==true){
        [MBProgressHUD showMessage:@"提交中"];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        
        
        [WebAgent moneyBiCostWithID:user_id[@"user_id"] andCostCount:self.priceLabel.titleLabel.text andSource_id:@"0002" success:^(id responseObject) {

            [WebAgent uploaduser_id:user_id[@"user_id"] language:self.languageBtn.titleLabel.text scene:self.scenceBtn.titleLabel.text content:self.contentTextView.text custom_time:orderTime duration:self.longBtn.titleLabel.text offer_money:self.priceLabel.titleLabel.text state:@"0" success:^(id responseObject) {
                //            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *message=dic[@"state"];
                [MBProgressHUD hideHUD];
                if([message isEqualToString:@"SUCCESS"]){
                    [MBProgressHUD showSuccess:@"提交成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD showError:@"上传失败 请重试"];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"提交失败，请检查网络"];
            }];
            
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"扣币失败，请重试"];
            NSLog(@"fail");
        }];
        
        
        
   
    }else{
        
        [MBProgressHUD showError:@"请完善定制信息"];
        
    }
    
    
    
}



@end
