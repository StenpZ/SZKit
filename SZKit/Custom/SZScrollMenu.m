
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZScrollMenu.h"
#import "SZAdapter.h"
#import "UIView+SZKit.h"

#if __has_include(<UIImageView+WebCache.h>)
#import <UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@implementation SZMenuItem


- (void)dealloc {
    NSLog(@"dealloc menuItem");
}
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self prepareUI];
    }
    
    return self;
}

#pragma mark - Prepare UI
- (void)prepareUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.imageView = ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:imageView];
        
        imageView;
    });
    
    self.textLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"text";
        
        [self.contentView addSubview:label];
        
        label;
    });
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.offset(-kRealLength(5));
        make.height.offset(kRealLength(16));
        make.left.mas_greaterThanOrEqualTo(0).priorityHigh();
        make.right.mas_lessThanOrEqualTo(0).priorityHigh();
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.offset(kRealLength(10));
        make.bottom.equalTo(self.textLabel.mas_top);
        make.width.equalTo(self.imageView.mas_height);
    }];
}

@end


@class SZMenuSection;

@protocol SZMenuSectionProtocol <NSObject>

/**
 Size of items.
 
 @param menuSection SZMenuSection
 @return CGSize
 */
- (CGSize)sizeOfItemsInMenuSection:(SZMenuSection *)menuSection;

/**
 Number of items.
 
 @param menuSection SZMenuSection
 @return NSUInteger
 */
- (NSUInteger)numberOfItemsInMenuSection:(SZMenuSection *)menuSection;

/**
 SZMenuItem

 @param menuSection SZMenuSection
 @param indexPath NSIndexPath
 @return SZMenuItem
 */
- (SZMenuItem *)menuSection:(SZMenuSection *)menuSection menuItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 Did select item at indexPath.
 
 @param menuSection SZMenuSection
 @param indexPath NSIndexPath
 */
- (void)menuSection:(SZMenuSection *)menuSection didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface SZScrollMenu (Getter)

@property(nonatomic, copy, readonly) NSString *itemIdentifier;
@property(nonatomic, strong, readonly) Class itemClass;

@end


/**********************  SZMenuSection ***************************/
@interface SZMenuSection : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, weak) id<SZMenuSectionProtocol> delegate;

@property(nonatomic, copy, readonly) NSString *itemIdentifier;

@property(nonatomic, assign) NSUInteger section;

@property(nonatomic, weak) SZScrollMenu *scrollMenu;

@end

@implementation SZMenuSection


- (void)dealloc {
    NSLog(@"dealloc menuSection");
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _itemIdentifier = @"reuseItem";
        [self prepareUI];
    }
    
    return self;
}

#pragma mark - Getter&Setter
- (void)setDelegate:(id<SZMenuSectionProtocol>)delegate {
    
    _delegate = delegate;
    if (self.collectionView) {
        
        [self.collectionView reloadData];
    }
}

#pragma mark - Prepare UI
- (void)prepareUI {
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView;
    });
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setScrollMenu:(SZScrollMenu *)scrollMenu {
    _scrollMenu = scrollMenu;
    [self.collectionView registerClass:_scrollMenu.itemClass forCellWithReuseIdentifier:_scrollMenu.itemIdentifier];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeOfItemsInMenuSection:)]) {
        
        return [self.delegate sizeOfItemsInMenuSection:self];
    }
    
    return CGSizeZero;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInMenuSection:)]) {
        
        return [self.delegate numberOfItemsInMenuSection:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(menuSection:menuItemAtIndexPath:)]) {
        return [self.delegate menuSection:self menuItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuSection:didSelectItemAtIndexPath:)]) {
        
        [self.delegate menuSection:self didSelectItemAtIndexPath:indexPath];
    }
}

@end


/**********************  SZScrollMenu ***************************/
@interface SZScrollMenu ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SZMenuSectionProtocol>
/**
 *  The collectionView.
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  The pageControl.
 */
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;

@property (nonatomic) NSUInteger maxRow;
@property (nonatomic) NSUInteger maxColumn;

@property(nonatomic, copy, readonly) NSString *itemIdentifier;
@property(nonatomic, strong) Class itemClass;
@property(nonatomic, strong) NSMutableDictionary *reuseCellList;

@end

@implementation SZScrollMenu

