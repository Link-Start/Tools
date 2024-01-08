//
//  LSUserCenterTabCell.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/8/24.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LSUserCenterItemModel;

@interface LSUserCenterTabCell : UITableViewCell

/// 数据
@property (nonatomic, strong) LSUserCenterItemModel *item;

@end

NS_ASSUME_NONNULL_END
