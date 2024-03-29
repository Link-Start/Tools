//
//  ViewController.m
//  LSProjectTool
//
//  Created by Xcode on 16/7/14.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
//


#import "ViewController.h"
#import "LSTextView.h"
#import "LSBaseViewController.h"
#import "NetworkRequest.h"
#import "LSNetworking.h"
#import "Function.h"
#import "JsonTools.h"
#import "LSGetCurrentLocation.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
//#import "Util/Tools/Function/Function.h"
#import "AppDelegate.h"
#import "FTPopOverMenu.h"
#import "LBXPermission.h"
#import "LSCheckoutNetworkState.h"

#import "TZImagePickerController.h"

//#include <cstddef>

//#import "LSProjectTool-Swift.h"


@interface ViewController ()<UITextFieldDelegate, AMapLocationManagerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong)  LSTextView *inputView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H;

@property (weak, nonatomic)  UITextField *textField;
@property (nonatomic, strong) UIView *demoView;

///位置
@property (nonatomic, strong) LSGetCurrentLocation *getLocation;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) BOOL isFullScreen;

@end




@implementation ViewController


#define kuu @"uu"

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self begainFullScreen];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endFullScreen];
}


- (void)viewDidLoad {
    
 CGFloat statusBarHeight = ({
        CGFloat statusBarHeight = 0;
        if (@available(iOS 13.0, *)) {
            statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
        } else {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        statusBarHeight;
    });
    
   
    
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    //   定位超时时间，最低2s，此处设置为2s
//    self.locationManager.locationTimeout =2;
//    //   逆地理请求超时时间，最低2s，此处设置为2s
//    self.locationManager.reGeocodeTimeout = 2;
//    

//    [self.getLocation startUpdateLocation];
//    self.getLocation.getCurrentLocation = ^(NSString *str, CLPlacemark *placemark) {
//
//        NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@", placemark.administrativeArea, placemark.locality, placemark.subLocality,placemark.name]);
//    };
//
    self.inputView = [LSTextView textView];
    self.inputView.frame = CGRectMake(100, 200, 200, 30);
    self.inputView.ls_placeholder(@"123456789").ls_placeholderColor([UIColor redColor]).ls_maxNumberOfLines(3);//
    [self.view addSubview:self.inputView];
//     self.f = [[FengChe alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
//    UILabel *l = [[UILabel alloc] init];
//    l = ({
//        l.text = @"..";
//        l;
//    });
//    //语法糖
//    self.f = ({
//        FengChe *f = [[FengChe alloc] init];
//        f;
//    });
//    NSArray *array = @[@1, @2, @3, @4, @5, @6];
//
//    NSString *str = [array componentsJoinedByString:@","];
//
//    NSLog(@"__________________________：%@", str);

    /************ 打印属性 *************/
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"json"];
//    // 将文件数据化
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    // 对数据进行JSON格式化并返回字典形式
//    NSDictionary *dict = [Function getDicFromResponseObject:data];
//    [JsonTools propertyCodeWithDictionary:dict];
    
//    [self configLocationManager];
    
    NSString *usrename = @"ouv11";
    NSString *pwd = @"";
    NSString *resultStr = [self obfuscate:[NSString stringWithFormat:@"%@@@%@", usrename, pwd] withKey:@"s488v"];
    
    

#pragma mark - ----------------- 屏幕旋转
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
#pragma mark - ----------------- 屏幕旋转
    
    
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"哈哈哈" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor yellowColor]];
    self.btn.frame = CGRectMake(100, 400, 100, 30);
    [self.btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];

    
    UIButton *changeIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeIconBtn setTitle:@"改变Icon" forState:UIControlStateNormal];
    [changeIconBtn setBackgroundColor:[UIColor redColor]];
    changeIconBtn.frame = CGRectMake(100, 500, 100, 30);
    [changeIconBtn addTarget:self action:@selector(changeIconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeIconBtn];
    
    UIButton *resetIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetIconBtn setTitle:@"重置Icon" forState:UIControlStateNormal];
    [resetIconBtn setBackgroundColor:[UIColor cyanColor]];
    resetIconBtn.frame = CGRectMake(100, 600, 100, 30);
    [resetIconBtn addTarget:self action:@selector(resetIconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetIconBtn];
    
    [self presentViewController:self animated:YES completion:nil];
    
    
    //Duration: 动画持续时间
//delay: 动画执行延时
//usingSpringWithDamping: 震动效果，范围 0.0f~1.0f，数值越小,「弹簧」的震动效果越明显.当“dampingRatio”为1时，动画将平滑地减速到其最终模型值，而不会振荡
//initialSpringVelocity: 初始速度，数值越大一开始移动越快
//options: 动画的过渡效果
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    
#pragma mark - ------
    
   
//    [LSCheckoutNetworkState currentNetworkStatus];
    
    
    [LSNetworking startMonitoring];
   
//    [LBXPermission authorizeWithType:LBXPermissionType_DataNetwork completion:^(BOOL granted, BOOL firstTime) {
//        if (granted) {
//            //TODO
//            //dosth
//            NSLog(@"跳转 网络权限 之后");
//        } else if (!firstTime) {
//            //不是第一次请求权限，那么可以弹出权限提示，用户选择设置，即跳转到设置界面，设置权限
//            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有定位权限，是否前往设置" cancel:@"取消" setting:@"设置"];
//        } else {
//            NSLog(@"跳转 网络权限 之后");
//        }
//    }];
}

