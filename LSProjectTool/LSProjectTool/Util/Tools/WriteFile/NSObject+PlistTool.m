//
//  NSObject+PlistTool.m
//  TimeToSee
//
//  Created by Xcode on 15/1/21.
//  Copyright (c) 2015年 苏州麦卡软件有限公司. All rights reserved.
//

#import "NSObject+PlistTool.h"

@implementation NSObject (PlistTool)

/**
 *  通过文件名获取文件路径 (Documents文件路径)
 *
 *  @param plistFileName 文件名
 *
 *  @return 文件路径
 */
- (NSString *)getDocumentFilePath:(NSString*)plistFileName{
    /**
     *  @brief 获取应用程序沙盒中的Documents文件夹路径
     *  @param NSDocumentDirectory 指程序中对应的Documents文件夹路径
     *  @param NSUserDomainMask 用户主目录中(说明是在当前应用沙盒中获取,所有应用沙盒目录组成一个数组结构的数据存放)
     *  @param YES                 展开成完整路径
     */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //
    NSString *documentsDirectory = [paths firstObject];
    
    /**
     *  isSubclassOfClass  判断对象是否为指定类的子类  是类方法
     *  isKindOfClass      用于判断对象是不是参数提供的类型(参数可以是父类的class)    对象方法
     */
    //如果不是NSData类型 并且 不是NSData的子类
    if (![self isKindOfClass:[NSData class]] && ![[self class] isSubclassOfClass:[NSData class]]) {
        // hasSuffix:判断是否以某个字符串结束
        // 如果不是以.plist 结束
        if (![plistFileName hasSuffix:@".plist"]) {
            //在结尾处加上.plist 
            plistFileName = [NSString stringWithFormat:@"%@.plist", plistFileName];
        }
    }
    // 返回文件路径
    //stringByAppendingPathComponent就是将前面的路径格式和后面的普通的字符串格式链接在一起，并且以路径格式返回
    return  [documentsDirectory stringByAppendingPathComponent:plistFileName];
}

/**
 *  通过文件名将文件存入plist文件
 *  plist文件:明文保存,操作的对象:只支持NSArray、NSMutableArray、NSDictionary、NSMutableDictionary
 *  @param plistFileName 文件名
 *
 *  @return
 */
- (BOOL)saveToFile:(NSString *)plistFileName{
    
    // 如果是 图片
    if ([self isKindOfClass:[UIImage class]]) {
        //转化成data数据
        NSData *imageData = UIImagePNGRepresentation((UIImage *)self);
        //把数据保存到plistFileName文件中
        [imageData saveToFile:plistFileName];
    }
    // 获取Documents 中的文件的路径
    NSString *plistPath=[self getDocumentFilePath:plistFileName];
    
    //如果实现了 数据写入文件的 方法
    if ([self respondsToSelector:@selector(writeToFile:atomically:)]) {
        //返回写入结果 writeToFile:归档
        return  [(id)self writeToFile:plistPath atomically: YES];
    }
    
    return NO;
}

/**
 *  通过文件名读取文件中的数据
 *  @param plistFileName 文件名
 *
 *  @return plist文件中的数据
 */
+ (instancetype)readFromFile:(NSString*)plistFileName{
    
    //如果 对象是UIImage 的子类
    if ([self isSubclassOfClass:[UIImage class]]) {
        //返回
        return [UIImage imageWithData:[NSData readFromFile:plistFileName]] ;
    }
    // 获取Documents 中的文件的路径
    NSString *plistPath=[self getDocumentFilePath:plistFileName];
    //创建文件管理器
    NSFileManager *fileManger=[NSFileManager defaultManager];
    //文件是否存在 YES: 是  NO:否
    if ([fileManger fileExistsAtPath: plistPath]){
        // 如果对象是NSMutableDictonary 的子类
        if ([self isSubclassOfClass:[NSMutableDictionary class]]) {
            // dictionaryWithContentsOfFile:解档
            return [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            
            // 如果对象是NSDictionary 的子类
        } else if ([self isSubclassOfClass:[NSDictionary class]]) {
            return [NSDictionary dictionaryWithContentsOfFile:plistPath];
            
             // 如果对象是NSMutableArray 的子类
        } else if ([self isSubclassOfClass:[NSMutableArray class]]){
            return [NSMutableArray arrayWithContentsOfFile:plistPath];
            
             // 如果对象是NSArray 的子类
        } else if ([self isSubclassOfClass:[NSArray class]]){
            return [NSArray arrayWithContentsOfFile:plistPath];
            
             // 如果对象是NSMutableData 的子类
        } else if ([self isSubclassOfClass:[NSMutableData class]]){
            return [NSMutableData dataWithContentsOfFile:plistPath];
            
             // 如果对象是NSData 的子类
        } else if ([self isSubclassOfClass:[NSData class]]){
            return [NSData dataWithContentsOfFile:plistPath];
            
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

//存数据
-(void)SetPlistValue:(id)value andKeyName:(NSString*)keyName andFileName:(NSString*)fileName {
    //plist文件路径
    NSString *thePath = [self getDocumentFilePath:fileName];
    //创建文件管理器
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //新建空的CityPicked
    NSMutableDictionary *mDict;
    //判断文件是否存在 如果存在
    if([fileManager fileExistsAtPath:thePath]) {
        //从已知编码的文件读取数据
        mDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:thePath] mutableCopy];
    } else {
        //
        mDict = [[NSMutableDictionary alloc] init];
    }
    
    if (value) {
        //把对应的 key ,value值 存入字典
        [mDict setObject:value forKey:keyName];
    }
    //归档, 把数据写入文件
    [mDict writeToFile:thePath atomically:YES];
}

//取出数据
- (NSObject*)GetPlistValueOfKey:(NSString*)keyName andFileName:(NSString*)fileName
{
    NSObject *returnObject;
    //plist文件路径
    NSString *thePath = [self getDocumentFilePath:fileName];
    //创建文件管理器
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //新建空的CityPicked
    NSMutableDictionary *tempMMDic;
    //判断文件是否存在 如果存在
    if([fileManager fileExistsAtPath:thePath]) {
        ////从已知编码的文件读取数据
        tempMMDic = [[[NSMutableDictionary alloc] initWithContentsOfFile:thePath] mutableCopy];
        //从字典中根据key值 取出对应的value
        returnObject = [tempMMDic objectForKey:keyName];
    } else {
        //如果 文件不存在
//        tempMMDic = [[NSMutableDictionary alloc] init];
//        //归档 ,把空数据写入文件
//        [tempMMDic writeToFile:thePath atomically:YES];
        returnObject = nil;
    }
    //返回数据
    return returnObject;
}

@end
