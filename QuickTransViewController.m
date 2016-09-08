//
//  QuickTransViewController.m
//  CharttingController
//
//  Created by tjufe on 16/7/21.
//  Copyright © 2016年 tjufe. All rights reserved.
//  if([self.userIdentifier isEqualToString:@"TRANSTOR"])

#import "QuickTransViewController.h"
#import "BaseTableView.h"
#import "BaseAudioButton.h"
#import "ChatFrameInfo.h"
#import "ChatModel.h"
#import "ChatTableViewCell.h"
#import "CWViewController.h"
#import "RecordMethod.h"
#import "iflyMSC/IFlyMSC.h"
#import "StringTransViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "AFHTTPSessionManager.h"
#import "NSString+HBWmd5.h"
#import "WebAgent.h"
#import "FeedBackViewController.h"
#import "MJRefresh.h"
#import "YBZbtnView.h"
#import "MBProgressHUD+XMG.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#define LANGUAGE_ENGLISH  @"ENGLISH"
#define LANGUAGE_CHINESE  @"CHINESE"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHight  [UIScreen mainScreen].bounds.size.height
#define krequL   [UIScreen mainScreen].bounds.size.width*0.44

@interface QuickTransViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate,BaseTableViewDelegate,BaseAudioButtonDelegate,UITableViewDataSource,UITableViewDelegate,IFlySpeechRecognizerDelegate,RCIMClientReceiveMessageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong) NSString *selectedCellMessageID;

@property(nonatomic,strong) BaseTableView *bottomTableView;
@property(nonatomic,strong) UIView      *inputBottomView;
@property(nonatomic,strong) UIButton    *changeSendContentBtn;
@property(nonatomic,strong) UIButton    *selectLangueageBtn;
@property(nonatomic,strong) BaseAudioButton    *reportAudioBtn;
@property(nonatomic,strong) BaseAudioButton    *reportEnglishBtn;

@property(nonatomic,strong) UIButton    *sendMessageBtn;
@property(nonatomic,strong) UITextView *inputTextView;
@property(nonatomic,strong) NSString * senderID;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) NSMutableArray *dataSource;
//@property(nonatomic,strong) UIRefreshControl *refreshController;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *subBottomView;
@property(nonatomic,strong) UILabel *shortLabel;

@property(nonatomic,strong) UIImageView *sayView;
@property(nonatomic,strong) UIImageView *cancelSayView;
@property(nonatomic,assign) BOOL isCancelSendRecord;
@property(nonatomic,assign) BOOL isRecognizer;
@property(nonatomic,assign) BOOL isZero;
@property(nonatomic,assign) BOOL isKeyboardShow;


///////asdasdasdasd

@property(nonatomic,strong) CWViewController *cwViewController;
//@property(nonatomic,strong) RecordMethod *recordMethod;
@property(nonatomic,strong) NSString *cellMessageID;
@property(nonatomic,strong) NSString *currentCellID;

@property (nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic,strong) StringTransViewController *stringTransVC;


@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *target_id;
@property (nonatomic,strong) NSString *token;


@property (nonatomic,strong) NSString *userIdentifier;
@property (nonatomic,strong) NSString *voice_Language;
@property (nonatomic,strong) NSString *trans_Language;
@property (nonatomic,strong) UIImageView *backgroundImageView;

@property (nonatomic,strong) YBZbtnView *btnview;
@property (nonatomic,assign) BOOL isequal;
@end

@implementation QuickTransViewController{
    NSInteger  ascCount;
    NSString   *iFlySpeechRecognizerString;
    CGFloat    KeyboardWillShowHeight;
    NSTimeInterval *KeyboardWillShowInterval;
    NSString *userIDinfo;
    
    int userCount;
    int translatorCount;
    NSTimer *timer;
    int   countDownNumber;
    
}

- (instancetype)initWithUserID:(NSString *)userID WithTargetID:(NSString *)targetID WithUserIdentifier:(NSString *)userIdentifier WithVoiceLanguage:(NSString *)voice_Language WithTransLanguage:(NSString *)trans_Language
{
    self = [super init];
    if (self) {
        self.user_id = userID;
        self.target_id = targetID;
        [self getTokenWithUserID:self.user_id];        //获取token并且登录融云服务器
        
        self.userIdentifier = userIdentifier;
        
        self.voice_Language = voice_Language;
        self.trans_Language = trans_Language;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.voice_Language forKey:@"VOICE_LANGUAGE"];
        [userDefaults setObject:self.trans_Language forKey:@"TRANS_LANGUAGE"];
        NSDictionary *user = [userDefaults dictionaryForKey:@"user_id"];
        userIDinfo = user[@"user_id"];
        //欠缺单利处理 （头像获取）
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"即时翻译"];
    [self.view addSubview:self.backgroundImageView];
    
    [self setupRefresh];
    
    self.isCancelSendRecord = NO;
    self.isRecognizer = NO;
    self.isZero = NO;
    self.isKeyboardShow = NO;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    _stringTransVC = [[StringTransViewController alloc]init];
    [_stringTransVC viewDidLoad];
    
    [self pullHistoryCount];
    self.senderID = self.user_id;
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChatHisTory"];
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    self.dataSource = [[NSMutableArray alloc]init];
    
    self.cwViewController = [[CWViewController alloc]init];
    [self.view addSubview:self.bottomTableView];
    [self.view addSubview:self.inputBottomView];
    [self.inputBottomView addSubview:self.changeSendContentBtn];
    [self.inputBottomView addSubview:self.selectLangueageBtn];
    [self.inputBottomView addSubview:self.inputTextView];
    [self.bottomTableView setContentOffset:CGPointMake(0, self.bottomTableView.bounds.size.height)];
    
    [self AddTapGestureRecognizer];
    [self reloadDataSourceWithNumber:ascCount];
    
    self.iFlySpeechRecognizer  = [[IFlySpeechRecognizer alloc]init];
    self.iFlySpeechRecognizer.delegate = self;
    
    //设置导航栏返回按钮的点击事件
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"结束聊天" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageAndPop)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToRoot) name:@"backToRoot" object:nil];
    
    //键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘收起
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(determinePlayARecord:) name:@"determinePlayARecord" object:nil];
    
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    
    if([self.userIdentifier isEqualToString:@"TRANSTOR"]){
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            // 在另一个线程中启动下载功能，加GCD控制
//            [WebAgent ]
        
        });

    }
    
    //    [self performSelector:@selector(sendAwebMessage) withObject:nil afterDelay:10];
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
    
    NSString *resultName=[NSString stringWithFormat:@"%@backgroundimg.jpg",user_id[@"user_id"]];
    
    NSString *url2=[NSString stringWithFormat:@"http://%@/TravelHelper/uploadimg/%@",serviseId,resultName];
    
    NSURL *url = [NSURL URLWithString:url2];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    if(img){
        [self.backgroundImageView setImage:img];
    }
    

    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userCount=0;
    translatorCount=0;
    self.tabBarController.tabBar.hidden=YES;
    self.backgroundImageView.frame = [UIScreen mainScreen].bounds;
    
}
#pragma mark - 融云->链接融云服务器 & 获取token

