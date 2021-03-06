
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZNavigationBar.h"
#import "SZAdapter.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@implementation SZBarButtonItem

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self initWithImage:image title:nil target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self initWithImage:nil title:title target:target action:action];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action {
    self = [SZBarButtonItem buttonWithType:UIButtonTypeSystem];
    if (self) {
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
            self.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        }
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

@end


@interface SZNavigationBar ()

@property(nonatomic, strong) UIView *separator;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation SZNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _spacing = 10;
        self.frame = CGRectMake(0, 0, ScreenWidth(), HEIGHT_NAVI());
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.maskView];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_STATUSBAR(), ScreenWidth(), HEIGHT_NAVI_BAR())];
        [self addSubview:self.contentView];
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVI() - 0.5, ScreenWidth(), 0.5)];
        [self addSubview:self.separator];
        self.tintColor = [UIColor blackColor];
        self.barTintColor = [UIColor whiteColor];
        self.separatorColor = [UIColor lightGrayColor];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kRealFontSize(15)];
        _titleLabel.textColor = self.tintColor;
        [_titleView removeFromSuperview];
        _titleView = nil;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
        }];
    }
    [self updateConstraintsCustom];
    return _titleLabel;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.tintColor = tintColor;
            continue;
        }
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.textColor = tintColor;
            continue;
        }
    }
}

- (void)setAlpha:(CGFloat)alpha {
    self.maskView.alpha = alpha;
}

- (void)setSeparatorHidden:(BOOL)separatorHidden {
    _separatorHidden = separatorHidden;
    self.separator.hidden = separatorHidden;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.separator.backgroundColor = _separatorColor;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    self.maskView.backgroundColor = _barTintColor;
}

- (void)setLeftButtonItem:(SZBarButtonItem *)leftButtonItem {
    [_leftButtonItem removeFromSuperview];
    if (self.leftButtonItems.count) {
        for (UIView *v in self.leftButtonItems) {
            [v removeFromSuperview];
        }
    }
    _leftButtonItem = leftButtonItem;
    [self.contentView addSubview:_leftButtonItem];
    [_leftButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(_spacing);
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(44);
    }];
    [self updateConstraintsCustom];
}

- (CGFloat)getItemWidth:(SZBarButtonItem *)item {
    if (!item) {
        return 0;
    }
    CGFloat wid = item.frame.size.width;
    if (!wid) {
        if (item.titleLabel.text) {
            [item sizeToFit];
            wid = item.frame.size.width;
        } else {
            wid = 30;
        }
    }
    return wid;
}

- (void)setRightButtonItem:(SZBarButtonItem *)rightButtonItem {
    [_rightButtonItem removeFromSuperview];
    if (self.rightButtonItems.count) {
        for (UIView *v in self.rightButtonItems) {
            [v removeFromSuperview];
        }
    }
    _rightButtonItem = rightButtonItem;
    [self.contentView addSubview:_rightButtonItem];
    [_rightButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-_spacing);
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(44);
    }];
    [self updateConstraintsCustom];
}

- (CGFloat)getTitleViewWidth {
    CGFloat wid = ScreenWidth();
    wid -= 2 * _spacing;
    if (self.leftButtonItem) {
        wid -= [self getItemWidth:self.leftButtonItem] + _spacing;
    }
    if (self.rightButtonItem) {
        wid -= [self getItemWidth:self.rightButtonItem] + _spacing;
    }
    
    if (self.leftButtonItems) {
        for (SZBarButtonItem *item in self.leftButtonItems) {
            wid -= [self getItemWidth:item] + _spacing;
        }
    }
    
    if (self.rightButtonItems) {
        for (SZBarButtonItem *item in self.rightButtonItems) {
            wid -= [self getItemWidth:item] + _spacing;
        }
    }
    
    return wid;
}

