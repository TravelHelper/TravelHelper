//
//  YBZWaitViewController.m
//  YBZTravel
//
//  Created by tjufe on 16/8/6.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZWaitViewController.h"
#import "QuickTransViewController.h"
#import "YBZGifView.h"
#import "AFNetworking.h"
#import "WebAgent.h"

@interface YBZWaitViewController ()
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height

@property(nonatomic,strong)UILabel *userNameLabel;
@end

@implementation YBZWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"口语即时";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showGifImageMethodThree];
    [self.view addSubview:self.userNameLabel];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginChatWithTranslator:) name:@"beginChatWithTranslator" object:nil];
    
}
#pragma mark 播放动态图片方式 第三方显示本地动态图片
-(void)showGifImageMethodThree
{
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"匹配译员动态图" ofType:@"gif"];
    YBZGifView *dataView2 = [[YBZGifView alloc] initWithFrame:CGRectMake(kWidth*0.4, kHeight*0.32, kWidth*0.15, kWidth*0.13) filePath:path];
    [self.view addSubview:dataView2];
}
#pragma mark - 观察者方法

-(void)beginChatWithTranslator:(NSNotification *)noti{
    
    
    NSString *translatorId = noti.object[@"translatorID"];
    NSString *language = noti.object[@"language_catgory"];
  
    NSString *VoiceLanguage;
    NSString *TransLanguage;
    if ([language isEqualToString:@"英语"]) {
        
        VoiceLanguage = Voice_YingYu;
        TransLanguage = Trans_YingYu;
    }
    if ([language isEqualToString:@"美语"]) {
        
        VoiceLanguage = Voice_MeiYu;
        TransLanguage = Trans_MeiYu;
    }
    if ([language isEqualToString:@"韩语"]) {
        
        VoiceLanguage = Voice_HanYu;
        TransLanguage = Trans_HanYu;
    }
    if ([language isEqualToString:@"西班牙语"]) {
        
        VoiceLanguage = Voice_XiBanYa;
        TransLanguage = Trans_XiBanYa;
    }
    if ([language isEqualToString:@"泰语"]) {
        
        VoiceLanguage = Voice_TaiYu;
        TransLanguage = Trans_TaiYu;
    }
    if ([language isEqualToString:@"阿拉伯语"]) {
        
        VoiceLanguage = Voice_ALaBoYu;
        TransLanguage = Trans_ALaBoYu;
    }
    if ([language isEqualToString:@"俄语"]) {
        
        VoiceLanguage = Voice_EYu;
        TransLanguage = Trans_EYu;
    }
    if ([language isEqualToString:@"葡萄牙语"]) {
        
        VoiceLanguage = Voice_PuTaoYaYu;
        TransLanguage = Trans_PuTaoYaYu;
    }
    if ([language isEqualToString:@"希腊语"]) {
        
        VoiceLanguage = Voice_XiLaYu;
        TransLanguage = Trans_XiLaYu;
    }
    if ([language isEqualToString:@"荷兰语"]) {
        
        VoiceLanguage = Voice_HeLanYu;
        TransLanguage = Trans_HeLanYu;
    }
    if ([language isEqualToString:@"波兰语"]) {
        
        VoiceLanguage = Voice_BoLanYu;
        TransLanguage = Trans_BoLanYu;
    }
    if ([language isEqualToString:@"丹麦语"]) {
        
        VoiceLanguage = Voice_DanMaiYu;
        TransLanguage = Trans_DanMaiYu;
    }
    if ([language isEqualToString:@"芬兰语"]) {
        
        VoiceLanguage = Voice_FenLanYu;
        TransLanguage = Trans_FenLanYu;
    }
    if ([language isEqualToString:@"捷克语"]) {
        
        VoiceLanguage = Voice_JieKeYu;
        TransLanguage = Trans_JieKeYu;
    }
    if ([language isEqualToString:@"瑞典语"]) {
        
        VoiceLanguage = Voice_RuiDianYu;
        TransLanguage = Trans_RuiDianYu;
    }
    if ([language isEqualToString:@"匈牙利语"]) {
        
        VoiceLanguage = Voice_XiongYaLiYu;
        TransLanguage = Trans_XiongYaLiYu;
    }
    if ([language isEqualToString:@"日语"]) {
        
        VoiceLanguage = Voice_RiYu;
        TransLanguage = Trans_RiYu;
    }
    if ([language isEqualToString:@"法语"]) {
        
        VoiceLanguage = Voice_FaYa;
        TransLanguage = Trans_FaYu;
    }
    if ([language isEqualToString:@"德语"]) {
        
        VoiceLanguage = Voice_DeYu;
        TransLanguage = Trans_DeYu;
    }
    if ([language isEqualToString:@"意大利语"]) {
        
        VoiceLanguage = Voice_YiDaLiYu;
        TransLanguage = Trans_YiDaLiYu;
    }

    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userIDDictionary = [userdefault objectForKey:@"user_id"];
    NSString *userID=userIDDictionary[@"user_id"];
    
    QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:userID WithTargetID:translatorId WithUserIdentifier:@"USER" WithVoiceLanguage:VoiceLanguage WithTransLanguage:TransLanguage];
    
    
    
    [self.navigationController pushViewController:quickVC animated:YES];
  
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = FONT_15;

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"亲！正在为您匹配译员，请耐心等待!"];
        
        NSRange  qinRange = NSMakeRange(0, 2);
        NSRange  pipeiRange = NSMakeRange(2, 9);
        NSRange  waitRange = NSMakeRange(11, 6);
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:qinRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:174.0/255.0f green:174.0/255.0f blue:174.0/255.0f alpha:0.9] range:pipeiRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0f green:129.0/255.0f blue:204.0/255.0f alpha:0.9] range:waitRange];
        
        [_userNameLabel setFrame:CGRectMake(0, kHeight/3.0, kWidth, 100)];
        [_userNameLabel setAttributedText:str];
        [_userNameLabel setTextAlignment:NSTextAlignmentCenter];
        

    }
    return _userNameLabel;
}

@end




















