//
//  LSPhotographVC.m
//  LSProjectTool
//
//  Created by Xcode on 16/11/8.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSPhotographVC.h"
#import "LSCustomCamera.h"

@interface LSPhotographVC ()

///
@property (nonatomic, strong) LSCustomCamera *customCamera;

/*********按钮**********/
///切换前后摄像头
@property (nonatomic, strong) UIButton *switchCameraBtn;
///拍照按钮
@property (nonatomic, strong) UIButton *takePhotoBtn;
///取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
///添加点击事件
@property (nonatomic, strong) UIButton *confirmBtn;


@end

@implementation LSPhotographVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*******************上方按钮*******************/
    //切换前后摄像头按钮
    self.switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.switchCameraBtn];
    
    /*******************下方按钮*******************/
    //拍照按钮
    self.takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.takePhotoBtn];
    
    //取消按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.cancelBtn];
    
    //完成按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.confirmBtn];
    
    //打开自动布局
    [self openAutoLayout];
    //添加约束
    [self addConstraint];
    [self.switchCameraBtn setTitle:@"切换" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    //添加点击事件
    [self.switchCameraBtn addTarget:self action:@selector(switchCameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotoBtn addTarget:self action:@selector(takePhotoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[LSCustomCamera shareCustomCamera] takePhotoComplete:self.view takePhotoFrame:[UIScreen mainScreen].bounds completion:^(UIImage *image) {
       
        NSLog(@"%@", image);
    }];
    
    
    self.view.backgroundColor = [UIColor redColor];
}

///打开自动布局
- (void)openAutoLayout {
    // 谁被约束，谁就得开启autoLayout
    // autoLayout默认不开启
    // 打开自动布局(Autoresizing和autoLayout不能同时存在)
    self.switchCameraBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.cancelBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.takePhotoBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.confirmBtn.translatesAutoresizingMaskIntoConstraints = false;
}

///添加约束
- (void)addConstraint {
    NSDictionary *viewsDic = @{@"switchCameraBtn":self.switchCameraBtn, @"takePhotoBtn":self.takePhotoBtn, @"cancelBtn":self.cancelBtn, @"confirmBtn":self.confirmBtn};
    
    //约束
    
    //切换前后摄像头按钮
    //中心
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchCameraBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //纵
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[switchCameraBtn]" options:0 metrics:nil views:viewsDic]];
    
    //取消按钮
    //横
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[cancelBtn]" options:0 metrics:nil views:viewsDic]];
    //纵
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelBtn]-20-|" options:0 metrics:nil views:viewsDic]];
    
    //拍照按钮
    //中心
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.takePhotoBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //纵
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[takePhotoBtn]-20-|" options:0 metrics:nil views:viewsDic]];
    
    //确定按钮
    //横
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[confirmBtn]-20-|" options:0 metrics:nil views:viewsDic]];
    //纵
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[confirmBtn]-20-|" options:0 metrics:nil views:viewsDic]];
}

// 判断横屏竖屏、
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact && newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        NSLog(@"横屏");
        
        //更新了支持的方向后，记得刷新下控制器，调用：
        [UIViewController attemptRotationToDeviceOrientation];
    }
    
    if (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact && newCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        NSLog(@"竖屏");
        
        //更新了支持的方向后，记得刷新下控制器，调用：
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

#pragma mark - 切换前后摄像头按钮点击事件
- (void)switchCameraBtnAction:(UIButton *)sender {
    NSLog(@"切换前后摄像头按钮点击事件");
    [[LSCustomCamera shareCustomCamera] switchCamera];
}

#pragma mark - 拍照按钮点击事件
- (void)takePhotoBtnAction:(UIButton *)sender {
    NSLog(@"拍照按钮点击事件");
    
    //拍照
    [[LSCustomCamera shareCustomCamera] takePhotoBtnAction];
    self.takePhotoBtn.hidden = YES;//隐藏拍照按钮
    [self.cancelBtn setTitle:@"重新拍照" forState:UIControlStateNormal];
}

#pragma mark - 取消按钮点击事件
- (void)cancelBtnAction:(UIButton *)sender {
    NSLog(@"取消按钮点击事件");
    
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[LSCustomCamera shareCustomCamera] clearDrawLayer];
        }];
        
    } else { //重新拍照
        
        [[LSCustomCamera shareCustomCamera] startRun];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.takePhotoBtn.hidden = NO; //显示拍照按钮
    }
    
    
}

#pragma mark - 完成按钮点击事件
- (void)confirmBtnAction:(UIButton *)sender {
    NSLog(@"完成按钮点击事件");

    [self dismissViewControllerAnimated:YES completion:^{
        [[LSCustomCamera shareCustomCamera] clearDrawLayer];
    }];
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