-(void)connectRongCloudServerWithToken:(NSString *)token{
    //融云
    [[RCIMClient sharedRCIMClient]initWithAppKey:@"kj7swf8o77j02"];
    [[RCIMClient sharedRCIMClient] connectWithToken:token
                                            success:^(NSString *userId) {
                                                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                            } error:^(RCConnectErrorCode status) {
                                                NSLog(@"登陆的错误码为:%ld", (long)status);
                                            } tokenIncorrect:^{
                                                //token过期或者不正确。
                                                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                [self getTokenWithUserID:self.user_id];//重新获取token;
                                                NSLog(@"token错误");
                                            }];
}

-(void)getTokenWithUserID:(NSString *)userID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlstr =@"https://api.cn.rong.io/user/getToken.json";
    NSDictionary *dic =@{@"userId":userID,
                         @"name":userID,
                         @"portraitUri":@""
                         };
    
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString * appkey = @"kj7swf8o77j02";
    NSString * Signature = [[NSString stringWithFormat:@"%@%@%@",appkey,nonce,timestamp] sha1];//sha1对签名进行加密
    //以下拼接请求内容
    [manager.requestSerializer setValue:appkey forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:Signature forHTTPHeaderField:@"Signature"];
    [manager.requestSerializer setValue:@"dsAcPXZxOq" forHTTPHeaderField:@"appSecret"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //开始请求
    [manager POST:urlstr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" %@", responseObject);
        
        NSLog(@"%@",responseObject[@"token"]);
        
        [self connectRongCloudServerWithToken:responseObject[@"token"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    //    [manager POST:urlstr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        //这里你就能得到token啦~
    //
    ////        NSData *data = [[NSData alloc] initWithData:responseObject];
    ////        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //
    //        NSLog(@" %@", responseObject);
    //
    //        NSLog(@"%@",responseObject[@"token"]);
    //
    //        [self connectRongCloudServerWithToken:responseObject[@"token"]];
    //
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
    
}

#pragma mark - 融云

//发送一条语音消息
-(void)sendAWebVoice:(NSString *)extra{
    
    NSDictionary *dict = [self getRCMessageDictionaryWithExtra:extra];
    
    
    NSURL *URL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:self.cellMessageID]];
    
    RCVoiceMessage *voiceMessage = [RCVoiceMessage messageWithAudio:[NSData dataWithContentsOfURL:URL] duration:[dict[@"audioSecond"] intValue]];
    
    voiceMessage.extra = extra;
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.target_id content:voiceMessage pushContent:nil pushData:nil success:^(long messageId) {
        NSLog(@"发送成功。当前消息ID：%ld", messageId);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
    }];
    
}
//发送一条文本消息
-(void)sendAwebMessage:(NSString *)extra{
    // 构建消息的内容，这里以文本消息为例。
    RCTextMessage *testMessage = [RCTextMessage messageWithContent:@"Extra已经携带一切信息"];
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
    testMessage.extra = extra;
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.target_id
                                       content:testMessage
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                           
                                           
                                           if([self.userIdentifier isEqualToString:@"TRANSTOR"]){
                                               
                                               translatorCount++;
                                               
                                               NSString *strCount=[NSString stringWithFormat:@"%d",translatorCount];
                                               
                                               NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                               NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
                                               [WebAgent UpdateTranslatorMessageCount:mseeage_id andTranslator_price:strCount success:^(id responseObject) {
                                                   
                                               } failure:^(NSError *error) {
                                                   
                                               }];
                                               
                                               
                                           }else{
                                               
                                               userCount++;
                                               NSString *strCount=[NSString stringWithFormat:@"%d",userCount];
                                               
                                               NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                                               NSString *mseeage_id = [userdefault objectForKey:@"messageId"];
                                               [WebAgent UpdateUserMessageCount:mseeage_id andUser_price:strCount success:^(id responseObject) {
                                                   
                                               } failure:^(NSError *error) {
                                                   
                                               }];
                                               
                                           }

                                           
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                                       }];
}

//接收文本以及语音消息
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    
    
    if ([self.target_id isEqualToString:message.senderUserId]) {
        
        
        
        
        if([self.userIdentifier isEqualToString:@"TRANSTOR"]){
            
            userCount++;
        
        }else{
        
            translatorCount++;
        
        }
        
        
        if ([message.content isMemberOfClass:[RCTextMessage class]]) {
            RCTextMessage *testMessage = (RCTextMessage *)message.content;
            
            NSLog(@"消息内容：%@,附带消息内容---%@asdasdas----%@", testMessage.content,testMessage.extra,message.senderUserId);
            
            NSDictionary *dict = [self getRCMessageDictionaryWithExtra:testMessage.extra];
            NSLog(@"消息信息》》》%@",dict);
            
            ///////
            
            [self addHistoryWithDict:dict];
            
            ///////////////////////////////////////////
            ///////////
            //////
            
            NSInteger count = self.dataArr.count;
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.dataArr insertObject:dict atIndex:count];
                ascCount = ascCount + 1;
                
                
                
                [self reloadDataSourceWithNumber:ascCount];
                [self.bottomTableView reloadData];
                
                [self.sendMessageBtn removeFromSuperview];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:ascCount-1 inSection:0];
                [self.bottomTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
                
                ///////////
                if (self.isKeyboardShow == YES) {
                    
                    NSInteger cccount = self.dataSource.count;
                    NSIndexPath *iindex = [NSIndexPath indexPathForRow:cccount - 1 inSection:0];
                    CGRect    rect = [self.bottomTableView rectForRowAtIndexPath:iindex];
                    CGFloat   cellMaxY = rect.origin.y + rect.size.height + 64;
                    ;
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        CGFloat moveY = 0.0;
                        CGFloat xiangjian;
                        xiangjian = cellMaxY - ([UIScreen mainScreen].bounds.size.height - KeyboardWillShowHeight - CGRectGetHeight(self.inputBottomView.frame));
                        
                        if (xiangjian <= 0) {
                            moveY = 0;
                        }
                        
                        if (xiangjian > 0 && xiangjian < KeyboardWillShowHeight) {
                            moveY = xiangjian;
                        }
                        
                        if (xiangjian >= KeyboardWillShowHeight ) {
                            moveY = KeyboardWillShowHeight;
                        }
                        self.inputBottomView.transform = CGAffineTransformMakeTranslation(0, -KeyboardWillShowHeight);
                        self.bottomTableView.transform = CGAffineTransformMakeTranslation(0, -moveY);
                    }];
                }
                //////
                /////////
                ////////////
                ////////////////////////////
                
            });
            
            
        }
        
        
        
        if ([message.content isMemberOfClass:[RCVoiceMessage class]]) {
            
            RCVoiceMessage *voiceMessage = (RCVoiceMessage *)message.content;
            
            NSLog(@"时长：%ld,附带消息内容---%@asdasdas----%@", voiceMessage.duration,voiceMessage.extra,voiceMessage.wavAudioData);
            
            //语音存在本地，并且加入展示数组⬇️
            NSDictionary *dic = [self getRCMessageDictionaryWithExtra:voiceMessage.extra];
            NSURL *uurl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:dic[@"messageID"]]];
            [voiceMessage.wavAudioData writeToURL:uurl atomically:NO];
            NSLog(@"sccczsc...%@df%@",dic,uurl);
            
            NSInteger count = self.dataArr.count;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.dataArr insertObject:dic atIndex:count];
                ascCount = ascCount + 1;
                
                
                
                [self reloadDataSourceWithNumber:ascCount];
                [self.bottomTableView reloadData];
                
                
                [self.sendMessageBtn removeFromSuperview];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:ascCount - 1 inSection:0];
                [self.bottomTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
                //语音存在本地，并且加入展示数组
                
                if (self.isKeyboardShow == YES) {
                    
                    NSInteger cccount = self.dataSource.count;
                    NSIndexPath *iindex = [NSIndexPath indexPathForRow:cccount - 1 inSection:0];
                    CGRect    rect = [self.bottomTableView rectForRowAtIndexPath:iindex];
                    CGFloat   cellMaxY = rect.origin.y + rect.size.height + 64;
                    ;
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        CGFloat moveY = 0.0;
                        CGFloat xiangjian;
                        xiangjian = cellMaxY - ([UIScreen mainScreen].bounds.size.height - KeyboardWillShowHeight - CGRectGetHeight(self.inputBottomView.frame));
                        
                        if (xiangjian <= 0) {
                            moveY = 0;
                        }
                        
                        if (xiangjian > 0 && xiangjian < KeyboardWillShowHeight) {
                            moveY = xiangjian;
                        }
                        
                        if (xiangjian >= KeyboardWillShowHeight ) {
                            moveY = KeyboardWillShowHeight;
                        }
                        self.inputBottomView.transform = CGAffineTransformMakeTranslation(0, -KeyboardWillShowHeight);
                        self.bottomTableView.transform = CGAffineTransformMakeTranslation(0, -moveY);
                    }];
                }
                
            });
            
        }
        
    }else{
        NSLog(@"对话的人已经改变了！");
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}

