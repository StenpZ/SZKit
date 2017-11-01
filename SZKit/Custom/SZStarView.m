
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZStarView.h"
#import "UIView+SZKit.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface SZStarView ()

@property(nonatomic, readwrite) NSUInteger starsCount;

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation SZStarView

- (instancetype)initWithStarSize:(CGSize)starSize starInsets:(UIEdgeInsets)starInsets starsCount:(NSUInteger)starsCount {
    self = [super init];
    if (self) {
        _starSize = starSize;
        _starInsets = starInsets;
        _starsCount = starsCount;
        [self prepareUI];
        self.normalStarImageName = @"img_star_normal";
        self.selectedStarImageName = @"img_star_selected";
    }
    return self;
}

- (void)prepareUI {
    self.clipsToBounds = YES;
    self.starBackgroundView = [self buidlStarView];
    self.starForegroundView = [self buidlStarView];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.sz_width) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(self.starBackgroundView.sz_width);
        }];
    }
    if (!self.sz_height) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.starBackgroundView.sz_height);
        }];
    }
}

- (void)setNormalStarImageName:(NSString *)normalStarImageName {
    _normalStarImageName = normalStarImageName;
    for (UIImageView *v in self.starBackgroundView.subviews) {
        v.image = [UIImage imageNamed:_normalStarImageName];
    }
}

- (void)setSelectedStarImageName:(NSString *)selectedStarImageName {
    _selectedStarImageName = selectedStarImageName;
    for (UIImageView *v in self.starForegroundView.subviews) {
        v.image = [UIImage imageNamed:_selectedStarImageName];
    }
}

- (void)setScore:(float)score {
    _score = score;
    [self setScore:_score completion:nil];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score completion:(void (^)(BOOL finished))completion {
    
    if (score < 0) {
        score = 0;
    }
    if (score > 1) {
        score = 1;
    }
    CGPoint point = CGPointMake(score * self.starBackgroundView.sz_width, 0);
    
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

- (UIView *)buidlStarView {
    CGFloat wid = _starsCount * (_starSize.width + _starInsets.left) + _starInsets.right;
    CGFloat hig = _starInsets.top + _starSize.height + _starInsets.bottom;
    CGRect frame = CGRectMake(0, 0, wid, hig);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.starsCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(_starInsets.left + (_starInsets.left + _starSize.width) * i, _starInsets.top, _starSize.width, _starSize.height);
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
    if (p.x > self.starBackgroundView.sz_width) {
        p.x = self.starBackgroundView.sz_width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.starBackgroundView.sz_width];
    float score = [str floatValue];
    if (score < self.minimumScore) {
        score = self.minimumScore;
    }
    if (self.shouldIntScore) {
        int a = ceilf(score * self.starsCount);
        score = (float)a / self.starsCount;
        NSString *str = [NSString stringWithFormat:@"%0.2f", score];
        score = [str floatValue];
    }
    p.x = score * self.starBackgroundView.sz_width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.starBackgroundView.sz_height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starView:didSelectedAtScore:)]) {
        [self.delegate starView:self didSelectedAtScore:score];
    }
}

@end
