//
//  CustomTranslateTableViewCell.m
//  YBZTravel
//
//  Created by 李连芸 on 16/9/17.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "CustomTranslateTableViewCell.h"
#define kScreenWidth   [[UIScreen mainScreen]bounds].size.width

@implementation CustomTranslateTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                 contentModel:(CustomTranslateInfoModel *)infoModel
{
    self = [super init];
    if (self) {
        self.framInfo = [[CustomTranslateCellFramInfo alloc]initWithInfoModel:infoModel];
        self.backgroundColor = [UIColor clearColor];
        [self customCellContent:infoModel andCellFram:self.framInfo];
        self.customID = infoModel.customID;
        self.user_id = infoModel.user_id;
        
        [self addSubview:self.cellView];
        [self addSubview:self.tagImgView];
        [self addSubview:self.langueKindLable];
        [self addSubview:self.lageKLable];
        [self addSubview:self.sceneLable];
        [self addSubview:self.scLable];
        [self addSubview:self.contentLable];
        [self addSubview:self.cntLable];
        [self addSubview:self.interperLable];
        [self addSubview:self.itpLable];
        [self addSubview:self.translateTimeLable];
        [self addSubview:self.tslTimeLable];
        [self addSubview:self.durationLable];
        [self addSubview:self.drtLable];
        [self addSubview:self.offerMoneyLable];
        [self addSubview:self.jeLable];
        [self addSubview:self.ofmLable];
        [self addSubview:self.publishTimeLable];
        [self addSubview:self.pbmLable];
        [self addSubview:self.threeWhiteImgView];
        
        
        [self.tagImgView setImage:[UIImage imageNamed:self.cellKind]];
        
    }
    return self;
}

-(void)customCellContent:(CustomTranslateInfoModel *)infoModel
             andCellFram:(CustomTranslateCellFramInfo *)framInfo
{
    self.infoModel = infoModel;
    
    NSString *tagImgName = @"用户翻译-我的定制列表";
    self.cellKind = [tagImgName stringByAppendingString:infoModel.cellKind];
    
    self.threeWhiteImgView.frame = CGRectMake(kScreenWidth*0.27, kScreenWidth*0.067, kScreenWidth*0.067, kScreenWidth*0.023);
    
    self.lageKLable.frame = framInfo.lageKFrame;
    self.lageKLable.text = @"语种:";
    self.lageKLable.font = FONT_12;
    self.lageKLable.textColor = [UIColor colorWithRed:250.0/255.0f green:217.0/255.0f blue:0.0/255.0f alpha:1];
    self.langueKindLable.frame = framInfo.langueKindLableFrame;
    self.langueKindLable.text = infoModel.langueKind;
    [self.langueKindLable setAdjustsFontSizeToFitWidth:YES];
    self.langueKindLable.font = FONT_12;
    self.langueKindLable.textColor = [UIColor colorWithRed:250.0/255.0f green:217.0/255.0f blue:0.0/255.0f alpha:1];
    
    self.sceneLable.frame = framInfo.sceneLableFrame;
    self.sceneLable.text = infoModel.scene;
    [self.sceneLable setAdjustsFontSizeToFitWidth:YES];
    self.sceneLable.font = FONT_12;
    self.sceneLable.textColor = [UIColor whiteColor];
    self.scLable.frame = framInfo.scFrame;
    self.scLable.text = @"场景:";
    self.scLable.font = FONT_12;
    self.scLable.textColor = [UIColor whiteColor];
    
    self.contentLable.frame = framInfo.contentLableFrame;
    self.contentLable.text = infoModel.content;
    [self.contentLable setAdjustsFontSizeToFitWidth:YES];
    self.contentLable.font = FONT_10;
    self.contentLable.textColor = [UIColor whiteColor];
    self.cntLable.frame = framInfo.cntFrame;
    self.cntLable.text = @"内容:";
    self.cntLable.font = FONT_10;
    self.cntLable.textColor = [UIColor whiteColor];
    
    self.interperLable.frame = framInfo.interperLableFrame;
    self.interperLable.text = infoModel.interper;
    [self.interperLable setAdjustsFontSizeToFitWidth:YES];
    self.interperLable.font = FONT_10;
    self.interperLable.textColor = [UIColor whiteColor];
    self.itpLable.frame = framInfo.itpFrame;
    self.itpLable.text = @"应邀议员:";
    self.itpLable.font = FONT_10;
    self.itpLable.textColor = [UIColor whiteColor];
    
    self.translateTimeLable.frame = framInfo.translateTimeLableFrame;
    self.translateTimeLable.text = infoModel.translateTime;
    self.translateTimeLable.font = FONT_10;
    self.translateTimeLable.textColor = [UIColor whiteColor];
    self.tslTimeLable.frame = framInfo.tslTimeFrame;
    self.tslTimeLable.text = @"定翻时间:";
    self.tslTimeLable.font = FONT_10;
    self.tslTimeLable.textColor = [UIColor whiteColor];
    
    self.durationLable.frame = framInfo.durationLableFrame;
    self.durationLable.text = infoModel.duration;
    self.durationLable.font = FONT_10;
    self.durationLable.textColor = [UIColor whiteColor];
    self.drtLable.frame = framInfo.drtFrame;
    self.drtLable.text = @"时长:";
    self.drtLable.font = FONT_10;
    self.drtLable.textColor = [UIColor whiteColor];
    
    self.offerMoneyLable.frame = framInfo.offerMoneyLableFrame;
    self.offerMoneyLable.text = infoModel.offerMoney;
    [self.offerMoneyLable sizeToFit];
    self.offerMoneyLable.font = FONT_10;
    self.offerMoneyLable.textColor = [UIColor colorWithRed:250.0/255.0f green:217.0/255.0f blue:0.0/255.0f alpha:1];
    self.jeLable.frame = CGRectMake(CGRectGetMaxX(self.offerMoneyLable.frame), CGRectGetMinY(self.offerMoneyLable.frame), self.offerMoneyLable.frame.size.width, self.offerMoneyLable.frame.size.height);
    self.jeLable.font = FONT_10;
    self.jeLable.text = @"嗨币";
    self.jeLable.textColor = [UIColor whiteColor];
    self.ofmLable.frame = framInfo.ofmFrame;
    self.ofmLable.text = @"提供金额:";
    self.ofmLable.font = FONT_10;
    self.ofmLable.textColor = [UIColor whiteColor];
    
    self.publishTimeLable.frame = framInfo.publishTimeLableFrame;
    self.publishTimeLable.text = infoModel.publishTime;
    self.publishTimeLable.font = FONT_10;
    self.publishTimeLable.textColor = [UIColor whiteColor];
    self.pbmLable.frame = framInfo.pbmFrame;
    self.pbmLable.text = @"发布日期:";
    self.pbmLable.font = FONT_10;
    self.pbmLable.textColor = [UIColor whiteColor];
    
    self.tagImgView.frame = framInfo.tagImgViewFrame;
    
    self.cellView.frame = framInfo.cellViewFram;
    
}


