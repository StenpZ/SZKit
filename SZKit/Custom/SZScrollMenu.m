
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

/**********************  SZMenuItem ***************************/
@interface SZMenuItem ()
/**
 *  The icon.
 */
@property (nonatomic, strong) UIImageView *icon;
/**
 *  The label.
 */
@property (nonatomic, strong) UILabel *label;
/**
 *  The edge of item.
 */
@property (nonatomic, assign) SZEdgeInsets edgeInsets; //default is {5,0,5,0,5}

@end

@implementation SZMenuItem
#pragma mark - Life Cycle
+ (void)initialize {
    
    SZMenuItem *item = [self appearance];
    
    item.iconSize = kRealLength(36);
    item.iconCornerRadius = kRealLength(18);
    item.textColor = [UIColor darkTextColor];
    item.textFont = [UIFont systemFontOfSize:kRealLength(11)];
    item.textHeight = kRealLength(20);
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    
    return self;
}

#pragma mark - Getter&Setter
- (void)setIconSize:(CGFloat)iconSize {
    
    if (iconSize >= 0) {
        
        _iconSize = iconSize;
        [self updateIconConstraints];
    }
}

- (void)setIconCornerRadius:(CGFloat)iconCornerRadius {
    
    if (iconCornerRadius >= 0) {
        
        _iconCornerRadius = iconCornerRadius;
        self.icon.layer.cornerRadius = iconCornerRadius;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    self.label.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    
    _textFont = textFont;
    self.label.font = textFont;
}

- (void)setEdgeInsets:(SZEdgeInsets)edgeInsets {
    
    _edgeInsets = edgeInsets;
    [self updateItemEdgeInsets];
}

#pragma mark - Prepare UI
- (void)prepareUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.icon = ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = self.iconCornerRadius;
        
        imageView;
    });
    
    self.label = ({
        
        UILabel *label = [[UILabel alloc] init];
        
        label.textColor = self.textColor;
        label.font = self.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        label;
    });
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.label];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    //The constraint of icon.
    [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.edgeInsets.top);
        make.centerX.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(self.iconSize);
    }];
    
    //The constraint of label.
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.icon.mas_bottom).offset(self.edgeInsets.middle);
        make.left.mas_equalTo(self.edgeInsets.left);
        make.right.mas_equalTo(- self.edgeInsets.right);
    }];
}

- (void)updateIconConstraints {
    
    if (self.icon) {
        
        [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.width.mas_equalTo(self.iconSize);
        }];
    }
}

- (void)updateItemEdgeInsets {
    
    if (self.icon && self.label) {
        
        [self.icon mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.edgeInsets.top);
        }];
        
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.icon.mas_bottom).offset(self.edgeInsets.middle);
            make.left.mas_equalTo(self.edgeInsets.left);
            make.right.mas_equalTo(- self.edgeInsets.right);
        }];
    }
}

#pragma mark - Customize
- (void)customizeItemWithObject:(id<SZMenuItemObject>)object {
    
    if (object == nil) return;
    
    self.label.text = object.text;
    if ([object.image isKindOfClass:[NSString class]]) {
        
        NSURL *url = [NSURL URLWithString:(NSString *)object.image];
        [self.icon sd_setImageWithURL:url placeholderImage:object.placeholderImage];
    }else if ([object.image isKindOfClass:[NSURL class]]){
        
        [self.icon sd_setImageWithURL:(NSURL *)object.image placeholderImage:object.placeholderImage];
    }else if ([object.image isKindOfClass:[UIImage class]]){
        
        self.icon.image = (UIImage *)object.image;
    }
}

#pragma mark - Identifier
+ (NSString *)identifier {
    
    return NSStringFromClass([self class]);
}

@end


/**********************  SZMenuSectionProtocol ***************************/
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
 Object at indexPath.
 
 @param menuSection SZMenuSection
 @param indexPath NSIndexPath
 @return id<SZMenuItemObject>
 */
- (id<SZMenuItemObject>)menuSection:(SZMenuSection *)menuSection objectAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 Did select item at indexPath.
 
 @param menuSection SZMenuSection
 @param indexPath NSIndexPath
 */
- (void)menuSection:(SZMenuSection *)menuSection didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end


/**********************  SZMenuSection ***************************/
NS_CLASS_AVAILABLE_IOS(8_0) @interface SZMenuSection : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**
 *  The collectionView.
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  The delegate.
 */
@property (nonatomic, weak) id<SZMenuSectionProtocol> delegate;
/**
 *  The section.
 */
@property (nonatomic, assign) NSUInteger section;

@property(nonatomic, assign) SZEdgeInsets itemEdgeInsets;

@end

@implementation SZMenuSection

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
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
        
        [collectionView registerClass:[SZMenuItem class] forCellWithReuseIdentifier:[SZMenuItem identifier]];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView;
    });
    
    [self.contentView addSubview:self.collectionView];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
}

