//
//  HFVideoCaptureViewController.m
//  LYDLiveDemo
//
//  Created by yuandiLiao on 17/3/2.
//  Copyright © 2017年 yuandiLiao. All rights reserved.
//

#import "YDVideoCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YDVideoCaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UIButton *changeCameraPositionButton;
//会话对象
@property (nonatomic,strong)AVCaptureSession *captureSession;
//摄像头设备
@property (nonatomic,strong)AVCaptureDevice *videoDevice;
//声音设备
@property (nonatomic,strong)AVCaptureDevice *audioDevice;
//设备视屏输入对象
@property (nonatomic,strong)AVCaptureDeviceInput *videoDeviceInput;
//设备音频输入对象
@property (nonatomic,strong)AVCaptureDeviceInput *audioDeviceInput;
//设备视屏输出对象
@property (nonatomic,strong)AVCaptureVideoDataOutput *videoOutput;
//设备音频输出对象
@property (nonatomic,strong)AVCaptureAudioDataOutput *audioOutput;
//输入与输出连接
@property (nonatomic,strong)AVCaptureConnection *videoConnection;
@end

@implementation YDVideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self captureVideoAndAudio];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.changeCameraPositionButton];
}

-(void)captureVideoAndAudio
{
    //开始配置
    [self.captureSession beginConfiguration];
    //添加视屏输入和音频输入到session中
    if ([self.captureSession canAddInput:self.videoDeviceInput]) {
        [self.captureSession addInput:self.videoDeviceInput];
    }
    if ([self.captureSession canAddInput:self.audioDeviceInput]) {
        [self.captureSession addInput:self.audioDeviceInput];
    }
    
    //设置代理，获取视屏输出数据
    //这里要创建一个串行队列
    dispatch_queue_t videoOutputQueue = dispatch_queue_create("videoOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.videoOutput setSampleBufferDelegate:self queue:videoOutputQueue];
    if ([self.captureSession canAddOutput:self.videoOutput]) {
        //将输出视屏加入session中
        [self.captureSession addOutput:self.videoOutput];
    }
    dispatch_queue_t audioOutputQueue = dispatch_queue_create("audioOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.audioOutput setSampleBufferDelegate:self queue:audioOutputQueue];
    if ([self.captureSession canAddOutput:self.audioOutput]) {
        [self.captureSession addOutput:self.audioOutput];
    }
    // 9.获取视频输入与输出连接，用于分辨音视频数据
    self.videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //显示在layer层
    AVCaptureVideoPreviewLayer *capturePreViewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    capturePreViewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:capturePreViewLayer atIndex:0];
    //完成配置
    [self.captureSession commitConfiguration];
    //启动会话
    [self.captureSession startRunning];
    
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 获取输入设备数据，有可能是音频有可能是视频
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_videoConnection == connection) {
        NSLog(@"采集到视频数据");
    } else {
        NSLog(@"采集到音频数据");
    }
}
-(AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}
-(AVCaptureDevice *)videoDevice
{
    if (!_videoDevice) {
        _videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];

    }
    return _videoDevice;
}
-(AVCaptureDevice *)audioDevice
{
    if (!_audioDevice) {
        _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    }
    return _audioDevice;
}

-(AVCaptureDeviceInput *)videoDeviceInput
{
    if (!_videoDeviceInput) {
        _videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.videoDevice error:nil];
    }
    return _videoDeviceInput;
}
-(AVCaptureDeviceInput *)audioDeviceInput
{
    if (!_audioDeviceInput) {
        _audioDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.audioDevice error:nil];
    }
    return _audioDeviceInput;
}
-(AVCaptureVideoDataOutput *)videoOutput
{
    if (!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    }
    return _videoOutput;
}
-(AVCaptureAudioDataOutput *)audioOutput
{
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    }
    return _audioOutput;
}

// 指定摄像头方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
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
-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)changeCameraPosition
{
    
    // 获取需要改变的方向
    AVCaptureDevicePosition currentCameraPosition = [self.videoDevice position];
    
    if (currentCameraPosition == AVCaptureDevicePositionBack)
    {
        currentCameraPosition = AVCaptureDevicePositionFront;
    }
    else
    {
        currentCameraPosition = AVCaptureDevicePositionBack;
    }

//    // 获取需要改变的方向
    //重新获取摄像设备
    AVCaptureDevice *videoDevice = [self getVideoDevice:currentCameraPosition];
    //重置视屏输入
    AVCaptureDeviceInput *videoDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:videoDevice error:nil];
    if (videoDeviceInput) {
        [_captureSession beginConfiguration];
        [self.captureSession removeInput:self.videoDeviceInput];
        if ([self.captureSession canAddInput:videoDeviceInput]) {
            [self.captureSession addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
            self.videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
            self.videoDevice = videoDevice;
        }else{
            [self.captureSession addInput:self.videoDeviceInput];
        }
        [self.captureSession commitConfiguration];

    }
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
