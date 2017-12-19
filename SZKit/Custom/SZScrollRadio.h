
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

/*! 默认注册SZScrollRadioCell */
- (void)registerClass:(Class)cellClass;
- (__kindof SZScrollRadioCell *)dequeueReusableCellForIndex:(NSUInteger)index;

- (void)reloadData;

- (void)beginScroll;
- (void)stopScroll;

@end


@interface SZScrollRadioCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *textLabel;

@end
