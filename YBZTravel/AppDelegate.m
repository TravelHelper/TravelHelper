//
//  AppDelegate.m
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "AppDelegate.h"
#import "YBZRootViewController.h"
#import "YBZTranslationController.h"
#import "iflyMSC/IFlyMSC.h"
#import "YBZWaitingViewController.h"
//#import <RongIMLib/RongIMLib.h>
#import <SMS_SDK/SMSSDK.h>
#import "YBZMyRewardViewController.h"
#import "FreeTransViewController.h"
#import "JPUSHService.h"
#import "UIAlertController+SZYKit.h"
#import "WebAgent.h"
#import "UIAlertController+SZYKit.h"
#import "YBZMyMoneyViewController.h"
#import "YBZtoalertView.h"
#import "EMSDKFull.h"
#import "BaiduMobStat.h"
#import "QuickTransViewController.h"
#import "MBProgressHUD+XMG.h"
#import <StoreKit/StoreKit.h>
#import "SVProgressHUD.h"
#import "YBZPrepareViewController.h"
#import "YBZTargetWaitingViewController.h"


#define Trans_YingYu    @"en"
#define Voice_YingYu    @"en-GB"

@interface AppDelegate ()<SKPaymentTransactionObserver>

@property(nonatomic,assign) NSString* isLogin;
@property(nonatomic,strong) UIAlertController *alertVC;
//@property(nonatomic,strong) UITableView *
@property (nonatomic,strong) UIView             *hubView;
@property (nonatomic, strong)YBZtoalertView  *toalertView;

@end

