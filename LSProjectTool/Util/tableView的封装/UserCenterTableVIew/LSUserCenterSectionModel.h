//
//  LSUserCenterSectionModel.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/8/24.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSUserCenterSectionModel : NSObject

/// 传空表示分组无名称
@property (nonatomic, copy) NSString *sectionHeaderName;
/// 分组 hdader 高度
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
/// item 模型数组
@property (nonatomic, strong) NSArray *itemArray;
/// 背景色
@property (nonatomic, strong) UIColor *sectionHeaderBgColor;

@end

NS_ASSUME_NONNULL_END
