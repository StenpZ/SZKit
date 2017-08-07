
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@class SZScrollBanner;
@class SZScrollBannerCell;


@protocol SZScrollBannerProtocol <NSObject>

@required
- (NSUInteger)numbersofPageAtScrollBanner:(SZScrollBanner *)scrollBanner;

- (__kindof SZScrollBannerCell *)scrollBanner:(SZScrollBanner *)scrollBanner cellForPageAtIndex:(NSUInteger)index;

@optional
- (void)scrollBanner:(SZScrollBanner *)scrollBanner didSelectedAtIndex:(NSUInteger)index;

@end

/*! 滚动Banner */
@interface SZScrollBanner : UIView

@property(nonatomic, weak) id<SZScrollBannerProtocol> delegate;

@property(nonatomic, copy, readonly) NSString *defaultCellIdentifier;

@property(nonatomic, readonly) NSUInteger numbersofPage;

/*! 间隔时间 default：3s */
@property(nonatomic) NSTimeInterval scrollInterval;

@property(nonatomic, strong, readonly) UIPageControl *pageControl;

/*! 是否显示PageControl default：Yes */
@property(nonatomic) BOOL showPageControl;

/*! 单页数据时是否隐藏PageControl default：Yes */
@property(nonatomic) BOOL hidePageControlForSinglePage;

/*! 注册Cell 默认注册了SZScrollBannerCell，identifier：self.defaultCellIdentifier */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
/*! 如果不自定义SZScrollBannerCell 可传入self.defaultCellIdentifier */
- (__kindof SZScrollBannerCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index;

- (void)reloadData;

@end


@interface SZScrollBannerCell : UICollectionViewCell

@property(nonatomic, strong, readonly) UIImageView *imageView;
@property(nonatomic, strong, readonly) UILabel *textLabel;

/*! default：[UIColor blackColor] */
@property(nonatomic, strong) UIColor *textBackgroundColor;
/*! default: 0.5 */
@property(nonatomic) CGFloat textBackgroundAlpha;
/*! default: NO */
@property(nonatomic) BOOL textHidden;

@end
