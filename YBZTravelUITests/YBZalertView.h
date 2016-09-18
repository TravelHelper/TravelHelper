//
//  YBZalertView.h
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/10.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
@interface YBZalertView : UIView
@property (nonatomic,strong)UIImageView *picimageView;
@property (nonatomic,strong)UIImageView *titleimageView;
@property (nonatomic,strong)UILabel *nicknameLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *levelLabel;
@property (nonatomic,strong)UILabel *levelnumberLabel;
@property (nonatomic,strong)UILabel *activelLabel;
@property (nonatomic,strong)UILabel *activenumberLabel;
@property (nonatomic,strong)UILabel *languagetypeLabel;

@property (nonatomic,strong)UIImageView *triangleView;
@property (nonatomic,strong)UIImageView *triangleView2;

@property (nonatomic,strong)TQStarRatingView *starView;

@property (nonatomic,strong)UIButton *reservationBtn;

@property (nonatomic,strong)UIImageView *languageView;
@end
