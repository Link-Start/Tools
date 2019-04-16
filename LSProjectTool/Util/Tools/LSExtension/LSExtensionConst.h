//
//  LSExtensionConst.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/9.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef LSExtensionConst_h
#define LSExtensionConst_h


/// 过期 提醒
#define LSExtensionDeprecated(instead) NS_DEPRECATED(1_0, 1_0, 1_0, 1_0, instead)

/// 构建错误
#define LSExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setLS_error:error];

/// 日志输出
#ifdef DEBUG
#define LSExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define LSExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define LSExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setLS_error:nil]; \
if ((condition) == NO) { \
LSExtensionBuildError(clazz, msg); \
return returnValue;\
}

#define LSExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define LSExtensionAssert(condition) LSExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define LSExtensionAssertParamNotNil2(param, returnValue) \
LSExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define LSExtensionAssertParamNotNil(param) LSExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define LSLogAllIvars \
-(NSString *)description \
{ \
return [self LS_keyValues].description; \
}


#define LSExtensionLogAllProperties LSLogAllIvars

/**
 *  类型（属性类型）
 */
extern NSString *const LSPropertyTypeInt;
extern NSString *const LSPropertyTypeShort;
extern NSString *const LSPropertyTypeFloat;
extern NSString *const LSPropertyTypeDouble;
extern NSString *const LSPropertyTypeLong;
extern NSString *const LSPropertyTypeLongLong;
extern NSString *const LSPropertyTypeChar;
extern NSString *const LSPropertyTypeBOOL1;
extern NSString *const LSPropertyTypeBOOL2;
extern NSString *const LSPropertyTypePointer;

extern NSString *const LSPropertyTypeIvar;
extern NSString *const LSPropertyTypeMethod;//方法
extern NSString *const LSPropertyTypeBlock;//block
extern NSString *const LSPropertyTypeClass;//类
extern NSString *const LSPropertyTypeSEL;//
extern NSString *const LSPropertyTypeId;

#endif /* LSExtensionConst_h */
