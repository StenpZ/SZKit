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

@interface TempViewController ()<SZScrollRadioProtocol, SZScrollBannerProtocol>

@property(nonatomic, weak) UILabel *label;

@property(nonatomic, strong) SZScrollRadio *scrollRadio;
@property(nonatomic, strong) SZStarView *starView;
@property(nonatomic, strong) SZScrollBanner *banner;

@end

@implementation TempViewController

- (void)dealloc {
    [[SZTimer shareInstance] cancelTimerWithName:@"SZTTT"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[SZTimer shareInstance] setLogEnabled:NO];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth(), 20)];
    label.backgroundColor = [UIColor redColor];
    label.sz_lineSpace = 5;
    label.sz_characterSpace = 5;
    label.sz_keywords = @"text";
    label.sz_keywordsFont = [UIFont boldSystemFontOfSize:kRealFontSize(20)];
    label.sz_keywordsFontColor = [UIColor blueColor];
    label.sz_keywordsBackGroundColor = [UIColor yellowColor];
    label.font = [UIFont systemFontOfSize:kRealFontSize(14)];
    label.numberOfLines = 0;
    label.sz_text = @"ashfaifoadsfntextasjkfnjksdfnkatext";
    [self.view addSubview:label];
    self.label = label;
    
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:@"SZTTT" timeInterval:1 queue:nil repeats:YES actionOption:SZTaskOptionAbandonPrevious action:^{
        [weakSelf changeColor];
    }];
    
    self.scrollRadio = ({
       
        SZScrollRadio *scrollRadio = [[SZScrollRadio alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth() - 40, kRealLength(60))];
        
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
        [scrollRadio registerClass:[SZScrollRadioCell class] forCellReuseIdentifier:@"reuseCell"];
        [scrollRadio reloadData];
        
        scrollRadio;
    });
    
    [self.view addSubview:self.scrollRadio];
    
    self.starView = ({
       
        SZStarView *starView = [[SZStarView alloc] initWithFrame:CGRectMake(100, 200, kRealLength(100), kRealLength(20))];
        
        starView.slideEnabled = YES;
        
        starView;
    });
    [self.view addSubview:self.starView];
    
    self.banner = ({
       
        SZScrollBanner *banner = [[SZScrollBanner alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth(), kRealLength(90))];
        banner.delegate = self;
        
        banner;
    });
    [self.view addSubview:self.banner];
    [self.banner reloadData];
    
    // Do any additional setup after loading the view.
}

- (NSUInteger)numbersofPageAtScrollBanner:(SZScrollBanner *)scrollBanner {
    return 10;
}

- (SZScrollBannerCell *)scrollBanner:(SZScrollBanner *)scrollBanner cellForPageAtIndex:(NSUInteger)index {
    SZScrollBannerCell *cell = [scrollBanner dequeueReusableCellWithIdentifier:scrollBanner.defaultCellIdentifier forIndex:index];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", index];
    return cell;
}

- (void)scrollBanner:(SZScrollBanner *)scrollBanner didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"点击:%ld", index);
}

- (void)changeColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.backgroundColor = [UIColor sz_randomColor];
    });
}

- (void)moreAction:(UIButton *)sender {
    NSLog(@"更多");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSUInteger)numbersOfRowAtScrollRadio:(SZScrollRadio *)scrollRadio {
    return 3;
}

- (NSUInteger)countsOfItemAtScrollRadio:(SZScrollRadio *)scrollRadio {
    return 10;
}

- (SZScrollRadioCell *)scrollRadio:(SZScrollRadio *)scrollRadio cellForRowAtIndex:(NSUInteger)index {
    SZScrollRadioCell *cell = [scrollRadio dequeueReusableCellWithIdentifier:@"reuseCell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据：%ld", (unsigned long)index];
    
    return cell;
}

- (void)scrollRadio:(SZScrollRadio *)scrollRadio didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"选择了:%ld", index);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
