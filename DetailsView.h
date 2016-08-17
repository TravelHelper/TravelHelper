//
//  DetailsView.h
//  Test
//
//  Created by aGuang on 16/8/3.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailsView : UIViewController<AVAudioPlayerDelegate>
{
//    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
}

@property (nonatomic , strong) UIView *detailView;
@property (nonatomic , strong) UIImageView *userImage;
@property (nonatomic , strong) UILabel *userNameLabel;
@property (nonatomic , strong) UILabel *messageLabel;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *firstTranslateLabel;
@property (nonatomic , strong) UILabel *secondTranslateLabel;
@property (nonatomic , strong) UILabel *collectionTimeLabel;
@property (nonatomic , strong) UIImageView *audioImage;
@property (nonatomic , strong) UILabel *audioTimeLabel;
@property (nonatomic , strong) UIButton *playAudioButton;
@property (nonatomic , strong) AVAudioPlayer *player;

@property (nonatomic , strong) NSString *userNameText;
@property (nonatomic , strong) NSString *messageText;
@property (nonatomic , strong) NSString *collectionTimeText;
@property (nonatomic , strong) NSString *userImageText;
@property (nonatomic , strong) NSDictionary *detailsDictionary;

@property (nonatomic , assign) BOOL isPlaying;

@end
