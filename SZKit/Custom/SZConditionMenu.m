
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZConditionMenu.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

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

@property(nonatomic) CGFloat height;

@property(nonatomic) NSUInteger currentColumn;

@end

@implementation SZConditionMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.height = CGRectGetHeight(frame);
        _itemIdentifier = @"reuse_Item";
        _cellIdentifier = @"reuse_Cell";
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.header = ({
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing =
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *header = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        header.backgroundColor = [UIColor whiteColor];
        header.scrollEnabled =
        header.showsVerticalScrollIndicator =
        header.showsHorizontalScrollIndicator = NO;
        
        header.dataSource = self;
        header.delegate = self;
        
        [self addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        header;
    });
    
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


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(numberOfColumnsInConditionMenu:)]) {
        return [self.delegate numberOfColumnsInConditionMenu:self];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(conditionMenu:itemForHeaderInColumn:)]) {
        return [self.delegate conditionMenu:self itemForHeaderInColumn:indexPath.row];
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / [self.header numberOfItemsInSection:0], self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentColumn = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(conditionMenu:didSelectedHeaderInColumn:)]) {
        [self.delegate conditionMenu:self didSelectedHeaderInColumn:indexPath.row];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(conditionMenu:numberOfRowsInColumn:)]) {
        return [self.delegate conditionMenu:self numberOfRowsInColumn:self.currentColumn];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(conditionMenu:cellForMenuAtIndexPath:)]) {
        return [self.delegate conditionMenu:self cellForMenuAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:self.currentColumn]];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
