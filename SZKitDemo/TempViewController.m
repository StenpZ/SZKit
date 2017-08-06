//
//  TempViewController.m
//  SZKitDemo
//
//  Created by zxc on 2017/8/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "TempViewController.h"
#import "SZKit.h"

@interface TempViewController ()<SZScrollRadioDataSource, SZScrollRadioDelegate>

@property(nonatomic, weak) UILabel *label;

@property(nonatomic, strong) SZScrollRadio *scrollRadio;

@end

@implementation TempViewController

- (void)dealloc {
    [[SZTimer shareInstance] cancelTimerWithName:@"SZTTT"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        scrollRadio.dataSource = self;
        scrollRadio.delegate = self;
        [scrollRadio registerClass:[SZScrollRadioCell class] forCellReuseIdentifier:@"reuseCell"];
        [scrollRadio reloadData];
        
        scrollRadio;
    });
    
    [self.view addSubview:self.scrollRadio];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)changeColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.backgroundColor = [UIColor sz_randomColor];
    });
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

- (void)scrollRadioDidSelectedAtIndex:(NSUInteger)index {
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
