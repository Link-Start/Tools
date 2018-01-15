//
//  UILabel+ChainSyntax.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/10.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChainSyntax)

- (id(^)(id))link;

@end
