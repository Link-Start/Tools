//
//  LSSegmentedView.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/29.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSegmentedView : UIView

@property (nonatomic, strong) NSMutableArray *titleArray;

///屏幕最大显示数量
@property (nonatomic, assign) NSInteger ls_maxShowNum;

///初始化
- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSMutableArray *)titleArray;

@end
