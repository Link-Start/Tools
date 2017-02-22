//
//  LSCustomCamera.m
//  LSProjectTool
//
//  Created by Xcode on 16/11/3.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSCustomCamera.h"
#import <AVFoundation/AVFoundation.h>

//AVCaptureMetadataOutputObjectsDelegate :用于处理采集信息的代理
//UIGestureRecognizerDelegate 手势
@interface LSCustomCamera ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>//

///捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

///输入流
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

///协调输入输出流的数据 session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

///预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
///绘制图层
@property (nonatomic, strong) CALayer *drawLayer;

///输出流 - 用于捕捉静态图片
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

///原始视频帧，用于获取实时图像以及视频录制
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

/// 完成回调
@property (nonatomic, copy) void (^completionCallBack)(UIImage *);

///焦点锁定view
@property (nonatomic, strong) UIView *focusView;

//手势是否可用
@property (nonatomic, assign, getter=isEnable) BOOL enable;

///记录开始的缩放比例
@property (nonatomic, assign) CGFloat beginScalingRatio;
///记录最后的缩放比例
@property (nonatomic, assign) CGFloat endScalingRatio;

@end



@implementation LSCustomCamera



///单利
+ (LSCustomCamera *)shareCustomCamera {
    
    static LSCustomCamera *ls_customCamera = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_customCamera = [[LSCustomCamera alloc] init];
    });
    return ls_customCamera;
}

- (instancetype)takePhotoComplete:(UIView *)view takePhotoFrame:(CGRect)takePhotoFrame completion:(void (^)(UIImage *))completion {
    NSAssert(completion != nil, @"必须完成回调");
    
    return [self initWithView:view takePhotoFrame:takePhotoFrame completion:completion];
}

- (instancetype)initWithView:(UIView *)view takePhotoFrame:(CGRect)takePhtotFrame completion:(void (^)(UIImage *))completion {
    self = [super init];
    
    if (self) {
        _parentView = view;
        _completionCallBack = completion;
        _enable = YES;
        _beginScalingRatio = 1.0;
        _endScalingRatio = 1.0;
        //设置扫描会话
        [self setupSession];
    }
    return self;
}

/// 设置 会话
- (void)setupSession {
    
    //设置焦点锁定view
    [self configFocusView];
    
    //将预览图层添加到父视图上
      [self.parentView.layer insertSublayer:self.previewLayer atIndex:0];
    
    //添加手势
    [self addGestureRecongnizer];
    
   //设备开始取景
   [self startRun];
}

///添加手势
- (void)addGestureRecongnizer {
    //添加轻拍手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.parentView addGestureRecognizer:tapGesture];
    
    //手势缩放，手动调节相机焦距 -- 1
    //添加缩放手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    [self.parentView addGestureRecognizer:pinchGesture];
    pinchGesture.delegate = self;
}

//设置焦点锁定view
- (void)configFocusView {
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.parentView addSubview:_focusView];
    _focusView.hidden = YES;
}

///手势缩放，手动调节相机焦距 -- 2
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)recognizer {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.parentView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if (![self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        
        self.endScalingRatio = self.beginScalingRatio * recognizer.scale;
        
        //相机支持的焦距是1.0~67.5，
//        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
//        CGFloat minScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoScaleAndCropFactor];
        if (self.endScalingRatio <= 1.0){
            self.endScalingRatio = 1.0;
        }

        if (self.endScalingRatio >= 65.0) {
            self.endScalingRatio = 65.0;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.endScalingRatio, self.endScalingRatio)];
        [CATransaction commit];  
    }
}

///手势缩放，手动调节相机焦距 -- 3
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (!self.enable) { //如果手势不能用
        return NO;
    }
    
    //如果是缩放手势
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginScalingRatio = self.endScalingRatio;
    }
    return YES;
}

//根据前后置位置拿到相应的摄像头：
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices)
        if ( device.position == position ){
            return device;
        }
    return nil;
}

