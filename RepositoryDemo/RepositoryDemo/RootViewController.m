//
//  RootViewController.m
//  RepositoryDemo
//
//  Created by 李雪智 on 16/5/18.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 10)];
    _label.backgroundColor = ColorFF6600;
    [self.view addSubview:_label];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