- (void)dealloc {
    NSLog(@"dealloc menu");
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cellIdentifier = @"reuseSection";
        _itemIdentifier = @"reuseItem";
        _pageControlHeight = (NSInteger)kRealLength(16);
        _menuItemHeight = (NSInteger)kRealLength(64);
        [self prepareUI];
        self.currentPageIndicatorTintColor = [UIColor darkTextColor];
        self.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

#pragma mark - Getter&Setter
- (NSMutableDictionary *)reuseCellList {
    if (!_reuseCellList) {
        _reuseCellList = [NSMutableDictionary dictionary];
    }
    return _reuseCellList;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    if (self.pageControl) {
        
        self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    if (_pageIndicatorTintColor) {
        
        self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    }
}

- (void)setMenuItemHeight:(CGFloat)menuItemHeight {
    _menuItemHeight = (NSInteger)menuItemHeight;
}

- (void)setPageControlHeight:(CGFloat)pageControlHeight {
    _pageControlHeight = (NSInteger)pageControlHeight;
}

- (void)setDelegate:(id<SZScrollMenuProtocol>)delegate {
    _delegate = delegate;
    [self reloadData];
}

#pragma mark - Prepare UI
- (void)prepareUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView = ({
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        
        [collectionView registerClass:[SZMenuSection class] forCellWithReuseIdentifier:self.cellIdentifier];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView;
    });
    
    self.pageControl = ({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];

        [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        
        pageControl;
    });
    
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(self.pageControlHeight);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(self.pageControl.mas_top);
    }];
    [self registerMenuItemClass:[SZMenuItem class]];
}

- (void)registerMenuItemClass:(Class)itemClass {
    self.itemClass = itemClass;
}

- (SZMenuItem *)dequeueReusableItemForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *idx = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
    SZMenuSection *section = self.reuseCellList[idx];
    return [section.collectionView dequeueReusableCellWithReuseIdentifier:self.itemIdentifier forIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.frame), self.menuItemHeight);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    CGFloat rows = (CGFloat)_numberOfMenus / _maxColumn;

    return ceil(rows);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SZMenuSection *section = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    section.scrollMenu = self;
    section.section = indexPath.item;
    section.delegate = self;
    NSIndexPath *idx = [NSIndexPath indexPathForItem:0 inSection:section.section];
    self.reuseCellList[idx] = section;
    
    return section;
}

#pragma mark - SZMenuSectionProtocol
- (CGSize)sizeOfItemsInMenuSection:(SZMenuSection *)menuSection {
    
    CGFloat width =  CGRectGetWidth(self.frame)/_maxColumn;
    
    return CGSizeMake(width, self.menuItemHeight);
}

- (NSUInteger)numberOfItemsInMenuSection:(SZMenuSection *)menuSection {

    NSUInteger number = _numberOfMenus - _maxColumn * menuSection.section;
    
    return MIN(number, _maxColumn);
}

- (SZMenuItem *)menuSection:(SZMenuSection *)menuSection menuItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(scrollMenu:menuItemAtIndexPath:)]) {
        NSIndexPath *idx = [NSIndexPath indexPathForRow:indexPath.row inSection:menuSection.section];
        return [self.delegate scrollMenu:self menuItemAtIndexPath:idx];
    }
    return nil;
}

- (void)menuSection:(SZMenuSection *)menuSection didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenu:didSelectItemAtIndexPath:)]) {
        
        NSIndexPath *idx = [NSIndexPath indexPathForRow:indexPath.row inSection:menuSection.section];
        
        [self.delegate scrollMenu:self didSelectItemAtIndexPath:idx];
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.frame;
    
    [self.pageControl setCurrentPage:offset.x / bounds.size.width];
}

#pragma mark - PageCotrolTurn
- (void)pageTurn:(UIPageControl *)sender {
    
    CGSize viewSize = self.collectionView.frame.size;
    
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

#pragma mark - Public
- (void)reloadData {
    if ([self.delegate respondsToSelector:@selector(numberOfMenusInScrollMenu:)] &&
        [self.delegate respondsToSelector:@selector(numberOfRowsInScrollMenu:)] &&
        [self.delegate respondsToSelector:@selector(numberOfColumnsInScrollMenu:)]) {
        _numberOfMenus = [self.delegate numberOfMenusInScrollMenu:self];
        _maxRow = [self.delegate numberOfRowsInScrollMenu:self];
        _maxColumn = [self.delegate numberOfColumnsInScrollMenu:self];
    }
    NSUInteger numberOfPages = ceil((CGFloat)_numberOfMenus / (_maxRow * _maxColumn));
    
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.hidden = numberOfPages < 2;
    CGFloat height = _maxRow * self.menuItemHeight + self.pageControlHeight;
    self.sz_height = height;
    [self.collectionView reloadData];
}

@end