#pragma mark - 语音听写私有方法 & IFlySpeechRecognizerDelegate

-(void)iFlySpeechRecognizerStop{
    [self.iFlySpeechRecognizer stopListening];//做完现在的任务
    self.isRecognizer = NO;
    
}

-(void)iFlySpeechRecognizerCancel{
    
    [self.iFlySpeechRecognizer cancel];//一切
    self.isRecognizer = NO;
}

-(void)iFlySpeechRecognizerBegin:(NSString *)language{
    
    self.isRecognizer = YES;
    [self.iFlySpeechRecognizer setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    if ([language isEqualToString:LANGUAGE_ENGLISH]) {
        [self.iFlySpeechRecognizer setParameter: @"en_us" forKey:[IFlySpeechConstant LANGUAGE]];//英语
    }
    if ([language isEqualToString:LANGUAGE_CHINESE]) {
        [self.iFlySpeechRecognizer setParameter: @"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];//中文
    }
    
    
    //asr_audio_path保存录音文件名,默认目录是documents
    //    [self.iFlySpeechRecognizer setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [self.iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [self.iFlySpeechRecognizer startListening];
}

//IFlySpeechRecognizerDelegate

- (void) onError:(IFlySpeechError *) errorCode{
    
    if(self.isCancelSendRecord == YES){
        
    }else{
        
        
        //    if ([self.cwViewController.secondString intValue] < 1 ) {
        //
        //            self.shortLabel = [[UILabel alloc]initWithFrame:self.subBottomView.bounds];
        //            self.shortLabel.text = @"说话时间过短，小于1秒";
        //            self.shortLabel.font = FONT_10;
        //            self.shortLabel.textAlignment = NSTextAlignmentCenter;
        //            self.shortLabel.backgroundColor = [UIColor clearColor];
        //            [self.subBottomView addSubview:self.shortLabel];
        //
        //            [self performSelector:@selector(removeRecordPageView) withObject:nil afterDelay:1.0f];
        //
        //        }else{
        int needNumber=8-countDownNumber;
        if(needNumber>=1){
            [self sendRecordAudioWithRecordURLString:self.cellMessageID];
        }else{
            
            [MBProgressHUD showError:@"话语长度不能小于1s"];
            
        }
        
        //        }
    }
    
    NSLog(@"错误描述--->%@",errorCode);
    
}


- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *result = [NSMutableString new];
    NSDictionary *dic = [results objectAtIndex:0];
    NSLog(@"DIC:%@",dic);
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    if(iFlySpeechRecognizerString != nil && ![iFlySpeechRecognizerString isEqualToString:@""]){
        iFlySpeechRecognizerString = [NSString stringWithFormat:@"%@%@",iFlySpeechRecognizerString,result];
    }else{
        iFlySpeechRecognizerString = result;
    }
    NSLog(@"哈哈哈%@",iFlySpeechRecognizerString);
    
    if (self.isCancelSendRecord == YES && self.isZero == YES) {
        
        //取消发送
        //        iFlySpeechRecognizerString = @"";
        
    }
    
    if (self.isCancelSendRecord == NO  && self.isZero == YES) {
        
        //发送
        
        NSLog(@"asdasdsad%@",iFlySpeechRecognizerString);
        
        //        iFlySpeechRecognizerString = @"";
    }
}

#pragma mark - 观察者方法

-(void)determinePlayARecord:(NSNotification *)info{
    
    self.currentCellID = info.userInfo[@"cellID"];
    [self.cwViewController playButtonClickWithURLString:self.currentCellID];
    NSLog(@"%@",self.currentCellID);
    [self cancelResignFirstResponder];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"determinePlayARecord" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification                                                           object:nil];
}


#pragma mark - 功能方法

-(void)pullHistoryCount{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"ChatHisTory"]];
    
    
    NSInteger count = arr.count;
    
    if (count < 6) {
        ascCount = count;
    }else{
        ascCount = 6;
    }
    
}

//添加历史聊天记录
-(void)addHistoryWithDict:(NSDictionary *)dict{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"ChatHisTory"]];
    
    
    NSInteger count = arr.count;
    
    [arr insertObject:dict atIndex:count];
    
    [userDefault setObject:arr forKey:@"ChatHisTory"];
    
    [userDefault synchronize];
}


//获取当前时间string
-(NSString *)getCurerentTimeString{
    
    
    NSDate *currentTime = [NSDate date];
    
    NSString *dateString = [self fromDateToNSString:currentTime];
    
    return dateString;
}

//Date转化为Nsstring方法
//格式为：2016-04-0813:15:10" 把这个字符串传进去 @"yyyy-MM-ddHH:mm:ss"
-(NSString *)fromDateToNSString:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-ddHH-mm-ss"];
    
    
    NSString *dateNSString = [formatter stringFromDate:date];
    
    
    return dateNSString;
}