- (NSString *)obfuscate:(NSString *)string withKey:(NSString *)key
{
  // Create data object from the string
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
 
  // Get pointer to data to obfuscate
  char *dataPtr = (char *) [data bytes];
 
  // Get pointer to key data
  char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
 
  // Points to each char in sequence in the key
  char *keyPtr = keyData;
  int keyIndex = 0;
 
  // For each character in data, xor with current value in key
  for (int x = 0; x < [data length]; x++)
  {
    // Replace current character in data with
    // current character xor'd with current key value.
    // Bump each pointer to the next character
    *dataPtr = *dataPtr++ ^ *keyPtr++;
 
    // If at end of key data, reset count and
    // set key pointer back to start of key value
    if (++keyIndex == [key length])
      keyIndex = 0, keyPtr = keyData;
  }
 
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)getNeedSignStrFrom:(id)obj {
//    NSDictionary *dict = obj;
//    NSArray *arrPrimary = dict.allKeys;
//    NSArray *arrKey = [arrPrimary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
//        NSComparisonResult result = [obj1 compare:obj2];
//        return result==NSOrderedDescending;//NSOrderedAscending 倒序
//    }];
//
//    NSString *str =@"";
//
//    for (NSString *s in arrKey) {
//        id value = dict[s];
//        if([value isKindOfClass:[NSDictionary class]]) {
//            value = [self getNeedSignStrFrom:value];
//        }
//        if([str length] !=0) {
//            str = [str stringByAppendingString:@","];
//        }
////        str = [str stringByAppendingFormat:@"%@:%@",s,value];
//
//
//        str = [str stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"@\"\%@\":@\"\%@\"", s, value]];
//    }
//    NSLog(@"str:%@",str);
//
//    NSArray *temArr = [str componentsSeparatedByString:@","];
//
//    NSLog(@"str:%@",temArr);
    
    NSDictionary *dict = obj;
    NSArray *arrPrimary = dict.allValues;
    NSArray *arrValue = [arrPrimary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;//NSOrderedAscending 倒序
    }];
    
    NSString *str =@"";
    
    for (NSString *v in arrValue) {
        
        for (NSString *key in dict.allKeys) {
            if ([dict[key] isEqualToString:v]) {
   
                if([str length] !=0) {
                    str = [str stringByAppendingString:@","];
                }

                str = [str stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"@\"\%@\":@\"\%@\"", key, v]];
                
                break;
            }
        }
    }
    NSLog(@"str:%@",str);
    
    NSArray *temArr = [str componentsSeparatedByString:@","];
    
    NSLog(@"str:%@",temArr);
    
    return str;
}


- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            NSLog(@"定位  locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        NSLog(@"定位经纬度  location:%@", location);
        if (regeocode) {
            NSLog(@" 定位地址  reGeocode:%@", regeocode);
        }
    }];
}

- (void)startSerialLocation {
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation {
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    //定位错误
    NSLog(@"%s, 定位结果 amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //定位结果
    NSLog(@"定位结果 location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

- (void)btnAction {
   
   
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//
//    // You can get the photos by block, the same as by delegate.
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [vc presentViewController:imagePickerVc animated:YES completion:nil];
  
}

- (IBAction)btnAction:(UIButton *)sender {
//    CeshiVC *vc = [[CeshiVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    NSArray *temArr = @[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3",@"1", @"2", @"3",@"1", @"2", @"3"];
    FTPopOverMenu *menu = [[FTPopOverMenu alloc] init];
//    FTPopOverMenuConfiguration *config = [[FTPopOverMenuConfiguration alloc] init];
//    config.optionsListLimitHeight = 800;
////    config.
//
//    [menu showForSender:sender window:nil senderFrame:CGRectNull withMenu:temArr imageNameArray:nil config:config doneBlock:^(NSInteger selectedIndex) {
//
//    } dismissBlock:^{
//
//    }];

    [menu showForSender:sender withMenu:temArr configBlock:^FTPopOverMenuConfiguration *{
        FTPopOverMenuConfiguration *config = [[FTPopOverMenuConfiguration alloc] init];
        config.optionsListLimitHeight = 200;
        return config;
    } doneBlock:^(NSInteger selectedIndex) {
        
    } dismissBlock:^{
        
    }];
}

- (void)changeIconBtnAction:(UIButton *)sender {
    NSLog(@"更改 Icon");
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        [[UIApplication sharedApplication] setAlternateIconName:@"oubasaller" completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"更换Icon错误：%@", error);
            } else {
                NSLog(@"更换Icon成功");
            }
            
        }];
    }
}


