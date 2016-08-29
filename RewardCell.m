//
//  RewardCell.m
//  YBZTravel
//
//  Created by 孙锐 on 16/8/29.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "RewardCell.h"


@interface RewardCell()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *backgroundColorView;
@property (nonatomic, strong) UIImageView *answerCountImageView;
@property (nonatomic, strong) UILabel *answerCountLabel;
@end



@implementation RewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndModel:(NSDictionary *)model
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self getDataWithModel:model];
        [self setAllControlsFrame];
        [self addAllControls];
        [self showCountOfAnswerWithState:model[@"proceed_state"] AndCount:model[@"answer_list"]];
    }
    return self;
}

#pragma mark -----addSubview-----



-(void)getDataWithModel:(NSDictionary *)model{


    self.titleLabel.text = model[@"reward_title"];
    self.contentLabel.attributedText = [self getImageTextWithstr:model[@"reward_text"]];
    self.dateLabel.text = [self getDateWithCurrectFormat:model[@"release_time"]];
    self.moneyLabel.attributedText = [self getMoneyLabelTextWithMoney:model[@"reward_money"]];

    
}


-(void)showCountOfAnswerWithState:(NSString *)state AndCount:(NSString *)count{

    if ([state isEqualToString:@"1"]) {
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
        rightImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, 0.00874*SCREEN_HEIGHT, 0.041*SCREEN_WIDTH, 0.0262*SCREEN_HEIGHT);
        [self.backgroundColorView addSubview:rightImageView];
    }else if ([state isEqualToString:@"0"]){
        if (![count isEqualToString:@"0"]) {
            self.answerCountImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, 0.0157*SCREEN_HEIGHT, 0.058*SCREEN_WIDTH, 0.021*SCREEN_HEIGHT);
            [self.backgroundColorView addSubview:self.answerCountImageView];
            UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5+0.003*SCREEN_WIDTH, 0.0152*SCREEN_HEIGHT, 0.058*SCREEN_WIDTH, 0.021*SCREEN_HEIGHT)];
            numberLabel.text = count;
            numberLabel.font = [UIFont systemFontOfSize:0.014*SCREEN_HEIGHT];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [self.backgroundColorView addSubview:numberLabel];
        }
    }
}




-(NSAttributedString *)getImageTextWithstr:(NSString *)str{

    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"imgMyReward"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -0.0045*SCREEN_HEIGHT, SCREEN_WIDTH*0.04, SCREEN_HEIGHT*0.0205);
    // 创建带有图片的富文本
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc] initWithString:str];
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];

    return attri;
}

-(NSString *)getDateWithCurrectFormat:(NSString *)dateStr{

    NSArray *arr = [dateStr componentsSeparatedByString:@" "];
    NSString *str = [@"发布日期： " stringByAppendingString:arr[0]];
    return str;
}

-(NSMutableAttributedString *)getMoneyLabelTextWithMoney:(NSString *)money{

    NSString *string = [NSString stringWithFormat:@"悬 赏 金 额：%@.00 嗨 币",money];
    NSUInteger length = money.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,7)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8,length+3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(length+11,3)];
    return str;
}


-(void)setAllControlsFrame{

    
    self.backgroundColorView.frame = CGRectMake(0.0469*SCREEN_WIDTH, 0.00878*SCREEN_HEIGHT, 0.9062*SCREEN_WIDTH, 0.14*SCREEN_HEIGHT);
    CGSize textLabelSize;
    NSString *info = self.titleLabel.text;
    textLabelSize = [info boundingRectWithSize:CGSizeMake(0.74*SCREEN_WIDTH, 0.0422*SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.0422*SCREEN_WIDTH]} context:nil].size;

    self.titleLabel.frame = CGRectMake(0.086*SCREEN_WIDTH, 0.022*SCREEN_HEIGHT, textLabelSize.width, 0.0422*SCREEN_WIDTH);
    self.contentLabel.frame = CGRectMake(0.086*SCREEN_WIDTH, 0.0533*SCREEN_HEIGHT, 0.74*SCREEN_WIDTH, 0.0483*SCREEN_HEIGHT);
    self.dateLabel.frame = CGRectMake(0.086*SCREEN_WIDTH, 0.1168*SCREEN_HEIGHT, 0.39*SCREEN_WIDTH, 0.033*SCREEN_WIDTH);
    self.moneyLabel.frame = CGRectMake(0.508*SCREEN_WIDTH, 0.1168*SCREEN_HEIGHT, 0.445*SCREEN_WIDTH, 0.033*SCREEN_WIDTH);
}




-(void)addAllControls{

    [self addSubview:self.backgroundColorView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.moneyLabel];
}


#pragma mark -----getters-----

-(UILabel *)titleLabel{

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:220.0f/255.0f blue:0 alpha:1.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:0.0422*SCREEN_WIDTH];
    }
    return _titleLabel;
}


-(UILabel *)contentLabel{

    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:0.0344*SCREEN_WIDTH];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

-(UILabel *)dateLabel{

    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont systemFontOfSize:0.033*SCREEN_WIDTH];
    }
    return _dateLabel;
}

-(UILabel *)moneyLabel{

    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.font = [UIFont systemFontOfSize:0.033*SCREEN_WIDTH];
    }
    return _moneyLabel;
}

-(UIView *)backgroundColorView{

    if (!_backgroundColorView) {
        _backgroundColorView = [[UIView alloc]init];
        _backgroundColorView.backgroundColor = UIColorFromRGB(0x28243B);
        _backgroundColorView.layer.cornerRadius = 5.0;
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0.423*SCREEN_WIDTH, 0.111*SCREEN_HEIGHT, 0.00156*SCREEN_WIDTH, 0.014*SCREEN_HEIGHT)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_backgroundColorView addSubview:whiteView];
    }
    return _backgroundColorView;
}

-(UIImageView *)answerCountImageView{

    if (!_answerCountImageView) {
        _answerCountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"state2"]];
    }
    return _answerCountImageView;
}



@end
