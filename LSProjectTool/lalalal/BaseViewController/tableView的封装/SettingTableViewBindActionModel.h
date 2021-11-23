//
//  SettingTableViewBindActionModel.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/11/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingTableViewBindActionModel : NSObject

/// 左侧图标
@property (nonatomic, copy) NSString *leftImgName;
/// 标题
@property (nonatomic, copy) NSString *leftLabelStr;
/// 右侧文字
@property (nonatomic, copy) NSString *rightLabelStr;
/// 右侧箭头是否显示
@property (nonatomic, assign) BOOL isMore;

/// 点击每行cell点击事件，传索引
@property (nonatomic, copy) void(^itemClock)(NSIndexPath *indexPath);

/// 没有点击事件
- (instancetype)initModelWithLeftImgName:(NSString *)leftImgName leftLabelStr:(NSString *)leftLabelStr rightLabelStr:(NSString * _Nullable)rightLabelStr isMore:(BOOL)isMore;
/// 有点击事件
- (instancetype)initModelWithLeftImgName:(NSString *)leftImgName leftLabelStr:(NSString *)leftLabelStr rightLabelStr:(NSString * _Nullable)rightLabelStr isMore:(BOOL)isMore itemClick:(void(^)(NSIndexPath *indexPath))itemClick;

@end

NS_ASSUME_NONNULL_END
