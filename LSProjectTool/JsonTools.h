//
//  JsonTools.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/1/17.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonTools : NSObject

//自动生成属性声明的代码
+ (void)MApropertyModelWithDictionary:(NSDictionary *)dict;

+(void)propertyCodeWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
