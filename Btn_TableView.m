//
//  Btn_TableView.m
//  点击按钮出现下拉列表
//
//  Created by 杜甲 on 14-3-26.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import "Btn_TableView.h"
#import "YBZRewardHallViewController.h"

@interface Btn_TableView ()


@end


@implementation Btn_TableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)addViewData
{
    
    self.m_bHidden = true;
    self.m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.m_btn addTarget:self action:@selector(expandableButton:) forControlEvents:UIControlEventTouchUpInside];
    self.m_btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.m_btn.backgroundColor = [UIColor clearColor];
    [self  addSubview:self.m_btn];
    self.m_ExpandTableVC = [[ExpandTableVC alloc] initWithStyle:UITableViewStylePlain];
    self.m_ExpandTableVC.view.frame = CGRectMake(0, self.m_btn.frame.size.height, self.frame.size.width, 0);
    self.m_ExpandTableVC.delegate_ExpandTableVC = self;
    self.m_ExpandTableVC.m_ContentArr  = self.m_TableViewData;
    [self addSubview:self.m_ExpandTableVC.view];
    self.m_btnpanduan = NO;
}

-(void)expandableButton:(UIButton*)sender
{
    
    if (!self.m_btnpanduan) {
        self.m_btnpanduan=YES;
    }else{
        self.m_btnpanduan=NO;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        sender.userInteractionEnabled = false;
        if (self.m_bHidden) {
            self.m_ExpandTableVC.view.frame = CGRectMake(0, self.m_btn.frame.size.height, self.m_btn.frame.size.width, 0);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.m_btn.frame.size.width, 300);
            self.panduan = @"1";
        }else{
            
            [self tableViewHidden];
            self.panduan = @"0";
        }
    } completion:^(BOOL finished) {
        sender.userInteractionEnabled = true;
        self.m_bHidden = !self.m_bHidden;
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setTextALabel2" object:nil
                                                      userInfo:@{@"文本":self.panduan}];
}


-(void)tableViewHidden
{
    self.m_ExpandTableVC.view.frame = CGRectMake(0, self.m_btn.frame.size.height, self.m_btn.frame.size.width, 0);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.m_btn.frame.size.width, self.m_btn.frame.size.height);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self expandableButton:self.m_btn];
    
    if ([_delegate_Btn_TableView respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate_Btn_TableView tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellName = [[NSString alloc]init];
    self.cellName = cell.textLabel.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setTextALabel" object:nil];
   
}



@end
