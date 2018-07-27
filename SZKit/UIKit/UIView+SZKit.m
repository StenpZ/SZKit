
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

- (BOOL)showOnScreen {    
    [self layoutIfNeeded];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect))
        return NO;
    // 若view 隐藏
    if (self.hidden)
        return NO;
    // 若没有superview
    if (!self.superview)
        return NO;
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero))
        return NO;
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect))
        return NO;
    
    UIViewController *vc = [UIView viewControllerOnScreen];
    BOOL ret = [self isVisableOnView:vc.view];
    return ret;
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

+ (UIViewController *)viewControllerOnScreen {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    
    return vc;
}

- (BOOL)isVisableOnView:(UIView *)view {
    UIView *top = self;
    if (top == view) {
        return YES;
    }
    if (top.superview) {
        top = top.superview;
        return [top isVisableOnView:view];
    }
    return NO;
}

@end