@implementation AppDelegate{

    BOOL isChat;
    NSString *userID;
    NSString *targetID;
    NSString *missionID;
    NSTimer *quitTimer;
    NSString *userIdentifier;
    BOOL needPush;
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    //Baidutongji
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"34fe3d89a2"];

    
    needPush = NO;
    isChat = NO;
    missionID = @"";
    targetID = @"";
    quitTimer = [NSTimer timerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stopFindingTranslator" object:nil];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        
        userID = user_id[@"user_id"];

        if (isChat == NO) {
            [WebAgent removeFromWaitingQueue:userID success:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
        }else if(isChat == YES){
            [WebAgent sendRemoteNotificationsWithuseId:targetID WithsendMessage:@"退出聊天" WithType:@"0003" WithSenderID:userID WithMessionID:missionID WithLanguage:@"language" success:^(id responseObject) {
                
           } failure:^(NSError *error) {
                
            }];
            
            
            
            [WebAgent changeTranslatorBusy:userID state:@"0" success:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
            
            [WebAgent getMoneyDouDealWithMissionID:missionID  success:^(id responseObject) {
                        
            } failure:^(NSError *error) {
                        
            }];

   
            
        }

    
    }];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [SMSSDK registerApp:@"14797912782c8" withSecret:@"398b1d6e9521d5d868bae9812d60fff3"];
    ///远程推送！！！千万不能动⬇️
    //    [JPUSHService resetBadge];
    //    [JPUSHService setBadge:0];quitChat
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatMessage:) name:@"chatMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitChat) name:@"quitChat" object:nil];

    isChat = NO;
    NSString *advertisingId = nil;
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"4309446657f3a7b64ef168ee"
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerAliasAndTag) name:kJPFNetworkDidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textForView) name:@"textForView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAlart:) name:@"beginToAlert" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTargetID) name:@"getTargetID" object:nil];
    
    ///远程推送⬆️！！！！！！
    //    FreeTransViewController  *freeVC = [[FreeTransViewController alloc]initWithUserID:@"001" WithTargetID:@"001" WithUserIdentifier:@"TRANSTOR" WithVoiceLanguage:Voice_YingYu WithTransLanguage:Trans_YingYu];
    
    //
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    YBZRootViewController *rootVC = [[YBZRootViewController alloc]init];
    self.window.rootViewController = rootVC;
    
    
    //讯飞!!!!!!!!!!!!!!(勿动！)
    NSString *appid = @"56e695e6";
    NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
    [IFlySpeechUtility createUtility:initString];
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"ChatHisTory"] == nil) {
        
        NSUserDefaults *userDfault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *mutableARR = [NSMutableArray array];
        [userDfault setObject:mutableARR forKey:@"ChatHisTory"];
        [userDfault synchronize];
        
    }
    
    
    
    
    if (launchOptions != nil) {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil) {
            // 这个字典就是推送消息的userInfo
            
            self.userDic=dictionary;
            
            
            
        }
    }
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1146161023178105#travelhelper"];
    options.apnsCertName = @"push";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    self.myWindow = [[YBZMyWindow alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    [self.myWindow makeKeyAndVisible];
    
    
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    
    return YES;
}


//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:AppStore];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if([dic[@"status"]intValue]==21007){
    
        
        NSURL *url=[NSURL URLWithString:SANDBOX];
        NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
        requestM.HTTPBody=bodyData;
        requestM.HTTPMethod=@"POST";
        //创建连接并发送同步请求
        NSError *error=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
        if (error) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if([dic[@"status"] intValue]==0){
            NSLog(@"购买成功！");
            NSDictionary *dicReceipt= dic[@"receipt"];
            NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
            NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识            
            int money = [productIdentifier intValue];
            if (money == 1 ) {
                NSDictionary *dicReceipt= dic[@"receipt"];
                NSDictionary *dicInApp=[dicReceipt[@"in_app"] lastObject];
                NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
                money = [productIdentifier intValue];

            }
            NSDictionary *dictionary = @{@"money":[NSString stringWithFormat:@"%d" ,money]};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addBiNotification" object:dictionary];
            
            //        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            //        if ([productIdentifier isEqualToString:@"001"]) {
            //            int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
            //            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
            //        }else{
            //            [defaults setBool:YES forKey:productIdentifier];
            //        }
            //在此处对购买记录进行存储，可以存储到开发商的服务器端
        }else{
            [MBProgressHUD showError:@"购买失败，未通过验证！"];
            NSLog(@"购买失败，未通过验证！");
        }

    
    }else if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_ID = [userdefault objectForKey:@"user_id"];
        NSString *user_id = user_ID[@"user_id"];
        int money = [productIdentifier intValue];
        [WebAgent getBiWithID:user_id andPurchaseCount:[NSString stringWithFormat:@"%d",money] andSource_id:@"0006" success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        if ([productIdentifier isEqualToString:@"001"]) {
//            int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
//            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
//        }else{
//            [defaults setBool:YES forKey:productIdentifier];
//        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        [MBProgressHUD showError:@"购买失败，未通过验证！"];
        NSLog(@"购买失败，未通过验证！");
    }
}
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    
    for(SKPaymentTransaction *tran in transaction){
        
        
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"交易完成");
                [self verifyPurchaseWithPaymentTransaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                
                
                
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [SVProgressHUD showErrorWithStatus:@"购买失败"];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark -  远程推送！！


-(void)registerAliasAndTag{
    
    //可变
    //    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    //    NSString *userID = [userdefault objectForKey:@"user_id"];
    //    if (userID != nil && ![userID isEqualToString:@""]) {
    //        [JPUSHService setTags:nil alias:userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    //            NSLog(@"isrescode----%d, itags------%@,ialias--------%@",iResCode,iTags,iAlias);
    //        }];
    //    }
    
    
    
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userID = [userdefault objectForKey:@"user_id"];
    if(userID == NULL){}
    else
    {
        [WebAgent userLoginState:userID[@"user_id"] success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *str= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.isLogin = str[@"state"];
            NSLog(@"%@",self.isLogin);
            if ([self.isLogin  isEqual: @"1"])
            {
                NSString * strid = [userID[@"user_id"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                [JPUSHService setTags:nil alias:strid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
                 {
                     
                     NSLog(@"isrescode----%d, itags------%@,ialias--------%@",iResCode,iTags,iAlias);
                 }];
                
                
            }
            
        }
                         failure:^(NSError *error) {
                             NSLog(@"this is 2222222 failure%@",error);
                         }];
    }
    
}




- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     NSLog(@"My token is: %@", deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    //    application.applicationIconBadgeNumber = (NSInteger)0;
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    
    
    // IOS 7 Support Required
    //    application.applicationIconBadgeNumber = (NSInteger)0;
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSString *yonghuID = [userInfo valueForKey:@"sender_id"];
    NSLog(@"--------------9 8--");
    NSLog(@"%@",userInfo);
    NSLog(@"----------heiheihei------");
    NSString *language_catgory = [userInfo valueForKey:@"language_catgory"];
    if ([language_catgory isEqualToString:@""]||language_catgory == nil) {
        language_catgory = @"";
    }
    NSString *pay_number = @"0";
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    
    NSString *messionID = [userInfo valueForKey:@"messionID"];
    NSString *type = [userInfo valueForKey:@"type"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:messionID forKey:@"messageId"];
    
    
    if ([type isEqualToString:@"0002"]) {
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
        
        //        [WebAgent UpdateUserListWithID:mseeage_id andAnswerId:yonghuID success:^(id responseObject) {
        //            NSLog(@"SUCCESS");
        //
        //        } failure:^(NSError *error) {
        //
        //        }];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"beginChatWithTranslator" object:@{@"translatorID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];
        
        
        
    }else if ([type isEqualToString:@"0004"]){
//        needPush = YES;
        
        UIViewController *nowVC=[self currentViewController];
        if (![nowVC isKindOfClass:[YBZWaitingViewController class]]) {
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"已有用户与您匹配成功，请立刻开始即时翻译！" confirmTitle:@"现在就去" confirmHandler:^(UIAlertAction *action) {
                NSDictionary *dict = [self getLanguage:language_catgory];
                NSUserDefaults *user_Info = [NSUserDefaults standardUserDefaults];
                NSDictionary *user_id = [user_Info dictionaryForKey:@"user_id"];
                NSString *mission_id = [user_Info objectForKey:@"messageId"];
                
                
                
                [WebAgent selectCancelState:mission_id success:^(id responseObject) {
                    NSData *data = [[NSData alloc] initWithData:responseObject];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([dic[@"data"] isEqualToString:@"1"]) {
                        [UIAlertController showAlertAtViewController:nowVC title:@"抱歉" message:@"您来晚了，用户已取消翻译" confirmTitle:@"我知道了"confirmHandler:^(UIAlertAction *action) {
                            
                        }];
                    }else{
                        [WebAgent changeTranslatorBusy:user_id[@"user_id"] state:@"1" success:^(id responseObject) {
                            [MBProgressHUD showError:mission_id toView:nowVC.view];
                            [WebAgent updateTranslatorAnswerID:user_id[@"user_id"] MissionID:mission_id success:^(id responseObject) {
                                   QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:user_id[@"user_id"] WithTargetID:yonghuID WithUserIdentifier:@"TRANSTOR" WithVoiceLanguage:dict[@"voice"] WithTransLanguage:dict[@"trans"]];
                                [nowVC.navigationController pushViewController:quickVC animated:YES];

                            } failure:^(NSError *error) {
                                
                            }];

                        } failure:^(NSError *error) {
                            
                        }];
                    }

                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"进入聊天页面失败" toView:nowVC.view];
                }];
            }];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIntoTransView" object:@{@"yonghuID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];

        }
        


        

