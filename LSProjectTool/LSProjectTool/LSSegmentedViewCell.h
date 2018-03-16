//
//  LSSegmentedViewCell.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/29.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LSSegmentedViewCell : UICollectionViewCell
///颜色
@property (nonatomic, strong) UIColor *ls_titleLabelColor;
///数据
@property (nonatomic, copy) NSString *titleStr;


@end