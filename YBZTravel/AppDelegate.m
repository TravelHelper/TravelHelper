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
//#import <RongIMLib/RongIMLib.h>
#import <SMS_SDK/SMSSDK.h>
#import "YBZMyRewardViewController.h"
#import "FreeTransViewController.h"
#import "JPUSHService.h"
#import "UIAlertController+SZYKit.h"
#import "WebAgent.h"
#import "YBZtoalertView.h"
#import "EMSDKFull.h"

#define Trans_YingYu    @"en"
#define Voice_YingYu    @"en-GB"

@interface AppDelegate ()

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
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIntoTransView" object:@{@"yonghuID":yonghuID,@"language_catgory":language_catgory,@"pay_number":pay_number}];
        
        
        
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
                
            }];
        }else{
            [UIAlertController showAlertAtViewController:nowVC title:@"提示" message:@"您有一条悬赏回答被采纳，请稍后到钱包查看您的嗨币是否到账！" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
                
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
//    quitTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(postQuitMessage:) userInfo:nil repeats:YES];
    [quitTimer fire];
    
    
}

-(void)postQuitMessage:(NSTimer *)timer{

    if (isChat == YES) {
        [WebAgent sendRemoteNotificationsWithuseId:targetID WithsendMessage:@"退出聊天" WithType:@"0003" WithSenderID:userID WithMessionID:missionID WithLanguage:@"language" success:^(id responseObject) {
            [WebAgent userLogout:userID success:^(id responseObject) {
                isChat = NO;
            } failure:^(NSError *error) {
                
            }];

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

}







@end
