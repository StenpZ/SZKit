
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

// 参考自YANScrollMenu git:https://github.com/yanff/YANScrollMenu

@protocol SZMenuItemObject <NSObject>

@property(nonatomic, copy) NSString *text;

@property(nonatomic, strong) id image;

@property(nonatomic, strong) UIImage *placeholderImage;

@end

/****************************  SZEdgeInsets ***************************/

/**
 *  @brief  The edgeInsets of SZMenuItem.
 */
typedef struct SZEdgeInsets{
    
    CGFloat top;        //The top margin of icon
    CGFloat left;       //The left margin of label
    CGFloat middle;     //The margin between label and icon
    CGFloat right;      //The right margin of label
    CGFloat bottom;     //The bottom margin of label
    
}SZEdgeInsets;

/**
 Make SZEdgeInsets
 
 @param top       The top margin of icon
 @param left      The left margin of label
 @param middle    The margin between label and icon
 @param right     The right margin of label
 @param bottom    The bottom margin of label
 @return SZEdgeInsets
 */
UIKIT_STATIC_INLINE SZEdgeInsets SZEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat middle, CGFloat right, CGFloat bottom) {
    SZEdgeInsets insets = {top, left, middle, right,bottom};
    return insets;
}

UIKIT_STATIC_INLINE SZEdgeInsets SZEdgeInsetsZero() {
    SZEdgeInsets insets = {0.f, 0.f, 0.f, 0.f, 0.f};
    return insets;
}

@interface SZMenuItem : UICollectionViewCell
/**
 *  The size of icon.
 */
@property (nonatomic, assign) CGFloat iconSize  UI_APPEARANCE_SELECTOR ; //defaul is 36;
/**
 *  The cornerRadius of icon.
 */
@property (nonatomic, assign) CGFloat iconCornerRadius UI_APPEARANCE_SELECTOR; //defaul is 18;
/**
 *  The color of label.
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR ; //defaul is [UIColor darkTextColor];
/**
 *  The font of label.
 */
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR; //defaul is [UIFont systemFontOfSize:11];

/**
 The height of label
 */
@property(nonatomic, assign) CGFloat textHeight UI_APPEARANCE_SELECTOR; //defaul is 20;

@end;

/**********************  SZScrollMenuProtocol ***************************/

@class SZScrollMenu;
/**
 *  @brief  SZScrollMenuProtocol(protocol)
 */
@protocol SZScrollMenuProtocol <NSObject>
/**
 Number of rows for each page.
 
 @param scrollMenu SZScrollMenu
 @return NSUInteger
 */
- (NSUInteger)numberOfRowsForEachPageInScrollMenu:(SZScrollMenu *)scrollMenu;
/**
 Number of items for each row.
 
 @param scrollMenu SZScrollMenu
 @return NSUInteger
 */
- (NSUInteger)numberOfItemsForEachRowInScrollMenu:(SZScrollMenu *)scrollMenu;
/**
 Number of menus (total).
 
 @param scrollMenu SZScrollMenu
 @return NSUInteger
 */
- (NSUInteger)numberOfMenusInScrollMenu:(SZScrollMenu *)scrollMenu;
/**
 Object at index.
 
 @param scrollMenu SZScrollMenu
 @param indexPath NSIndexPath
 @return id<YANMenuObject>
 */
- (id<SZMenuItemObject>)scrollMenu:(SZScrollMenu *)scrollMenu objectAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 Did select at index.
 
 @param scrollMenu SZScrollMenu
 @param indexPath NSIndexPath
 */
- (void)scrollMenu:(SZScrollMenu *)scrollMenu didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

/**********************  SZScrollMenu ***************************/

/**
 *  @brief  SZScrollMenu 类似美团、淘宝的首页菜单
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface SZScrollMenu : UIView
/**
 *  The delegate of SZScrollMenu
 */
@property (nonatomic, weak) id<SZScrollMenuProtocol> delegate;
/**
 *  The currentPageIndicatorTintColor of pageControl.
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;  //default is  [UIColor darkTextColor]
/**
 *  The pageIndicatorTintColor of pageControl.
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor; //default is  [UIColor groupTableViewBackgroundColor]

@property(nonatomic, assign) CGFloat pageControlHeight; //default is  16

@property(nonatomic, assign) SZEdgeInsets itemEdgeInsets;  //default is  {5, 0, 5, 0, 0}

/**
 Use to reload datasource and refresh UI.
 */
- (void)reloadData;

@end
