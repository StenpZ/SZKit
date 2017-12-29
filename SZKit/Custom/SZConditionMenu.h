
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@class SZConditionMenu;
@class SZConditionMenuItem;
@class SZConditionMenuItemCell;

@protocol SZConditionMenuProtocol <NSObject>

/// 列数
- (NSInteger)numberOfColumnsInConditionMenu:(SZConditionMenu *)conditionMenu;

/// 行数
- (NSInteger)conditionMenu:(SZConditionMenu *)conditionMenu numberOfRowsInColumn:(NSInteger)column;

/// 列头视图
- (SZConditionMenuItem *)conditionMenu:(SZConditionMenu *)conditionMenu itemForHeaderInColumn:(NSInteger)column;

/// cell
- (SZConditionMenuItemCell *)conditionMenu:(SZConditionMenu *)conditionMenu cellForMenuAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)conditionMenu:(SZConditionMenu *)conditionMenu didSelectedHeaderInColumn:(NSInteger)column;

- (void)conditionMenu:(SZConditionMenu *)conditionMenu didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;

@end


/// 列头视图
@interface SZConditionMenuItem : UICollectionViewCell

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIImageView *imageView;

@end


@interface SZConditionMenuItemCell : UITableViewCell

@end


/// 筛选菜单组
@interface SZConditionMenu : UIView

@property(nonatomic, weak) id<SZConditionMenuProtocol> delegate;

@property(nonatomic, weak) UITableView *fatherTableView;

@property(nonatomic) CGFloat rowHeight;
@property(nonatomic) CGSize separatorSize;
@property(nonatomic, strong) UIColor *separatorColor;

- (void)registerReusableCell:(Class)cellClass;
- (SZConditionMenuItemCell *)dequeueReusableCell;

- (void)registerReusableHeaderItem:(Class)itemClass;
- (SZConditionMenuItem *)dequeueReusableHeaderItemAtColumn:(NSInteger)column;

@end
