
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/// 参照自https://github.com/devxoul/UITextView-Placeholder
@interface UITextView (SZKit)

@property (nonatomic, readonly) UITextView *placeholderTextView;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property(nonatomic) NSInteger maxLengthOfText;
@property(nonatomic, copy) void(^textChangeBlock) (NSString *text);

+ (UIColor *)defaultPlaceholderColor;

@end
