//
//  UIImage+GenerateBarCode.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2020/1/14.
//  Copyright © 2020 Link-Start. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GenerateBarCode)

// 生成条形码
+ (UIImage *)generateCode128:(NSString *)code size:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
