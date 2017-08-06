
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIView+SZKit.h"
#import <objc/runtime.h>

@interface UIView ()

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation UIView (SZKit)

#pragma mark - frame
- (CGFloat)sz_width {
    return self.bounds.size.width;
}

- (void)setSz_width:(CGFloat)sz_width {
    CGRect frame = self.frame;
    frame.size.width = sz_width;
    self.frame = frame;
}

- (CGFloat)sz_height {
    return self.bounds.size.height;
}

- (void)setSz_height:(CGFloat)sz_height {
    CGRect frame = self.frame;
    frame.size.height = sz_height;
    self.frame = frame;
}

- (CGFloat)sz_orgin_x {
    return self.frame.origin.x;
}

- (void)setSz_orgin_x:(CGFloat)sz_orgin_x {
    CGRect frame = self.frame;
    frame.origin.x = sz_orgin_x;
    self.frame = frame;
}

- (CGFloat)sz_orgin_y {
    return self.frame.origin.y;
}

- (void)setSz_orgin_y:(CGFloat)sz_orgin_y {
    CGRect frame = self.frame;
    frame.origin.y = sz_orgin_y;
    self.frame = frame;
}

#pragma mark - 圆角
- (CGFloat)sz_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setSz_cornerRadius:(CGFloat)sz_cornerRadius {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = sz_cornerRadius;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    objc_setAssociatedObject(self, @selector(tapGestureRecognizer), tapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sz_addTapTarget:(id)target action:(SEL)action {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    self.userInteractionEnabled = YES;
}

- (void)sz_removeTapTarget:(id)target action:(SEL)action {
    [self.tapGestureRecognizer removeTarget:target action:action];
    [self removeGestureRecognizer:self.tapGestureRecognizer];
    self.userInteractionEnabled = NO;
}

@end