//        NSDictionary *dict = @{@"language_catigory":language_catgory ,@"yonghuID":yonghuID};
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rootVCLoadDone:) name:@"rootVCLoadDone" object:dict];
        
    }else if ([type isEqualToString:@"0003"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"backToRoot" object:@{@"yonghuID":yonghuID}];
    }else if ([type isEqualToString:@"0005"]){
        UIViewController *nowVC=[self currentViewController];
        if ([nowVC isKindOfClass:[YBZTranslationController class]]) {
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"您的悬赏被回答啦~快去采纳满意的答案吧" cancelTitle:@"确定" confirmTitle:@"我的悬赏" cancelHandler:^(UIAlertAction *action) {
                
            } confirmHandler:^(UIAlertAction *action) {
                YBZMyRewardViewController *vc = [[YBZMyRewardViewController alloc ]init];
                [nowVC.navigationController pushViewController:vc animated:YES];
            }];
        }else{
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"您的悬赏被回答啦~请尽快采纳满意的答案" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
            }];
        }

    }else if ([type isEqualToString:@"0006"]){
        UIViewController *nowVC=[self currentViewController];
        

        if ([nowVC isKindOfClass:[YBZTranslationController class]]) {
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"您有一条悬赏回答被采纳，请到钱包查看您的嗨币是否到账！" cancelTitle:@"确定" confirmTitle:@"钱包" cancelHandler:^(UIAlertAction *action) {
                
            } confirmHandler:^(UIAlertAction *action) {
                YBZMyMoneyViewController *myMoneyVC = [[YBZMyMoneyViewController alloc]init];
                [nowVC.navigationController pushViewController:myMoneyVC animated:YES];
            }];
        }else{
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"您有一条悬赏回答被采纳，请稍后到钱包查看您的嗨币是否到账！" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
            }];
        }
    }else if ([type isEqualToString:@"9009"]){
        UIViewController *nowVC=[self currentViewController];
        
        
        if ([nowVC isKindOfClass:[YBZPrepareViewController class]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"finishCustomTranslate" object:nil];
            
        }else{
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"对方已完成定制，请查看嗨币是否到账" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
            }];
        }
    }else if([type isEqualToString:@"9002"]){
        UIViewController *nowVC=[self currentViewController];
        if([nowVC isKindOfClass:[YBZPrepareViewController class]]){
        
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];

            [WebAgent getNameWithID:yonghuID success:^(id responseObject) {
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *name = dict[@"name"];
                YBZTargetWaitingViewController *targetViewController=[[YBZTargetWaitingViewController alloc]initWithUserId:user_id[@"user_id"] targetId:yonghuID andType:language_catgory andIsCall:NO andName:name];
                targetViewController.messionId = messionID;
                [nowVC.navigationController presentViewController:targetViewController animated:YES completion:^{
                    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *dic = [userinfo dictionaryForKey:messionID];
                    if (dic == nil) {
                        NSMutableArray *array = [NSMutableArray array];
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                        [dictionary setObject:array forKey:@"call_info"];
                        [userinfo setObject:dictionary forKey:messionID];
                        NSString *time = [self getNowTime];
                        NSDictionary *dict =@{@"sender":name,@"eventType":@"发起",@"time":time};
                        NSMutableDictionary *dictionaryDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        NSArray *arrayArr = [dictionary objectForKey:@"call_info"];
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:arrayArr];
                        [arr addObject:dict];
                        [dictionary setObject:arr forKey:@"call_info"];
                        [userinfo setObject:dictionaryDic forKey:messionID];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTableViewData" object:nil];
                    }else{
                    
                        NSString *time = [self getNowTime];
                        NSDictionary *dict =@{@"sender":name,@"eventType":@"发起",@"time":time};
                        //    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                        NSDictionary *dic = [userinfo objectForKey:messionID];
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
                        NSArray *array = [dictionary objectForKey:@"call_info"];
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
                        [arr addObject:dict];
                        [dictionary setObject:arr forKey:@"call_info"];
                        [userinfo setObject:dictionary forKey:messionID];
                    }
                }];
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"获取信息失败"];
                YBZTargetWaitingViewController *targetViewController=[[YBZTargetWaitingViewController alloc]initWithUserId:user_id[@"user_id"] targetId:yonghuID andType:language_catgory andIsCall:NO andName:@"未知"];
                targetViewController.messionId = messionID;

                [nowVC.navigationController presentViewController:targetViewController animated:YES completion:^{
                    
                }];
            }];
            
        }else{
        
            
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
            
            [WebAgent getNameWithID:yonghuID success:^(id responseObject) {
                NSData *data = [[NSData alloc]initWithData:responseObject];
                NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *name = dict[@"name"];
                
                NSString *needName=[NSString stringWithFormat:@"收到来自%@的定制开始请求",name];
                [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:needName cancelTitle:@"稍等" confirmTitle:@"进入" cancelHandler:^(UIAlertAction *action) {
                    
                    
                    
                    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
                    
                    //    NSString *time=[self getNowTime];
                    //    NSDictionary *dict =@{@"sender":@"USER",@"eventType":@"发起",@"time":time};
                    
                    NSString *time = [self getNowTime];
                    NSDictionary *dict =@{@"sender":@"USER",@"eventType":@"结束",@"time":time};
                    //    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                    NSDictionary *dic = [userinfo objectForKey:messionID];
                    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
                    NSArray *array = [dictionary objectForKey:@"call_info"];
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
                    [arr addObject:dict];
                    [dictionary setObject:arr forKey:@"call_info"];
                    [userinfo setObject:dictionary forKey:messionID];
                    
                    

                    
                    //发个推送？
                    [WebAgent sendRemoteNotificationsWithuseId:yonghuID WithsendMessage:@"对方正忙" WithType:@"9003" WithSenderID:user_id[@"user_id"] WithMessionID:messionID WithLanguage:language_catgory success:^(id responseObject) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTableViewData" object:nil];
                    } failure:^(NSError *error) {
                        
                    }];
                    

                    
                } confirmHandler:^(UIAlertAction *action) {
                    
                    YBZTargetWaitingViewController *targetViewController=[[YBZTargetWaitingViewController alloc]initWithUserId:user_id[@"user_id"] targetId:yonghuID andType:language_catgory andIsCall:NO andName:name];
                    targetViewController.messionId = messionID;

                    [nowVC.navigationController presentViewController:targetViewController animated:YES completion:^{
                        
                    }];
                    
                }];

                
                
               
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"获取信息失败"];
                YBZTargetWaitingViewController *targetViewController=[[YBZTargetWaitingViewController alloc]initWithUserId:user_id[@"user_id"] targetId:yonghuID andType:language_catgory andIsCall:NO andName:@"未知"];
                targetViewController.messionId = messionID;

                [nowVC.navigationController presentViewController:targetViewController animated:YES completion:^{
                    
                }];
            }];
            
            
            
        }
        
        
        
    
    }else if([type isEqualToString:@"9003"]){
        
        
        
        
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        NSString *time = [self getNowTime];
        
        
        
        [WebAgent getNameWithID:yonghuID success:^(id responseObject) {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            NSDictionary *dict2= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *name = dict2[@"name"];
           
            
            NSDictionary *dict =@{@"sender":name,@"eventType":@"结束",@"time":time};
            //    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userinfo objectForKey:messionID];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSArray *array = [dictionary objectForKey:@"call_info"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
            [arr addObject:dict];
            [dictionary setObject:arr forKey:@"call_info"];
            [userinfo setObject:dictionary forKey:messionID];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTableViewData" object:nil];

            
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"获取信息失败"];
            
            NSDictionary *dict =@{@"sender":@"未知",@"eventType":@"结束",@"time":time};
            //    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userinfo objectForKey:messionID];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSArray *array = [dictionary objectForKey:@"call_info"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
            [arr addObject:dict];
            [dictionary setObject:arr forKey:@"call_info"];
            [userinfo setObject:dictionary forKey:messionID];

            
            
        }];

        

        

        
        
        
        UIViewController *nowVC=[self getPresentedViewController];
        if([nowVC isKindOfClass:[YBZTargetWaitingViewController class]]){
        
            [MBProgressHUD showNormalMessage:@"对方正忙，请稍后"];
            [nowVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        
        }else{
        
            [MBProgressHUD showNormalMessage:@"对方正忙，请稍后"];
            
        }
        
        
        
    }else if([type isEqualToString:@"9001"]){
        UIViewController *nowVC=[self currentViewController];
        NSString *nowTime = [self getNowTime];
        NSUserDefaults *userDfault = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [userDfault objectForKey:messionID];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dict2 setValue:nowTime forKey:@"second_time"];
