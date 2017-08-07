
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

@property(nonatomic) NSTimeInterval scrollInterval;

@property(nonatomic, strong, readonly) UIPageControl *pageControl;

@property(nonatomic) BOOL showPageControl;

@property(nonatomic) BOOL hidePageControlForSinglePage;


- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (__kindof SZScrollBannerCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index;

- (void)reloadData;

- (void)beginScroll;
- (void)stopScroll;

@end


@interface SZScrollBannerCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;

@end
