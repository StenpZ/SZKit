
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！


#import <UIKit/UIKit.h>

@class SZPageView;

@protocol SZPageViewProtocol <NSObject>

/**
 SZPageView总页数

 @param pageView SZPageView
 @return 页数
 */
- (NSUInteger)numbersOfPageInPageView:(SZPageView *)pageView;

/**
 获取内容视图

 @param pageView SZPageView
 @param page 第几页
 @return 内容页视图
 */
- (UIView *)pageView:(SZPageView *)pageView itemViewAtPage:(NSUInteger)page;

@optional

/**
 内容页已经显示

 @param pageView SZPageView
 @param itemView 内容页视图
 @param page 当前页数
 */
- (void)pageView:(SZPageView *)pageView itemView:(__kindof UIView *)itemView didAppearAtPage:(NSUInteger)page;

@end


/**
 类似驾考宝典或者是小说阅读的覆盖翻页效果视图
 */
@interface SZPageView : UIView

/**
 点击切换 点击视图左边上一页，右边下一页 default：YES
 */
@property(nonatomic) BOOL tapToSwitchEnabled;

/**
 滑动切换 跟随手指 向右上一页，向左下一页 default：YES
 */
@property(nonatomic) BOOL panToSwitchEnabled;

/**
 切换动画时长 default：0.2
 */
@property(nonatomic) CGFloat switchAnimationTime;

///**
// 循环切换 default：YES
// */
//@property(nonatomic) BOOL circleSwitchEnabled;

/**
 总页数
 */
@property(nonatomic, readonly) NSUInteger numbersOfPage;

/**
 当前显示页索引
 */
@property(nonatomic, readonly) NSUInteger currentIndex;

/**
 当前显示页视图
 */
@property(nonatomic, weak, readonly) __kindof UIView *currentItemView;


@property(nonatomic, weak) id<SZPageViewProtocol> delegate;


/**
 重新加载数据 索引在正常范围内(currentIndex >= 0 && currentIndex < numberOfPages)当前页不变 否则会重新加载到第一页
 */
- (void)reloadData;

/**
 重新加载数据到第一页
 */
- (void)reloadDataToFirst;

/**
 切换到下一页

 @param animated 是否需要切换动画
 @return 是否切换成功
 */
- (BOOL)switchToNextPageAnimated:(BOOL)animated;

/**
 切换到上一页

 @param animated 是否需要切换动画
 @return 是否切换成功
 */
- (BOOL)switchToLastPageAnimated:(BOOL)animated;

/**
 切换到某一页

 @param page 页数
 @param animated 是否需要切换动画
 @return 是否切换成功
 */
- (BOOL)switchToPage:(NSUInteger)page animated:(BOOL)animated;

@end
