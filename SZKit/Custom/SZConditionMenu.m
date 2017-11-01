//
//  SZConditionMenu.m
//  SZKitDemo
//
//  Created by zxc on 2017/10/19.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZConditionMenu.h"


@implementation SZConditionMenuItem

@end


@implementation SZConditionMenuItemCell

@end


@interface SZConditionMenu ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UICollectionView *header;
@property(nonatomic, strong) UIView *headerBG;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy, readonly) NSString *itemIdentifier;
@property(nonatomic, copy, readonly) NSString *cellIdentifier;

@end

@implementation SZConditionMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemIdentifier = @"reuse_Item";
        _cellIdentifier = @"reuse_Cell";
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    
    
    [self registerReusableHeaderItem:[SZConditionMenuItem class]];
    [self registerReusableCell:[SZConditionMenuItemCell class]];
}

- (SZConditionMenuItemCell *)dequeueReusableCell {
    return [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
}

- (void)registerReusableCell:(Class)cellClass {
    [self.tableView registerClass:cellClass forCellReuseIdentifier:self.cellIdentifier];
}

- (SZConditionMenuItem *)dequeueReusableHeaderItemAtColumn:(NSInteger)column {
    return [self.header dequeueReusableCellWithReuseIdentifier:self.itemIdentifier forIndexPath:[NSIndexPath indexPathForItem:column inSection:0]];
}

- (void)registerReusableHeaderItem:(Class)itemClass {
    [self.header registerClass:itemClass forCellWithReuseIdentifier:self.cellIdentifier];
}

@end
