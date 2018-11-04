
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！


#import <UIKit/UIKit.h>

/**
 HSB or HSV 颜色拾取
 可根据颜色自动定位
 */
@interface SZColorPicker : UIControl

@property(nonatomic, readonly) UIColor *selectedColor;

+ (instancetype)colorPickerWithBubbleWidth:(CGFloat)bubbleWidth completion:(void (^)(UIColor *color))complention;

- (void)changeColor:(UIColor *)color;

@end