//        dict[@"second_time"] = nowTime;
        [userDfault setObject:dict2 forKey:messionID];
        if ([nowVC isKindOfClass:[YBZPrepareViewController class]]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changViewWithState" object:nil];
        }else{
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"对方已进入准备页面，请立刻开始您的定制" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
            }];
        }
        
    }else if([type isEqualToString:@"9000"]){
        UIViewController *presentVC = [self getPresentedViewController];
        if (![presentVC isKindOfClass:[UIAlertController class]]) {
            UIViewController *nowVC=[self currentViewController];
            
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"对方已进入准备页面，请立刻开始您的定制" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
            }];
        }

    }else if( [type isEqualToString:@"0001"]){
        UIViewController *nowVC=[self currentViewController];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        YBZtoAlertModel *model=[[YBZtoAlertModel alloc]init];
        model.translatorID=user_id[@"user_id"];
        model.yonghuID=yonghuID;
        model.language_catgory=language_catgory;
        model.messionID=messionID;
        model.pay_number=pay_number;
        
        if(!self.toalertView){
            
            self.toalertView=[[YBZtoalertView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, SCREEN_HEIGHT*0.2, SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.6) andModel:model];
            //    alertView.backgroundColor=[UIColor redColor];
            [nowVC.view addSubview:self.hubView];
            [nowVC.view addSubview:self.toalertView];
        

            
        }else {
            
            [self.toalertView addModel:model];
        }
        
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}





