//
//  CameraAndPhotoTool.m
//  sheet
//
//  Created by lyb on 16/3/22.
//  Copyright © 2016年 lyb. All rights reserved.
//
///系统版本
#define kSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])


#import "VDCameraAndPhotoTool.h"
#import "UIImage+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h> //ios8之前的框架
#import <Photos/Photos.h>//ios8出来的框架



typedef enum {
    ///相册
    photoType,
    ///拍照
    cameraType,
    ///录像
    videoType
}pickerType;
static VDCameraAndPhotoTool *tool ;

@interface VDCameraAndPhotoTool ()<UIActionSheetDelegate>

@property (nonatomic, copy)cameraReturn finishBack;

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property(nonatomic, weak)UIViewController *fromVc;

@property (nonatomic, strong) UIImagePickerController *picker;


@end


@implementation VDCameraAndPhotoTool

//创建单利对象
+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[VDCameraAndPhotoTool alloc] init];
    });
    
    
    
    return tool;
}

//录像 - 摄像
- (void)showVideoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    ///确定相机是否可用: 先判断是否有摄像头 再判断摄像头是否可用
    if (![self toDetermineWhetherTheCameraIsAvailable]) {
        return;
    }
    ///判断访问权限
    [self setUpImagePicker:videoType];
    
    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面-录像
    
    //刷新约束的改变，使UIView重新布局
    //layoutIfNeeded是调整布局，也就是view的位置，一般是对subviews作用
    [vc.view layoutIfNeeded];
}

//照相 - 拍照
- (void)showCameraInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    ///确定相机是否可用: 先判断是否有摄像头 再判断摄像头是否可用
    if (![self toDetermineWhetherTheCameraIsAvailable]) {
        return;
    }
    ///判断访问权限
    [self setUpImagePicker:cameraType];
    
    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面-照相
    [vc.view layoutIfNeeded];
}

//相册
- (void)showPhotoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack{
    
    if (finishBack) {
        self.finishBack = finishBack;
    }
    ///判断访问权限
   [self setUpImagePicker:photoType];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:self.picker animated:YES completion:nil];//进入相册界面
    [vc.view layoutIfNeeded];

}

#pragma mark - imagePicker delegate
/**
 *  完成回调
 *
 *  @param picker imagePickerController
 *  @param info   信息字典
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //图片
        
        UIImage *image;
        // 如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.picker.allowsEditing) {
            // 获取编辑后的照片
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 获取原始照片
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) { //相机
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //保存图片至相册
              /**
                *  保存到相册的方法
                *  @param image#>              需要保存的图片
                *  @param completionTarget#>   哪个控制器 description#>
                *  @param completionSelector#> 哪个方法 点击方法文档里面有提示 description#>
                *  @param contextInfo#>        参数,传什么现实什么 description#>
                *  @return
                */
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            });
        }
        
        //根据屏幕方向裁减图片(640, 480)||(480, 640),如不需要裁减请注释
        image = [UIImage resizeImageWithOriginalImage:image];
        
        if (self.finishBack) {
            self.finishBack(image,nil);
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) { //视频
        
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr = [url path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
    }
}

/**
 *  点击相册取消按钮的回调方法
 *
 *  @param picker 取消按钮
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}

//图片保存完毕的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf {
    if (error) {//可以在此解析错误
        NSLog(@"保存图片过程中发生错误，错误信息:%@",error.localizedDescription);
    } else {//保存成功
        NSLog(@"图片保存成功.");
        [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {//可以在此解析错误
         NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    } else {//保存成功
         NSLog(@"视频保存成功.");
        //录制完之后自动播放
        if (self.finishBack) {
            self.finishBack(nil,videoPath);
        }
        
       [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showImagePickerController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        self.finishBack = finishBack;
    }
    
    if (vc) {
        self.fromVc = vc;
        [self.actionSheet showInView:vc.view];
    }
}

///确定相机是否可用: 先判断是否有摄像头 再判断摄像头是否可用
- (BOOL)toDetermineWhetherTheCameraIsAvailable {
    
    if (![self isCameraAvailable]) { //如果没有摄像头 返回NO
        NSLog(@"没有摄像头");
        return NO;
    }
    if (![self isRearCameraAvailable] && ![self isFrontCameraAvailable]) { //如果摄像头不可用 返回NO
        NSLog(@"摄像头不可用");
        return NO;
    }
    return YES;
}

/// 判断设备是否有摄像头
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/// 前面的摄像头是否可用
- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/// 后面的摄像头是否可用
- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

///判断访问权限
- (void)setUpImagePicker:(pickerType )type {

    //解决iOS8在调用系统相机拍照时，会有一两秒的停顿，然后再弹出UIImagePickConroller的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    self.picker = nil;
    self.picker = [[UIImagePickerController alloc] init];//初始化
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;//设置不可编辑
    
    if (type == photoType) { //相册
        
        //判断用户是否允许访问相册权限
        ///获取当前应用对照片的访问授权状态
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        ///如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
            //无权限
            NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
            // 提示语
            NSString *tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
            NSLog(@"相册-没有权限访问相册");
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.sourceType = sourceType;
        
    } else if (type == cameraType) { //拍照
        //判断用户是否允许访问相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//AVAuthorizationStatusDenied://用户已经明确否认了这一照片数据的应用程序访问
//AVAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。可能是家长控制权限
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
            //无权限
            NSLog(@"拍照-没有权限访问相机");
            return;
        }
        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
            //无权限
            NSLog(@"拍照-没有权限访问相册");
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.sourceType = sourceType;
        
        
    } else if (type == videoType) { //摄像
        //判断用户是否允许访问相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
            //无权限
            NSLog(@"摄像-没有权限访问相机");
            return;
        }
        
        //判断用户是否允许访问麦克风权限
        authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
            //无权限
            NSLog(@"摄像-没有权限访问麦克风");
            return;
        }

        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
            //无权限
            NSLog(@"摄像-没有权限访问相册");
            return;
        }
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.sourceType = sourceType;
        
        self.picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        self.picker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        self.picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
    }
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"0");
        [self showCameraInViewController:self.fromVc andFinishBack:nil];
    } else if (buttonIndex == 1) {
        NSLog(@"1");
        [self showPhotoInViewController:self.fromVc andFinishBack:nil];
    } else if (buttonIndex == 2) {
        NSLog(@"2");
        [self showVideoInViewController:self.fromVc andFinishBack:nil];
    }
}


#pragma mark - getter and setter
- (UIActionSheet *)actionSheet {
    if (_actionSheet == nil) {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"录像", nil];
    }
    return _actionSheet;
}

@end
