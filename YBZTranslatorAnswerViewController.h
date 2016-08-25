//
//  YBZTranslatorAnswerViewController.h
//  YBZTravel
//
//  Created by sks on 16/8/14.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZBaseViewController.h"
#import "WebAgent.h"

@interface YBZTranslatorAnswerViewController : YBZBaseViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage     *previewImg;
@property (nonatomic,strong) NSString    *rewardID;
@property (nonatomic,strong) NSString    *reward_id;
@end
