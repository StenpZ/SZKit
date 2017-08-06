
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UILabel (SZKit)

/*! 字间距 */
@property(nonatomic) CGFloat sz_characterSpace;

/*! 行间距 */
@property(nonatomic) CGFloat sz_lineSpace;

@property(nonatomic, copy) NSString *sz_keywords;
@property(nonatomic, strong) UIColor *sz_keywordsFontColor;
@property(nonatomic, strong) UIColor *sz_keywordsBackGroundColor;
@property(nonatomic, strong) UIFont *sz_keywordsFont;

/*! 设置这个就可以了，不需要设置.text */
@property(nonatomic, copy) NSString *sz_text;

@end
