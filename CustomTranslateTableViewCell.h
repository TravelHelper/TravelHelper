//
//  CustomTranslateTableViewCell.h
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTranslateInfoModel.h"
#import "CustomTranslateCellFramInfo.h"


@interface CustomTranslateTableViewCell : UITableViewCell

@property(nonatomic,strong)CustomTranslateCellFramInfo *framInfo;
@property(nonatomic,strong)CustomTranslateInfoModel *infoModel;

@property (nonatomic , strong)UILabel *langueKindLable;
@property (nonatomic , strong)UILabel *sceneLable;
@property (nonatomic , strong)UILabel *contentLable;
@property (nonatomic , strong)UILabel *interperLable;
@property (nonatomic , strong)UILabel *translateTimeLable;
@property (nonatomic , strong)UILabel *durationLable;
@property (nonatomic , strong)UILabel *offerMoneyLable;
@property (nonatomic , strong)UILabel *publishTimeLable;

@property (nonatomic , strong)UILabel *lageKLable;
@property (nonatomic , strong)UILabel *scLable;
@property (nonatomic , strong)UILabel *cntLable;
@property (nonatomic , strong)UILabel *itpLable;
@property (nonatomic , strong)UILabel *tslTimeLable;
@property (nonatomic , strong)UILabel *drtLable;
@property (nonatomic , strong)UILabel *ofmLable;
@property (nonatomic , strong)UILabel *pbmLable;
@property (nonatomic , strong)UIImageView *tagImgView;
@property (nonatomic , strong)UIImageView *threeWhiteImgView;

@property (nonatomic , strong)NSString *cellKind;
@property (nonatomic , strong)NSString *customID;
@property (nonatomic , strong)NSString *user_id;

@property (nonatomic , strong)UILabel *jeLable;
@property(nonatomic ,strong)UIView *cellView;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                 contentModel:(CustomTranslateInfoModel *)infoModel;

@end