-(void)sendRecordAudioWithRecordURLString:(NSString *)urlString{
    NSInteger count = self.dataArr.count;
    
    
    //////////
    //    iFlySpeechRecognizerString = @"你吃饭了吗？";
    
    //////////
    int needNumber=8-countDownNumber;
    
    NSString *needStr=[NSString stringWithFormat:@"%d\"",needNumber];
    
    NSDictionary *dict = @{@"senderID":self.senderID,
                           @"chatAudioContent":urlString,
                           @"chatContentType":@"audio",
                           @"chatPictureURLContent":@"",
                           @"messageID":self.cellMessageID,
                           @"sendIdentifier":self.userIdentifier,
                           @"audioSecond":needStr,
                           @"AVtoStringContent":iFlySpeechRecognizerString,
                           @"sendTime":self.cellMessageID,
                           @"chatTextContent":@"",
                           @"senderImgPictureURL":@""};
    
    [self addHistoryWithDict:dict];
    
    NSString *extra = [self getRCMessageExtraStringWithsenderID:dict[@"senderID"] chatTextContent:dict[@"chatTextContent"] chatContentType:dict[@"chatContentType"] chatPictureURLContent:dict[@"chatPictureURLContent"] messageID:dict[@"messageID"] senderImgPictureURL:dict[@"senderImgPictureURL"] chatAudioContent:dict[@"chatAudioContent"] audioSecond:dict[@"audioSecond"] sendIdentifier:dict[@"sendIdentifier"] AVtoStringContent:dict[@"AVtoStringContent"] sendTime:dict[@"sendTime"]];
    [self sendAWebVoice:extra];
    
    
    self.inputTextView.text = nil;
    [self.dataArr insertObject:dict atIndex:count];
    ascCount = ascCount + 1;
    [self reloadDataSourceWithNumber:ascCount];
    [self.bottomTableView reloadData];
    
    [self.sendMessageBtn removeFromSuperview];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:ascCount - 1 inSection:0];
    [self.bottomTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //    [self performSelector:@selector(freeTranslationMethod) withObject:nil afterDelay:1.0f];
}

//免费翻译进行
-(void)freeTranslationMethod{
    
    if (iFlySpeechRecognizerString == nil || [iFlySpeechRecognizerString isEqualToString:@""]) {
        //不需要翻译
    }else{
        NSInteger count = self.dataArr.count;
        
        self.stringTransVC.inputTF.text = iFlySpeechRecognizerString;
        [self.stringTransVC btnClick];
        NSString *result = self.stringTransVC.resultString;
        
        
        NSDictionary *dict = @{@"senderID":@"0002",@"chatTextContent":result,@"chatContentType":@"text",@"chatPictureURLContent":@"",@"sendIdentifier":@"FREETRANS"};
        self.inputTextView.text = nil;
        [self.dataArr insertObject:dict atIndex:count];
        ascCount = ascCount + 1;
        [self reloadDataSourceWithNumber:ascCount];
        [self.bottomTableView reloadData];
        
        [self.sendMessageBtn removeFromSuperview];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:ascCount - 1 inSection:0];
        [self.bottomTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
    }
}

