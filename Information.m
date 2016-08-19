//
//  Information.m
//  Moneybag
//
//  Created by sks on 16/8/3.
//  Copyright © 2016年 liuzhongyi. All rights reserved.
//

#import "Information.h"

@implementation Information

- (instancetype)initWitTitleText:(NSString *)titleText
                            time:(NSString *)time
                            youBi:(NSString *)youBi
{
    self = [super init];
    if (self) {
        
        self.titleText = titleText;
        self.time= time;
        self.youBi = youBi;
    }
    return self;
}


@end
