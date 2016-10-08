//
//  AppDelegate.m
//  YBZTravel
//
//  Created by tjufe on 16/7/7.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "AppDelegate.h"
#import "YBZRootViewController.h"
#import "MBProgressHUD+XMG.h"
#import "iflyMSC/IFlyMSC.h"
#import "QuickTransViewController.h"
//#import <RongIMLib/RongIMLib.h>
#import <SMS_SDK/SMSSDK.h>
#import "FreeTransViewController.h"
#import "JPUSHService.h"
#import "WebAgent.h"
#import "YBZtoalertView.h"

#define Trans_YingYu    @"en"
#define Voice_YingYu    @"en-GB"

@interface AppDelegate ()

@property(nonatomic,assign) NSString* isLogin;
@property(nonatomic,strong) UIAlertController *alertVC;
//@property(nonatomic,strong) UITableView *
@property (nonatomic,strong) UIView             *hubView;
@property (nonatomic, strong)YBZtoalertView  *toalertView;

@end

@implementation AppDelegate


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];//消息推送
    NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *content = [[pushNotificationKey objectForKey:@"aps"]objectForKey:@"alert"];
    
//    UIViewController *nowVC=[self currentViewController];
   
//    [MBProgressHUD showMessage:@"000" toView: self.window.rootViewController.view];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        
        switch (permissionStatus) {
            case AVAudioSessionRecordPermissionUndetermined:{
                NSLog(@"第一次调用，是否允许麦克风弹框");
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    // CALL YOUR METHOD HERE - as this assumes being called only once from user interacting with permission alert!
                    if (granted) {
                        // Microphone enabled code
                    }
                    else {
                        // Microphone disabled code
                    }
                }];
                break;
            }
            case AVAudioSessionRecordPermissionDenied:
                // direct to settings...
                NSLog(@"已经拒绝麦克风弹框");
                
                break;
            case AVAudioSessionRecordPermissionGranted:
                NSLog(@"已经允许麦克风弹框");
                // mic access ok...
                break;
            default:
                // this should not happen.. maybe throw an exception.
                break;
        }
        if(permissionStatus == AVAudioSessionRecordPermissionUndetermined) ;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [SMSSDK registerApp:@"14797912782c8" withSecret:@"398b1d6e9521d5d868bae9812d60fff3"];
///远程推送！！！千万不能动⬇️
//    [JPUSHService resetBadge];
//    [JPUSHService setBadge:0];
    
    
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
                 apsForProduction:false
            advertisingIdentifier:advertisingId];
    
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerAliasAndTag) name:kJPFNetworkDidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textForView) name:@"textForView" object:nil];
    
    
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
    
    
    return YES;
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
    NSString *pay_number = [userInfo valueForKey:@"pay_number"];
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    
    NSString *messionID = [userInfo valueForKey:@"ID"];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:messionID forKey:@"messageId"];
    
    NSString *str = [content substringWithRange:NSMakeRange(content.length-8, 8)];
    
    if ([content isEqualToString:@"匹配成功"]) {

        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
        NSDictionary *user_id = [userdefault objectForKey:@"user_id"];
        NSString *userID = user_id[@"user_id"];
//        [WebAgent UpdateUserListWithID:mseeage_id andAnswerId:yonghuID success:^(id responseObject) {
//            NSLog(@"SUCCESS");
//            
//        } failure:^(NSError *error) {
//            
//        }];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"beginChatWithTranslator" object:@{@"translatorID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];
//        UIViewController *nowVC=[self currentViewController];
//
//        NSDictionary *dic = [self getLanguageWithString:language_catgory];
//        [WebAgent removeFromWaitingQueue:userID success:^(id responseObject) {
//            [WebAgent changeTranslatorBusy:userID state:@"1" success:^(id responseObject) {
//                QuickTransViewController *quickVC = [[QuickTransViewController alloc]initWithUserID:userID WithTargetID:yonghuID WithUserIdentifier:@"TRANSTOR" WithVoiceLanguage:dic[@"voice"] WithTransLanguage:dic[@"trans"]];
//                [nowVC.navigationController pushViewController:quickVC animated:YES];
//            } failure:^(NSError *error) {
//                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                }];
//                [alertVC addAction:okAction];
//                [nowVC presentViewController:alertVC animated:YES completion:nil];        }];
//            
//        } failure:^(NSError *error) {
//            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查您的网络" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            }];
//            [alertVC addAction:okAction];
//            [nowVC presentViewController:alertVC animated:YES completion:nil];
//        }];
//
        
        
    }else if ([content isEqualToString:@"进入聊天"]){
           [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIntoTransView" object:@{@"yonghuID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];
        
        
        
    }else if ([content isEqualToString:@"退出聊天"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"backToRoot" object:@{@"yonghuID":yonghuID}];
    }else if( [str isEqualToString:@"口语即时翻译请求"]){
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
            NSLog(@"-----------------------liuruidong------------------------");
        }else{
            
            [self.toalertView addModel:model];
        }
        
//        if(self.alertVC){
//        
//            self.alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"接收到新的翻译任务！" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"recieveARemoteRequire" object:@{@"yonghuID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number,@"messionID":messionID}];
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"算了吧" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                self.alertVC=nil;
//            }];
//            [self.alertVC addAction:okAction];
//            [self.alertVC addAction:cancelAction];
//        
//            [self.window.rootViewController presentViewController:self.alertVC animated:YES completion:nil];
//            
//        }
        
        
        
        
      
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter]postNotificationName:@"quitApp" object:nil];
    
    
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