#pragma mark - 系统Appdelegate
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //退出应用
//    quitTimer=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(postQuitMessage:) userInfo:nil repeats:YES];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [quitTimer fire];
    
    
}

-(void)postQuitMessage:(NSTimer *)timer{

    if (isChat == YES) {
        [WebAgent sendRemoteNotificationsWithuseId:targetID WithsendMessage:@"退出聊天" WithType:@"0003" WithSenderID:userID WithMessionID:missionID WithLanguage:@"language" success:^(id responseObject) {

        } failure:^(NSError *error) {
            
        }];
    }

}

-(void)chatMessage{

    
}


-(void)hideView{
    
    
    
    
}

-(void)textForView{
    
    UIViewController *nowVC=[self currentViewController];
    NSLog(@"%@",nowVC);
    [self.toalertView removeFromSuperview];
    [self.hubView removeFromSuperview];
    self.toalertView=nil;
    
}

-(UIViewController *)currentViewController
{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    
    return currVC;
}


- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
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


-(void)getAlart:(NSNotification *)notification{
    
    //    UIColor *receiveColor=(UIColor *)[notification object];
    NSDictionary *dic=(NSDictionary *)[notification object];
    
    
    NSString *yonghuID = [dic valueForKey:@"sender_id"];
    NSLog(@"--------------9 8--");
    NSLog(@"%@",dic);
    NSLog(@"----------heiheihei------");
    NSString *language_catgory = [dic valueForKey:@"language_catgory"];
    NSString *pay_number = [dic valueForKey:@"pay_number"];
    
    NSDictionary *aps = [dic valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSString *type = [dic valueForKey:@"type"];
    NSString *messionID = [dic valueForKey:@"messionID"];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:messionID forKey:@"messageId"];
    
    NSString *str = [content substringWithRange:NSMakeRange(content.length-8, 8)];
    
    //    if ([content isEqualToString:@"匹配成功"]) {
    //
    //        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    ////        NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
    //
    //        //        [WebAgent UpdateUserListWithID:mseeage_id andAnswerId:yonghuID success:^(id responseObject) {
    //        //            NSLog(@"SUCCESS");
    //        //
    //        //        } failure:^(NSError *error) {
    //        //
    //        //        }];
    //
    //
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"beginChatWithTranslator" object:@{@"translatorID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];
    //
    //
    //
    //    }else if ([content isEqualToString:@"进入聊天"]){
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIntoTransView" object:@{@"yonghuID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];
    //
    //
    //
    //    }else if ([content isEqualToString:@"退出聊天"]){
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"backToRoot" object:@{@"yonghuID":yonghuID}];
    //    }else
    //
    
    if( [type isEqualToString:@"0001"]){
        UIViewController *nowVC=[self currentViewController];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        YBZtoAlertModel *model=[[YBZtoAlertModel alloc]init];
        model.translatorID=user_id[@"user_id"];
        model.yonghuID=yonghuID;
        model.language_catgory=language_catgory;
        model.messionID=messionID;
        model.pay_number=pay_number;
        
        if(!self.toalertView){
            
            self.toalertView=[[YBZtoalertView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.15, SCREEN_HEIGHT*0.2, SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.6) andModel:model];
            //    alertView.backgroundColor=[UIColor redColor];
            [nowVC.view addSubview:self.hubView];
            [nowVC.view addSubview:self.toalertView];
        }else{
            
            [self.toalertView addModel:model];
        }
        
        
        
    }
    
    
    self.userDic=nil;
    
    
}