-(void)sendTextMessageMethodWithString:(NSString *)text{
    
    NSString *currentDateString = [self getCurerentTimeString];
    self.cellMessageID = currentDateString;
    
    NSInteger count = self.dataArr.count;
    if ([self.inputTextView.text  isEqual: @""]) {
        NSLog(@"空了2");
    }else{
        NSDictionary *dict = @{@"senderID":self.senderID,
                               @"chatTextContent":text,
                               @"chatContentType":@"text",
                               @"chatPictureURLContent":@"",
                               @"messageID":self.cellMessageID,
                               @"senderImgPictureURL":@"",
                               @"chatAudioContent":self.cellMessageID,
                               @"audioSecond":@"",
                               @"sendIdentifier":self.userIdentifier,
                               @"AVtoStringContent":@"",
                               @"sendTime":self.cellMessageID};
        
        [self addHistoryWithDict:dict];
        
        NSString *extra = [self getRCMessageExtraStringWithsenderID:dict[@"senderID"] chatTextContent:dict[@"chatTextContent"] chatContentType:dict[@"chatContentType"] chatPictureURLContent:dict[@"chatPictureURLContent"] messageID:dict[@"messageID"] senderImgPictureURL:dict[@"senderImgPictureURL"] chatAudioContent:dict[@"chatAudioContent"] audioSecond:dict[@"audioSecond"] sendIdentifier:dict[@"sendIdentifier"] AVtoStringContent:dict[@"AVtoStringContent"] sendTime:dict[@"sendTime"]];
        [self sendAwebMessage:extra];
        
        self.inputTextView.text = nil;
        [self.dataArr insertObject:dict atIndex:count];
        ascCount = ascCount + 1;
        [self reloadDataSourceWithNumber:ascCount];
        [self.bottomTableView reloadData];
        
        [self.sendMessageBtn removeFromSuperview];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:ascCount - 1 inSection:0];
        [self.bottomTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
        if (self.isKeyboardShow == YES) {
            //////////
            NSInteger cccount = self.dataSource.count;
            NSIndexPath *iindex = [NSIndexPath indexPathForRow:cccount - 1 inSection:0];
            CGRect    rect = [self.bottomTableView rectForRowAtIndexPath:iindex];
            CGFloat   cellMaxY = rect.origin.y + rect.size.height + 64;
            ;
            [UIView animateWithDuration:0.25 animations:^{
                
                CGFloat moveY = 0.0;
                CGFloat xiangjian;
                xiangjian = cellMaxY - ([UIScreen mainScreen].bounds.size.height - KeyboardWillShowHeight - CGRectGetHeight(self.inputBottomView.frame));
                
                if (xiangjian <= 0) {
                    moveY = 0;
                }
                
                if (xiangjian > 0 && xiangjian < KeyboardWillShowHeight) {
                    moveY = xiangjian;
                }
                
                if (xiangjian >= KeyboardWillShowHeight ) {
                    moveY = KeyboardWillShowHeight;
                }
                self.inputBottomView.transform = CGAffineTransformMakeTranslation(0, -KeyboardWillShowHeight);
                self.bottomTableView.transform = CGAffineTransformMakeTranslation(0, -moveY);
            }];
        }
    }
    
}
//加载datasource
-(void)reloadDataSourceWithNumber:(long)count{
    self.dataSource = [[NSMutableArray alloc]init];
    long dataCount = self.dataArr.count;
    if (dataCount>=count) {
        long j=0;
        long m=count;
        for (long i=count; i >0; i--) {
            
            [self.dataSource insertObject:self.dataArr[dataCount-m] atIndex:j];
            m--;
            j++;
        }
    }else{
        for (int i=0; i<_dataArr.count; i++) {
            [self.dataSource insertObject:self.dataArr[i] atIndex:i];
        }
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSInteger i = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *object = self.dataSource[i];
    
    ChatModel *model = [[ChatModel alloc]init];
    
    
    if([object[@"senderID"]isKindOfClass:[NSDictionary class]]){
        if ([object[@"senderID"][@"user_id"] isEqualToString:userIDinfo]) {
            model.isSender = 1;
            model.senderImgPictureURL = self.user_id;
        }else{
            model.isSender = 0;
            model.senderImgPictureURL = self.target_id;
        }
        
    }else{
        
        if ([object[@"senderID"]isEqualToString:userIDinfo]) {
            model.isSender = 1;
            model.senderImgPictureURL = self.user_id;
        }else{
            model.isSender = 0;
            model.senderImgPictureURL = self.target_id;
        }
        
    }
    
    
    
    model.senderID = object[@"senderID"];
    model.chatTextContent = object[@"chatTextContent"];
    model.chatContentType = object[@"chatContentType"];
    model.chatPictureURLContent = object[@"chatPictureURLContent"];
    model.messageID            = object[@"messageID"];
    model.sendIdentifier = object[@"sendIdentifier"];
    model.AVtoStringContent = object[@"AVtoStringContent"];
    model.audioSecond = object[@"audioSecond"];
    model.chatAudioContent = object[@"chatAudioContent"];
//    model.senderImgPictureURL = object[@"senderImgPictureURL"];
    model.sendTime = object[@"sendTime"];
    
    
    ChatTableViewCell *cell = [[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Model:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger i = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *object = self.dataSource[i];
    ChatModel *model = [[ChatModel alloc]init];
    NSLog(@"%@",object[@"senderID"]);
    if ([object[@"user_id"] isEqualToString:self.senderID]) {
        model.isSender = 1;
    }else{
        model.isSender = 0;
    }
    
    model.senderID = object[@"senderID"];
    model.chatTextContent = object[@"chatTextContent"];
    model.chatContentType = object[@"chatContentType"];
    model.chatPictureURLContent = object[@"chatPictureURLContent"];
    model.AVtoStringContent = object[@"AVtoStringContent"];
    model.sendIdentifier = object[@"sendIdentifier"];
    model.chatAudioContent = object[@"chatAudioContent"];
    model.senderImgPictureURL = object[@"senderImgPictureURL"];
    model.audioSecond = object[@"audioSecond"];
    model.sendTime = object[@"sendTime"];
    model.messageID = object[@"messageID"];
    
    ChatTableViewCell *cell = [[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Model:model];
    
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatTableViewCell *cell = [self.bottomTableView cellForRowAtIndexPath:indexPath];
    
    self.currentCellID = cell.messageID;
    NSLog(@"%@------%ld",self.currentCellID,(long)indexPath.row);
    
}

-(void)countDown{
    
    countDownNumber--;
    if(countDownNumber<=3){
        
        //        UITouch *touch = [[event touchesForView:button] anyObject];
        
        //将XY轴的座标资讯正规化后输出
        //        NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].x]) ;
        //        NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].y]) ;
        //        NSLog(@"ButtonEnded!");
        [MBProgressHUD showError:@"话语长度不能大于5s"];
        [self removeRecordPageView];
        
        if (self.isCancelSendRecord == YES) {
            
            [self removeRecordPageView];
            
            [self.cwViewController cancelButtonClick];
            self.isZero = YES;
            [self iFlySpeechRecognizerStop];
            iFlySpeechRecognizerString = @"";
            
        }else{
            
            
            [self.cwViewController recordButtonClick];
            
            [self iFlySpeechRecognizerStop];
            
            //        if ([self.cwViewController.secondString intValue] < 1 ) {
            //
            //            self.shortLabel = [[UILabel alloc]initWithFrame:self.subBottomView.bounds];
            //            self.shortLabel.text = @"说话时间过短，小于1秒";
            //            self.shortLabel.font = FONT_10;
            //            self.shortLabel.textAlignment = NSTextAlignmentCenter;
            //            self.shortLabel.backgroundColor = [UIColor clearColor];
            //            [self.subBottomView addSubview:self.shortLabel];
            //
            //            [self performSelector:@selector(removeRecordPageView) withObject:nil afterDelay:1.0f];
            //
            //        }else{
            //
            //
            //            [self sendRecordAudioWithRecordURLString:self.cellMessageID];
            //
            //        }
            
            
            self.isZero = YES;
            
            
        }
        
        
        [timer invalidate];
        
    }
    
    NSLog(@"aa");
    
}


#pragma mark - BaseAudioButtonDelegate

-(void)button:(UIButton *)button BaseTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    countDownNumber=8;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    self.cwViewController = [[CWViewController alloc]init];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.subBottomView];
    //        [self.cancelSayView removeFromSuperview];
    //        [self.subBottomView addSubview:self.sayView];
    
    self.isCancelSendRecord = NO;
    self.isZero = NO;
    iFlySpeechRecognizerString = @"";
    
    if(self.bottomView){
        [self.cancelSayView removeFromSuperview];
        [self.subBottomView addSubview:self.sayView];
    }
    
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    //将XY轴的座标资讯正规化后输出
    NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].x]) ;
    NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].y]) ;
    
    NSString *currentDateString = [self getCurerentTimeString];
    NSString *ID = [NSString stringWithFormat:@"%@.wav",currentDateString];
    self.cellMessageID = ID;
    
    self.cwViewController.URLNameString = self.cellMessageID;
    [self.cwViewController getSavePath];
    [self.cwViewController recordButtonClick];
    
    
    
    
    if (self.isRecognizer == NO) {
        [self iFlySpeechRecognizerBegin:LANGUAGE_CHINESE];
    }
    
    
    NSLog(@"ButtonBegan!");
}


