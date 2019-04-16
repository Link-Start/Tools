//
//  LSExtensionConst.m
//  LSProjectTool
//
//  Created by Xcode on 16/10/9.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef LSExtensionConst_M
#define LSExtensionConst_M


#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const LSPropertyTypeInt = @"i";
NSString *const LSPropertyTypeShort = @"s";
NSString *const LSPropertyTypeFloat = @"f";
NSString *const LSPropertyTypeDouble = @"d";
NSString *const LSPropertyTypeLong = @"l";
NSString *const LSPropertyTypeLongLong = @"q";
NSString *const LSPropertyTypeChar = @"c";
NSString *const LSPropertyTypeBOOL1 = @"c";
NSString *const LSPropertyTypeBOOL2 = @"b";
NSString *const LSPropertyTypePointer = @"*";

NSString *const LSPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const LSPropertyTypeMethod = @"^{objc_method=}";
NSString *const LSPropertyTypeBlock = @"@?";
NSString *const LSPropertyTypeClass = @"#";
NSString *const LSPropertyTypeSEL = @":";
NSString *const LSPropertyTypeId = @"@";


#endif /* LSExtensionConst_h */