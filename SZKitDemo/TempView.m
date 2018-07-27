//
//  TempView.m
//  SZKitDemo
//
//  Created by StenpZ on 2018/7/27.
//  Copyright © 2018年 StenpZ. All rights reserved.
//

#import "TempView.h"
#import "SZKit.h"
#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface TempView ()

@property(nonatomic, strong) UILabel *indexLabel;

@end

@implementation TempView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor sz_randomColor];
        
        self.indexLabel = ({
            UILabel *label = [UILabel new];
            [self addSubview:label];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor blackColor];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.offset(0);
                make.width.offset(100);
                make.height.offset(40);
            }];
            
            label;
        });

    }
    return self;
}

- (void)setIndex:(NSUInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"第（%ld）页", _index];
}

@end
