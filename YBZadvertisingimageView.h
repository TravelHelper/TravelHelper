//
//  YBZadvertisingimageView.h
//  YBZTravel
//
//  Created by 王俊钢 on 16/9/22.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBZadvertisingimageView;

@protocol YBZadvertisingimageViewDelegate <NSObject>

-(void)closeImageBtnClick:(YBZadvertisingimageView *)aCell;

@end

@interface YBZadvertisingimageView : UIImageView
@property (nonatomic,strong) UIButton *delbtn;
@property(nonatomic,assign)id<YBZadvertisingimageViewDelegate>delegate;


-(void)closebtnclick;
@end