- (CGFloat)getTitleWidth {
    CGFloat wid = ScreenWidth();
    wid -= 2 * _spacing;
    
    if (!self.leftButtonItems.count && !self.rightButtonItems.count) {
        if (_leftButtonItem || _rightButtonItem) {
            wid -= 2 * (MAX([self getItemWidth:_leftButtonItem], [self getItemWidth:_rightButtonItem]) + _spacing);
        }
        return wid;
    }
    
    CGFloat widL = 0;
    CGFloat widR = 0;
    if (self.leftButtonItems) {
        for (SZBarButtonItem *item in self.leftButtonItems) {
            widL += [self getItemWidth:item] + _spacing;
        }
    }
    
    if (self.rightButtonItems) {
        for (SZBarButtonItem *item in self.rightButtonItems) {
            widR += [self getItemWidth:item] + _spacing;
        }
    }
    wid -= 2 * MAX(widL, widR);
    
    return wid;
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    _titleView = titleView;
    [self.contentView addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(30);
    }];
    [self updateConstraintsCustom];
}

- (void)setLeftButtonItems:(NSArray<SZBarButtonItem *> *)leftButtonItems {
    [_leftButtonItem removeFromSuperview];
    _leftButtonItem = nil;
    for (SZBarButtonItem *item in _leftButtonItems) {
        [item removeFromSuperview];
    }
    _leftButtonItems = leftButtonItems;
    for (SZBarButtonItem *item in _leftButtonItems) {
        [self.contentView addSubview:item];
    }
    [self updateConstraintsCustom];
}

- (void)setRightButtonItems:(NSArray<SZBarButtonItem *> *)rightButtonItems {
    [_rightButtonItem removeFromSuperview];
    _rightButtonItem = nil;
    for (SZBarButtonItem *item in _rightButtonItems) {
        [item removeFromSuperview];
    }
    _rightButtonItems = rightButtonItems;
    for (SZBarButtonItem *item in _rightButtonItems) {
        [self.contentView addSubview:item];
    }
    [self updateConstraintsCustom];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)updateConstraintsCustom {
    SZBarButtonItem *leftLast;
    SZBarButtonItem *rightLast;
    if (_leftButtonItem) {
        [_leftButtonItem mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset([self getItemWidth:_leftButtonItem]);
        }];
        leftLast = _leftButtonItem;
    }
    if (_rightButtonItem) {
        [_rightButtonItem mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset([self getItemWidth:_rightButtonItem]);
        }];
        rightLast = _rightButtonItem;
    }
    if (_leftButtonItems) {
        SZBarButtonItem *lastItem;
        for (SZBarButtonItem *item in _leftButtonItems) {
            if (lastItem) {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.contentView);
                    make.left.equalTo(lastItem.mas_right).offset(_spacing);
                    make.width.offset([self getItemWidth:item]);
                    make.height.offset(44);
                }];
            } else {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.contentView);
                    make.left.offset(_spacing);
                    make.width.offset([self getItemWidth:item]);
                    make.height.offset(44);
                }];
            }
            lastItem = item;
        }
        leftLast = lastItem;
    }
    if (_rightButtonItems) {
        SZBarButtonItem *lastItem;
        for (SZBarButtonItem *item in _rightButtonItems) {
            if (lastItem) {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lastItem.mas_left).offset(-_spacing);
                    make.centerY.mas_equalTo(self.contentView);
                    make.width.offset([self getItemWidth:item]);
                    make.height.offset(44);
                }];
            } else {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-_spacing);
                    make.centerY.mas_equalTo(self.contentView);
                    make.width.offset([self getItemWidth:item]);
                    make.height.offset(44);
                }];
            }
            lastItem = item;
        }
        rightLast = lastItem;
    }
    if (_titleView) {
        if (leftLast) {
            [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLast.mas_right).offset(_spacing);
                make.centerY.mas_equalTo(self.contentView);
                make.height.offset(30);
                make.width.offset([self getTitleViewWidth]);
            }];
        } else {
            [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(_spacing);
                make.centerY.mas_equalTo(self.contentView);
                make.height.offset(30);
                make.width.offset([self getTitleViewWidth]);
            }];
        }
    }
    if (_titleLabel) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.width.mas_lessThanOrEqualTo([self getTitleWidth]).priorityHigh();
        }];
    }
}

@end