-(void)button:(UIButton *)button BaseTouchesCancel:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    NSLog(@"ButtonCancel!");
}
-(UIImageView *)sayView{
    if (!_sayView) {
        _sayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, krequL, krequL)];
        UIImage *img = [UIImage imageNamed:@"01"];
        [_sayView setImage:img];
    }
    return _sayView;
}
-(UIImageView *)cancelSayView{
    if (!_cancelSayView) {
        _cancelSayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, krequL, krequL)];
        UIImage *img = [UIImage imageNamed:@"02"];
        [_cancelSayView setImage:img];
    }
    return _cancelSayView;
}
-(void)button:(UIButton *)button BaseTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
    UITouch *touch = [[event touchesForView:button] anyObject];
    NSString *xString = [NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].x];
    NSString *yString = [NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].y];
    int x = [xString intValue];
    int y = [yString intValue];
    //将XY轴的座标资讯正规化后输出
    NSLog(@"%d",x) ;
    NSLog(@"%d",y) ;
    
    if (self.bottomView) {
        
        //取消发送View热区
        
        CGFloat leftBorder = (CGRectGetMinX(self.subBottomView.frame) - CGRectGetMinX(self.reportAudioBtn.frame)-self.subBottomView.frame.origin.x-100);
        CGFloat rightBorder = (CGRectGetMaxX(self.subBottomView.frame) - CGRectGetMinX(self.reportAudioBtn.frame)+CGRectGetMaxX(self.subBottomView.frame)+100);
        CGFloat topBorder =  (CGRectGetMinY(self.subBottomView.frame) - (CGRectGetMinY(self.reportAudioBtn.frame) + CGRectGetMinY(self.inputBottomView.frame))-CGRectGetMinY(self.subBottomView.frame)-100);
        CGFloat bottomBorder =  (CGRectGetMaxY(self.subBottomView.frame) - (CGRectGetMinY(self.reportAudioBtn.frame) + CGRectGetMinY(self.inputBottomView.frame))+150);
        
        //            CGFloat leftBorder = (CGRectGetMinX(self.subBottomView.frame) - CGRectGetMinX(self.reportEnglishBtn.frame)-self.subBottomView.frame.origin.x-100);
        //            CGFloat rightBorder = (CGRectGetMaxX(self.subBottomView.frame) - CGRectGetMinX(self.reportEnglishBtn.frame)+CGRectGetMaxX(self.subBottomView.frame)+100);
        //            CGFloat topBorder =  (CGRectGetMinY(self.subBottomView.frame) - (CGRectGetMinY(self.reportEnglishBtn.frame) + CGRectGetMinY(self.inputBottomView.frame))-CGRectGetMinY(self.subBottomView.frame)-100);
        //            CGFloat bottomBorder =  (CGRectGetMaxY(self.subBottomView.frame) - (CGRectGetMinY(self.reportEnglishBtn.frame) + CGRectGetMinY(self.inputBottomView.frame))+150);
        //
        //1.获得全局的并发队列
        
        if (x > leftBorder && x < rightBorder && y > topBorder && y < bottomBorder) {
            [self.sayView removeFromSuperview];
            [self.subBottomView addSubview:self.cancelSayView];
            self.isCancelSendRecord = YES;
            
            NSLog(@"取消发送语音");
            //                [self.cwViewController pauseRecordBtnClick];
            
            //2.添加任务到队列中，就可以执行任务
            //异步函数：具备开启新线程的能力
            //                dispatch_async(queue, ^{
            //                    // 在另一个线程中启动下载功能，加GCD控制
            //                    if (self.isRecognizer == YES) {
            //                        [self iFlySpeechRecognizerStop];
            //                    }
            
            //                });
            
            
            
            
        }else{
            [self.cancelSayView removeFromSuperview];
            [self.subBottomView addSubview:self.sayView];
            self.isCancelSendRecord=NO;
            //                dispatch_async(queue, ^{
            //                    [self.cwViewController goOnRecordBtnClick];
            //                    self.isCancelSendRecord = NO;
            //
            //
            //                    if (self.isRecognizer == NO) {
            //                        [self iFlySpeechRecognizerBegin:LANGUAGE_CHINESE];
            //                    }
            //
            //                    NSLog(@"继续录音");
            //
            //                });
            
            
            
        }
    }
    
    
    
    NSLog(@"ButtonMoved!");
}

-(void)button:(UIButton *)button BaseTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [timer invalidate];
    
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    //将XY轴的座标资讯正规化后输出
    NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].x]) ;
    NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].y]) ;
    NSLog(@"ButtonEnded!");
    
    [self removeRecordPageView];
    
    if (self.isCancelSendRecord == YES) {
        
        [self removeRecordPageView];
        
        [self.cwViewController cancelButtonClick];
        self.isZero = YES;
        [self iFlySpeechRecognizerStop];
        iFlySpeechRecognizerString = @"";
        
    }else{
        
        
        [self.cwViewController recordButtonClick];
        
        [self iFlySpeechRecognizerStop];
        
        //        if ([self.cwViewController.secondString intValue] < 1 ) {
        //
        //            self.shortLabel = [[UILabel alloc]initWithFrame:self.subBottomView.bounds];
        //            self.shortLabel.text = @"说话时间过短，小于1秒";
        //            self.shortLabel.font = FONT_10;
        //            self.shortLabel.textAlignment = NSTextAlignmentCenter;
        //            self.shortLabel.backgroundColor = [UIColor clearColor];
        //            [self.subBottomView addSubview:self.shortLabel];
        //
        //            [self performSelector:@selector(removeRecordPageView) withObject:nil afterDelay:1.0f];
        //
        //        }else{
        //        
        //            
        //            [self sendRecordAudioWithRecordURLString:self.cellMessageID];
        //            
        //        }
        
        
        self.isZero = YES;
        
        
    }
    
}

-(void)removeRecordPageView{
    
    [self.shortLabel removeFromSuperview];
    [self.subBottomView removeFromSuperview];
    [self.bottomView removeFromSuperview];
}

#pragma mark - BaseTableViewDelegate





-(void)tableView:(UITableView *)tableView BaseTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //宣告一个UITouch的指标来存放事件触发时所撷取到的状态
    UITouch *touch = [[event touchesForView:tableView] anyObject];
    [self cancelResignFirstResponder];
    //将XY轴的座标资讯正规化后输出
    NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].x]) ;
    NSLog(@"%@",[NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].y]) ;
    
    NSLog(@"Began!");
    self.isequal=YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundImageView.transform =CGAffineTransformIdentity;
        self.inputBottomView.transform = CGAffineTransformIdentity;
        self.btnview.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
}

-(void)tableView:(UITableView *)tableView BaseTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Enaded!");
}

-(void)tableView:(UITableView *)tableView BaseTouchesCancel:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Cancel!");
}

-(void)tableView:(UITableView *)tableView BaseTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"Moved!");
}


#pragma mark - 观察者模式

-(void)keyboardWillShow:(NSNotification *)noti{
    
    self.isKeyboardShow = YES;
    NSInteger count = self.dataSource.count;
    
    CGRect  rect;
    CGFloat   cellMaxY;
    if (count != 0) {
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        rect = [self.bottomTableView rectForRowAtIndexPath:index];
        cellMaxY = rect.origin.y + rect.size.height + 64;
    }else{
        
        cellMaxY = 0;
    }
    
    
    CGRect keyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyboardRect.size.height;
    KeyboardWillShowHeight = deltaY;
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat moveY = 0.0;
        CGFloat xiangjian;
        xiangjian = cellMaxY - ([UIScreen mainScreen].bounds.size.height - deltaY - CGRectGetHeight(self.inputBottomView.frame));
        
        if (xiangjian <= 0) {
            moveY = 0;
        }
        
        if (xiangjian > 0 && xiangjian < deltaY) {
            moveY = xiangjian ;
        }
        
        if (xiangjian >= deltaY ) {
            moveY = deltaY;
        }
        self.inputBottomView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        self.bottomTableView.transform = CGAffineTransformMakeTranslation(0, -moveY);
    }];
    
    if (count != 0 ) {
        
        NSIndexPath *ndex = [NSIndexPath indexPathForRow:ascCount - 1 inSection:0];
        [self.bottomTableView scrollToRowAtIndexPath:ndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    
    
}
-(void)keyboardWillHide:(NSNotification *)noti{
    
    self.isKeyboardShow = NO;
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.inputBottomView.transform = CGAffineTransformIdentity;
        self.bottomTableView.transform = CGAffineTransformIdentity;
    }];
    
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    
    NSLog(@"变了");
    if ([self.inputTextView.text isEqualToString:@""] || self.inputTextView.text == nil) {
        
        [self.sendMessageBtn removeFromSuperview];
        
    }else{
        
        [self.inputBottomView addSubview:self.sendMessageBtn];
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (text != nil && ![text isEqualToString:@""]) {
            //发送消息！！！！！！
            [self sendTextMessageMethodWithString:textView.text];
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    //开始输入聊天信息
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    //结束输入聊天信息
}

#pragma mark - 私有方法


- (void)AddTapGestureRecognizer{
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelResignFirstResponder)];
    
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
    //    [self.bottomTableView addGestureRecognizer:tapGesture];
    
}

