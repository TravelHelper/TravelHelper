//
//  YBZWaitingViewController.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZWaitingViewController.h"
#import "QuickTransViewController.h"
#import "WebAgent.h"
#import "YBZGifView.h"


@interface YBZWaitingViewController ()
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height

@property(nonatomic,strong)UILabel *userNameLabel;
@end

@implementation YBZWaitingViewController{

    NSString *userID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showGifImageMethodThree];
    [self.view addSubview:self.userNameLabel];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消等候" style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    userID = user_id[@"user_id"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginChatWithUser:) name:@"pushIntoTransView" object:nil];
}

-(void)showGifImageMethodThree
{
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"匹配译员动态图" ofType:@"gif"];
    YBZGifView *dataView2 = [[YBZGifView alloc] initWithFrame:CGRectMake(kWidth*0.4, kHeight*0.32, kWidth*0.15, kWidth*0.13) filePath:path];
    [self.view addSubview:dataView2];
}
-(void)viewWillAppear:(BOOL)animated{

    
}

-(void)popToRoot{

    [WebAgent removeFromWaitingQueue:userID success:^(id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

-(void)beginChatWithUser:(NSNotification *)noti{

    NSString *yonghuID = noti.object[@"yonghuID"];
    NSString *language = noti.object[@"language_catgory"];
    NSDictionary *dict = [self getLanguageWithString:language];
    [WebAgent removeFromWaitingQueue:userID success:^(id responseObject) {
        QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:userID WithTargetID:yonghuID WithUserIdentifier:@"TRANSTOR" WithVoiceLanguage:dict[@"voice"] WithTransLanguage:dict[@"trans"]];
        [self.navigationController pushViewController:quickVC animated:YES];
    } failure:^(NSError *error) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];

}

-(NSDictionary *)getLanguageWithString:(NSString *)language{
    
    NSString *VoiceLanguage;
    NSString *TransLanguage;
    if ([language isEqualToString:@"英语"]) {
        
        VoiceLanguage = Voice_YingYu;
        TransLanguage = Trans_YingYu;
    }
    if ([language isEqualToString:@"美式英语"]) {
        
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
    
    NSDictionary *dict = @{@"voice":VoiceLanguage,
                           @"trans":TransLanguage
                           };
    return dict;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = FONT_15;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"亲！正在为您寻找用户，请耐心等待!"];
        
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
