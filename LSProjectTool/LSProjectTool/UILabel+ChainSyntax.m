//
//  UILabel+ChainSyntax.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/10.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "UILabel+ChainSyntax.h"

@implementation UILabel (ChainSyntax)

- (id (^)(id))link {
    
     id (^linkS)() = ^{
        return self;
    };
    return linkS;
}

@end