-(void)quitChat{

    isChat = NO;
}


-(void)chatMessage:(NSNotification *)notification{
  
    isChat = YES;
    NSDictionary *dict = notification.object;
    userID = dict[@"userID"];
    targetID = dict[@"targetID"];
    missionID = dict[@"missionID"];
    userIdentifier = dict[@"userIdentifier"];
}






- (UIWindow *)thisAlertWindow
{
    if (!_thisAlertWindow) {
        _thisAlertWindow = [[UIWindow alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
        [_thisAlertWindow setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        /*
         UIWindowLevel 有如下三种:
         UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal;
         UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert;
         UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar;
         */
        //
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.backgroundColor=[UIColor redColor];
        _thisAlertWindow.rootViewController = controller;
        [_thisAlertWindow setWindowLevel:UIWindowLevelNormal];//
//        [_thisAlertWindow addSubview:self];
    }
    return _thisAlertWindow;
}

-(NSDictionary *)getLanguage:(NSString *)language{
    
    NSString *VoiceLanguage;
    NSString *TransLanguage;
    if ([language isEqualToString:@"language"]) {
        VoiceLanguage = Voice_YingYu;
        TransLanguage = Trans_YingYu;
    }
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
    if (VoiceLanguage == nil || TransLanguage == nil) {
        VoiceLanguage = @"language";
        TransLanguage = @"language";
    }
    NSDictionary *dic =@{@"voice":VoiceLanguage,@"trans":TransLanguage};
    return dic;
}


-(void)rootVCLoadDone:(NSNotification *)object{
    NSDictionary *dictionary = object.object;
    NSString *language_catgory = dictionary[@"language_catgory"];
    NSString *yonghuID = dictionary[@"yonghuID"];
    NSDictionary *dict =  [self getLanguage:language_catgory];
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:user_id[@"user_id"] WithTargetID:yonghuID WithUserIdentifier:@"TRANSTOR" WithVoiceLanguage:dict[@"voice"] WithTransLanguage:dict[@"trans"]];
    UIViewController *nowVC=[self currentViewController];
    if ([nowVC isKindOfClass:[YBZRootViewController class]]) {
        [nowVC.navigationController pushViewController:quickVC animated:YES];
    }else{
        YBZTranslationController *rootVC = [[YBZTranslationController alloc]init];
        self.window.rootViewController = rootVC;
        nowVC=[self currentViewController];
        [nowVC.navigationController pushViewController:nowVC animated:YES];
    }

}

-(NSString *)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}


@end
