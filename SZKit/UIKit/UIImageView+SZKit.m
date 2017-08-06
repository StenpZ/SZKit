
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIImageView+SZKit.h"
#import "UIImage+SZKit.h"


@implementation UIImageView (SZKit)

- (void)sz_setImageWithUrls:(NSArray *)imageUrls {
    [self sz_setImageWithUrls:imageUrls placeHolder:nil];
}

- (void)sz_setImageWithUrls:(NSArray *)imageUrls placeHolder:(UIImage *)placeholder {
    return [self sz_setImageWithUrls:imageUrls placeHolder:placeholder complent:nil];
}

- (void)sz_setImageWithUrls:(NSArray *)imageUrls placeHolder:(UIImage *)placeholder complent:(void (^)(UIImage *))complentBlock {
    self.image = placeholder;
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;
        UIImage *avatarImage = [UIImage sz_imageWithImageUrls:imageUrls backGroundColor:[UIColor lightGrayColor]];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.image = avatarImage;
            if (complentBlock) {
                complentBlock(avatarImage);
            }
        });
    });
}

@end
