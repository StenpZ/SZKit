
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIScrollView+ScalableCover.h"
#import <objc/runtime.h>

@implementation UIImageView (ScalableCover)

- (void)setDefaultHeight:(CGFloat)defaultHeight {
    objc_setAssociatedObject(self, @selector(defaultHeight), @(defaultHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)defaultHeight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSuperScroll:(UIScrollView *)superScroll {
    UIScrollView *_scroll = objc_getAssociatedObject(self, @selector(superScroll));
    [_scroll removeObserver:self forKeyPath:@"contentOffset"];
    objc_setAssociatedObject(self, @selector(superScroll), superScroll, OBJC_ASSOCIATION_ASSIGN);
    [superScroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview {
    [self.superScroll removeObserver:self forKeyPath:@"contentOffset"];
    [super removeFromSuperview];
}

- (UIScrollView *)superScroll {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superScroll) {
        return;
    }
    
    if (self.superScroll.contentOffset.y < 0) {
        CGFloat offset = - self.superScroll.contentOffset.y;
        self.frame = CGRectMake(-offset, -offset, self.superScroll.bounds.size.width + offset * 2, self.defaultHeight + offset);
    } else {
        self.frame = CGRectMake(0, 0, self.superScroll.bounds.size.width, self.defaultHeight);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.superScroll) {
        [self setNeedsLayout];
    }
}

@end


@implementation UIScrollView (ScalableCover)

- (void)setScalableCover:(UIImageView *)scalableCover {
    objc_setAssociatedObject(self, @selector(scalableCover), scalableCover, OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:scalableCover];
    [self sendSubviewToBack:scalableCover];
    scalableCover.superScroll = self;
}

- (UIImageView *)scalableCover {
    return objc_getAssociatedObject(self, _cmd);
}

@end