- (void)cancelResignFirstResponder{
    
    [self.inputTextView resignFirstResponder];
    
}


#pragma mark - 响应事件

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.bottomTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.bottomTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#pragma mark - warning 自动刷新(一进入程序就下拉刷新)
    //[self.popularCellView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.bottomTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.bottomTableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.bottomTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.bottomTableView.headerRefreshingText = @"数据刷新中";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.cellArr insertObject:MJRandomData atIndex:0];
    //    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.bottomTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.bottomTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    //    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.cellArr addObject:MJRandomData];
    //    }
    //
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.bottomTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.bottomTableView footerEndRefreshing];
    });
}

-(void)refreshView:(UIRefreshControl *)refresh{
    
    [self reloadDataSourceWithNumber:ascCount+6];
    [self.bottomTableView reloadData];
    
    [refresh endRefreshing];
    
}

-(void)sendAudioInfoClick{
    
        NSLog(@"发送语音");
}

-(void)benginRecordAudio{
    
    NSLog(@"开始录音");
    
}

-(void)TouchDragExitClickWithEvent:(UIEvent *)event{
    
    NSLog(@"asdasda");
    
}

-(void)backToRoot{
    
    [WebAgent removeFromWaitingQueue:userIDinfo success:^(id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

-(void)sendMessageAndPop{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *mseeage_id = [userdefault objectForKey:@"messageId"];

    [WebAgent sendRemoteNotificationsWithuseId:self.target_id WithsendMessage:@"退出聊天" WithlanguageCatgory:_trans_Language WithpayNumber:@"0" WithSenderID:userIDinfo WithMessionID:mseeage_id success:^(id responseObject) {
        [WebAgent removeFromWaitingQueue:userIDinfo success:^(id responseObject) {
            
            if([self.userIdentifier isEqualToString:@"TRANSTOR"])
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [WebAgent interpreterRequireStateWithuserId:self.user_id success:^(id responseObject) {
                    
                    
                    NSLog(@"译员成功返回首页");
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"译员未返回首页");
                    
                }];
            }
            else
            {
                
                FeedBackViewController *fbvc = [[FeedBackViewController alloc]initWithtargetID:self.target_id];
                [self.navigationController pushViewController:fbvc animated:YES];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"失败");
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error) {
        NSLog(@"失败");
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}




-(void)changeSendContentTwoClick{
    
    if (self.changeSendContentBtn.tag == 1001) {
        //输入转语音
        [self.inputBottomView addSubview:self.reportAudioBtn];
        //        [self.inputBottomView addSubview:self.reportEnglishBtn];
        [self cancelResignFirstResponder];
        self.changeSendContentBtn.tag = 1002;
        [self.changeSendContentBtn setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        
    }else{
        //语音转输入
        self.changeSendContentBtn.tag = 1001;
        [self.reportAudioBtn removeFromSuperview];
        //        [self.reportEnglishBtn removeFromSuperview];
        [self.changeSendContentBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        
    }
    
    
    
}

-(void)selectLangueageClick{
    
    [self cancelResignFirstResponder];
   // NSLog(@"跳转到新的切换语言页面");
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"ChatHisTory"];
    [userDefault synchronize];
    
    //弹出下方view
    if (self.isequal==YES) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundImageView.transform =CGAffineTransformMakeTranslation(0, -60);
            self.btnview.transform =CGAffineTransformMakeTranslation(0, -60);
            self.inputBottomView.transform = CGAffineTransformMakeTranslation(0, -60);
            self.isequal = !self.isequal;
        }completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundImageView.transform =CGAffineTransformIdentity;
            self.inputBottomView.transform = CGAffineTransformIdentity;
            self.btnview.transform =CGAffineTransformIdentity;
            self.isequal = !self.isequal;
        }completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(void)sendMessageBtnClick{
    
    [self sendTextMessageMethodWithString:self.inputTextView.text];
    
    
    
    NSLog(@"发送消息");
}

#pragma mark - extra自制定制方法

-(NSString *)getRCMessageExtraStringWithsenderID:(NSString *)senderID chatTextContent:(NSString *)chatTextContent chatContentType:(NSString *)chatContentType chatPictureURLContent:(NSString *)chatPictureURLContent messageID:(NSString *)messageID senderImgPictureURL:(NSString *)senderImgPictureURL chatAudioContent:(NSString *)chatAudioContent audioSecond:(NSString *)audioSecond sendIdentifier:(NSString *)sendIdentifier AVtoStringContent:(NSString *)AVtoStringContent sendTime:(NSString *)sendTime{
    
    NSString *one = [NSString stringWithFormat:@"senderID:%@",senderID];
    NSString *two = [NSString stringWithFormat:@"chatTextContent:%@",chatTextContent];
    NSString *three = [NSString stringWithFormat:@"chatContentType:%@",chatContentType];
    NSString *four = [NSString stringWithFormat:@"chatPictureURLContent:%@",chatPictureURLContent];
    NSString *five = [NSString stringWithFormat:@"messageID:%@",messageID];
    NSString *six = [NSString stringWithFormat:@"senderImgPictureURL:%@",senderImgPictureURL];
    NSString *seven = [NSString stringWithFormat:@"chatAudioContent:%@",chatAudioContent];
    NSString *eight = [NSString stringWithFormat:@"audioSecond:%@",audioSecond];
    NSString *nine = [NSString stringWithFormat:@"sendIdentifier:%@",sendIdentifier];
    NSString *ten = [NSString stringWithFormat:@"AVtoStringContent:%@",AVtoStringContent];
    NSString *eleven = [NSString stringWithFormat:@"sendTime:%@",sendTime];
    
    
    NSString *resultString = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@&%@&%@&%@&%@",one,two,three,four,five,six,seven,eight,nine,ten,eleven];
    
    return resultString;
    
}

-(NSDictionary *)getRCMessageDictionaryWithExtra:(NSString *)extra{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray  * array= [extra componentsSeparatedByString:@"&"];
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *depStr = array[i];
        NSArray *arr = [depStr componentsSeparatedByString:@":"];
        [dic setObject:arr[1] forKey:arr[0]];
    }
    
    return dic;
}


#pragma mark - getters

-(YBZbtnView *)btnview
{
    if(!_btnview)
    {
        _btnview = [[YBZbtnView alloc] init];
        _btnview.backgroundColor = [UIColor lightGrayColor];
        [_btnview.btn01 addTarget:self action:@selector(btn01click) forControlEvents:UIControlEventTouchUpInside];
        [_btnview.btn02 addTarget:self action:@selector(btn02click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnview;
}

-(BaseTableView *)bottomTableView{
    if (!_bottomTableView) {
        _bottomTableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -64- CGRectGetHeight(self.inputBottomView.frame)) style:UITableViewStylePlain];
        _bottomTableView.backgroundColor = [UIColor clearColor];
        _bottomTableView.idelegate = self;
        _bottomTableView.delegate = self;
        _bottomTableView.dataSource = self;
        [_bottomTableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"Cell"];
        _bottomTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _bottomTableView.allowsSelection = YES;
        _bottomTableView.showsVerticalScrollIndicator = YES;
        _bottomTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        [_bottomTableView addSubview:self.refreshController];
        
        _bottomTableView.backgroundColor=[UIColor clearColor];
        
    }
    return _bottomTableView;
}

-(UIView *)inputBottomView{
    if (!_inputBottomView) {
        _inputBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHight*0.93, kScreenWidth, kScreenHight*0.070)];
        
        _inputBottomView.backgroundColor  = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f  blue:248.0f/255.0f  alpha:1];
    }
    
    return _inputBottomView;
}


-(UIButton *)changeSendContentBtn{
    
    if (!_changeSendContentBtn) {
        _changeSendContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeSendContentBtn.frame = CGRectMake(kScreenWidth*0.02, kScreenWidth*0.02, kScreenWidth*0.085, kScreenWidth*0.085);
        [_changeSendContentBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        [_changeSendContentBtn addTarget:self action:@selector(changeSendContentTwoClick) forControlEvents:UIControlEventTouchUpInside];
        _changeSendContentBtn.tag = 1001;//展示语音图片，点击切换成语音模式；
    }
    return _changeSendContentBtn;
    
}

-(UIButton *)selectLangueageBtn{
    
    if (!_selectLangueageBtn) {
        _selectLangueageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectLangueageBtn.frame = CGRectMake(kScreenWidth*0.85, kScreenWidth*0.02, kScreenWidth*0.085, kScreenWidth*0.085);
        [_selectLangueageBtn setImage:[UIImage imageNamed:@"dustbin"] forState:UIControlStateNormal];
        [_selectLangueageBtn addTarget:self action:@selector(selectLangueageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectLangueageBtn;
}

-(UITextView *)inputTextView{
    
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.changeSendContentBtn.frame) + 8,  kScreenWidth*0.02, CGRectGetMinX(self.selectLangueageBtn.frame) - 8 - (CGRectGetMaxX(self.changeSendContentBtn.frame) + 8),  kScreenWidth*0.085)];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.layer.cornerRadius = 4;
        _inputTextView.keyboardType = UIKeyboardTypeDefault;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.scrollEnabled = YES;
        _inputTextView.delegate = self;
        [_inputTextView setFont:FONT_16];
    }
    return _inputTextView;
}

-(BaseAudioButton *)reportAudioBtn{
    
    if (!_reportAudioBtn) {
        _reportAudioBtn = [BaseAudioButton buttonWithType:UIButtonTypeCustom];
        _reportAudioBtn.mdelegate = self;
        _reportAudioBtn.frame = CGRectMake(CGRectGetMaxX(self.changeSendContentBtn.frame) + 8,  kScreenWidth*0.02, CGRectGetMinX(self.selectLangueageBtn.frame) - 8 - (CGRectGetMaxX(self.changeSendContentBtn.frame) + 8),  kScreenWidth * 0.085);
        //        _reportAudioBtn.backgroundColor = [UIColor lightGrayColor];
        //        [_reportAudioBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_reportAudioBtn setImage:[UIImage imageNamed:@"saynew"] forState:UIControlStateNormal];
        [_reportAudioBtn addTarget:self action:@selector(sendAudioInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_reportAudioBtn addTarget:self action:@selector(benginRecordAudio) forControlEvents:UIControlEventTouchDown];
        [_reportAudioBtn addTarget:self action:@selector(TouchDragExitClickWithEvent:) forControlEvents:UIControlEventTouchDragExit];
    }
    return _reportAudioBtn;
}


-(UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.4;
        _bottomView.userInteractionEnabled = NO;
    }
    
    return _bottomView;
}

-(UIView *)subBottomView{
    
    if (!_subBottomView) {
        _subBottomView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - krequL)/2, ([UIScreen mainScreen].bounds.size.height - krequL)/2, krequL, krequL)];
        
        _subBottomView.userInteractionEnabled = NO;
    }
    
    return _subBottomView;
    
}

