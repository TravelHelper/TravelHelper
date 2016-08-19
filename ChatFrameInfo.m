//
//  ChatFrameInfo.m
//  CharttingController
//
//  Created by tjufe on 16/7/13.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "ChatFrameInfo.h"

@implementation ChatFrameInfo

#define kScreenWith  [UIScreen mainScreen].bounds.size.width
#define kScreenHMargin  20
#define kScreenVMargin  14
#define kTouXiangX  kScreenWith*0.044
#define kTouXiangY  10
#define kTouXiangL  kScreenWith*0.111
#define kTouXiangX2  kScreenWith*0.845
#define kQiPaoX kScreenWith*0.18

-(instancetype)initWithModel:(ChatModel *)model{
    
    self = [super init];
    if (self) {
        [self getCellAllControllerFrameWithModel:model];
    }
    return self;
}

//获得一条聊天信息所有控件的Frame

-(void)getCellAllControllerFrameWithModel:(ChatModel *)model{
    
    if ([model.chatContentType isEqualToString:@"text"]) {
        
        [self getObjectFrameOfTextViewWithChatContentType:model.chatContentType AndInfo:model.chatTextContent];
        
    }
    
    if ([model.chatContentType isEqualToString:@"picture"]) {
        
        [self getObjectFrameOfTextViewWithChatContentType:model.chatContentType AndInfo:model.chatPictureURLContent];
        
    }
    
    if ([model.chatContentType isEqualToString:@"audio"]) {
        
        [self getObjectFrameOfTextViewWithChatContentType:model.chatContentType AndInfo:model.chatAudioContent];
        
    }
    
    [self getHeadViewFrameWithisSender:model.isSender];
    
    [self getHeadImageViewFrame];
    
    [self getTextViewFrameWithisSender:model.isSender AndChatContent:model.chatContentType];
    
    
    
    [self getReadTranstorStringResultBtnFrame:model isSender:model.isSender];
    [self getSencondLabelFrame:model];
    [self getAVtoStringLabelFrame:model];
    if (self.chatTextLabelFrame.size.height == 0) {
        self.cellHeight = 2*kTouXiangY + kTouXiangL + self.AVtoStringLabelFrame.size.height;
    }else{
        self.cellHeight = 2*kTouXiangY + self.chatTextViewFrame.size.height;
    }
    
}

#pragma mark - green + black

//获取用户语音转文字的文字label－－Frame
-(void)getAVtoStringLabelFrame:(ChatModel *)model{
    
    if ([model.chatContentType isEqualToString:@"audio"]) {
        
        CGSize textLableSize;
        
        textLableSize = [model.AVtoStringContent boundingRectWithSize:CGSizeMake(kScreenWith*0.6, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} context:nil].size;
        
        if (model.isSender == 0) {
            self.AVtoStringLabelFrame = CGRectMake(CGRectGetMinX(self.chatTextViewFrame), CGRectGetMaxY(self.chatTextViewFrame), textLableSize.width, textLableSize.height);
        }else{
            if ((kScreenWith*0.277-2*kScreenVMargin) <textLableSize.width) {
                self.AVtoStringLabelFrame = CGRectMake(CGRectGetMaxX(self.chatTextViewFrame)-textLableSize.width, CGRectGetMaxY(self.chatTextViewFrame), textLableSize.width, textLableSize.height);
            }else{
                self.AVtoStringLabelFrame = CGRectMake(CGRectGetMinX(self.chatTextViewFrame)+8, CGRectGetMaxY(self.chatTextViewFrame), textLableSize.width, textLableSize.height);
            }
        }
    }
}

#pragma mark - y播放译员翻译文字

-(void)getReadTranstorStringResultBtnFrame:(ChatModel *)model isSender:(BOOL)isSender{
    
    NSString *identifier = model.sendIdentifier;
    
    if ([model.chatContentType isEqualToString:@"text"]) {
        if (isSender == 0) {
            if ([identifier isEqualToString:@"TRANSTOR"] || [identifier isEqualToString:@"FREETRANS"]) {
                self.transtorTextReadBtnFram = CGRectMake(CGRectGetMaxX(self.chatTextViewFrame)-23, kTouXiangY+kScreenVMargin+0.5*self.chatTextLabelFrame.size.height-0.022*kScreenWith,0.044*kScreenWith, 0.044*kScreenWith);
            }
        }else{
            if ([identifier isEqualToString:@"TRANSTOR"] || [identifier isEqualToString:@"FREETRANS"]) {
                self.transtorTextReadBtnFram = CGRectMake(CGRectGetMinX(self.chatTextViewFrame) +8  , kTouXiangY+kScreenVMargin+0.5*self.chatTextLabelFrame.size.height-0.022*kScreenWith, 0.044*kScreenWith, 0.044*kScreenWith);
            }
        }
    }
    
}

