//
//  YBZVideocontentViewController.m
//  YBZTravel
//
//  Created by 王俊钢 on 2016/10/23.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZVideocontentViewController.h"
#import "EMSDKFull.h"
//#import "EaseUI.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+XMG.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"

@interface YBZVideocontentViewController ()<EMCallManagerDelegate>

@property (nonatomic, strong)EMCallSession *callSession;


@property (nonatomic,strong) UIButton *sendbtn;
@property (nonatomic,strong) UIButton *sendVoiceBtn;

@property (nonatomic,strong) UIButton *pauseVoice;
@property (nonatomic,strong) UIButton *pauseVideo;
@property (nonatomic,strong) UIButton *changeCamara;

@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation YBZVideocontentViewController
{
    NSString *localChar;
    NSString *targetChar;
    int secondsCountDown;
    int realCountDown;
    NSTimer *countDownTimer;
    int callCount;
}
//930258

- (instancetype)initWithUserId:(NSString *)userId
                      targetId:(NSString *)targetId
{
    self = [super init];
    if (self) {
        localChar=userId;
        targetChar=targetId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    callCount=0;
    localChar=@"1";
    targetChar=@"2";
    
    realCountDown=4;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频/语音通话";
    [self.imageView setupImageViewer];
//    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
//    
//    EMError *error = [[EMClient sharedClient] registerWithUsername:localChar password:@"111111"];
//    if (error==nil) {
//        NSLog(@"注册成功");
//    }
//    
//    EMError *error2 = [[EMClient sharedClient] loginWithUsername:localChar password:@"111111"];
//    if (!error2) {
//        NSLog(@"登录成功");
//    }
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    //默认情况下扬声器播放
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];
//    
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
//    
//    //添加监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(sensorStateChange:)
//                                                 name:@"UIDeviceProximityStateDidChangeNotification"
//                                               object:nil];
    
    
    [self.view addSubview:self.sendbtn];
    [self.view addSubview:self.sendVoiceBtn];
    [self.view addSubview:self.pauseVoice];
    [self.view addSubview:self.pauseVideo];
    [self.view addSubview:self.changeCamara];
    [self.view addSubview:self.imageView];
    
    
}

-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:EMCallEndReasonHangup];
    [[EMClient sharedClient].callManager removeDelegate:self];
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.callSession pauseVideo];//暂停视频
    //    [self.callSession pauseVoice];//暂停音频
    //    [self.callSession resumeVideo];//恢复
    //    [self.callSession resumeVoice];//恢复
    //    [self.callSession switchCameraPosition:YES];//yes为前置摄像头。no为后置
    
}

#pragma mark - getters

-(UIButton *)changeCamara
{
    if(!_changeCamara)
    {
        _changeCamara = [[UIButton alloc] initWithFrame:CGRectMake(250, UIScreenHeight-70, 120, 80)];
        [_changeCamara setTitle:@"切换摄像头" forState:UIControlStateNormal];
        [_changeCamara setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_changeCamara addTarget:self action:@selector(changeCamaraClick) forControlEvents:UIControlEventTouchUpInside];
        _changeCamara.selected=NO;
    }
    return _changeCamara;
}

-(void)changeCamaraClick{
    
    if(self.pauseVoice.selected==NO){
        
        [self.callSession switchCameraPosition:NO];
        self.pauseVoice.selected=YES;
        
        
    }else{
        
        [self.callSession resumeVoice];
        self.pauseVoice.selected=NO;
        [self.callSession switchCameraPosition:YES];
        
    }
    
}


-(UIButton *)pauseVoice
{
    if(!_pauseVoice)
    {
        _pauseVoice = [[UIButton alloc] initWithFrame:CGRectMake(170, UIScreenHeight-70, 120, 80)];
        [_pauseVoice setTitle:@"暂停音频" forState:UIControlStateNormal];
        [_pauseVoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pauseVoice addTarget:self action:@selector(pauseVoiceClick) forControlEvents:UIControlEventTouchUpInside];
        _pauseVoice.selected=NO;
    }
    return _pauseVoice;
}

-(void)pauseVoiceClick{
    
    if(self.pauseVoice.selected==NO){
        
        [self.callSession pauseVoice];
        self.pauseVoice.selected=YES;
        [self.pauseVoice setTitle:@"恢复音频" forState:UIControlStateNormal];
        
    }else{
        
        [self.callSession resumeVoice];
        self.pauseVoice.selected=NO;
        [self.pauseVoice setTitle:@"暂停音频" forState:UIControlStateNormal];
        
    }
    
}

