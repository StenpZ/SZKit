
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface NSString (SZKit)


/**
 验证手机号码合法性

 @return 结果
 */
- (BOOL)sz_validateMobile;


/**
 验证邮箱地址合法性

 @return 结果
 */
- (BOOL)sz_validateEmail;


/**
 判断字符串是否是表情

 @return YES/NO
 */
- (BOOL)sz_isEmoji;

/// 获取文字高度
- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineSpace:(CGFloat)lineSpace;

- (CGFloat)widthWithFont:(UIFont *)font;

/// 时间戳转时间
- (NSString *)stringWithFormatter:(NSString *)formatter;

@end
