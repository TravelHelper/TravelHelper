//
//  YBZMyWindow.m
//  YBZTravel
//
//  Created by 刘芮东 on 2016/11/11.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "YBZMyWindow.h"
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface YBZMyWindow ()<UIGestureRecognizerDelegate>



@end


@implementation YBZMyWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        /*
         UIWindowLevel 有如下三种:
         UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal;
         UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert;
         UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar;
         */
        //
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.backgroundColor=[UIColor redColor];
        self.rootViewController = controller;
        [self setWindowLevel:UIWindowLevelNormal];
        
        
        //添加移动的手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        //添加点击的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
        
        
        
    }
    return self;
}


#pragma mark -触摸事件监听
-(void)locationChange:(UIPanGestureRecognizer*)p
{
    //[[UIApplication sharedApplication] keyWindow]
    CGPoint panPoint = [p locationInView:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
//    if(p.state == UIGestureRecognizerStateBegan)
//    {
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeColor) object:nil];
//        _imageView.alpha = 0.8;
//    }
//    else if (p.state == UIGestureRecognizerStateEnded)
//    {
//        [self performSelector:@selector(changeColor) withObject:nil afterDelay:4.0];
//    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"x:%f------y:%f",panPoint.x,panPoint.y);
//        self.center = CGPointMake(panPoint.x, panPoint.y);
//        self.frame=CGRectMake(panPoint.x, panPoint.y, 100, 100);
        self.center = CGPointMake(self.center.x + panPoint.x-self.frame.size.width/2, self.center.y + panPoint.y-self.frame.size.height/2);
    }
//    else if(p.state == UIGestureRecognizerStateEnded)
//    {
//        if(panPoint.x <= kScreenWidth/2)
//        {
//            if(panPoint.y <= 40+HEIGHT/2 && panPoint.x >= 20+WIDTH/2)
//            {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
//                }];
//            }
//            else if(panPoint.y >= kScreenHeight-HEIGHT/2-40 && panPoint.x >= 20+WIDTH/2)
//            {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
//                }];
//            }
//            else if (panPoint.x < WIDTH/2+15 && panPoint.y > kScreenHeight-HEIGHT/2)
//            {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(WIDTH/2, kScreenHeight-HEIGHT/2);
//                }];
//            }
//            else
//            {
//                CGFloat pointy = panPoint.y < HEIGHT/2 ? HEIGHT/2 :panPoint.y;
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(WIDTH/2, pointy);
//                }];
//            }
//        }
//        else if(panPoint.x > kScreenWidth/2)
//        {
//            if(panPoint.y <= 40+HEIGHT/2 && panPoint.x < kScreenWidth-WIDTH/2-20 )
//            {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(panPoint.x, HEIGHT/2);
//                }];
//            }
//            else if(panPoint.y >= kScreenHeight-40-HEIGHT/2 && panPoint.x < kScreenWidth-WIDTH/2-20)
//            {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(panPoint.x, 480-HEIGHT/2);
//                }];
//            }
//            else if (panPoint.x > kScreenWidth-WIDTH/2-15 && panPoint.y < HEIGHT/2)
//            {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(kScreenWidth-WIDTH/2, HEIGHT/2);
//                }];
//            }
//            else
//            {
//                CGFloat pointy = panPoint.y > kScreenHeight-HEIGHT/2 ? kScreenHeight-HEIGHT/2 :panPoint.y;
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.center = CGPointMake(320-WIDTH/2, pointy);
//                }];
//            }
//        }
//    }
}

- (void)click:(UITapGestureRecognizer*)t
{
//    if (self.isCannotTouch) {
//        return;
//    }
//    self.isExit = YES;
//    [self makeOuttoAnimation];
    NSLog(@"click");
    
}


@end