-(UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"backgroundImage"];
    }
    return _backgroundImageView;
}

-(void)btn01click
{
    ascCount = 0;
    self.dataArr=[NSMutableArray array];
    self.dataSource=[NSMutableArray array];
    [self.bottomTableView reloadData];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChatHisTory"];
    
    NSLog(@"清空记录");
    
    [MBProgressHUD showSuccess:@"记录清除成功！"];
    
    self.isequal=YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundImageView.transform =CGAffineTransformIdentity;
        self.inputBottomView.transform = CGAffineTransformIdentity;
        self.btnview.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
}

-(void)btn02click
{
    
    self.isequal=YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundImageView.transform =CGAffineTransformIdentity;
        self.inputBottomView.transform = CGAffineTransformIdentity;
        self.btnview.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    [self changeIcon];
    
    NSLog(@"更改背景");
    
}

- (void)changeIcon
{
    UIAlertController *alertController;
    
    __block NSUInteger blockSourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"请选择做为头像的图片" preferredStyle:    UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击拍照");
            //相机
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //只支持访问相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"请选择做为头像的图片" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 选择图片后,回调选择

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self.backgroundImageView setImage:image];
    
    NSLog(@"aa");
    
    NSString *urlc=[NSString stringWithFormat:@"http://%@/TravelHelper/upload.php",serviseId];
    NSURL *URL = [NSURL URLWithString:urlc];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager setSecurityPolicy:securityPolicy];
    [manager POST:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //获取当前时间所闻文件名，防止图片重复
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        //            NSDictionary *myDictionary = [userinfo dictionaryForKey:@"myDictionary"];
        NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
        
        NSString *resultName=[NSString stringWithFormat:@"%@backgroundimg",user_id[@"user_id"]];
        
        //            NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        //        NSString *name = user_id[@"user_id"];
        
        [formData appendPartWithFileData:data name:@"file" fileName:resultName mimeType:@"image/png"];
        
        //            NSString *str = [NSString stringWithFormat:@"file:///Applications/XAMPP/xamppfiles/htdocs/OralEduServer/uploadImg/%@.jpg",name];
        //
        //            NSDictionary *para=@{@"user_moblie":name,@"user_newurl":str};
        //
        //            [HttpTool postWithparamsWithURL:@"Update/UrlUpdate" andParam:para success:^(id responseObject) {
        //                NSData *data = [[NSData allo c] initWithData:responseObject];
        //                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //
        //                NSLog(@"%@",dic);
        //
        //
        //
        //
        //            } failure:^(NSError *error) {
        //                NSLog(@"%@",error);
        //            }];
        //
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
    
    
    
    
}


@end