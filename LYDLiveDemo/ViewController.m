//
//  ViewController.m
//  LYDLiveDemo
//
//  Created by yuandiLiao on 17/3/2.
//  Copyright © 2017年 yuandiLiao. All rights reserved.
//

#import "ViewController.h"
#import "YDVideoCaptureViewController.h"
#import "YDGPUImageCaptureViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = @[@"原始相机",@"美颜相机"];
    [self.view addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YDVideoCaptureViewController *videoCapureVC = [[YDVideoCaptureViewController alloc] init];
        [self.navigationController presentViewController:videoCapureVC animated:YES completion:^{
            
        }];

    }else if (indexPath.row == 1){
        YDGPUImageCaptureViewController *GPUImageCature = [[YDGPUImageCaptureViewController alloc] init];
        [self.navigationController presentViewController:GPUImageCature animated:YES completion:^{
            
        }];

    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
