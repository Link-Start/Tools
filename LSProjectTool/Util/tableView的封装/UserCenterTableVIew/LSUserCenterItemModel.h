//
//  LSUserCenterItemModel.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/8/24.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//
//  个人中心或者设置模块
//  https://www.shuzhiduo.com/A/LPdoY9OwJ3/

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, LSUserCenterAccessoryType) {
    /// 没有
    LSUserCenterAccessoryTypeNone,
    /// 箭头
    LSUserCenterAccessoryTypeDiscloseureIndicator,
    /// switch 开关
    LSUserCenterAccessoryTypeSwitch,
};

NS_ASSUME_NONNULL_BEGIN

@interface LSUserCenterItemModel : NSObject


/// 功能名称
@property (nonatomic, copy) NSString *funcName;
/// 功能图片
@property (nonatomic, strong) UIImage *img;
/// 更多信息-提示文字
@property (nonatomic, copy) NSString *detailText;
/// 更多信息-提示图片
@property (nonatomic, strong) UIImage *detailImage;
/// 指示器类型
@property (nonatomic, assign) LSUserCenterAccessoryType accessorType;
/// 点击 item 要执行的代码
@property (nonatomic, copy) void(^executeCode)(void);
/// switch 开关变化
@property (nonatomic, copy) void(^switchValueChanged)(BOOL isOn);


@end

NS_ASSUME_NONNULL_END
