//
//  EnumDefinition.h
//  ChaoPai
//
//  Created by macbook v5 on 2018/9/17.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#ifndef EnumDefinition_h
#define EnumDefinition_h

//NS_STRING_ENUM
typedef NS_ENUM(NSUInteger, FromVCCome) {
    ///普通跳转
    FromVCComeNormal,
    ///从确认订单界面跳转
    FromVCComeSureOrderVC,
    ///从已购买界面
    FromVCComeAlreadyBuyVC,
    ///从已出售界面
    FromVCComeAlreadySaleVC,
};

typedef NS_ENUM(NSUInteger, FromToVC) {
    ///普通跳转
    FromToVCNormal,
    ///从订单支付成功界面过来
    FromToVCOrderPaySuccess,
    ///从确认订单界面跳转
    FromToVCSureOrderVC,
};

typedef NS_ENUM(NSUInteger, OrderPayWay) {
    ///微信支付
    OrderPayWayWeiXin,
    ///支付宝
    OrderPayWayAlipy,
    ///会员卡
    OrderPayWayVipCard,

};


///vip 普通游客、黄金会员、白金会员、钻石会员
typedef NS_ENUM(NSUInteger, VIPLevelType) {
    ///普通游客
    VIPLevelTypeNormal = 0,
    ///黄金会员
    VIPLevelTypeGold = 1,
    ///白金会员
    VIPLevelTypePlatinum = 2,
    ///钻石会员
    VIPLevelTypeDiamond = 3,
    
};


typedef NS_ENUM(NSUInteger, AddressType) {
    ///新增地址
    AddressTypeNewAdd = 0,
    ///修改地址
    AddressTypeEdit = 1,
};

///确认订单取货类型
typedef NS_ENUM(NSUInteger, PickupType) {
    ///门店自提
    PickupTypeStore = 0,
    ///送货上门
    PickupTypeHomeDelivery = 1,
};



#endif /* EnumDefinition_h */

/**
 
 常见枚举写法

 C语言模式的枚举写法：enum
 typedef enum{
     KLTypeRed = 1,
     KLTypeGreen = 2,
     KLTypeOrange = 3,
 } KLType;

 
 普通【整型】枚举写法 ：NS_ENUM
 typedef NS_ENUM(NSUInteger, KLType) {
     KLTypeRed = 1,
     KLTypeGreen = 2,
     KLTypeOrange = 3,
 };

 
 位移枚举 ：NS_OPTIONS
 typedef NS_OPTIONS(NSUInteger, KLType) {
     KLTypeRed = 1 << 0,
     KLTypeGreen = 1 << 1,
     KLTypeOrange = 1 << 2,
 };
 
 
 字符串类型枚举实现方式探索

 基于普通枚举，定义C方法实现

 // 先定义一个常见的枚举
 typedef NS_ENUM(NSUInteger, KLType) {
     KLTypeRed = 1,
     KLTypeGreen = 2,
     KLTypeOrange = 3,
 };
 // 定义一个C方法，C方法就是通过枚举值匹配字符串
 NSString *KLTypeString(KLType status) {
     switch (status) {
         case KLTypeRed:
             return @"红色";
         case KLTypeGreen:
             return @"绿色";
         case KLTypeOrange:
             return @"橘色";
         default:
             return @"";
     }
 }
 复制代码
 基于普通枚举，定义C数组，设置 枚举值为 index

 // 先定义一个常见的枚举
 typedef NS_ENUM(NSUInteger, KLType) {
     KLTypeRed = 1,
     KLTypeGreen = 2,
     KLTypeOrange = 3,
 };
 // 这个是 Map NSString * 类型的数组
 NSString *KLTypeStringMap[] = {
     [KLTypeRed] = @"红色",
     [KLTypeGreen] = @"绿色",
     [KLTypeOrange] = @"橘色"
 };


 // 使用：
 KLTypeStringMap[KLTypeRed];// 枚举值
 复制代码
 日常做法 宏定义

 #define static NSString * const KLTypeStringRed = @"红色";
 #define static NSString * const KLTypeStringGreen = @"绿色";
 #define static NSString * const KLTypeStringOrange = @"橘色";
 复制代码
 定义一种新的数据类型

 // 定义一个新的类型 是 NSSting * 类型 类型名字叫 KLTypeStr
 typedef NSString *KLTypeStr NS_STRING_ENUM;

 static KLTypeStr const KLTypeStringRed = @"红色";
 static KLTypeStr const KLTypeStringGreen = @"绿色";
 static KLTypeStr const KLTypeStringOrange = @"橘色";
 复制代码
 Apple官方的做法

 .h 文件中 -------------
 typedef NSString *KLTypeStr NS_STRING_ENUM;

 FOUNDATION_EXPORT KLTypeStr const KLTypeStringRed;
 FOUNDATION_EXPORT KLTypeStr const KLTypeStringGreen;
 FOUNDATION_EXPORT KLTypeStr const KLTypeStringOrange;

 .m 文件中 --------------
 NSString * const KLTypeStringRed = @"红色";
 NSString * const KLTypeStringGreen = @"绿色";
 NSString * const KLTypeStringOrange = @"橘色";
 复制代码

 比较的时候 StringEnum1 == StringEnum2 直接比较的是内存地址，效率会更高。
 相比会产生过多二进制文件的宏定义方式,假如宏定义比较多,建议用FOUNDATION_EXPORT。
 
 
 */