////设置预览图层
//- (void)setupLayers {
//    
//    if (self.parentView == nil) {
//        NSLog(@"父视图不存在");
//        return;
//    }
//    if (self.session == nil) {
//        NSLog(@"拍摄会话不存在");
//        return;
//    }
//    
//    //绘制图层
//    self.drawLayer = [CALayer layer];
//    self.drawLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor greenColor]);
//    
//    self.drawLayer.frame = [UIScreen mainScreen].bounds;
//    //将图层插入当前预览图层
//    [self.parentView.layer insertSublayer:self.drawLayer atIndex:0];
//    
//    //创建AVCaptureVideoPreviewLayer对象来实时获取摄像头图像
//    // 实例化预览图层, 传递 session是为了告诉图层将来显示什么内容
//    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
//    //设置预览图层填充方式
//    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    //设置图层的frame
//    self.previewLayer.frame = [UIScreen mainScreen].bounds;
//    ///将图层添加到预览view的图层上 调用[self.view addSubview: self.scanView]把摄像头获取的图像实时展示在屏幕上
//    [self.parentView.layer insertSublayer:self.previewLayer atIndex:0];
//    
////    如果是横屏开发时候会出现预览层貌似旋转的效果
////    self.previewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
//}


//拍照方法
- (void)takePhotoBtnAction {
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:currentOrientation];
    [connection setVideoOrientation:avcaptureOrientation];
    [connection setVideoScaleAndCropFactor:self.endScalingRatio];
    
    if (!connection) {
        NSLog(@"拍照失败!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        
        //停止
        [self stopRun];
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *img = [UIImage imageWithData:imageData];
        if (img.imageOrientation == UIImageOrientationDown) {
            NSLog(@"照片反了！！！！");
            img = [self normalizedImage:img];
        }
        
        if (img.imageOrientation == UIImageOrientationUp) {
            NSLog(@"照片正常！！");
        }
        
        if (self.completionCallBack) {
            self.completionCallBack([UIImage imageWithData:imageData]);
        }
        
        //保存图片
        //        [self saveImageToPhotoAlbum:[UIImage imageWithData:imageData]];
    }];

}
- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp){
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

//保存至相册
- (void)saveImageToPhotoAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
//指定方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error != NULL) {
        NSLog(@"保存图片失败");
    } else {
        NSLog(@"保存图片成功");
    }
}

//切换前后摄像头
- (void)switchCamera {
    NSUInteger cameraCount = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
    if (cameraCount > 1) {
        NSError *error;
        //给摄像头的切换添加翻转动画
        CATransition *animation = [self addFlipAnimation];
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newDeviceInput = nil;
        
        //拿到另外一个摄像头的位置
        AVCaptureDevicePosition position = [[self.deviceInput device] position];
        
        if (position == AVCaptureDevicePositionFront) { //如果是前置摄像头
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft; //动画翻转方向
            
        } else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;//动画翻转方向
        }
        
        //生成新的输入
        newDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
        
        if (newDeviceInput == nil) {
            NSLog(@"创建输入设备失败");
            return;
        }
        if (error) {
            NSLog(@"切换前后摄像头错误：%@", error);
            return;
        }
        
        [self.previewLayer addAnimation:animation forKey:nil];
        
        if (newDeviceInput) { //如果新的输入流存在
            
            [self.session beginConfiguration];
            
            [self.session removeInput:self.deviceInput];
            
            if ([self.session canAddInput:newDeviceInput]) {//如果能够添加新的输入流
                [self.session addInput:newDeviceInput];
                self.deviceInput = newDeviceInput;
                
            } else {
                [self.session addInput:self.deviceInput];
            }
            
            [self.session commitConfiguration];
        }
    }
}

