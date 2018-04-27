//
//  TempViewController.m
//  SZKitDemo
//
//  Created by zxc on 2017/8/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "TempViewController.h"
#import "SZKit.h"
#import <Masonry.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface TempViewController ()<SZScrollRadioProtocol, SZTagsViewProtocol>

@property(nonatomic, weak) UILabel *label;

@property(nonatomic, strong) SZScrollRadio *scrollRadio;
@property(nonatomic, strong) SZStarView *starView;
@property(nonatomic, strong) SZTagsView *tagsView;

@end

@implementation TempViewController

- (void)dealloc {
    [[SZTimer shareInstance] cancelTimerWithName:@"SZTTT"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationBar.title = @"详情";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth(), 20)];
    label.backgroundColor = [UIColor redColor];
    label.sz_lineSpace = 5;
    label.sz_characterSpace = 5;
    label.sz_keywords = @"text";
    label.sz_keywordsFont = [UIFont boldSystemFontOfSize:kRealFontSize(20)];
    label.sz_keywordsFontColor = [UIColor blueColor];
    label.sz_keywordsBackGroundColor = [UIColor yellowColor];
    label.font = [UIFont systemFontOfSize:kRealFontSize(14)];
    label.numberOfLines = 0;
    label.sz_text = @"ashfaifoadsfntextasjkfnjksdfnkatextsafdsfdsfsdfas";
    [self.view addSubview:label];
    self.label = label;
    
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:@"SZTTT" timeInterval:1 queue:nil repeats:YES actionOption:SZTaskOptionAbandonPrevious action:^{
        [weakSelf changeColor];
    }];
    
    self.scrollRadio = ({
       
        SZScrollRadio *scrollRadio = [[SZScrollRadio alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.label.frame) + 20, ScreenWidth() - 40, kRealLength(30))];
        scrollRadio.layer.cornerRadius = kRealLength(15);
        
        scrollRadio.backgroundColor = [UIColor whiteColor];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRealLength(50), kRealLength(20))];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [rightView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
            make.width.offset(1);
        }];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:kRealFontSize(12)];
        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [moreBtn addTarget:self
                    action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right);
            make.top.bottom.offset(0);
            make.right.offset(-kRealLength(10));
        }];
        scrollRadio.rightView = rightView;
        scrollRadio.delegate = self;
        
        scrollRadio;
    });
    
    [self.view addSubview:self.scrollRadio];
    
    self.starView = ({
       
        SZStarView *starView = [[SZStarView alloc] initWithStarSize:CGSizeMake(17, 17) starInsets:UIEdgeInsetsZero starsCount:5];
        
        starView.slideEnabled = YES;
        
        starView;
    });
    [self.view addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(self.scrollRadio.mas_bottom);
    }];
    
    self.tagsView = ({
       
        SZTagsView *banner = [[SZTagsView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth(), kRealLength(190))];
        banner.backgroundColor = [UIColor redColor];
        banner.backgroundColor = [UIColor sz_randomColor];
        banner.tagCornerRadius = banner.cellHeight / 2;
        banner.delegate = self;
        
        banner;
    });
    [self.view addSubview:self.tagsView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Action
- (void)changeColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.backgroundColor = [UIColor sz_randomColor];
    });
}

- (void)moreAction:(UIButton *)sender {
    NSLog(@"更多");
}

#pragma mark - SZTagsViewProtocol
- (NSInteger)numberOfItemsInTagsView:(SZTagsView *)tagsView {
    return 6;
}

- (NSString *)tagsView:(SZTagsView *)tagsView titleForItemAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"第%ld条数据sfdfass", (long)index];
}


#pragma mark - SZScrollRadioProtocol
- (NSUInteger)numbersOfRowAtScrollRadio:(SZScrollRadio *)scrollRadio {
    return 1;
}

- (NSUInteger)countsOfItemAtScrollRadio:(SZScrollRadio *)scrollRadio {
    return 10;
}

- (SZScrollRadioCell *)scrollRadio:(SZScrollRadio *)scrollRadio cellForRowAtIndex:(NSUInteger)index {
    SZScrollRadioCell *cell = [scrollRadio dequeueReusableCellForIndex:index];
    
    cell.textLabel.text = [NSString stringWithFormat:@"测jqwefqw数据：%ld", (unsigned long)index];
    
    return cell;
}

- (void)scrollRadio:(SZScrollRadio *)scrollRadio didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"选择了:%ld", index);
}

@end
