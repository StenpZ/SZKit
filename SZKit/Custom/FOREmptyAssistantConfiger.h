
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface FOREmptyAssistantConfiger : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

#pragma mark - datasource

// default nil
@property (nonatomic, strong)   UIImage *emptyImage;


// default @""
@property (nonatomic, copy)     NSString *emptyTitle;
// default systemFontOfSize:17.0f
@property (nonatomic, strong)   UIFont *emptyTitleFont;
// default darkGrayColor
@property (nonatomic, strong)   UIColor *emptyTitleColor;


// default @""
@property (nonatomic, copy)     NSString *emptySubtitle;
// default systemFontOfSize:15.0f
@property (nonatomic, strong)   UIFont *emptySubtitleFont;
// default lightGrayColor
@property (nonatomic, strong)   UIColor *emptySubtitleColor;


// default @""
@property (nonatomic, copy)     NSString *emptyBtnTitle;
// default systemFontOfSize:17.0f
@property (nonatomic, strong)   UIFont *emptyBtntitleFont;
// default whiteColor
@property (nonatomic, strong)   UIColor *emptyBtnTitleColor;
// default nil
@property (nonatomic, strong)   UIImage *emptyBtnImage;
// default blank_button
@property (nonatomic, strong)   UIImage *emptyBtnBackgroundImage;


// 自定义通用的空白view
@property (nonatomic, strong)   UIView *customView;

// 空白页整体位置默认是在tableView居中显示: default 0
@property (nonatomic)   CGFloat emptyCenterOffset;

// 空白页的图片、按钮、文案之间的间距大小: default 20
@property (nonatomic)   CGFloat emptySpaceHeight;

#pragma mark - delegate

// 添加空白页后ScrollView是否可以继续拖拽: default YES
@property (nonatomic)   BOOL allowScroll;

// default YES
@property (nonatomic)   BOOL userInteractionEnabled;

// 添加空白页后ScrollView是否可以展示: default YES
@property (nonatomic, copy) BOOL(^shouldDisplay)();

// 空白页区域点击
@property (nonatomic, copy) void(^emptyViewTapBlock)();

// 按钮点击
@property (nonatomic, copy) void(^emptyBtnClickBlock)();

// 空白页的图片是否执行动画: default YES
@property (nonatomic, copy) BOOL(^shouldStartImageViewAnimate)();

// 图片的动画, Note: shouldStartAnimate==NO || imageAnimation==nil || emptyImage==nil 三者成立一个就不执行动画
@property (nonatomic, strong) CAAnimation *imageAnimation;

// life cricle
@property (nonatomic, copy) void(^emptyViewWillAppear)();
@property (nonatomic, copy) void(^emptyViewWillDisappear)();
@property (nonatomic, copy) void(^emptyViewDidAppear)();
@property (nonatomic, copy) void(^emptyViewDidDisappear)();

@end