- (void)resetIconBtnAction:(UIButton *)sender {
    NSLog(@"恢复 Icon");
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"更换Icon错误%@", error);
            } else {
                NSLog(@"更换Icon成功");
            }
        }];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)dismiss:(id)sender {

     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", @"https://www.tqjf007.com/ios/ios_1557464600.plist"]]];
}


//调用系统相机之前判断权限
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        // 调用相机
//        [self pushImagePickerController];
    }
}


#pragma mark - ----------------- 屏幕旋转

// 是否支持自动转屏
- (BOOL)shouldAutorotate {// iOS16中此方法不再起作用，需要控制，- (UIInterfaceOrientationMask)supportedInterfaceOrientations
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.navigationController.topViewController preferredInterfaceOrientationForPresentation];
}

/// 开始 支持屏幕旋转
- (void)begainFullScreen {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    
    if (@available(iOS 16.0, *)) {
        UIWindowScene *windowScene =
            (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        for (UIWindow *windows in windowScene.windows) {
            if ([windows.rootViewController respondsToSelector:NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations")]) {
                [windows.rootViewController performSelector:NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations")];
            }
        }
    } else {
        // Fallback on earlier versions
    }
}

// 关闭 屏幕旋转
- (void)endFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
     //强制归正：
    if (@available(iOS 16.0, *)) {
        @try {
            // 1.........................
            //        // setNeedsUpdateOfSupportedInterfaceOrientations 方法是 UIViewController 的方法
            //        [self setNeedsUpdateOfSupportedInterfaceOrientations];
            //        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            //        UIWindowScene *scene = [array firstObject];
            //        // 屏幕方向
            //        UIInterfaceOrientationMask orientation = self.isFullScreen ? UIInterfaceOrientationMaskLandscape:UIInterfaceOrientationMaskPortrait;
            //        UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
            //        // 开始切换
            //        [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS errorHandler:^(NSError * _Nonnull error) {
            //            NSLog(@"屏幕旋转失败，错误:%@", error);
            //        }];
            
            // 2.........................
            NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *ws = (UIWindowScene *)array[0];
            Class GeometryPreferences = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
            id geometryPreferences = [[GeometryPreferences alloc]init];
            [geometryPreferences setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"interfaceOrientations"];
            SEL sel_method = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
            void (^ErrorBlock)(NSError *err) = ^(NSError *err){};
            if ([ws respondsToSelector:sel_method]) {
                (((void (*)(id, SEL,id,id))[ws methodForSelector:sel_method])(ws, sel_method,geometryPreferences,ErrorBlock));
            }
            
        } @catch (NSException *exception) {
        } @finally {
        }
    } else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            @try {
                SEL selector = NSSelectorFromString(@"setOrientation:");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:[UIDevice currentDevice]];
                int val = UIInterfaceOrientationPortrait;
                [invocation setArgument:&val atIndex:2];
                [invocation invoke];
            } @catch (NSException *exception) {
            } @finally {
            }
        }
    }
}
// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    [self onDeviceOrientationChange];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    
    // 在iOS 16中这里获取的为unknow......
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if (@available (iOS 13, *)) {
//        orientation = [UIApplication sharedApplication].windows.firstObject.windowScene.interfaceOrientation;
//    } else {
////        orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    }
    
    
    if (orientation == UIDeviceOrientationFaceUp) {
        return;
    }
    BOOL shouldFullScreen = UIDeviceOrientationIsLandscape(orientation);
    
    if (self.isFullScreen == shouldFullScreen) {
        return;
    }
    if (@available(iOS 16.0, *)) {
        if (orientation == UIDeviceOrientationPortraitUpsideDown) {//禁止上下颠倒
            return;
        }
    }
    self.isFullScreen = shouldFullScreen;
    
    if (shouldFullScreen) { //横屏
        NSLog(@"横屏");
        // iOS16, view需要重新更新frame， 旋转之后的屏幕宽高没有变化，需要自己重新赋值更改
    } else { //竖屏
        NSLog(@"竖屏");
    }
}
- (void)dealloc {

    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
#pragma mark - ----------------- 屏幕旋转

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (LSGetCurrentLocation *)getLocation {
    
    if (!_getLocation) {
        _getLocation = [[LSGetCurrentLocation alloc] init];
    }
    return _getLocation;
}

////设置水平方向
//[<#self.unreadCommentFloatLabel#> setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal]; //抗拉伸
//[<#self.unreadCommentFloatLabel#> setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//抗压缩
////设置竖直方向
//[<#self.unreadCommentFloatLabel#> setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical]; //抗拉伸
//[<#self.unreadCommentFloatLabel#> setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//抗压缩


@end
