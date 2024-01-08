//
//  SettingTableViewBindActionModel.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/11/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "SettingTableViewBindActionModel.h"

@implementation SettingTableViewBindActionModel

/// 没有点击事件
- (instancetype)initModelWithLeftImgName:(NSString *)leftImgName leftLabelStr:(NSString *)leftLabelStr rightLabelStr:(NSString * _Nullable)rightLabelStr isMore:(BOOL)isMore {
    
    SettingTableViewBindActionModel *item = [[SettingTableViewBindActionModel alloc] init];
    item.leftImgName = leftImgName;
    item.leftLabelStr = leftLabelStr;
    item.rightLabelStr = rightLabelStr;
    item.isMore = isMore;
    return item;
}
/// 有点击事件
- (instancetype)initModelWithLeftImgName:(NSString *)leftImgName leftLabelStr:(NSString *)leftLabelStr rightLabelStr:(NSString * _Nullable)rightLabelStr isMore:(BOOL)isMore itemClick:(void(^)(NSIndexPath *indexPath))itemClick {
    
    SettingTableViewBindActionModel *item = [[SettingTableViewBindActionModel alloc] init];
    item.leftImgName = leftImgName;
    item.leftLabelStr = leftLabelStr;
    item.rightLabelStr = rightLabelStr;
    item.isMore = isMore;
    item.itemClock = itemClick;
    
    return item;
}

@end
