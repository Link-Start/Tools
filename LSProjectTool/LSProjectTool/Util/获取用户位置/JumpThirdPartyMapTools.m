//
//  JumpThirdPartyMapTools.m
//  NiuCheCheUserSide
//
//  Created by macbook v5 on 2018/7/17.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#import "JumpThirdPartyMapTools.h"
#import <MapKit/MapKit.h>

@interface JumpThirdPartyMapTools ()

@property (nonatomic, strong) NSMutableArray *maps;
///目的地
@property (nonatomic, copy) NSString *endAddress;

@end

@implementation JumpThirdPartyMapTools

#pragma mark - 导航方法
-(void)navThirdMapWithLocation:(CLLocationCoordinate2D)endLocation endAddressStr:(NSString *)endAddress {
    
    self.endAddress = endAddress; //目的地
    
//    CLLocationCoordinate2D coor;
//    coor.latitude = [weakSelf.latitude doubleValue];
//    coor.longitude = [weakSelf.longitude doubleValue];
    
    NSMutableArray *maps = [NSMutableArray array];
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    iosMapDic[@"url"]   = [NSString stringWithFormat:@"%f-%f",endLocation.latitude,endLocation.longitude];
    [maps addObject:iosMapDic];
    
    /**
     1. origin={{我的位置}}  这个是不能被修改的 不然无法把出发位置设置为当前位置
     2. destination=latlng:%f,%f|name=目的地  name=XXXX name这个字段不能省略 否则导航会失败 而后面的文字则可以随便填
     2.1  想要是地图定位的目的地显示自己设置的地址 name后面的等号(=)改为冒号(:)即可
     
     3. coord_type=gcj02
     coord_type允许的值为bd09ll、gcj02、wgs84 如果你APP的地图SDK用的是百度地图SDK 请填bd09ll 否则 就填gcj02 wgs84你基本是用不上了(关于地图加密这里也不多谈 请自行学习)
     */
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude, self.endAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
/**
     1. sourceApplication=%@&backScheme=%@
     sourceApplication代表你自己APP的名称 会在之后跳回的时候显示出来 所以必须填写
     backScheme是你APP的URL Scheme 不填是跳不回来的哟
     2. dev=0 这里填0就行了，跟上面的gcj02一个意思 1代表wgs84 也用不上
     3. dlat:经度，dlon:纬度，dname:目的地。t:交通方式。path:表示路线规划，改为navi为直接语音导航。
*/
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        
        //路线规划
//        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=2",@"华品共享",endLocation.latitude,endLocation.longitude,self.endAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        //语音导航
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"APPName",@"UrlAcheme",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }

    
/**
     1. x-source=%@&x-success=%@
     跟高德一样 这里分别代表APP的名称和URL Scheme
     2. saddr= 这里留空则表示从当前位置触发
*/
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"appName",@"urlScheme",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude, self.endAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    // 苹果
    //    NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",startPoint.latitude,startPoint.longitude,endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //手机地图个数判断
    if (maps.count > 0) {
        //选择
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"使用导航" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSInteger index = maps.count;
        for (int i = 0; i < index; i++) {
            NSString *title = maps[i][@"title"];
            NSString *urlString = maps[i][@"url"];
            //苹果原生地图方法
            if (i == 0) {
                UIAlertAction *iosAntion = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self navAppleMap:urlString];
                }];
                [alertVC addAction:iosAntion];
                continue;
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [alertVC addAction:action];
        }
        
        UIAlertAction *cancleAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:cancleAct];
        
        if ([self.delegate respondsToSelector:@selector(presentVC:)]) {
            [self.delegate presentVC:alertVC];
        }
        
    } else {
        //        [SVProgressHUD showErrorWithStatus:@"未检测到地图应用"];
    }
}

//跳转到原生苹果地图
- (void)navAppleMap:(NSString *)urlString {
    
    NSArray *location = [urlString componentsSeparatedByString:@"-"];
    CGFloat latitude = [location[0] floatValue];
    CGFloat longitude = [location[1] floatValue];
    
    //终点坐标转换
    CLLocationCoordinate2D afterLocation = CLLocationCoordinate2DMake(latitude, longitude);
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:afterLocation addressDictionary:nil] ];
    //目的地名称
    toLocation.name = self.endAddress;//endLocation坐标对应的目的地名称
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : [NSNumber numberWithInteger:MKMapTypeStandard],
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

@end
