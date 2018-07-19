
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>


@interface SZMenuItem : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic, strong) id model;

- (void)prepareUI;
- (void)configUI;

@end;


@class SZScrollMenu;

@protocol SZScrollMenuProtocol <NSObject>

/**
 显示的行数

 @param scrollMenu SZScrollMenu
 @return 行数
 */
- (NSUInteger)numberOfRowsInScrollMenu:(SZScrollMenu *)scrollMenu;

/**
 显示的列数

 @param scrollMenu SZScrollMenu
 @return 列数
 */
- (NSUInteger)numberOfColumnsInScrollMenu:(SZScrollMenu *)scrollMenu;

/**
 菜单选项的总数

 @param scrollMenu SZScrollMenu
 @return 总数
 */
- (NSUInteger)numberOfMenusInScrollMenu:(SZScrollMenu *)scrollMenu;

/**
 SZMenuItem

 @param scrollMenu SZScrollMenu
 @param indexPath NSIndexPath
 @return SZMenuItem
 */
- (SZMenuItem *)scrollMenu:(SZScrollMenu *)scrollMenu menuItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 菜单选项选中事件

 @param scrollMenu SZScrollMenu
 @param indexPath NSIndexPath
 */
- (void)scrollMenu:(SZScrollMenu *)scrollMenu didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


/// 类似淘宝、美团的多行多列滑动翻页菜单
@interface SZScrollMenu : UIView

@property(nonatomic, weak) id<SZScrollMenuProtocol> delegate;

/// default is [UIColor darkTextColor]
@property(nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/// default is [UIColor groupTableViewBackgroundColor]
@property(nonatomic, strong) UIColor *pageIndicatorTintColor;

/// default is 16 in ip5
@property(nonatomic, assign) CGFloat pageControlHeight;

/// default is 64 in ip5
@property(nonatomic) CGFloat menuItemHeight;

@property(nonatomic, readonly) NSUInteger numberOfMenus;


/**
 注册复用SZMenuItem的Class

 @param itemClass SZMenuItem
 */
- (void)registerMenuItemClass:(Class)itemClass;

/**
 获取复用的SZMenuItem

 @param indexPath indexPath
 @return SZMenuItem
 */
- (__kindof SZMenuItem *)dequeueReusableItemForIndexPath:(NSIndexPath *)indexPath;

/// 刷新数据
- (void)reloadData;

@end
