//
//  DetailsView.m
//  Test
//
//  Created by aGuang on 16/8/3.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "DetailsView.h"
#import <AudioToolbox/AudioToolbox.h>
#define kSubViewHorizontalMargin    10
#define kSubViewVerticalMargin      10
#define kImageViewWidth             44
#define kImageViewHeight            44

@interface DetailsView ()

@end

@implementation DetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:204.0f/255.0f alpha:1];
    [self.view addSubview:self.detailView];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//从扬声器播放
//    NSString *string = [[NSBundle mainBundle] pathForResource:@"男孩别哭 - 海龟先生" ofType:@"mp3"];
//    NSLog(@"%@",string);
//    NSURL *url = [[NSURL alloc]initWithString:string];
//    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    self.player.delegate = self;
//    self.player.numberOfLoops = 1;//播放次数
//    self.player.volume = 1;//初始音量
    
    self.isPlaying = YES;
    
    // Do any additional setup after loading the view.
}

-(UIView *)detailView
{
    if(!_detailView)
    {
        _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width, self.collectionTimeLabel.frame.origin.y + self.collectionTimeLabel.frame.size.height + 10)];
        _detailView.backgroundColor = [UIColor whiteColor];
        
        [self.detailView addSubview:self.userImage];
        [self.detailView addSubview:self.userNameLabel];
        
        if([self.detailsDictionary[@"Type"] isEqualToString:@"text"])
        {
            [self.detailView addSubview:self.messageLabel];
        }
        else
        {
            [self.detailView addSubview:self.audioImage];
        }
        [self.detailView addSubview:self.titleLabel];
        [self.detailView addSubview:self.firstTranslateLabel];
        [self.detailView addSubview:self.secondTranslateLabel];
        [self.detailView addSubview:self.collectionTimeLabel];
    }
    return _detailView;
}
-(UIImageView *)userImage
{
    if(!_userImage)
    {
        _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin,  kSubViewVerticalMargin, kImageViewWidth, kImageViewWidth)];
        _userImage.image = [UIImage imageNamed:self.detailsDictionary[@"UserImage"]];
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.cornerRadius = 44.0/2.0f;
        _userImage.layer.borderWidth = 1.0f;
    }
    return _userImage;
}
-(UILabel *)userNameLabel
{
    if(!_userNameLabel)
    {
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userImage.frame.origin.x + self.userImage.frame.size.width + kSubViewHorizontalMargin, 2 * kSubViewVerticalMargin, 200, 30)];
        _userNameLabel.text = self.detailsDictionary[@"UserName"];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _userNameLabel;
}
-(UILabel *)messageLabel
{
    if(!_messageLabel)
    {
        CGFloat messageW = [UIScreen mainScreen].bounds.size.width - 2 * kSubViewHorizontalMargin;
        CGSize size = [self.detailsDictionary[@"Message"] boundingRectWithSize:CGSizeMake(messageW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.userImage.frame.origin.y + self.userImage.frame.size.height , size.width, size.height)];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;//顺序问题 导致不能换行
        _messageLabel.text = self.detailsDictionary[@"Message"];
    }
    return _messageLabel;
}
-(UIImageView *)audioImage
{
    if (!_audioImage) {
        _audioImage = [[UIImageView alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.userImage.frame.origin.y + self.userImage.frame.size.height + kSubViewVerticalMargin, [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 70)];
        _audioImage.backgroundColor = [UIColor lightGrayColor];
        //image点击事件
        [_audioImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(audioImageClick:)];
        [_audioImage addGestureRecognizer:click];
//        _playAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playAudioButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 70)];
//        [_playAudioButton setTitle:@"播放" forState:UIControlStateNormal];
//        _playAudioButton.backgroundColor = [UIColor redColor];
//        [_playAudioButton addTarget:self action:@selector(playAudioButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_audioImage addSubview:_playAudioButton];
        
        _audioTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 50, 20)];
        _audioTimeLabel.text = self.detailsDictionary[@"AudioTime"];
        [_audioImage addSubview:_audioTimeLabel];
    }
    return _audioImage;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        if([self.detailsDictionary[@"Type"] isEqualToString:@"text"])
        {
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height , [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 30)];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.text = @"译员翻译:";
        }
        else
        {
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.audioImage.frame.origin.y + self.audioImage.frame.size.height , [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 30)];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.text = @"译员翻译:";
        }
    }
    return _titleLabel;
}
-(UILabel *)firstTranslateLabel
{
    if(!_firstTranslateLabel)
    {
        CGFloat messageW = [UIScreen mainScreen].bounds.size.width - 2 * kSubViewHorizontalMargin;
        CGSize size = [self.detailsDictionary[@"FirstTranslate"] boundingRectWithSize:CGSizeMake(messageW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        _firstTranslateLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, size.width, size.height)];
        _firstTranslateLabel.numberOfLines = 0;
        _firstTranslateLabel.lineBreakMode = NSLineBreakByWordWrapping;//顺序问题 导致不能换行
        _firstTranslateLabel.text = self.detailsDictionary[@"FirstTranslate"];
    }
    return _firstTranslateLabel;
}
-(UILabel *)secondTranslateLabel
{
    if(!_secondTranslateLabel)
    {
        CGFloat messageW = [UIScreen mainScreen].bounds.size.width - 2 * kSubViewHorizontalMargin;
        CGSize size = [self.detailsDictionary[@"SecondTranslate"] boundingRectWithSize:CGSizeMake(messageW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        _secondTranslateLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.firstTranslateLabel.frame.origin.y + self.firstTranslateLabel.frame.size.height , size.width, size.height)];
        _secondTranslateLabel.numberOfLines = 0;
        _secondTranslateLabel.lineBreakMode = NSLineBreakByWordWrapping;//顺序问题 导致不能换行
        _secondTranslateLabel.text = self.detailsDictionary[@"SecondTranslate"];
    }
    return _secondTranslateLabel;
}
-(UILabel *)collectionTimeLabel
{
    if(!_collectionTimeLabel)
    {
        _collectionTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(2 * kSubViewHorizontalMargin, self.secondTranslateLabel.frame.origin.y + self.secondTranslateLabel.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 4 * kSubViewHorizontalMargin, 30)];
        NSString *wenzi = @"收藏于";
        _collectionTimeLabel.font = [UIFont systemFontOfSize:16];
        _collectionTimeLabel.text = [NSString stringWithFormat:@"%@%@",wenzi,self.detailsDictionary[@"Time"]];
    }
    return _collectionTimeLabel;
}
-(void)audioImageClick:(NSString *)URLString
{
    NSLog(@"----->>>>>点了点了");
    if(self.isPlaying == YES)
    {
        [self play];
    }
    else
    {
        [self stop];
    }
    
    
//        NSError *playerError;
//        //初始化播放器
//        NSURL *URL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:URLString]];
//    
//        NSLog(@"播放路径：：：%@",URL);
//    
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&playerError];
//    
//        if (player == nil)
//        {
//            NSLog(@"Error creating player: %@", [playerError description]);
//        }
//        //设置播放器代理
//        player.delegate = self;
//        //设置从扬声器播放
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
//        if([player isPlaying] && self.isPlaying == YES)
//        {
//            [player stop];
//            self.isPlaying = NO;
//            [self.playAudioButton setTitle:@"播放" forState:UIControlStateNormal];
//        }
//        //If the track is not player, play the track and change the play button to "Pause"
//        else
//        {
//            [player play];
//            self.isPlaying = YES;
//            NSLog(@"%d",(int)player.duration);
//            [self.playAudioButton setTitle:@"暂停" forState:UIControlStateNormal];
//        }
}
//播放
- (void)play
{
    [self.player play];
}
//暂停
- (void)stop
{
    self.player.currentTime = 0;
    [self.player stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
