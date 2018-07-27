//
//  PageViewController.m
//  SZKitDemo
//
//  Created by StenpZ on 2018/7/27.
//  Copyright © 2018年 StenpZ. All rights reserved.
//

#import "PageViewController.h"
#import "SZKit.h"
#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif
#import "TempView.h"


@interface PageViewController ()<SZPageViewProtocol>

@property(nonatomic, strong) SZPageView *pageView;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.pageView.delegate = self;
}

- (SZPageView *)pageView {
    if (!_pageView) {
        _pageView = [SZPageView new];
    }
    return _pageView;
}

- (NSUInteger)numbersOfPageInPageView:(SZPageView *)pageView {
    return 10;
}


- (UIView *)pageView:(SZPageView *)pageView itemViewAtPage:(NSUInteger)page {
    TempView *temp = [TempView new];
    temp.index = page;
    return temp;
}

@end