-(UIView *)cellView{
    
    if (!_cellView){
        _cellView = [[UIView alloc]init];
        _cellView.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:67.0f/255.0f blue:121.0f/255.0f alpha:0.95];
        _cellView.layer.cornerRadius = 5.0;
    }
    return _cellView;
}

-(UIView *)tagImgView{
    
    if (!_tagImgView){
        _tagImgView = [[UIImageView alloc]init];
    }
    return _tagImgView;
}
-(UIView *)threeWhiteImgView{
    
    if (!_threeWhiteImgView){
        _threeWhiteImgView = [[UIImageView alloc]init];
        [_threeWhiteImgView setImage:[UIImage imageNamed:@"threewhite"]];
        
    }
    return _threeWhiteImgView;
}
-(UILabel *)langueKindLable{
    
    if (!_langueKindLable){
        _langueKindLable = [[UILabel alloc]init];
    }
    return _langueKindLable;
}

-(UILabel *)lageKLable{
    
    if (!_lageKLable){
        _lageKLable = [[UILabel alloc]init];
    }
    return _lageKLable;
}
-(UILabel *)sceneLable{
    
    if (!_sceneLable){
        _sceneLable = [[UILabel alloc]init];
    }
    return _sceneLable;
}
-(UILabel *)scLable{
    
    if (!_scLable){
        _scLable = [[UILabel alloc]init];
    }
    return _scLable;
}
-(UILabel *)contentLable{
    
    if (!_contentLable){
        _contentLable = [[UILabel alloc]init];
    }
    return _contentLable;
}
-(UILabel *)cntLable{
    
    if (!_cntLable){
        _cntLable = [[UILabel alloc]init];
    }
    return _cntLable;
}
-(UILabel *)interperLable{
    
    if (!_interperLable){
        _interperLable = [[UILabel alloc]init];
    }
    return _interperLable;
}
-(UILabel *)itpLable{
    
    if (!_itpLable){
        _itpLable = [[UILabel alloc]init];
    }
    return _itpLable;
}
-(UILabel *)translateTimeLable{
    
    if (!_translateTimeLable){
        _translateTimeLable = [[UILabel alloc]init];
    }
    return _translateTimeLable;
}
-(UILabel *)tslTimeLable{
    
    if (!_tslTimeLable){
        _tslTimeLable = [[UILabel alloc]init];
    }
    return _tslTimeLable;
}
-(UILabel *)durationLable{
    
    if (!_durationLable){
        _durationLable = [[UILabel alloc]init];
    }
    return _durationLable;
}
-(UILabel *)drtLable{
    
    if (!_drtLable){
        _drtLable = [[UILabel alloc]init];
    }
    return _drtLable;
}
-(UILabel *)offerMoneyLable{
    
    if (!_offerMoneyLable){
        _offerMoneyLable = [[UILabel alloc]init];
    }
    return _offerMoneyLable;
}
-(UILabel *)ofmLable{
    
    if (!_ofmLable){
        _ofmLable = [[UILabel alloc]init];
    }
    return _ofmLable;
}
-(UILabel *)publishTimeLable{
    
    if (!_publishTimeLable){
        _publishTimeLable = [[UILabel alloc]init];
    }
    return _publishTimeLable;
}
-(UILabel *)pbmLable{
    
    if (!_pbmLable){
        _pbmLable = [[UILabel alloc]init];
    }
    return _pbmLable;
}

-(UILabel *)jeLable{
    
    if (!_jeLable){
        _jeLable = [[UILabel alloc]init];
    }
    return _jeLable;
}

@end
