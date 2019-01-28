//
//  JsonTools.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/1/17.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

#import "JsonTools.h"
#import "DefineNSLog.h"

@implementation JsonTools

/*
 https://github.com/MISSAJJ
 自动生成属性声明的代码
 */

+ (void)MApropertyModelWithDictionary:(NSDictionary *)dict
{
    
    NSMutableString *strM = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *str;
        
        NSLog(@"%@",[obj class]);
        
        if ([NSStringFromClass([obj class]) containsString:@"String"]) {
            str = [NSString stringWithFormat:@"/** ====属性备注===== */\n@property (nonatomic, copy) NSString *%@;",key];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Number"]) {
            str = [NSString stringWithFormat:@"@/** ====属性备注===== */\nproperty (nonatomic, assign) int %@;",key];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Array"]) {
            str = [NSString stringWithFormat:@"/** ====属性备注===== */\n@property (nonatomic, strong) NSArray *%@;",key];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Dictionary"]) {
            str = [NSString stringWithFormat:@"/** ====属性备注===== */\n@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Boolean"]) {
            str = [NSString stringWithFormat:@"/** ====属性备注===== */\n@property (nonatomic, assign) BOOL %@;",key];
        }
        
        [strM appendFormat:@"\n%@\n",str];
    }];
    
    NSLog(@"\n\n\n=======自动生成属性声明的代码=======\n\n\n%@",strM);
}

+(void)propertyCodeWithDictionary:(NSDictionary *)dict
{
    NSMutableString *strMs = [NSMutableString string];
    NSMutableString *strM              = [NSMutableString string];
    NSMutableString *descriptionHeader = [NSMutableString stringWithFormat:@"[NSString stringWithFormat:%@\"",@"@"];
    NSMutableString *descriptionEnd    = [NSMutableString string];
    NSInteger count                    = [dict count];
    __block NSInteger index            = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                              id  _Nonnull obj,
                                              BOOL * _Nonnull stop) {
        //        NSLog(@"类型%@\n",[obj class]);
        
        NSString *str;
        NSString *Header;
        index ++;
        if ([NSStringFromClass([obj class]) containsString:@"String"] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Number"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Array"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
            
            for (NSDictionary *dic in obj) {
                [self propertyCodeWithDictionary:dic];
            }
        }
        if ([NSStringFromClass([obj class]) containsString:@"Dictionary"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
            
            [self propertyCodeWithDictionary:obj];
        }
        if ([NSStringFromClass([obj class]) containsString:@"Boolean"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%d"];
        }
        if ([NSStringFromClass([obj class]) containsString:@"NSNull"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@  (null);",key];
            Header = [NSString stringWithFormat:@"%@:%@,\\n",key,@"%@"];
        }
        [descriptionEnd appendFormat:@"_%@,",key];
        [descriptionHeader appendFormat:@"%@",Header];
        [strM appendFormat:@"\n%@",str];
        
//        NSLog(@"\n%@\n", str);

        [strMs appendFormat:@"\n%@\n",str];
    }];
    
    NSLog(@"\n\n\n=======自动生成属性声明的代码=======\n\n\n%@",strM);
//    if (count == index && count > 0) {
//        [descriptionHeader replaceCharactersInRange:NSMakeRange(descriptionHeader.length - 3, 3) withString:@"\","];
//        [descriptionEnd replaceCharactersInRange:NSMakeRange(descriptionEnd.length - 1, 1) withString:@"];"];
//    }
//    NSLog(@"\n\n*******模型所有属性，自己要改下(默认空的数据为字符串)*******%@",strM);
//    NSLog(@"\n\n***************重写模型的描述粘贴复制这句***************\nreture %@%@",descriptionHeader,descriptionEnd);
    
}


@end
