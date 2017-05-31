//
//  YDGPUImageCaptureViewController.m
//  LYDLiveDemo
//
//  Created by yuandiLiao on 17/3/30.
//  Copyright © 2017年 yuandiLiao. All rights reserved.
//

#import "YDGPUImageCaptureViewController.h"
#import <GPUImage.h>

@interface YDGPUImageCaptureViewController ()
@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UIButton *changeCameraPositionButton;

@property (nonatomic,strong)GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong)GPUImageView *catureVideoPreview;
@end

@implementation YDGPUImageCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setVideoCamera];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.changeCameraPositionButton];
}
-(void)setVideoCamera
{
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera = videoCamera;
    GPUImageView *gpuImageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.catureVideoPreview = gpuImageView;
    [self.view insertSubview:self.catureVideoPreview atIndex:0];
    [self.videoCamera addTarget:self.catureVideoPreview];
    [self.videoCamera startCameraCapture];
 
}
-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)changeCameraPosition
{
    
}
-(UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-40, 20, 30, 30)];
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(UIButton *)changeCameraPositionButton
{
    if (!_changeCameraPositionButton) {
        _changeCameraPositionButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-80, 20, 30, 30)];
        [_changeCameraPositionButton setImage:[UIImage imageNamed:@"camera_preview"] forState:UIControlStateNormal];
        [_changeCameraPositionButton addTarget:self action:@selector(changeCameraPosition) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCameraPositionButton;
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
