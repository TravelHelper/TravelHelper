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
#import <Foundation/Foundation.h>

@interface YBZWaitViewController ()
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height

@property(nonatomic,strong)UILabel *userNameLabel;
@end

@implementation YBZWaitViewController{
    
    NSString *userID;
    NSString *sender_ID;
    NSString *send_Message;
    NSString *user_language;
    NSString *pay_Number;
    NSTimer *timer;
    NSString *message_id;
    float intervalTime;


}


- (instancetype)initWithsenderID:(NSString *)senderID WithsendMessage:(NSString *)sendMessage WithlanguageCatgory:(NSString *)language WithpayNumber:(NSString *)payNumber
{
    self = [super init];
    if (self) {
        
        sender_ID = senderID;
        send_Message = sendMessage;
        user_language = language;
        pay_Number = payNumber;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"口语即时";
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    userID = user_id[@"user_id"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消等候" style:UIBarButtonItemStylePlain target:self action:@selector(stopFindingTranslator)];
    [self showGifImageMethodThree];
    [self.view addSubview:self.userNameLabel];
    
    [self matchTranslatorWithsenderID:sender_ID WithsendMessage:send_Message WithlanguageCatgory:user_language WithpayNumber:pay_Number];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitApp) name:@"quitApp" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginChatWithTranslator:) name:@"beginChatWithTranslator" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopFindingTranslator) name:@"stopFindingTranslator" object:nil];
    
}



-(void)quitApp{

    [timer invalidate];
}




-(void)matchTranslatorWithsenderID:(NSString *)senderID WithsendMessage:(NSString *)sendMessage WithlanguageCatgory:(NSString *)language WithpayNumber:(NSString *)payNumber{
    NSDate *sendDate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *morelocationString = [dateformatter stringFromDate:sendDate];
    
    //在这里加上修改状态的接口。
    [WebAgent creatUserList:morelocationString andUser_id:userID WithLanguage:language success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        message_id = dic[@"data"];
        intervalTime = [dic[@"time"] floatValue];;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:message_id forKey:@"messageId"];
        NSDictionary *dict = @{@"senderID":senderID,@"sendMessage":sendMessage,@"languageCatgory":language,@"payNumber":payNumber};
        timer=[NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(selectTranslatorWithDict:) userInfo:dict repeats:YES];

        
        [timer fire];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


-(void)selectTranslatorWithDict:(NSTimer *)timer{
    NSDictionary *dict = [timer userInfo];
    NSString *senderID = dict[@"senderID" ];
    NSString *sendMessage = dict[@"sendMessage"];
    NSString *language = dict[@"languageCatgory"];
    NSString *payNumber = dict[@"payNumber"];
    [WebAgent selectTranslator:language user_id:userID success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *resultData = dic[@"data"];
        NSString *code = dic[@"code"];
        if (resultData.count == 0) {
            NSLog(@"%@", code);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"抱歉，当前没有该语种的对应译员" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //注销
                [timer invalidate];
                [WebAgent stopFindingTranslator:userID missionID:message_id success:^(id responseObject) {
                    //                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error) {
                    
                }];
            }];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            if ([code isEqualToString:@"0000"]) {
                //通知进入聊天页面
                NSLog(@"开始聊天");
                NSDictionary *dict = [self getLanguageWithString:language];
                [WebAgent sendRemoteNotificationsWithuseId:resultData[0][@"user_id"] WithsendMessage:@"进入聊天" WithlanguageCatgory:language WithpayNumber:payNumber WithSenderID:userID WithMessionID:message_id success:^(id responseObject) {
//                    NSData *data = [[NSData alloc] initWithData:responseObject];
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"反馈推送—进入聊天通知成功！");
                    //注销
                    [timer invalidate];
                    QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:userID WithTargetID:resultData[0][@"user_id"] WithUserIdentifier:@"USER" WithVoiceLanguage:dict[@"voice"] WithTransLanguage:dict[@"trans"]];
                    [self.navigationController pushViewController:quickVC animated:YES];
                } failure:^(NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"进入聊天页面失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                }];
            }else{
                //发送推送
                for (int i = 0 ; i< resultData.count; i++) {
                    NSString *user_ID = resultData[i];
                    NSString * strid = [user_ID stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                    [WebAgent sendRemoteNotificationsWithuseId:strid WithsendMessage:sendMessage WithlanguageCatgory:language WithpayNumber:payNumber WithSenderID:senderID WithMessionID:message_id success:^(id responseObject) {
                        NSData *data = [[NSData alloc]initWithData:responseObject];
                        NSString *str= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        NSLog(@"%@",str);
                        NSLog(@"发送远程推送成功!");
                    } failure:^(NSError *error) {
                        NSLog(@"发送远程推送失败－－－>%@",error);
                    }];
                }
                
            }
        }
            
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark 播放动态图片方式 第三方显示本地动态图片
-(void)showGifImageMethodThree
{
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"匹配译员动态图" ofType:@"gif"];
    YBZGifView *dataView2 = [[YBZGifView alloc] initWithFrame:CGRectMake(kWidth*0.4, kHeight*0.32, kWidth*0.15, kWidth*0.13) filePath:path];
    [self.view addSubview:dataView2];
}


-(void)stopFindingTranslator{

    //修改状态变为0
    [timer invalidate];
    [WebAgent getMissionInfo:message_id success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *missionInfo = dic[@"data"][0];
        if ([missionInfo[@"answer_id"] isEqualToString:@""]) {
            [WebAgent stopFindingTranslator:userID missionID:message_id success:^(id responseObject) {
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的即时翻译已被接单，请耐心等待！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"再等一会" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我要取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [WebAgent stopFindingTranslator:userID missionID:message_id success:^(id responseObject) {
                        [WebAgent sendRemoteNotificationsWithuseId:missionInfo[@"answer_id"] WithsendMessage:@"退出聊天" WithlanguageCatgory:missionInfo[@"language"] WithpayNumber:@"0" WithSenderID:userID WithMessionID:message_id success:^(id responseObject) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } failure:^(NSError *error) {
                            [self.navigationController popViewControllerAnimated:YES];

                        }];
                } failure:^(NSError *error) {
                    
                }];
            }];

            [alertVC addAction:okAction];
            [alertVC addAction:cancelAction];

            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];

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
    
    [timer invalidate];
    
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

@end




















