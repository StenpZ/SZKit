
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIButton+SZKit.h"

@implementation UIButton (SZKit)

- (void)sz_layoutWithMargin:(CGFloat)margin {
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -margin, 0, margin);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, -margin);
    if (!self.frame.size.width) {
        [self sizeToFit];
    }
}

- (void)sz_layoutImageRightWithMargin:(CGFloat)margin {
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    CGFloat titleWid = ({
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = self.titleLabel.font;
        label.text = self.titleLabel.text;
        [label sizeToFit];
        
        label.bounds.size.width;
    });
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWid + margin, 0, - titleWid - margin);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.image.size.width - margin, 0, -self.imageView.image.size.width);
    if (!self.frame.size.width) {
        [self sizeToFit];
    }
}

- (void)sz_layoutImageTopWithMargin:(CGFloat)margin {
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    CGSize titleSize = ({
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = self.titleLabel.font;
        label.text = self.titleLabel.text;
        [label sizeToFit];
        
        label.bounds.size;
    });
    CGSize imageSize = self.imageView.image.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height - margin, 0, 0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - margin, 0);
    if (!self.frame.size.width) {
        [self sizeToFit];
    }
}

@end
