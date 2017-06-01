//
//  ViewController.m
//  HRCustomActionSheetDemo
//
//  Created by Zer0 on 2017/6/1.
//  Copyright © 2017年 Zer0. All rights reserved.
//

#import "ViewController.h"

#import "HRCustomActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickShowSheet:(id)sender {
    
    NSArray *contents = @[@"第一行",@"第二行",@"第三行",@"第四行"];
    
    [HRCustomActionSheet showDefaultCustomActionSheetWithTitle:@"这是标题" optionContents:contents selectedBlock:^(NSInteger index) {
        NSLog(@"点击了第%ld-------content:%@",index,contents[index]);
    }];
    
}

@end
