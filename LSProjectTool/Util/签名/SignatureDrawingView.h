//
//  SignatureDrawingView.h
//  MYYProject
//
//  Created by mac on 2018/7/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureDrawingView : UIView

/// 用来设置线条的颜色
@property (nonatomic, strong) UIColor *color;
/// 用来设置线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;
/// 用来记录已有线条
@property (nonatomic, strong) NSMutableArray *allLines;

// 初始化相关参数
- (void)initDrawingView;
// back操作 上一步
- (void)doBack;
// Forward操作 下一步
- (void)doForward;
// Clear操作 清除所有
- (void)clearAllLines;

// 保存Image
- (void)saveImage:(void(^)(UIImage * signature))saveSuccessBlock;

@end