///添加翻转动画
- (CATransition *)addFlipAnimation {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    
    return animation;
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture {
    
    if (self.enable) {
        CGPoint point = [gesture locationInView:gesture.view];
        
        //设置焦点
        [self focusAtPoint:point];
    }
}

//point为 点击的位置
- (void)focusAtPoint:(CGPoint)point {
    CGSize size = self.parentView.bounds.size;
    
    CGPoint focunsPoint = CGPointMake(point.y / size.height, 1 - point.x / size.width);
    //错误
    NSError *error;
    
    if ([self.device lockForConfiguration:&error]) {
        
        //对焦模式 和 对焦点
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focunsPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        //曝光模式和曝光点
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [self.device setExposurePointOfInterest:focunsPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        
        //设置对焦动画
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}


///清空绘制图层
- (void)clearDrawLayer {

    if (self.drawLayer.sublayers.count == 0) {
        return;
    }
    //删除预览图层
    [_drawLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

#pragma mark - 公共方法
/// 设备开始取景
- (void)startRun {
    if ([self.session isRunning]) {
        return;
    }
    _enable = YES;
    //开始捕获
    [self.session startRunning];
}

///停止捕获
- (void)stopRun {
    if (![self.session isRunning]) {
        return;
    }
    _enable = NO;
    [self.session stopRunning];
}

///移除手势
- (void)removeGestureRecognizer {
    for (id gesture in self.parentView.gestureRecognizers) {
        [self.parentView removeGestureRecognizer:gesture];
    }
}

//和扫一扫二维码伴随的就是开启系统照明，这个比较简单，也是利用 AVCaptureDevice,请看如下实现：
//手电筒🔦
- (void)systemLightSwitch:(BOOL)open {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch]) {
        //修改前必须先锁定
        [device lockForConfiguration:nil];
        
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        
        [device unlockForConfiguration];
    }
}

//闪光灯
- (void)systemSwitch {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯,如果没有闪光灯会崩溃
    if ([device hasFlash]) { //
        
        if (device.flashMode == AVCaptureFlashModeOff) { //关闭
            device.flashMode = AVCaptureFlashModeOn;
        } else if (device.flashMode == AVCaptureFlashModeOn) { //打开
            device.flashMode = AVCaptureFlashModeAuto;
        } else if (device.flashMode == AVCaptureFlashModeAuto) { //自动
            device.flashMode = AVCaptureFlashModeOff;
        }
        
    } else {
        NSLog(@"设备不支持闪光灯");
    }
    
    [device unlockForConfiguration];
}

#pragma mark - 懒加载
//硬件设备
- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([_device lockForConfiguration:nil]) { //先锁定
            //自动闪光灯
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
//                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
//                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            //自动曝光
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            //这句代码是对夜间拍照时候的自动补光, 如果没有这句代码, 晚上拍照基本上是黑色的, 比苹果系统的相机照片差很多
            if (_device.isLowLightBoostSupported) {
                _device.automaticallyEnablesLowLightBoostWhenAvailable = YES;
            }
            [_device unlockForConfiguration];
        }
    }
    return _device;
}

//输入流
- (AVCaptureDeviceInput *)deviceInput {
    if (!_deviceInput) {
        NSError *error = nil;
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
        if (error) {
            NSLog(@"创建输入设备失败");
            NSLog(@"创建输入设备错误：%@", error);
            return nil;
        }
    }
    return _deviceInput;
}

//输出流 - 用于捕捉静态图片
- (AVCaptureStillImageOutput *)stillImageOutput {
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        //输出设置：输出jpeg格式的图片
        [_stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    }
    return _stillImageOutput;
}

//原始视频帧，用于获取实时图像以及视频录制
- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        //设置像素格式
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    }
    return _videoDataOutput;
}

//协调输入输出流的数据
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        
        /// 设置高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        //判断是否能够添加设备
        if (![_session canAddInput:self.deviceInput]) {
            NSLog(@"无法添加输入设备!");
            return nil;
        }
        if (![_session canAddOutput:self.stillImageOutput]) {
            NSLog(@"无法添加输出设备stillImageOutput");
            return nil;
        }
        if (![_session canAddOutput:self.videoDataOutput]) {
            NSLog(@"无法添加输出设备videoDataOutput");
            return nil;
        }
        
        if ([_session canAddInput:self.deviceInput]) {
            [_session addInput:_deviceInput];
        }
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:_stillImageOutput];
        }
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:_videoDataOutput];
        }
    }
    return _session;
}

//预览层
- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        if (_parentView == nil) {
            NSLog(@"父视图不存在");
            return nil;
        }
        if (self.session == nil) {
            NSLog(@"拍摄会话不存在");
            return nil;
        }
        //绘制图层
        self.drawLayer = [CALayer layer];
        
        _drawLayer.frame = self.parentView.bounds;
        //将图层插入当前预览图层
        [self.parentView.layer insertSublayer:_drawLayer atIndex:0];
        
        //创建AVCaptureVideoPreviewLayer对象来实时获取摄像头图像
        // 实例化预览图层, 传递 session是为了告诉图层将来显示什么内容
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        //设置预览图层填充方式
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //设置图层的frame
        _previewLayer.frame = self.parentView.bounds;
        ///将图层添加到预览view的图层上 调用[self.view addSubview: self.scanView]把摄像头获取的图像实时展示在屏幕上
//        [self.parentView.layer insertSublayer:_previewLayer atIndex:0];
    }
    return _previewLayer;
}

@end
