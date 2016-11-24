//
//  AnswerCell.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/25.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "AnswerCell.h"
#import "WebAgent.h"
#import "UIImageView+WebCache.h"

@interface AnswerCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *answerContentLabel;
@property (nonatomic, strong) UILabel *answerTimeLabel;


@end


@implementation AnswerCell{

    boolean_t needChoose;
    NSDictionary *data;
    NSString *acceptID;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Model:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        data = dict;
        if ([dict[@"proceed_state"]isEqualToString:@"0"]) {
            needChoose = YES;
            acceptID = @"";
        }else{
            needChoose = NO;
            acceptID = data[@"accept_id"];
        }

        [self setAllControlsFrame];

        NSLog(@"%@",data[@"answer_time"]);
        
    }
    return self;
}



-(void)layoutIfNeeded{

    [self addAllControls];
    self.headImageView.frame = CGRectMake(0.034*SCREEN_WIDTH, 0.034*SCREEN_WIDTH, 0.111*SCREEN_WIDTH, 0.111*SCREEN_WIDTH);
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 0.111*SCREEN_WIDTH/2;
    NSString *userID = data[@"user_id"];
    NSString *str = [NSString stringWithFormat:@"http://139.224.44.36/TravelHelper/uploadimg/%@.jpg",userID];
    NSURL *headImgUrl = [NSURL URLWithString:str];
    [self.headImageView sd_setImageWithURL:headImgUrl placeholderImage:[UIImage imageNamed:@"HaveFun"]];
    [self addSubview:self.headImageView];

    
    
    

}




-(void)setAllControlsFrame{




    self.nameLabel.frame = CGRectMake(0.157*SCREEN_WIDTH, 0.034*SCREEN_HEIGHT, SCREEN_WIDTH-0.151*SCREEN_WIDTH, 0.021*SCREEN_HEIGHT);
    CGSize textLabelSize;
    NSString *info = self.answerContentLabel.text;
    textLabelSize = [info boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-0.167*SCREEN_WIDTH,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.02*SCREEN_HEIGHT]} context:nil].size;
    
    self.answerContentLabel.frame = CGRectMake(0.157*SCREEN_WIDTH, 0.07666*SCREEN_HEIGHT, SCREEN_WIDTH-0.187*SCREEN_WIDTH, textLabelSize.height);
    self.answerTimeLabel.frame = CGRectMake(0.157*SCREEN_WIDTH, 0.07666*SCREEN_HEIGHT+textLabelSize.height + 0.009*SCREEN_HEIGHT, SCREEN_WIDTH/3, 0.035*SCREEN_HEIGHT);
    self.acceptBtn.frame = CGRectMake(0.8*SCREEN_WIDTH, 0.08*SCREEN_HEIGHT+textLabelSize.height + 0.009*SCREEN_HEIGHT, 0.151*SCREEN_WIDTH, 0.038*SCREEN_HEIGHT);
    CGFloat sizeHeight = CGRectGetMaxY(self.acceptBtn.frame);
    self.height = sizeHeight + 0.017*SCREEN_HEIGHT;
}

-(void)addAllControls{
    [self addSubview:self.nameLabel];
    [self addSubview:self.answerTimeLabel];
    [self addSubview:self.answerContentLabel];
    if (needChoose == YES) {
        [self addSubview:self.acceptBtn];
    }else{
        if ([data[@"answer_id"] isEqualToString:acceptID]) {
            UIImageView *chooseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"已采纳"]];
            chooseImageView.frame = self.acceptBtn.frame;
            [self addSubview:chooseImageView];
        }
    }
}

-(void)acceptAnswerBtnClick{

    
    [WebAgent upLoadMyChoose:data[@"answer_id"] AndRewardId:data[@"reward_id"] success:^(id responseObject) {
    
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.acceptBtn removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedToReloadData" object:nil];
        UIImageView *chooseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"已采纳"]];
        chooseImageView.frame = self.acceptBtn.frame;
        [self addSubview:chooseImageView];
        [WebAgent getBiWithID:dict[@"data"] andPurchaseCount:dict[@"money"] andSource_id:@"0003" success:^(id responseObject) {
            [WebAgent sendRemoteNotificationsWithuseId:dict[@"data"] WithsendMessage:@"您有一个悬赏的回答被采纳" WithType:@"0006" WithSenderID:@"" WithMessionID:@""  WithLanguage :  @"language" success:^(id responseObject) {
                NSLog(@"反馈推送—匹配成功通知成功！");
            } failure:^(NSError *error) {
                NSLog(@"反馈推送－匹配成功通知失败－－>%@",error);
            }];
        } failure:^(NSError *error) {
            NSLog(@"wangluocuowu");
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
}



#pragma mark -----getters-----
-(UIImageView *)headImageView{

    if (!_headImageView) {
/*            NSString *userID = data[@"user_id"];
            NSString *str = [NSString stringWithFormat:@"http://139.224.44.36/TravelHelper/uploadimg/%@.jpg",userID];
            NSURL *headImgUrl = [NSURL URLWithString:str];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:headImgUrl]];
            if (img != nil) {
                _headImageView = [[UIImageView alloc]initWithImage:img];
            }else{
 */
                _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HaveFun"]];
 //           }
    }


    return _headImageView;
}

-(UILabel *)nameLabel{

    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = data[@"user_nickname"];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:0.02*SCREEN_HEIGHT];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

-(UILabel *)answerContentLabel{

    if (!_answerContentLabel) {
        _answerContentLabel = [[UILabel alloc]init];
        _answerContentLabel.text = data[@"answer_text"];
        _answerContentLabel.textColor = [UIColor grayColor];
        _answerContentLabel.font = [UIFont systemFontOfSize:0.02*SCREEN_HEIGHT];
        _answerContentLabel.textAlignment = NSTextAlignmentLeft;
        _answerContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _answerContentLabel.numberOfLines = 0;

    }
    return _answerContentLabel;
}

-(UILabel *)answerTimeLabel{
    
    if (!_answerTimeLabel) {
        _answerTimeLabel = [[UILabel alloc]init];
        _answerTimeLabel.text = data[@"answer_time"];
        _answerTimeLabel.textAlignment = NSTextAlignmentLeft;
        _answerTimeLabel.textColor = [UIColor grayColor];
        _answerTimeLabel.font = [UIFont systemFontOfSize:0.034*SCREEN_WIDTH];
    }
    return _answerTimeLabel;
}

-(UIButton *)acceptBtn{

    if (!_acceptBtn) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptBtn setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        [_acceptBtn addTarget:self action:@selector(acceptAnswerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptBtn;
}


@end
