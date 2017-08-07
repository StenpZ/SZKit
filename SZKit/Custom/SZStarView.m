
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZStarView.h"

@interface SZStarView ()

@property(nonatomic, copy) NSString *normalStarName;

@property(nonatomic, copy) NSString *selectedStarName;

@property(nonatomic, readwrite) NSUInteger starsCount;

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation SZStarView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame normalStar:@"img_star_normal" selectedStar:@"img_star_selected" starsCount:5];
}

- (instancetype)initWithFrame:(CGRect)frame normalStar:(NSString *)normalStar selectedStar:(NSString *)selectedStar starsCount:(NSUInteger)starsCount {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.normalStarName = normalStar;
        self.selectedStarName = selectedStar;
        self.starsCount = starsCount;
        self.animated = YES;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.starBackgroundView = [self buidlStarViewWithImageName:self.normalStarName];
    self.starForegroundView = [self buidlStarViewWithImageName:self.selectedStarName];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

- (void)setScore:(float)score {
    _score = score;
    [self layoutIfNeeded];
    [self setScore:_score completion:nil];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score completion:(void (^)(BOOL finished))completion {
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0) {
        score = 0;
    }
    if (score > 1) {
        score = 1;
    }
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(self.animated){
        [UIView animateWithDuration:0.2 animations:^{
            [self changeStarForegroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion){
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.slideEnabled) return;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    if(CGRectContainsPoint(rect,point)) {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.slideEnabled) return;

    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self changeStarForegroundViewWithPoint:point];
    }];
}

#pragma mark - Buidl Star View
/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.starsCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.starsCount, 0, frame.size.width / self.starsCount, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Change Star Foreground With Point
/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starView:didSelectedAtScore:)]) {
        [self.delegate starView:self didSelectedAtScore:score];
    }
}

@end
