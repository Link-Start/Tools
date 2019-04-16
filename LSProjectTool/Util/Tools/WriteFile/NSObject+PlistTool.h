//
//  NSObject+PlistTool.h
//  TimeToSee
//
//  Created by Xcode on 15/1/21.
//  Copyright (c) 2015年 苏州麦卡软件有限公司. All rights reserved.
// 把数据写入plist文件 从plist文件中取出数据


#pragma mark - 把数据写入plist文件 从plist文件中取出数据：
//plist文件: 明文保存,操作的对象:只支持NSArray、NSMutableArray、NSDictionary、NSMutableDictionary
//xml属性列表进行归档的方式是将对象存储在一个plist文件中

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (PlistTool)
/**
 *  通过文件名获取文件路径 (Documents文件路径,应用中用户数据可以放在这里)
 *
 *  @param plistFileName 文件名
 *
 *  @return 文件路径
 */
- (NSString *)getDocumentFilePath:(NSString *)plistFileName;

/**
 *  通过文件名将文件存入plist文件
 *
 *  @param plistFileName 文件名
 *
 *  @return
 */
- (BOOL)saveToFile:(NSString *)plistFileName;

/**
 *  通过文件名读取文件中的数据
 *
 *  @param plistFileName 文件名
 *
 *  @return plist文件中的数据
 */
+ (instancetype)readFromFile:(NSString *)plistFileName;

/**
 *  将数据写入plist文件中
 *
 *  @param value 需要存储的数据的值
 *  @param keyName 文件中数据存储时设置的key值
 *  @param fileName plist文件的文件名
 */
- (void)SetPlistValue:(id)value andKeyName:(NSString *)keyName andFileName:(NSString *)fileName;

/**
 *  从plist文件中取出数据
 *
 *  @param keyName 文件中数据存储时设置的key值
 *  @param fileName plist文件的文件名
 *
 *  @return 数据
 */
- (NSObject *)GetPlistValueOfKey:(NSString *)keyName andFileName:(NSString *)fileName;


@end

