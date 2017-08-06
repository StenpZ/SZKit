
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

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
#warning - 用手势的方式存在问题，存疑？
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_imageView) {
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
            make.width.equalTo(_imageView.mas_height);
        }];
    }
    
    if (_textLabel) {
        if (_imageView) {
            [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imageView.mas_right);
                make.centerY.mas_equalTo(self);
            }];
        } else {
            [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.centerY.mas_equalTo(self);
            }];
        }
    }
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = ({
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            [self addSubview:imageView];
            
            imageView;
        });
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = ({
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"测试数据测试数据";
            [self addSubview:label];
            
            label;
        });
    }
    return _textLabel;
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

@end

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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollRadioTimerName = @"kSZTimerScrollRadio";
        self.finalIndex = 0;
        self.changeInterval = 2;
        self.clipsToBounds = YES;
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.cellRegisterInfo setValue:cellClass forKey:identifier];
}

- (SZScrollRadioCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    if (![self.reuseCells objectForKey:identifier]) {
        SZScrollRadioCell *cell = [[SZScrollRadioCell alloc] initWithReuseIdentifier:identifier];
        [self.reuseCells setObject:cell forKey:identifier];
    }
    return [self.reuseCells objectForKey:identifier];
}


- (void)reloadData {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.visualCells removeAllObjects];
    
    if ([self.dataSource respondsToSelector:@selector(numbersOfRowAtScrollRadio:)]) {
        self.numbersOfRow = [self.dataSource numbersOfRowAtScrollRadio:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(countsOfItemAtScrollRadio:)]) {
        self.countsOfItem = [self.dataSource countsOfItemAtScrollRadio:self];
    }
    
    if (![self.dataSource respondsToSelector:@selector(scrollRadio:cellForRowAtIndex:)]) {
        return;
    }
    for (NSInteger index = 0; index < self.numbersOfRow * 2; index ++) {
        self.finalIndex = index;
        SZScrollRadioCell *cell = [self.dataSource scrollRadio:self
                                             cellForRowAtIndex:self.finalIndex];
        cell.index = self.finalIndex;
        __weak typeof(self)weakSelf = self;
        [cell setTapBlock:^(NSUInteger selectedIndex){
            __strong typeof(self)strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(scrollRadioDidSelectedAtIndex:)]) {
                [strongSelf.delegate scrollRadioDidSelectedAtIndex:selectedIndex];
            }
        }];
        self.itemHeight = CGRectGetHeight(self.bounds)/self.numbersOfRow;
        cell.frame = CGRectMake(0, self.finalIndex * self.itemHeight, CGRectGetWidth(self.bounds), self.itemHeight);
        [self addSubview:cell];
        [self.visualCells addObject:cell];
        [self.reuseCells removeObjectForKey:cell.reuseIdentifier];
    }
    [self beginScroll];
}

- (void)beginScroll {
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
                if ([self.dataSource respondsToSelector:@selector(scrollRadio:cellForRowAtIndex:)]) {
                    SZScrollRadioCell *cell = [self.dataSource scrollRadio:self cellForRowAtIndex:self.finalIndex];
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

