
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

@property(nonatomic, copy) NSString *reuseIdentifier;
@property(nonatomic) NSUInteger index;
@property(nonatomic, copy) void (^TapBlock)(NSUInteger index);

@end

@implementation SZScrollRadioCell

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        [self prepareUI];
        
        [self sz_addTapTarget:self action:@selector(tapAction)];
    }
    return self;
}

- (void)prepareUI {
    self.textLabel = ({
        UILabel *label = [[UILabel alloc] init];
        
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        label;
    });
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.mas_equalTo(self);
        make.right.offset(0);
    }];
}

- (void)tapAction {
    if (self.TapBlock) {
        self.TapBlock(self.index);
    }
}

@end


@interface SZScrollRadio ()

@property(nonatomic) NSUInteger numbersOfRow;
@property(nonatomic) NSUInteger countsOfItem;

@property(nonatomic) CGFloat itemHeight;

@property(nonatomic) NSUInteger finalIndex;

@property(nonatomic, strong) NSMutableDictionary *cellRegisterInfo;

@property(nonatomic, strong) NSMutableArray *visualCells;
@property(nonatomic, strong) NSMutableDictionary *reuseCells;
@property(nonatomic, copy) NSString *scrollRadioTimerName;

@property(nonatomic, copy, readonly) NSString *defaultCellIdentifier;

@end

static NSUInteger initIndex = 0;

@implementation SZScrollRadio

- (void)dealloc {
    [self stopScroll];
}

- (NSMutableDictionary *)cellRegisterInfo {
    if (!_cellRegisterInfo) {
        _cellRegisterInfo = [NSMutableDictionary dictionary];
    }
    return _cellRegisterInfo;
}

- (NSMutableArray *)visualCells {
    if (!_visualCells) {
        _visualCells = [NSMutableArray array];
    }
    return _visualCells;
}

- (NSMutableDictionary *)reuseCells {
    if (!_reuseCells) {
        _reuseCells = [NSMutableDictionary dictionary];
    }
    return _reuseCells;
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
    self.backgroundColor = [UIColor lightGrayColor];
    [self registerClass:[SZScrollRadioCell class]];
}

- (void)registerClass:(Class)cellClass {
    [self.cellRegisterInfo setValue:cellClass forKey:self.defaultCellIdentifier];
}

- (SZScrollRadioCell *)dequeueReusableCell {
    NSString *identifier = self.defaultCellIdentifier;
    if (![self.reuseCells objectForKey:identifier]) {
        SZScrollRadioCell *cell = [[self.cellRegisterInfo[identifier] alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
        [self.reuseCells setObject:cell forKey:identifier];
    }
    return [self.reuseCells objectForKey:identifier];
}


- (void)reloadData {
    
    for (UIView *view in self.visualCells) {
        [view removeFromSuperview];
    }
    [self.visualCells removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(numbersOfRowAtScrollRadio:)]) {
        self.numbersOfRow = [self.delegate numbersOfRowAtScrollRadio:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(countsOfItemAtScrollRadio:)]) {
        self.countsOfItem = [self.delegate countsOfItemAtScrollRadio:self];
    }
    
    if (![self.delegate respondsToSelector:@selector(scrollRadio:cellForRowAtIndex:)]) {
        return;
    }
    for (NSInteger index = 0; index < self.numbersOfRow * 2; index ++) {
        self.finalIndex = index;
        SZScrollRadioCell *cell = [self.delegate scrollRadio:self
                                             cellForRowAtIndex:self.finalIndex];
        cell.index = self.finalIndex;
        __weak typeof(self)weakSelf = self;
        [cell setTapBlock:^(NSUInteger selectedIndex){
            __strong typeof(self)strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(scrollRadio:didSelectedAtIndex:)]) {
                [strongSelf.delegate scrollRadio:strongSelf didSelectedAtIndex:selectedIndex];
            }
        }];
        self.itemHeight = CGRectGetHeight(self.bounds)/self.numbersOfRow;
        CGFloat orginX = self.leftView ? CGRectGetWidth(self.leftView.frame): 0;
        CGFloat marginR = self.rightView ? CGRectGetWidth(self.rightView.frame): 0;
        CGFloat width = CGRectGetWidth(self.frame) - orginX - marginR;

        cell.frame = CGRectMake(orginX, self.finalIndex * self.itemHeight, width, self.itemHeight);
        [self addSubview:cell];
        [self.visualCells addObject:cell];
        [self.reuseCells removeObjectForKey:cell.reuseIdentifier];
    }
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
    
    [UIView animateWithDuration:0.5 animations:^{
        for (SZScrollRadioCell *cell in self.visualCells) {
            cell.sz_orgin_y -= CGRectGetHeight(self.bounds);
        }
    } completion:^(BOOL finished) {
        
        NSArray *cells = [NSArray arrayWithArray:self.visualCells];
        
        for (SZScrollRadioCell *cell in cells) {
            if (cell.sz_orgin_y + cell.sz_height <= 0) {
                [cell removeFromSuperview];
                cell.sz_orgin_y += CGRectGetHeight(self.bounds) * 2;
                self.finalIndex ++;
                [self.visualCells removeObject:cell];
                [self.reuseCells setObject:cell forKey:cell.reuseIdentifier];
                if ([self.delegate respondsToSelector:@selector(scrollRadio:cellForRowAtIndex:)]) {
                    SZScrollRadioCell *cell = [self.delegate scrollRadio:self cellForRowAtIndex:self.finalIndex];
                    cell.index = self.finalIndex;
                    [self addSubview:cell];
                    [self.visualCells addObject:cell];
                    [self.reuseCells removeObjectForKey:cell.reuseIdentifier];
                }
            }
        }
    }];
}

- (void)stopScroll {
    [[SZTimer shareInstance] cancelTimerWithName:self.scrollRadioTimerName];
}

@end