-(UIButton *)pauseVideo
{
    if(!_pauseVideo)
    {
        _pauseVideo = [[UIButton alloc] initWithFrame:CGRectMake(170, UIScreenHeight-150, 120, 80)];
        [_pauseVideo setTitle:@"暂停视频" forState:UIControlStateNormal];
        [_pauseVideo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pauseVideo addTarget:self action:@selector(pauseVideoClick) forControlEvents:UIControlEventTouchUpInside];
        _pauseVideo.selected=NO;
    }
    return _pauseVideo;
}

-(void)pauseVideoClick{
    
    if(self.pauseVideo.selected==NO){
        
        [self.callSession pauseVideo];
        self.pauseVideo.selected=YES;
        [self.pauseVideo setTitle:@"恢复视频" forState:UIControlStateNormal];
        
    }else{
        
        [self.callSession resumeVideo];
        self.pauseVideo.selected=NO;
        [self.pauseVideo setTitle:@"暂停视频" forState:UIControlStateNormal];
        
    }
    
}


-(UIButton *)sendbtn
{
    if(!_sendbtn)
    {
        _sendbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, UIScreenHeight-150, 120, 80)];
        [_sendbtn setTitle:@"发送视频通话" forState:UIControlStateNormal];
        [_sendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendbtn addTarget:self action:@selector(sendbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendbtn;
}
-(UIButton *)sendVoiceBtn
{
    if(!_sendVoiceBtn)
    {
        _sendVoiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, UIScreenHeight-70, 120, 80)];
        [_sendVoiceBtn setTitle:@"发送音频通话" forState:UIControlStateNormal];
        [_sendVoiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendVoiceBtn addTarget:self action:@selector(sendVoiceBtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendVoiceBtn;
}
-(UIImageView *)imageView{

    if(!_imageView){
    
        _imageView=[[UIImageView alloc]init];
        [_imageView setImage:[UIImage imageNamed:@"backgroundImage"]];
        _imageView.frame=CGRectMake(40, 250, 200, 200);
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [imageView setupImageViewer];
        _imageView.clipsToBounds = YES;
        

    }
    return _imageView;
}
-(void)sendVoiceBtnclick{
    
    NSLog(@"发送音频通知!");
    
    [MBProgressHUD showMessage:@"请求发送，等待接听"];
    
    EMError *error = nil;
    //    startVoiceCall
    [[EMClient sharedClient].callManager startVoiceCall:targetChar completion:^(EMCallSession *aCallSession, EMError *aError) {
        //        completionBlock(aCallSession, aError);
        
        if (!error){
            //1.对方窗口
            self.callSession=aCallSession;
            //            aCallSession.remoteVideoView=[[EMCallRemoteView alloc]initWithFrame:CGRectMake(40, 64, 200, 200)];
            //            [self.view addSubview:aCallSession.remoteVideoView];
            //            aCallSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(40, 250, 200, 200)];
            //            [self.view addSubview:aCallSession.localVideoView];
        }
        
    }];
    
    
}


-(void)sendbtnclick
{
    NSLog(@"发送视频通知!");
    
    [MBProgressHUD showMessage:@"请求发送，等待接听"];
    EMError *error = nil;
    
    [[EMClient sharedClient].callManager startVideoCall:targetChar completion:^(EMCallSession *aCallSession, EMError *aError) {
        //        completionBlock(aCallSession, aError);
        
        if (!error){
            //1.对方窗口
            self.callSession=aCallSession;
            //            aCallSession.remoteVideoView=[[EMCallRemoteView alloc]initWithFrame:CGRectMake(40, 64, 200, 200)];
            //            [self.view addSubview:aCallSession.remoteVideoView];
            //            aCallSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(40, 250, 200, 200)];
            //            [self.view addSubview:aCallSession.localVideoView];
        }
        
    }];
    
    
}



//同意通话
//- (EMError *)answerCall:(NSString *)aSessionId
//{
//
//    return nil;
//}

/*!
 *  结束通话
 *
 *  @param aSessionId 通话的ID
 *  @param aReason    结束原因
 */
- (void)endCall:(NSString *)aSessionId
         reason:(EMCallEndReason)aReason
{
    NSLog(@"结束通话");
    
}
- (void)callDidReceive:(EMCallSession *)aSession{
    
    NSLog(@"收到");
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    self.callSession=aSession;
    //    aSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(40, 250, 200, 200)];
    //    [self.view addSubview:aSession.localVideoView];
    //    aSession.remoteVideoView=[[EMCallRemoteView alloc]initWithFrame:CGRectMake(40, 64, 200, 200)];
    //    [self.view addSubview:aSession.remoteVideoView];
    
    NSLog(@"%@",aSession.callId);
    [[EMClient sharedClient].callManager answerIncomingCall:aSession.callId];
    
    [MBProgressHUD showMessage:@"接收到通话请求，载入中。。"];
    
}
//
//- (void)didReceiveCallIncoming:(EMCallSession *)aSession{
//
//    NSLog(@"收到");
//    aSession.remoteVideoView=[[EMCallRemoteView alloc]initWithFrame:CGRectMake(40, 64, 200, 200)];
//    [self.view addSubview:aSession.remoteVideoView];
//    aSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(40, 250, 200, 200)];
//    [self.view addSubview:aSession.localVideoView];
//
//    [[EMClient sharedClient].callManager answerIncomingCall:targetChar];
//
//
//}
- (void)callDidConnect:(EMCallSession *)aSession{
    
    if(aSession.type==EMCallTypeVoice){
        self.callSession=aSession;
    }else{
        aSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(40, 250, 200, 200)];
        [self.view addSubview:aSession.localVideoView];
        aSession.remoteVideoView=[[EMCallRemoteView alloc]initWithFrame:CGRectMake(40, 64, 200, 200)];
        [self.view addSubview:aSession.remoteVideoView];
        self.callSession=aSession;
    }
    [MBProgressHUD hideHUD];
    NSLog(@"用户通道建立完成");
    
}
//- (void)didReceiveCallConnected:(EMCallSession *)aSession{
//
//    NSLog(@"用户通道建立完成");
//
//}
- (void)callDidAccept:(EMCallSession *)aSession{
    NSLog(@"用户同意了通话");
    [MBProgressHUD hideHUD];
    
    
}
//- (void)didReceiveCallAccepted:(EMCallSession *)aSession{
//
//    NSLog(@"用户同意了通话");
//
//}
- (void)didReceiveCallTerminated:(EMCallSession *)aSession
                          reason:(EMCallEndReason)aReason
                           error:(EMError *)aError{
//    [MBProgressHUD hideHUD];
    NSLog(@"通话结束");
    
}

- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    
    NSLog(@"对方结束了通话~");
    //60秒倒计时
    self.callSession=aSession;
    if(aReason==EMCallEndReasonFailed){
        
        if(callCount<=5){
            callCount++;
            secondsCountDown=realCountDown;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

            
        }else{
            callCount=0;
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求超时，请重试"];
            
        }
        
        
    }else{
        [MBProgressHUD hideHUD];
    }
}


