//
//  SZNavigationBar.m
//  SZKitDemo
//
//  Created by zxc on 2017/10/16.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZNavigationBar.h"
#import "SZAdapter.h"

#import <objc/runtime.h>

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
        self.frame = CGRectMake(0, 0, kScreenWidth(), 64);
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.maskView];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth(), 44)];
        [self addSubview:self.contentView];
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kScreenWidth(), 0.5)];
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
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = self.tintColor;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.contentView);
        }];
    }
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
    CGFloat wid = kScreenWidth();
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

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    [_titleLabel removeFromSuperview];
    _titleView = titleView;
    [self.contentView addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(30);
    }];
    [self updateConstraintsCustom];
}

- (void)setLeftButtonItems:(NSArray<SZBarButtonItem *> *)leftButtonItems {
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
}

@end


@implementation UIViewController(SZNavigationBar)

- (SZNavigationBar *)navigationBar {
    if (objc_getAssociatedObject(self, _cmd)) {
        return objc_getAssociatedObject(self, _cmd);
    }
    SZNavigationBar *bar = [[SZNavigationBar alloc] init];
    objc_setAssociatedObject(self, @selector(navigationBar), bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.view addSubview:bar];
    return bar;
}

@end

