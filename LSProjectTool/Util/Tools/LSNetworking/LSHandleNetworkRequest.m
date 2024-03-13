//
//  LSHandleNetworkRequest.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/16.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import "LSHandleNetworkRequest.h"

@implementation LSHandleNetworkRequest







#pragma mark - params --->string 把参数转变成字符串
/// params --->string 把参数转变成字符串
- (NSString *)returnStringFromParams:(NSDictionary *)params {
    // 转变可变数组
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in params) {// 遍历参数字典 取出value  并加入数组
        // 取出当前参数
        NSString *currentString = [NSString stringWithFormat:@"%@=%@", key, params[key]];
        [array addObject:currentString];
    }
    // 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
    //将array数组转换为string字符串
    NSString *resultString = [array componentsJoinedByString:@"&"];
    NSLog(@"参数：%@", resultString);
    return resultString;
}



#pragma mark  - 数据请求成功
/// 数据请求成功的回调方法
+ (void)successResponse:(id)responseData callback:(void (^)(id response))success hideHud:(MBProgressHUD *)hud {
    //手动关闭MBProgressHUD
    [self hiddenHud:hud];
    
    //如果调用了block
    if (success) {
        //block
        success([self tryToParseData:responseData]);
    }
}

#pragma mark - 解析数据
/// 尝试解析数据
/// 解析数据
/// @param responseData 服务器返回的数据
/// @return 解析后的数据
+ (id)tryToParseData:(id)responseData {
    
    ////这种可以打印中文
    //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    //NSNull:数组中元素的占位符，数据中的元素不能为nil（可以为空，也就是NSNull），
    //原因：nil 是数组的结束标志
    //kCFNull: NSNull的单例
    if (!responseData || responseData == (id)kCFNull) {
        NSLog(@"原数据为nil， 返回nil");
        return nil;
    }
    
    NSData *jsonData = nil;
    id jsonResults = nil;
    
    if ([responseData isKindOfClass:[NSDictionary class]]) {//如果是字典
        NSLog(@"返回原字典");
        return responseData;
    } else if ([responseData isKindOfClass:[NSArray class]]) {//如果是数组
        NSLog(@"返回原数组");
        return responseData;
    } else if ([responseData isKindOfClass:[NSString class]]) {//如果是NSString类型
        NSLog(@"字符串类型");
        jsonData = [(NSString *)responseData dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([responseData isKindOfClass:[NSData class]]) {//如果是NSData 类型
        jsonData = responseData;
    }
    
    if (jsonData) {
        NSError *error = nil;
        //使用缓冲区数据来解析 解析json数据
        //NSJSONReadingMutableContainers：返回可变容器,NSMutableDictionary或NSMutableArray
        jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments | kNilOptions error:&error];
        if (error != nil) {
            NSLog(@"有错误, 返回原数据");
            return responseData;
        } else {
            if ([jsonResults isKindOfClass:[NSDictionary class]]) {
                NSLog(@"JSON数据返回字典");
            } else if ([jsonResults isKindOfClass:[NSArray class]]) {
                NSLog(@"JSON数据返回数组");
            } else if ([jsonResults isKindOfClass:[NSString class]]) {
                NSLog(@"JSON数据返回字符串");
            } else if (jsonResults == nil && [responseData isKindOfClass:[NSString class]]) {
                NSLog(@"返回原字符串");
                return responseData;
            } else if (jsonResults == nil && [responseData isKindOfClass:[NSData class]]) {
                // 不是数组，不是字典，还不是字符串吗？
                NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                return string;
            } else {
                // 未识别
                NSLog(@"未识别防止解析报错，原数据返回nil");
                NSLog(@"未识别原数据：%@",responseData);
                return nil;
            }
        }
        return jsonResults;
    }
    //返回原数据
    return responseData;
    
    
    //如果是NSData类型的数据
    if ([responseData isKindOfClass:[NSData class]]) {
        //尝试解析为JSON
        if (responseData == nil) { //如果数据为空,直接返回
            return responseData;
        } else {
            
            NSError *error = nil;
            //使用缓冲区数据来解析 解析json数据
            //NSJSONReadingMutableContainers：返回可变容器,NSMutableDictionary或NSMutableArray
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
            //如果 有 错误error
            if (error != nil) {
                return responseData; //返回原来的数据
                
            } else { //如果没有错误 返回解析后的数据
                return response;
            }
            
//            return (error != nil) ? responseData : response;
        }
        
    } else { //如果不是NSData类型的数据,直接返回 原来的数据
        return responseData;
    }
}




#pragma mark  - 数据请求失败
/// 数据请求失败的回调方法(错误处理回调)
+ (void)handleCallbackWithError:(NSError *)error fail:(void (^)(NSError *error))fail hideHud:(MBProgressHUD *)hud {
    
    //手动关闭MBProgressHUD
    [self hiddenHud:hud];
    
    if ([error code] == NSURLErrorCancelled) { //如果错误代码 是请求取消
//        if (ls_shouldCallbackOnCancelRequest) { //如果 取消请求的回调 = yes
            //如果调用了block
//            if (fail) {
//                fail(error);
//            }
        fail?fail(error):Nil;
//        }
    } else {
        //如果调用了block
        fail?fail(error):Nil;
    }
    
    //根据错误代码显示提示信息
    [self showFailMarkedWordsWithError:error];
}


#pragma mark - 错误 Error
/// 根据错误代码显示提示信息
+ (void)showFailMarkedWordsWithError:(NSError *)error {
    
    //    NSLog(@"error = %@",error);
    //    NSLog(@"error.code = %d", error.code);//错误代码
    //    NSLog(@"error.description = %@", error.description);
    //    NSLog(@"error.localizedDescription = %@", error.localizedDescription); //错误信息
    //    NSLog(@"error.userInfo = %@", error.userInfo);
//    NSLog(@"error.userInfo[NSLocalizedFailureReasonErrorKey] = %@", error.userInfo[NSLocalizedFailureReasonErrorKey]);
    //    NSLog(@"error.domain = %@", error.domain);
    //    NSLog(@"error.localizedFailureReason = %@", error.localizedFailureReason);
    //    NSLog(@"error.localizedRecoverySuggestion = %@", error.localizedRecoverySuggestion);
    //    NSLog(@"error.localizedRecoveryOptions = %@", error.localizedRecoveryOptions);
    //    NSLog(@"error.recoveryAttempter = %@", error.recoveryAttempter);
    //    NSLog(@"error.helpAnchor = %@", error.helpAnchor);
    
    switch (error.code) {
        case -200:
        case -1016:
            [MBProgressHUD qucickTip:@"不支持的解析格式,请添加数据解析类型"];
            break;
        case -400:
            [MBProgressHUD qucickTip:@"参数传递错误"];
            break;
        case -401:
            [MBProgressHUD qucickTip:@"访问的页面没有授权"];
            break;
        case -404:
            [MBProgressHUD qucickTip:@"服务器错误"];
            break;
        case -405:
            //接口调用的方式或者参数不对
            [MBProgressHUD qucickTip:@"方法不被允许"];
            break;
        case -500:
            [MBProgressHUD qucickTip:@"服务器错误,服务暂不可用"];
            break;
        case -999:
            [MBProgressHUD qucickTip:@"取消请求"];
            break;
        case -1001:
            [MBProgressHUD qucickTip:@"请求超时"];
//            您当前网络状态不好,请检查您的网络连接
            break;
        case -1002:
            [MBProgressHUD qucickTip:@"URL地址需要utf-8编码"];
            break;
        case -1004:
            [MBProgressHUD qucickTip:@"无法连接到服务器"];
            break;
        case -1009:
            [MBProgressHUD qucickTip:@"已断开与互联网的连接"];
            break;
        case -1011:
            [MBProgressHUD qucickTip:@"请求头格式错误"];
            break;
        case -3840:
            [MBProgressHUD qucickTip:@"JSON数据格式错误"];
            break;
        default:
            [MBProgressHUD qucickTip:[NSString stringWithFormat:@"%ld数据请求错误", (long)error.code]];
            break;
    }
    
    NSString * __autoreleasing errString = LSHTTPCodeStatusStringMap[error.code];
    
    NSLog(@"***********\n 错误code：%ld \n 错误信息：%@", error.code, errString);
}

#pragma mark -
//隐藏hud  移除hud
+ (void)hiddenHud:(MBProgressHUD *)hud {
    if (hud != nil) {
//        hud.taskInProgress = NO;
        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES];
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
    }
}








@end