#pragma mark - 秒数

-(void)getSencondLabelFrame:(ChatModel *)model{
    
    if (model.isSender == 0) {
        if ([model.chatContentType isEqualToString:@"audio"]) {
            self.secondLableFrame = CGRectMake(kScreenWith*0.254, kTouXiangL*0.25, 20, kTouXiangL);
        }
    }else{
        if ([model.chatContentType isEqualToString:@"audio"]) {
            self.secondLableFrame = CGRectMake(kScreenWith*0.746-20,kTouXiangL*0.25, 20, kTouXiangL);
        }
    }
    
}

#pragma mark - 头像

-(void)getHeadViewFrameWithisSender:(BOOL)isSender{
    
    if (isSender == 0) {
        self.headBgViewFrame = CGRectMake(kTouXiangX,kTouXiangY,kTouXiangL, kTouXiangL);
    }else{
        self.headBgViewFrame = CGRectMake(kTouXiangX2,kTouXiangY,kTouXiangL, kTouXiangL);
    }
}

#pragma mark - 聊天气泡

-(void)getTextViewFrameWithisSender:(BOOL)isSender AndChatContent:(NSString *)chatContentType{
    
    if (isSender == 0) {
        
        if ([chatContentType isEqualToString:@"text"]) {
            
            self.chatTextViewFrame = CGRectMake(kQiPaoX, kTouXiangY, self.chatTextLabelFrame.size.width + 2*kScreenHMargin + 8, self.chatTextLabelFrame.size.height + kScreenVMargin*2);
        }
        
        if ([chatContentType isEqualToString:@"picture"]) {
            
            NSLog(@"这是一张图片");
            
        }
        
        if ([chatContentType isEqualToString:@"audio"]) {
            self.chatTextViewFrame = CGRectMake(kQiPaoX,kTouXiangY, kScreenWith*0.277, kTouXiangL);
        }
        
    }else{
        
        if ([chatContentType isEqualToString:@"text"]) {
            
            self.chatTextViewFrame = CGRectMake(kScreenWith*0.82-self.chatTextLabelFrame.size.width - 2*kScreenHMargin, kTouXiangY, self.chatTextLabelFrame.size.width +2*kScreenHMargin,self.chatTextLabelFrame.size.height + kScreenVMargin*2);
        }
        
        if ([chatContentType isEqualToString:@"picture"]) {
            
            NSLog(@"这是一张图片");
            
        }
        
        if ([chatContentType isEqualToString:@"audio"]) {
            
            self.chatTextViewFrame = CGRectMake(kScreenWith*(1-0.166-0.277), kTouXiangY, kScreenWith*0.277, kTouXiangL);
        }
        
    }
}

#pragma mark - 头像

-(void)getHeadImageViewFrame{
    
    self.headImageViewFrame = CGRectMake(0, 0, kTouXiangL , kTouXiangL );
}

#pragma mark - 气泡(text，Pickture，Audio)

-(void)getObjectFrameOfTextViewWithChatContentType:(NSString *)chatContentType AndInfo:(NSString *)info{
    
    if ([chatContentType isEqualToString:@"text"]) {
        
        CGSize textLableSize;
        
        textLableSize = [info boundingRectWithSize:CGSizeMake(180, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} context:nil].size;
        
        self.chatTextLabelFrame = CGRectMake(kScreenHMargin, kScreenVMargin, textLableSize.width, textLableSize.height);
        
    }
    
    if ([chatContentType isEqualToString:@"picture"]) {
        NSLog(@"图片哦~~");
    }
    
    if ([chatContentType isEqualToString:@"audio"]) {
        
        self.chatAudioViewFrame = CGRectMake(kScreenHMargin, 0, kScreenWith*0.277-2*kScreenVMargin, kTouXiangL);
        
    }
}

@end