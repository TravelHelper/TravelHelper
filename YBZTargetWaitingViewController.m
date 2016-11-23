//
//  YBZTargetWaitingViewController.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/11/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZTargetWaitingViewController.h"
#import "GFWaterView.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+XMG.h"
#import "EMSDKFull.h"

@interface YBZTargetWaitingViewController ()<EMCallManagerDelegate>

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic, strong)EMCallSession *callSession;

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层


@property (strong, nonatomic)  UIView *viewContainer;
@property (weak, nonatomic)  UIImageView *focusCursor; //聚焦光标
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *stateLabel;


@end

@implementation YBZTargetWaitingViewController
{
    NSString *localChar;
    NSString *targetChar;
    int secondsCountDown;
    int realCountDown;
    NSTimer *countDownTimer;
    int callCount;
    NSTimer *waterTimer;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    callCount=0;
    localChar=@"2";
    targetChar=@"1";
    realCountDown=4;

    self.view.backgroundColor=[UIColor whiteColor];
    waterTimer=[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(clickAnimation:) userInfo:nil repeats:YES];
    [self.view addSubview:self.viewContainer];
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.stateLabel];
}

//-(UIImageView *)userIconImageV
//{
//    if (!_userIconImageV) {
//        _userIconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-kScreenWith*0.168, kScreenHeight*0.02, kScreenWith*0.336, kScreenWith*0.336)];
//        _userIconImageV.backgroundColor = [UIColor clearColor];
//        _userIconImageV.layer.masksToBounds=YES;
//        _userIconImageV.layer.cornerRadius=kScreenWith*0.336/2.0f;
//    }
//    return _userIconImageV;
//}


-(void)viewWillAppear:(BOOL)animated{
//    self.callSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(40, 250, 200, 200)];
//    [self.view addSubview:self.callSession.localVideoView];
    [super viewWillAppear:animated];
    self.nameLabel.text=@"Simon";
    self.stateLabel.text=@"等待对方接听中...";
    self.viewContainer.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.headImageView.frame=CGRectMake(SCREEN_WIDTH*3/8-0.019*SCREEN_WIDTH, SCREEN_HEIGHT/2-0.019*SCREEN_WIDTH-0.1*SCREEN_HEIGHT, SCREEN_WIDTH/4+0.038*SCREEN_WIDTH, SCREEN_WIDTH/4+0.038*SCREEN_WIDTH);
    self.headImageView.layer.masksToBounds=YES;
    self.headImageView.layer.cornerRadius=SCREEN_WIDTH/8+0.019*SCREEN_WIDTH;
    self.headImageView.image=[UIImage imageNamed:@"head233"];
//    self.headImageView.backgroundColor=[UIColor greenColor];
    self.nameLabel.frame=CGRectMake(0.1*SCREEN_WIDTH, SCREEN_HEIGHT/2-0.019*SCREEN_WIDTH-0.1*SCREEN_HEIGHT+SCREEN_WIDTH/4+0.038*SCREEN_WIDTH+50, 0.8*SCREEN_WIDTH, 0.06*SCREEN_HEIGHT);
    self.stateLabel.frame=CGRectMake(0.1*SCREEN_WIDTH, SCREEN_HEIGHT/2-0.019*SCREEN_WIDTH-0.1*SCREEN_HEIGHT+SCREEN_WIDTH/4+0.038*SCREEN_WIDTH+50+0.06*SCREEN_HEIGHT+10, 0.8*SCREEN_WIDTH, 0.06*SCREEN_HEIGHT);
    self.cancelBtn.frame=CGRectMake(0.1*SCREEN_WIDTH, 0.857*SCREEN_HEIGHT, 0.8*SCREEN_WIDTH, 0.07*SCREEN_HEIGHT);
    
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        _captureSession=[[AVCaptureSession alloc]init];
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
            _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
        }
        //获得输入设备
        AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
        if (!captureDevice) {
            NSLog(@"取得后置摄像头时出现问题.");
            return;
        }
        
        
        NSError *error=nil;
        //根据输入设备初始化设备输入对象，用于获得输入数据
        _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
        if (error) {
            NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
            return;
        }
        //初始化设备输出对象，用于获得输出数据
        _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
        NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
        [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
        
        //将设备输入添加到会话中
        if ([_captureSession canAddInput:_captureDeviceInput]) {
            [_captureSession addInput:_captureDeviceInput];
        }
        
        //将设备输出添加到会话中
        if ([_captureSession canAddOutput:_captureStillImageOutput]) {
            [_captureSession addOutput:_captureStillImageOutput];
        }
        
        
        //创建视频预览层，用于实时展示摄像头状态
        _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
        
        CALayer *layer=self.viewContainer.layer;
        layer.masksToBounds=YES;
        
        _captureVideoPreviewLayer.frame=layer.bounds;
        _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
        //将视频预览层添加到界面中
        [layer addSublayer:_captureVideoPreviewLayer];
        //    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
        

        
    }else{
    
        [MBProgressHUD showError:@"获取摄像头信息失败"];
    
    }
    
    
    
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:localChar password:@"111111"];
    if (error==nil) {
        NSLog(@"注册成功");
    }
    
    EMError *error2 = [[EMClient sharedClient] loginWithUsername:localChar password:@"111111"];
    if (!error2) {
        NSLog(@"登录成功");
        [self sendbtnclick];
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
    

    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
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


-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
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


- (void)clickAnimation:(id)sender {
    __block GFWaterView *waterView = [[GFWaterView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/8, SCREEN_HEIGHT/2-0.1*SCREEN_HEIGHT, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
    
    waterView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:waterView];
    //    self.waterView = waterView;
    
    
    [UIView animateWithDuration:2 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 1.5, 1.5);
        
        waterView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [waterView removeFromSuperview];
    }];
    
}

