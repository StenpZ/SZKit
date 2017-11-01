//
//  SZConditionMenu.h
//  SZKitDemo
//
//  Created by zxc on 2017/10/19.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZConditionMenu;
@class SZConditionMenuItem;
@class SZConditionMenuItemCell;

@protocol SZConditionMenuProtocol <NSObject>

- (NSInteger)numberOfColumnsInConditionMenu:(SZConditionMenu *)conditionMenu;

- (NSInteger)conditionMenu:(SZConditionMenu *)conditionMenu numberOfRowsInColumn:(NSInteger)column;

- (SZConditionMenuItem *)conditionMenu:(SZConditionMenu *)conditionMenu itemForHeaderInColumn:(NSInteger)column;

- (SZConditionMenuItemCell *)conditionMenu:(SZConditionMenu *)conditionMenu cellForMenuAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)conditionMenu:(SZConditionMenu *)conditionMenu didSelectedHeaderInColumn:(NSInteger)column;

- (void)conditionMenu:(SZConditionMenu *)conditionMenu didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;

@end


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
