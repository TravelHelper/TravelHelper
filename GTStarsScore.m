

#import "GTStarsScore.h"
#import "UIView+Extention.h"
#import "FeedBackViewController.h"
const NSInteger kStarCount = 5;

@interface GTStarsScore ()

/** 灰色星星视图 */
@property (nonatomic, strong) UIView *grayView;

/** 黄色星星视图 */
@property (nonatomic, strong) UIView *yellowView;



/** 比例 */
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic,strong)UIPanGestureRecognizer *pan;

@property(nonatomic,strong)UITapGestureRecognizer *tap;

@end

@implementation GTStarsScore

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.tempFrame = frame;
        
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib {
    self.tempFrame = self.frame;
    
    [self setUp];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)setUp {
    
    //    self.backgroundColor = [UIColor clearColor];
    
    self.grayView = [[UIView alloc] initWithFrame:CGRectZero];
    self.yellowView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:_grayView];
    [self addSubview:_yellowView];
    
    UIImage *starGrayImage = [UIImage imageNamed:@"star_gray"];
    UIImage *starYellowImage = [UIImage imageNamed:@"star_yellow"];
    
    // 设置视图view为图片大小的5
    self.gt_height = starGrayImage.size.height;
    self.gt_width = starGrayImage.size.width * kStarCount;
    
    self.grayView.backgroundColor = [UIColor clearColor];
    self.grayView.backgroundColor = [UIColor colorWithPatternImage:starGrayImage];
    
    self.yellowView.backgroundColor = [UIColor clearColor];
    self.yellowView.backgroundColor = [UIColor colorWithPatternImage:starYellowImage];
    
    self.grayView.frame = self.bounds;
    self.yellowView.frame = self.bounds;
    self.yellowView.gt_width = 0;
    
    // 缩放视图
    self.scale = self.tempFrame.size.height / self.gt_height;
    
    CGFloat sy = self.scale;
    CGFloat sx = self.scale;
    self.transform = CGAffineTransformScale(self.transform, sx, sy);
    
    // 重置origin点
    self.gt_origin = self.tempFrame.origin;
    
    // 添加手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:self.pan];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:self.tap];
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self];
    
    [self changeYellowView:point];
    
    if ([self.delegate respondsToSelector:@selector(starsScore:valueChange:)]) {
        self.value= self.yellowView.gt_width / self.gt_width * self.scale;
        [self.delegate starsScore:self valueChange:round(self.value * 100) / 100.0];
        
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan locationInView:self];
    
    [self changeYellowView:point];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if ([self.delegate respondsToSelector:@selector(starsScore:valueChange:)]) {
            self.value = self.yellowView.gt_width / self.gt_width * self.scale;
            [self.delegate starsScore:self valueChange:round(self.value * 100) / 100.0];
            
        }
    }
}

- (void)changeYellowView:(CGPoint)point {
    
    if (CGRectContainsPoint(self.bounds, point)) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.yellowView.gt_width = point.x;
        }];
    }
}


-(void)setToValue:(CGFloat)x{

    self.yellowView.gt_width=x*self.bounds.size.width;

}

- (void)setScoreScale:(CGFloat)scoreScale {
    _scoreScale = scoreScale;
    CGFloat starW = scoreScale * self.gt_width / self.scale;
    [self changeYellowView:CGPointMake(starW, 0)];
}

-(void)toRemoveGesture{
    [self removeGestureRecognizer:self.pan];
    [self removeGestureRecognizer:self.tap];

}

@end