#pragma mark - Identifier
+ (NSString *)identifier {
    
    return NSStringFromClass([self class]);
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
    
    SZMenuItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[SZMenuItem identifier] forIndexPath:indexPath];
    
    item.edgeInsets = self.itemEdgeInsets;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuSection:objectAtIndexPath:)]) {
        
        id<SZMenuItemObject> object = [self.delegate menuSection:self objectAtIndexPath:indexPath];
        [item customizeItemWithObject:object];
    }
    
    return item;
    
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

@property(nonatomic, assign) CGFloat itemHeight;

@end

@implementation SZScrollMenu

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.pageControlHeight = 16;
        self.itemEdgeInsets = SZEdgeInsetsMake(kRealLength(5), 0.f, kRealLength(5), 0.f, 0.f);
        [self prepareUI];
    }
    
    return self;
}

#pragma mark - Getter&Setter
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    if (self.pageControl) {
        
        self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    if (self.pageIndicatorTintColor) {
        
        self.pageIndicatorTintColor = pageIndicatorTintColor;
    }
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
        
        [collectionView registerClass:[SZMenuSection class] forCellWithReuseIdentifier:[SZMenuSection identifier]];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"log"];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView;
    });
    
    self.pageControl = ({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        
        pageControl.currentPageIndicatorTintColor = [UIColor darkTextColor];
        pageControl.pageIndicatorTintColor =  [UIColor groupTableViewBackgroundColor];
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
    }];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.frame), self.itemHeight - SZCollectionItemHeightComplexity);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsForEachRowInScrollMenu:)] && [self.delegate respondsToSelector:@selector(numberOfMenusInScrollMenu:)]) {
        
        NSUInteger total = [self.delegate numberOfMenusInScrollMenu:self];
        
        NSUInteger items = [self.delegate numberOfItemsForEachRowInScrollMenu:self];
        
        CGFloat rows = (CGFloat)total * 1.f /items;
        
        if ([self.delegate respondsToSelector:@selector(numberOfRowsForEachPageInScrollMenu:)]) {
            
            NSUInteger rows = [self.delegate numberOfRowsForEachPageInScrollMenu:self];
            
            NSUInteger numberOfPages = ceil(total*1.f/(rows * items));
            
            self.pageControl.numberOfPages = numberOfPages;
            self.pageControl.hidden = numberOfPages < 2;
        }
        
        return ceil(rows);
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SZMenuSection *section = [collectionView dequeueReusableCellWithReuseIdentifier:[SZMenuSection identifier] forIndexPath:indexPath];
    
    section.itemEdgeInsets = self.itemEdgeInsets;
    section.section = indexPath.row;
    section.delegate = self;
    
    return section;
}

#pragma mark - SZMenuSectionProtocol
- (CGSize)sizeOfItemsInMenuSection:(SZMenuSection *)menuSection {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsForEachPageInScrollMenu:)] && [self.delegate respondsToSelector:@selector(numberOfItemsForEachRowInScrollMenu:)]) {

        NSUInteger items = [self.delegate numberOfItemsForEachRowInScrollMenu:self];
        
        CGFloat width =  CGRectGetWidth(self.frame)/items;
        
        return CGSizeMake(width, self.itemHeight);
    }
    
    return CGSizeZero;
}

- (NSUInteger)numberOfItemsInMenuSection:(SZMenuSection *)menuSection {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfMenusInScrollMenu:)] && [self.delegate respondsToSelector:@selector(numberOfRowsForEachPageInScrollMenu:)]) {
        
        NSUInteger total = [self.delegate numberOfMenusInScrollMenu:self];
        
        NSUInteger items = [self.delegate numberOfItemsForEachRowInScrollMenu:self];
        
        NSUInteger number = total - items * menuSection.section;
        
        return MIN(number, items);
    }
    
    return 0;
}

- (id<SZMenuItemObject>)menuSection:(SZMenuSection *)menuSection objectAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollMenu:objectAtIndexPath:)]) {
        
        NSIndexPath *idx = [NSIndexPath indexPathForRow:indexPath.row inSection:menuSection.section];
        
        return [self.delegate scrollMenu:self objectAtIndexPath:idx];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsForEachPageInScrollMenu:)]) {
        
        NSUInteger rows = [self.delegate numberOfRowsForEachPageInScrollMenu:self];
        
        SZMenuItem *menuItem = [SZMenuItem appearance];
        
        CGFloat height = menuItem.iconSize + menuItem.textHeight + self.itemEdgeInsets.top + self.itemEdgeInsets.bottom + self.itemEdgeInsets.middle;
        
        self.itemHeight = height;
        
        CGFloat fullHeight = rows * (self.itemHeight - SZCollectionItemHeightComplexity) + _pageControlHeight - SZCollectionItemHeightComplexity;
        
        self.sz_height = MAX(fullHeight, self.bounds.size.height);
        
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.sz_height - _pageControlHeight);
        }];
    }
    
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}


@end