-(void)timeFireMethod{
    secondsCountDown--;
    if(secondsCountDown==0){
        EMError *error = nil;
        NSLog(@"运行一次");
        if(self.callSession.type==EMCallTypeVideo){
            [[EMClient sharedClient].callManager startVideoCall:targetChar completion:^(EMCallSession *aCallSession, EMError *aError) {
                //        completionBlock(aCallSession, aError);
                
                if (!error){
                    
                    self.callSession=aCallSession;
                   
                }
                
            }];
        }else if(self.callSession.type==EMCallTypeVoice){
            
            
            EMError *error = nil;
            //    startVoiceCall
            [[EMClient sharedClient].callManager startVoiceCall:targetChar completion:^(EMCallSession *aCallSession, EMError *aError) {
                
                if (!error){
                    //1.对方窗口
                    self.callSession=aCallSession;
                  
                }
                
            }];
            
        }
        [countDownTimer invalidate];
    }
}


- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType{

    NSLog(@"对方关闭或继续了输出流，可以判断，懒。。");

}

- (void)callNetworkDidChange:(EMCallSession *)aSession
                      status:(EMCallNetworkStatus)aStatus{
    
    NSLog(@"您当前网络状态不稳定,重连上了应该支持续传。。需要一部4G来证实");

}


@end
