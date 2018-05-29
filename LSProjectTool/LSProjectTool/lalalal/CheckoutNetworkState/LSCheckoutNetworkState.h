//
//  CheckoutNetworkState.h
//  Tedddd
//
//  Created by Xcode on 16/8/11.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Tools.h"
@interface LSCheckoutNetworkState : NSObject
/**
 *  当前网络是否活跃
 *
 *  @return  YES:活跃  NO:不活跃
 */
+ (BOOL)activeNetwork;

///是WiFi 网络
+ (BOOL)isWiFiNetwork;
@end
