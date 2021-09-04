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

//#import "LSProjectTool-Swift.h"


@interface ViewController ()<UITextFieldDelegate, AMapLocationManagerDelegate>

@property (weak, nonatomic)  LSTextView *inputView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H;

@property (weak, nonatomic)  UITextField *textField;
@property (nonatomic, strong) UIView *demoView;

///位置
@property (nonatomic, strong) LSGetCurrentLocation *getLocation;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) AMapLocationManager *locationManager;

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
    
//    self.inputView.ls_placeholder(@"123456789").ls_placeholderColor([UIColor redColor]).ls_maxNumberOfLines(3);//
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
   
}

- (IBAction)btnAction:(id)sender {
//    CeshiVC *vc = [[CeshiVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    

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
- (BOOL)shouldAutorotate {
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
}

// 关闭 屏幕旋转
- (void)endFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
     //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
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


@end
