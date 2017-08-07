
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZScrollBanner.h"
#import "SZTimer.h"
#import "UIView+SZKit.h"
#import "UIColor+SZKit.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface SZScrollBannerCell ()


@end

@implementation SZScrollBannerCell

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
        }];
    }
    return _textLabel;
}

@end


@interface SZScrollBanner ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@property(nonatomic, strong, readwrite) UIPageControl *pageControl;

@property(nonatomic, copy) NSString *scrollBannerTimerName;

@property(nonatomic, readwrite) NSUInteger numbersofPage;

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
        _defaultCellIdentifier = @"SZBannerCell_default";
        [self prepareUI];
    }
    return self;
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
        pageControl.currentPageIndicatorTintColor = [UIColor sz_randomColor];
        pageControl.pageIndicatorTintColor = [UIColor sz_randomColor];
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPage = 0;

        pageControl;
    });
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.offset(16);
        make.bottom.offset(-10);
    }];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (SZScrollBannerCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)reloadData {
    [self.collectionView reloadData];
    [self beginScroll];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layout.itemSize = self.frame.size;
    self.collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

- (void)beginScroll {
    
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:self.scrollBannerTimerName timeInterval:self.scrollInterval queue:nil repeats:YES actionOption:SZTaskOptionAbandonPrevious action:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self)strongSelf = weakSelf;
            [strongSelf automaticScroll];
        });
    }];
}

- (void)automaticScroll {
    if (!self.numbersofPage) return;
    
    if (self.numbersofPage == 1) return;
    
    NSUInteger index = self.collectionView.contentOffset.x / self.layout.itemSize.width;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    self.pageControl.currentPage = MIN(index + 1, self.numbersofPage);
    if (index == self.numbersofPage) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            self.pageControl.currentPage = 0;
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

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(numbersofPageAtScrollBanner:)]) {
        self.numbersofPage = [self.delegate numbersofPageAtScrollBanner:self];
    }
    self.collectionView.scrollEnabled = self.numbersofPage > 1 ? YES: NO;
    self.pageControl.numberOfPages = self.numbersofPage;
    if (self.numbersofPage) {
        return self.numbersofPage + 2;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(scrollBanner:cellForPageAtIndex:)] && self.numbersofPage) {
        return [self.delegate scrollBanner:self cellForPageAtIndex:[self indexFromIndexPath:indexPath]];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.defaultCellIdentifier forIndexPath:indexPath];
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
        self.pageControl.currentPage = 0;
    } else if (index == 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.numbersofPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.pageControl.currentPage = self.numbersofPage;
    } else {
        self.pageControl.currentPage = self.numbersofPage - 1;
    }
    
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self beginScroll];
}

@end
