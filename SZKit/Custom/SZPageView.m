
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZPageView.h"
#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif
#import "UIView+SZKit.h"

@interface SZPageView ()

/**
 当前显示内容页
 */
@property(nonatomic, strong) UIView *contentView;

/**
 将要显示内容页
 */
@property(nonatomic, strong) UIView *tempView;

/**
 总页数
 */
@property(nonatomic) NSUInteger numbersOfPage;

/**
 当前显示页索引
 */
@property(nonatomic) NSUInteger currentIndex;

/**
 在动画中
 */
@property(nonatomic) BOOL isAnimating;

/**
 滑动下一页
 */
@property(nonatomic) BOOL next;

/**
 滑动下一页页数
 */
@property(nonatomic) NSInteger nextPage;

@end


@implementation SZPageView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    [self addGestureRecognizers];
    self.tapToSwitchEnabled =
    self.panToSwitchEnabled = YES;
    self.switchAnimationTime = 0.2;
}

/**
 添加手势
 */
- (void)addGestureRecognizers {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabHandle:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
}

- (UIView *)currentItemView {
    return self.contentView;
}

- (void)setDelegate:(id<SZPageViewProtocol>)delegate {
    _delegate = delegate;
    [self reloadData];
}

#pragma mark - 手势识别
- (void)tabHandle:(UITapGestureRecognizer *)tap {
    if (!self.tapToSwitchEnabled) return;
    if (self.isAnimating) return;
    CGPoint touchPoint = [tap locationInView:self];
    BOOL next = touchPoint.x > self.center.x ? YES: NO;
    if (next) {
        [self switchToNextPageAnimated:YES];
    } else {
        [self switchToLastPageAnimated:YES];
    }
}

- (void)panHandle:(UIPanGestureRecognizer *)pan {
    if (!self.panToSwitchEnabled) return;
#warning 这里快速滑动好像有点问题 todo
    if (self.isAnimating) return;
    CGPoint tempPoint = [pan translationInView:self];

    BOOL next = self.next;
    NSInteger page = self.nextPage;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.next = tempPoint.x < 0 ? YES: NO;
        self.nextPage = self.next ? self.currentIndex + 1: self.currentIndex - 1;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        if (page < 0 || page >= self.numbersOfPage) {
            return;
        }
        if (!self.tempView) {
            self.tempView = [self.delegate pageView:self itemViewAtPage:page];
            if (self.tempView.superview != self) {
                [self addSubview:self.tempView];
                [self.tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.offset(0);
                    make.width.offset(self.sz_width);
                    make.left.offset(next ? 0: -self.sz_width);
                }];
                [self layoutIfNeeded];
            }
        }

        if (next) {
            [self bringSubviewToFront:self.contentView];
        }

        if (next) {
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(tempPoint.x);
            }];
        } else {
            [self.tempView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(tempPoint.x - self.sz_width);
            }];
        }
        [self layoutIfNeeded];
    } else {
        [self panEndHandle];
    }
}

- (void)panEndHandle {
    BOOL next = self.next;
    NSInteger page = self.nextPage;
    self.isAnimating = YES;
    BOOL success = NO;
    if (next) {
        if (self.contentView.sz_orgin_x < -self.sz_width * 0.18) {
            success = YES;
        }
    } else {
        if (self.tempView.sz_orgin_x > -(self.sz_width - self.sz_width * 0.18)) {
            success = YES;
        }
    }
    if (success) {
        [self switchToPage:page animated:YES];
    } else {
        if (next) {
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
            }];
        } else {
            [self.tempView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.offset(-self.sz_width);
            }];
        }
        
        [UIView animateWithDuration:self.switchAnimationTime animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
            [self.tempView removeFromSuperview];
            self.tempView = nil;
        }];
    }
    self.nextPage = self.currentIndex;
}

- (void)reloadData {
    if (!self.sz_width) {
        [self layoutIfNeeded];
    }
    self.numbersOfPage = [self.delegate numbersOfPageInPageView:self];
    if (self.currentIndex >= self.numbersOfPage) {
        self.currentIndex = 0;
    }
    [self.contentView removeFromSuperview];
    [self.tempView removeFromSuperview];
    self.contentView = nil;
    self.tempView = nil;
    self.contentView = [self.delegate pageView:self itemViewAtPage:self.currentIndex];
    [self addSubview:self.contentView];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(self.sz_width);
    }];
    [self layoutIfNeeded];
}

- (void)reloadDataToFirst {
    self.currentIndex = 0;
    [self reloadData];
}

- (BOOL)switchToNextPageAnimated:(BOOL)animated {
    return [self switchToPage:self.currentIndex + 1 animated:animated];
}

- (BOOL)switchToLastPageAnimated:(BOOL)animated {
    return [self switchToPage:self.currentIndex - 1 animated:animated];
}

- (BOOL)switchToPage:(NSUInteger)page animated:(BOOL)animated {
    if (page >= self.numbersOfPage){
        self.isAnimating = NO;
        return NO;
    }
    
    if (page == self.currentIndex){
        self.isAnimating = NO;
        return NO;
    }
    
    BOOL next = page > self.currentIndex;
    
    if (!self.tempView) {
        self.tempView = [self.delegate pageView:self itemViewAtPage:page];
        if (self.tempView.superview != self) {
            [self addSubview:self.tempView];
        }
        
        [self.tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.width.offset(self.sz_width);
            make.left.offset(next ? 0: -self.sz_width);
        }];
        [self layoutIfNeeded];
    }
    if (next) {
        [self bringSubviewToFront:self.contentView];
    }

    if (!animated) {
        [self layoutIfNeeded];
        [self switchComplentForPage:page];
        return YES;
    }
    self.isAnimating = YES;
    if (next) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(-self.sz_width);
        }];
    } else {
        [self.tempView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
        }];
    }
    [UIView animateWithDuration:self.switchAnimationTime animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self switchComplentForPage:page];
    }];
    return YES;
}

- (void)switchComplentForPage:(NSUInteger)page {
    self.isAnimating = NO;
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    self.contentView = self.tempView;
    self.currentIndex = page;
    self.tempView = nil;
    if ([self.delegate respondsToSelector:@selector(pageView:itemView:didAppearAtPage:)]) {
        [self.delegate pageView:self itemView:self.contentView didAppearAtPage:self.currentIndex];
    }
}

@end
