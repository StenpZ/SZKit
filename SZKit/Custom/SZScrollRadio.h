
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@class SZScrollRadio;
@class SZScrollRadioCell;

@protocol SZScrollRadioProtocol <NSObject>

@required
/*! 同时显示行数 */
- (NSUInteger)numbersOfRowAtScrollRadio:(SZScrollRadio *)scrollRadio;

/*! 消息总条数 */
- (NSUInteger)countsOfItemAtScrollRadio:(SZScrollRadio *)scrollRadio;

- (SZScrollRadioCell *)scrollRadio:(SZScrollRadio *)scrollRadio cellForRowAtIndex:(NSUInteger)index;

@optional
- (void)scrollRadio:(SZScrollRadio *)scrollRadio didSelectedAtIndex:(NSUInteger)index;

@end


/*! 上下滚动广告视图 */
@interface SZScrollRadio : UIView

@property(nonatomic, weak) id<SZScrollRadioProtocol> delegate;

@property(nonatomic, copy, readonly) NSString *defaultCellIdentifier;

/*! leftView
 *  orgin.x 左边距
 *  orgin.y 竖直中心的偏移值
 *  无需调addSubView: */
@property(nonatomic, strong) UIView *leftView;

/*! rightView
 *  orgin.x 右边距 需要设置负数
 *  orgin.y 竖直中心的偏移值
 *  无需调addSubView: */
@property(nonatomic, strong) UIView *rightView;

/*! 滚动一次的时间 default：2 */
@property(nonatomic) NSTimeInterval changeInterval;

/*! 默认注册SZScrollRadioCell identifier = self.defaultCellIdentifier */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (__kindof SZScrollRadioCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadData;

- (void)beginScroll;
- (void)stopScroll;

@end


@interface SZScrollRadioCell : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@end
