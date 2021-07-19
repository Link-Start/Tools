//
//  LSCommonTableViewCell.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSCommonTableViewCell : UITableViewCell

/// 容器视图。  包裹了 MesageCell 的各类视图，作为 Cell 的“底”，方便进行视图管理与布局
@property (nonatomic, strong) UIView *containerView;

@end

NS_ASSUME_NONNULL_END
