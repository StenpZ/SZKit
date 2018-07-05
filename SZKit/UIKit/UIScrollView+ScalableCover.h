
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UIImageView (ScalableCover)

@property(nonatomic) CGFloat defaultHeight;
@property(nonatomic, weak) UIScrollView *superScroll;

@end


@interface UIScrollView (ScalableCover)

@property(nonatomic, weak) UIImageView *scalableCover;

@end
