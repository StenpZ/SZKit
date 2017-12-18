
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZScrollBanner.h"
#import "SZTimer.h"
#import "UIView+SZKit.h"
#import "UIColor+SZKit.h"
#import "UIImage+SZKit.h"
#import "SZAdapter.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface SZScrollBannerCell ()

@property(nonatomic, strong, readwrite) UIImageView *imageView;
@property(nonatomic, strong, readwrite) UILabel *textLabel;
@property(nonatomic, strong) UIView *textBackgroundView;

@end

@implementation SZScrollBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self prepareUI];
        self.textBackgroundAlpha = 0.5;
        self.textBackgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)prepareUI {
    
    self.clipsToBounds = YES;
    self.imageView = ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView;
    });
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.textBackgroundView = [[UIView alloc] init];
    
    [self.contentView addSubview:self.textBackgroundView];
    
    self.textLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:kRealLength(12)];
        label.textColor = [UIColor whiteColor];
        
        label;
    });
    [self.contentView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(kRealLength(10));
        make.right.offset(-kRealLength(10));
        make.height.offset(kRealLength(25));
    }];
    
    [self.textBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(self.textLabel);
    }];
}

- (void)setTextBackgroundAlpha:(CGFloat)textBackgroundAlpha {
    
    _textBackgroundAlpha = textBackgroundAlpha;
    self.textBackgroundView.alpha = _textBackgroundAlpha;
}

- (void)setTextBackgroundColor:(UIColor *)textBackgroundColor {
    
    _textBackgroundColor = textBackgroundColor;
    self.textBackgroundView.backgroundColor = _textBackgroundColor;
}

- (void)setTextHidden:(BOOL)textHidden {
    
    _textHidden = textHidden;
    self.textBackgroundView.hidden =
    self.textLabel.hidden = _textHidden;
}

@end


@interface SZScrollBanner ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@property(nonatomic, strong) UIPageControl *pageControl;

@property(nonatomic, copy) NSString *scrollBannerTimerName;

@property(nonatomic, readwrite) NSUInteger numbersofPage;

@property(nonatomic) NSInteger currentIndex;

@property(nonatomic, copy, readonly) NSString *defaultCellIdentifier;

@end

static NSUInteger initIndex = 0;

@implementation SZScrollBanner

- (void)dealloc {
    
    [self stopScroll];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        initIndex ++;
        self.scrollBannerTimerName = [NSString stringWithFormat:@"kSZTimerScrollBanner_%ld", (unsigned long)initIndex];
        self.scrollInterval = 3;
        self.pageControlHeight = kRealLength(25);
        _defaultCellIdentifier = @"SZScrollBannerCell_default";
        [self prepareUI];
        self.showPageControl = YES;
        self.currentPageIndicatorTintColor = [UIColor darkTextColor];
        self.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
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

- (void)setPageControlHeight:(CGFloat)pageControlHeight {
    _pageControlHeight = (NSInteger)pageControlHeight;
}

- (void)setNumbersofPage:(NSUInteger)numbersofPage {
    
    _numbersofPage = numbersofPage;
    self.collectionView.scrollEnabled = self.numbersofPage > 1 ? YES: NO;
    self.pageControl.numberOfPages = self.numbersofPage;
    
    BOOL isSingle = self.numbersofPage > 1 ? NO: YES;
    
    self.pageControl.hidden = (self.showPageControl && !isSingle) ? NO: YES;
}

- (void)setDelegate:(id<SZScrollBannerProtocol>)delegate {
    _delegate = nil;
    _delegate = delegate;
    [self reloadData];
}

- (void)prepareUI {
    
    self.layout = ({
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout;
    });
    
    self.collectionView = ({
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollsToTop = NO;
        [collectionView registerClass:[SZScrollBannerCell class] forCellWithReuseIdentifier:self.defaultCellIdentifier];
        
        collectionView;
    });
    [self addSubview:self.collectionView];
    
    self.pageControl = ({
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPage = 0;
        
        pageControl;
    });
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.offset(self.pageControlHeight);
        make.bottom.offset(0);
    }];
}

- (void)registerClass:(Class)cellClass {
    
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:self.defaultCellIdentifier];
}

- (SZScrollBannerCell *)dequeueReusableCellForIndex:(NSUInteger)index {
    
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:self.defaultCellIdentifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)reloadData {
    
    if (self.superview) {
        [self.superview layoutIfNeeded];
        self.layout.itemSize = self.bounds.size;
    }
    if ([self.delegate respondsToSelector:@selector(numbersofPageAtScrollBanner:)]) {
        
        self.numbersofPage = [self.delegate numbersofPageAtScrollBanner:self];
    }
    [self.collectionView reloadData];
    if (self.numbersofPage > 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self beginScroll];
}

- (void)adjustToFitWhenWillAppear {
    if (!self.numbersofPage) return;
    
    float index = self.collectionView.contentOffset.x / self.layout.itemSize.width;
    if (index != self.currentIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self configPageControl];
    }
}

- (void)beginScroll {
    if (self.numbersofPage <= 1) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:self.scrollBannerTimerName
                                               timeInterval:self.scrollInterval
                                                      queue:nil
                                                    repeats:YES
                                               actionOption:SZTaskOptionAbandonPrevious
                                                     action:^{
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             __strong typeof(self)strongSelf = weakSelf;
                                                             
                                                             [strongSelf automaticScroll];
                                                         });
                                                     }];
}

- (void)automaticScroll {
    
    NSUInteger index = self.collectionView.contentOffset.x / self.layout.itemSize.width;
    
    if (index > self.numbersofPage) {
        index = self.numbersofPage;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong typeof(self)strongSelf = weakSelf;
        
        [strongSelf configPageControl];
    });
    if (index == self.numbersofPage) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            __strong typeof(self)strongSelf = weakSelf;
            
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [strongSelf configPageControl];
        });
    }
}

- (void)stopScroll {
    
    [[SZTimer shareInstance] cancelTimerWithName:self.scrollBannerTimerName];
}

- (NSUInteger)indexFromIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger index = indexPath.item;
    
    if (index == self.numbersofPage + 1) {
        
        index = 0;
    } else if (index == 0) {
        
        index = self.numbersofPage - 1;
    } else {
        
        index = index - 1;
    }
    return index;
}

- (NSInteger)currentIndex {
    if (self.numbersofPage <= 1) {
        return 0;
    }
    NSIndexPath *visibleIndexPath = self.collectionView.indexPathsForVisibleItems.firstObject;
    return [self indexFromIndexPath:visibleIndexPath];
}

- (void)configPageControl {
    
    self.pageControl.currentPage = self.currentIndex;
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.numbersofPage) {
        return self.numbersofPage + 2;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(scrollBanner:cellForPageAtIndex:)] && self.numbersofPage) {
        
        return [self.delegate scrollBanner:self cellForPageAtIndex:[self indexFromIndexPath:indexPath]];
    }
    SZScrollBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.defaultCellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage sz_imageWithColor:[UIColor groupTableViewBackgroundColor]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(scrollBanner:didSelectedAtIndex:)] && self.numbersofPage) {
        [self.delegate scrollBanner:self didSelectedAtIndex:[self indexFromIndexPath:indexPath]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self stopScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger index = self.collectionView.contentOffset.x / self.layout.itemSize.width;
    
    if (index > self.numbersofPage) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (index == 0) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.numbersofPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self configPageControl];
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self beginScroll];
}

@end

