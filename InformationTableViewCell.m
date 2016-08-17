//
//  InformationTableViewCell.m
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "InformationTableViewCell.h"

@interface InformationTableViewCell ()


@property (nonatomic , strong) Information *information;
@property (nonatomic , strong) CellInformation *cellInformation;

@end

@implementation InformationTableViewCell

- (void)setCellData:(Information *)Information
          CellInformation:(CellInformation *)CellInformation
{
    self.information = Information;
    self.cellInformation = CellInformation;
    self.titleTextLable.text = self.information.titleText;
    self.timeLable.text = self.information.time;
    NSMutableAttributedString *youBistr = [[NSMutableAttributedString alloc] initWithString:self.information.youBi];
    [youBistr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,self.information.youBi.length)];
    [self.youBiLable setAttributedText:youBistr] ;

    
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //[self sendStarValue];
    
    self.titleTextLable.frame = self.cellInformation.titleTextLableFrame;
    self.timeLable.frame = self.cellInformation.timeLabelFrame;
    self.youBiLable.frame = self.cellInformation.youBiLableFrame;
}


@end
