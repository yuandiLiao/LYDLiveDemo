//
//  ViewController.m
//  LYDLiveDemo
//
//  Created by yuandiLiao on 17/3/2.
//  Copyright © 2017年 yuandiLiao. All rights reserved.
//

#import "ViewController.h"
#import "YDVideoCaptureViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    button.center = self.view.center;
    [button setTitle:@"去直播" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(statLive) forControlEvents:UIControlEventTouchUpInside];
}
-(void)statLive
{
    YDVideoCaptureViewController *videoCapureVC = [[YDVideoCaptureViewController alloc] init];
    [self.navigationController presentViewController:videoCapureVC animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