-(void)sendbtnclick
{
    NSLog(@"发送视频通知!");
    
//    [MBProgressHUD showMessage:@"请求发送，等待接听"];
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

-(UIImageView *)headImageView{

    if(!_headImageView){
        _headImageView=[[UIImageView alloc]init];
        
    }
    return _headImageView;

}
-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn=[[UIButton alloc]init];
        _cancelBtn.backgroundColor=[UIColor redColor];
        //        NSString *stu_id = ApplicationDelegate.userSession;
        //        NSString *stu_pwd = ApplicationDelegate.userPsw;
       
        [_cancelBtn setTitle:@"挂断" forState:UIControlStateNormal];
        //[_exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_cancelBtn setFont:[UIFont systemFontOfSize:0.045*SCREEN_WIDTH]];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 0.05*SCREEN_WIDTH;
    }
    return _cancelBtn;
}

-(UIView *)viewContainer{

    if(!_viewContainer){
    
        _viewContainer=[[UIView alloc]init];
        _viewContainer.backgroundColor=[UIColor blackColor];
        
    }
    return _viewContainer;

}

-(UILabel *)nameLabel{

    if(!_nameLabel){
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.textColor=[UIColor whiteColor];
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        _nameLabel.font=[UIFont systemFontOfSize:0.055*SCREEN_WIDTH];
        _nameLabel.alpha=0.7;
    }
    return _nameLabel;
}
-(UILabel *)stateLabel{

    if(!_stateLabel){
        _stateLabel=[[UILabel alloc]init];
        _stateLabel.textColor=[UIColor whiteColor];
        _stateLabel.textAlignment=NSTextAlignmentCenter;
        _stateLabel.font=[UIFont systemFontOfSize:0.055*SCREEN_WIDTH];
        _stateLabel.alpha=0.7;
    }
    return _stateLabel;

}

-(void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];

}

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
        
        aSession.remoteVideoView=[[EMCallRemoteView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        aSession.remoteVideoView.scaleMode=EMCallViewScaleModeAspectFill;
        [self.view addSubview:aSession.remoteVideoView];
        
        [self.view sendSubviewToBack:aSession.remoteVideoView];
        [self.captureSession stopRunning];
        [self.viewContainer removeFromSuperview];
        [self.headImageView removeFromSuperview];
        [waterTimer invalidate];
        self.nameLabel.text=@"Simon 视频通话中...";
        self.stateLabel.text=@"01:20";
        aSession.localVideoView=[[EMCallLocalView alloc]initWithFrame:CGRectMake(20, 0, 210*SCREEN_WIDTH/SCREEN_HEIGHT, 210)];
        [self.view addSubview:aSession.localVideoView];
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
        
//        if(callCount<=5){
//            callCount++;
            secondsCountDown=realCountDown;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            
//        }else{
//            callCount=0;
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"请求超时，请重试"];
//            
//        }
        
        
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
