
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZScrollRadio.h"
#import "SZTimer.h"
#import "UIView+SZKit.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface SZScrollRadioCell ()

@end

@implementation SZScrollRadioCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.textLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:label];
        label;
    });
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.right.offset(0);
    }];
}

@end


@interface SZScrollRadio ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic) NSUInteger numbersOfRow;
@property(nonatomic) NSUInteger countsOfItem;

@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@property(nonatomic) NSUInteger finalIndex;

@property(nonatomic, copy) NSString *scrollRadioTimerName;

@property(nonatomic, copy, readonly) NSString *defaultCellIdentifier;

@end

static NSUInteger initIndex = 0;

@implementation SZScrollRadio

- (void)dealloc {
    [self stopScroll];
}

- (void)setFinalIndex:(NSUInteger)finalIndex {
    if (finalIndex > self.countsOfItem - 1) {
        finalIndex = 0;
    }
    _finalIndex = finalIndex;
}

- (void)setLeftView:(UIView *)leftView {
    [_leftView removeFromSuperview];
    _leftView = leftView;
    [self addSubview:_leftView];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(leftView.sz_orgin_x);
        make.centerY.equalTo(self.mas_centerY).offset(leftView.sz_orgin_y);
        make.width.offset(leftView.sz_width);
        make.height.offset(leftView.sz_height);
    }];
}

- (void)setRightView:(UIView *)rightView {
    [_rightView removeFromSuperview];
    _rightView = rightView;
    [self addSubview:_rightView];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(rightView.sz_orgin_x);
        make.centerY.equalTo(self.mas_centerY).offset(rightView.sz_orgin_y);
        make.width.offset(rightView.sz_width);
        make.height.offset(rightView.sz_height);
    }];
}

- (void)setDelegate:(id<SZScrollRadioProtocol>)delegate {
    _delegate = nil;
    _delegate = delegate;
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        initIndex ++;
        _scrollRadioTimerName = [NSString stringWithFormat:@"kSZTimerScrollRadio_%ld", (unsigned long)initIndex];
        _defaultCellIdentifier = @"SZScrollRadioCell_default";
        self.finalIndex = 0;
        self.changeInterval = 2;
        self.clipsToBounds = YES;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.layout = ({
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layout;
    });
    
    self.collectionView = ({
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        collectionView.backgroundColor = [UIColor whiteColor];
//        collectionView.pagingEnabled = YES;
        collectionView.scrollEnabled = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollsToTop = NO;
        
        collectionView;
    });
    [self addSubview:self.collectionView];
    
    [self registerClass:[SZScrollRadioCell class]];
}

- (void)registerClass:(Class)cellClass {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:self.defaultCellIdentifier];
}

- (__kindof SZScrollRadioCell *)dequeueReusableCellForIndex:(NSUInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:self.defaultCellIdentifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)reloadData {
    
    if ([self.delegate respondsToSelector:@selector(numbersOfRowAtScrollRadio:)]) {
        self.numbersOfRow = [self.delegate numbersOfRowAtScrollRadio:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(countsOfItemAtScrollRadio:)]) {
        self.countsOfItem = [self.delegate countsOfItemAtScrollRadio:self];
    }
    
    if (![self.delegate respondsToSelector:@selector(scrollRadio:cellForRowAtIndex:)]) {
        return;
    }
    CGFloat itemHeight = (NSInteger)CGRectGetHeight(self.bounds)/self.numbersOfRow;
    CGFloat orginY = (self.bounds.size.height - self.numbersOfRow * itemHeight) / 2;
    CGFloat orginX = self.leftView ? CGRectGetWidth(self.leftView.frame): 0;
    CGFloat marginR = self.rightView ? CGRectGetWidth(self.rightView.frame): 0;
    CGFloat width = CGRectGetWidth(self.frame) - orginX - marginR;
    
    self.layout.itemSize = CGSizeMake(width, itemHeight);
    self.collectionView.frame = CGRectMake(orginX, orginY, width, itemHeight * self.numbersOfRow);
    
    [self.collectionView reloadData];
    
    [self beginScroll];
}

- (void)beginScroll {
    if (self.countsOfItem <= self.numbersOfRow) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:self.scrollRadioTimerName timeInterval:self.changeInterval queue:nil repeats:YES actionOption:SZTaskOptionAbandonPrevious action:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self)strongSelf = weakSelf;
            [strongSelf scroll];
        });
    }];
}

- (void)scroll {
    NSUInteger index = self.collectionView.contentOffset.y / self.layout.itemSize.height;
    index += self.numbersOfRow;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)stopScroll {
    [[SZTimer shareInstance] cancelTimerWithName:self.scrollRadioTimerName];
}

- (NSIndexPath *)indexFromIndexPath:(NSIndexPath *)indexPath {
    if (self.countsOfItem % self.numbersOfRow == 0) {
        if (indexPath.row < self.countsOfItem) {
            return indexPath;
        }
        return [NSIndexPath indexPathForItem:indexPath.row - self.countsOfItem inSection:0];
    } else {
        if (indexPath.row < self.countsOfItem) {
            return indexPath;
        }
        if (indexPath.row > (self.countsOfItem / self.numbersOfRow + 1) * self.numbersOfRow) {
            return [NSIndexPath indexPathForItem:indexPath.row - (self.countsOfItem / self.numbersOfRow + 1) * self.numbersOfRow inSection:0];
        }
        return nil;
    }
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.countsOfItem % self.numbersOfRow == 0) {
        return (self.countsOfItem / self.numbersOfRow + 1) * self.numbersOfRow;
    }
    return (self.countsOfItem / self.numbersOfRow + 2) * self.numbersOfRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(scrollRadio:cellForRowAtIndex:)] && self.countsOfItem) {
        NSIndexPath *idx = [self indexFromIndexPath:indexPath];
        if (idx) {
            return [self.delegate scrollRadio:self cellForRowAtIndex:idx.row];
        }
    }
    SZScrollRadioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.defaultCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(scrollRadio:didSelectedAtIndex:)] && self.countsOfItem) {
        NSIndexPath *idx = [self indexFromIndexPath:indexPath];
        if (idx) {
            [self.delegate scrollRadio:self didSelectedAtIndex:indexPath.row];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSUInteger index = self.collectionView.contentOffset.y / self.layout.itemSize.height;
    if (self.countsOfItem % self.numbersOfRow == 0) {
        if (index == self.countsOfItem) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    } else {
        if (index == (self.countsOfItem / self.numbersOfRow + 1) * self.numbersOfRow) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

@end

