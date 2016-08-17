//
//  InformationTableViewCell.h
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Information.h"
#import "CellInformation.h"

@interface InformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleTextLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *youBiLable;

- (void)setCellData:(Information *)Information
          CellInformation:(CellInformation *)CellInformation;
@end
