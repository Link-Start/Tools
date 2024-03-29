//
//  ADFileManager.m
//  LSProjectTool
//
//  Created by Xcode on 16/12/7.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "ADFileManager.h"
#import <UIKit/UIKit.h>

@interface ADFileManager()

@property (nonatomic, strong) NSFileManager *manager;

@end


@implementation ADFileManager
#pragma mark - 沙盒目录相关
/**
    主目录，tmp目录路径可直接获取
    libraryDir通过NSSearchPathForDirectoriesInDomains
    Library / Preferences的目录通过libraryDir拼接
    Library / Caches的目录通过NSSearch搜索CachesDirectory
    
    NSSearchPathForDirectoriesInDomains
    第一个参数是哪个目录
    第二个参数是搜索谁的
    第三个参数 ' ~ ' 路径是否展开
    ' ~ ' 路径是详细路径前半段直接隐藏用' ~ '显示
 
 @ NSDocumentDirectory 指程序中对应的Documents文件夹路径
 @ NSUserDomainMask    用户主目录中(说明是在当前应用沙盒中获取,所有应用沙盒目录组成一个数组结构的数据存放)
 @ YES                 展开成完整路径
 */

///获取应用的根目录(获取沙盒路径),也就是Documents的上级目录,当然也是tmp目录的上级目录:NSHomeDirectory()
+ (NSString *)homeDirPath {
    return NSHomeDirectory();
}

///获取Documents文件夹目录/路径
+ (NSString *)documentsDirPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

///获取Library目录/路径
+ (NSString *)libraryDirPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
//沙盒中Library/Preferences的目录路径
+ (NSString *)preferencesDirPath {
    NSString *libraryDir = [self libraryDirPath];
    return [libraryDir stringByAppendingPathComponent:@"Preferences"];
}

//沙盒中Library/Caches 的 目录路径
+ (NSString *)cachesDirPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
// 沙盒中tmp的目录路径
+ (NSString *)tmpDirPath {
    return NSTemporaryDirectory();
}

#pragma mark - 遍历文件夹
/**
    通过FileManager的subpathsOfDirectoryAtPath:error:深遍历路径
    通过FileManager的contentsOfDirectoryAtPath:error:浅遍历路径
 */
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        //深遍历
        //返回当前目录下及子目录下的所有文件和文件夹
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    } else {
        //浅遍历
        //返回当前目录下的所有文件和文件夹
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        } else {
            listArr = nil;
        }
    }
    return listArr;
}

//遍历沙盒主目录
+ (NSArray *)listFilesInHomeDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self homeDirPath] deep:deep];
}

//遍历Library目录
+ (NSArray *)listFilesInLibraryDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self libraryDirPath] deep:deep];
}

//遍历Documents目录
+ (NSArray *)listFilesInDocumentDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self documentsDirPath] deep:deep];
}

//遍历tmp目录
+ (NSArray *)listFilesInTmpDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self tmpDirPath] deep:deep];
}

//遍历Caches目录
+ (NSArray *)listFilesInCachesDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self cachesDirPath] deep:deep];
}

#pragma mark - 获取文件属性
/**
    先通过FileManager的attributesOfItemAtPath:error:获取路径下文件属性集合，而后通过key取出某个属性
 */

//根据key获取文件某个属性
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key {
    return [[self attributesOfItemAtPath:path] objectForKey:key];
}
//根据key获取文件某个属性(错误信息error)
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [[self attributesOfItemAtPath:path error:error] objectForKey:key];
}

//获取文件属性集合
+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path {
    return [self attributesOfItemAtPath:path error:nil];
}

//获取文件属性集合(错误信息error)
+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
}

#pragma mark - 创建文件(夹)
/**
    创建文件夹:通过fileManager的createDirectoryAtPath:withIntermediateDirectories:attributes:error:
    
    createDirectoryAtPath:withIntermediateDirectories:attributes:error:
    第一个参数代表文件夹路径
    第二个参数代表是否允许创建中间目录
    第三个参数代表设置，如访问权限、所属用户/用户组。nil代表选择系统默认设置。
    第四个参数代表错误信息
 
    创建文件:通过fileManager的createFileAtPath:contents:attributes:
    如果文件夹路径不存在，则先创建文件夹。通过自定义方法directoryAtPath判断
    如果创建失败返回NO，没有错误信息
    如果文件存在但不想复写则返回YES
    先创建文件，而后判断是否写入内容
    content代表写入的内容，如果有则写入
 
    获取文件修改时间、创建时间则先获取文件的所有属性
    通过KeyNSFileModificationDate(修改) NSFileCreationDate(创建)
    获取到所需的修改时间、创建时间
 
 
 */

//创建文件夹
+ (BOOL)createDirectoryAtPath:(NSString *)path {
    return [self createDirectoryAtPath:path error:nil];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}

//创建文件
+ (BOOL)createFileAtPath:(NSString *)path {
    return [self createFileAtPath:path content:nil overwrite:YES error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:nil overwrite:YES error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:nil overwrite:overwrite error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:nil overwrite:overwrite error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self createFileAtPath:path content:content overwrite:YES error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:content overwrite:YES error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:content overwrite:overwrite error:nil];
}

+ (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    //如果文件夹路径不存在, 那么先创建文件夹
    NSString *directoryPath = [self directoryAtPath:path];
    if (![self isExistsAtPath:directoryPath]) {
        //创建文件夹
        if (![self createDirectoryAtPath:directoryPath error:error]) {
            return NO;
        }
    }
    //如果文件存在, 并不想覆盖, 那么直接返回YES。
    if (!overwrite) {
        if ([self isExistsAtPath:path]) {
            return YES;
        }
    }
    //创建文件
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (content) {
        [self writeFileAtPath:path content:content error:error];
    }
    return isSuccess;
}

//获取创建文件时间
+ (NSDate *)creationDateOfItemAtPath:(NSString *)path {
    return [self creationDateOfItemAtPath:path error:nil];
}

+ (NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileCreationDate error:error];
}
//获取文件修改时间
+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path {
    return [self modificationDateOfItemAtPath:path error:nil];
}

+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileModificationDate error:error];
}

#pragma mark - 删除文件(夹)
/**
    删除文件/文件夹 通过fileManager的removeItemAtPath:error:直接删除这个路径文件/文件夹
 
    清空Caches文件夹:
    先浅遍历cache文件夹，获取其下所有文件与目录
    而后拼接在cache路径后，通过自定义方法removeItemAtPath:移除
    让一个BOOL值为YES的isSuccess &= 移除后的结果值
    则有一个移除错误就会为NO
 
    清空tmp文件夹同上
 */

+ (BOOL)removeItemAtPath:(NSString *)path {
    return [self removeItemAtPath:path error:nil];
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

//清空Caches文件夹
+ (BOOL)clearCachesDirectory {
    NSArray *subFiles = [self listFilesInCachesDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self cachesDirPath] stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
    
}

//清空tmp文件夹
+ (BOOL)clearTmpDirectory {
    NSArray *subFiles = [self listFilesInTmpDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self tmpDirPath] stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

#pragma mark - 复制文件(夹)
/**
    复制文件/文件夹 先要保证源文件路径存在，不然通过NSException抛出异常
    而后获取路径上的文件夹，如果文件夹路径不存在则创建文件夹路径，创建失败直接返回NO
    而后判断是否允许重写，如果允许重写且文件存在则先删掉要重写的文件
    
    调用fileManager的copyItemAtPath:toPath:error:复制文件
 */

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self copyItemAtPath:path toPath:toPath overwrite:NO error:nil];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    return [self copyItemAtPath:path toPath:toPath overwrite:NO error:error];
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    return [self copyItemAtPath:path toPath:toPath overwrite:overwrite error:nil];
}


+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    //先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在, 请检查源文件路径",path];
        return NO;
    }
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        //创建复制路径
        if (![self createFileAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    //如果覆盖, 那么先删掉源文件
    if (overwrite) {
        if ([self isExistsAtPath:toPath]) {
            [self removeItemAtPath:toPath error:error];
        }
    }
    //复制文件
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
    
    return isSuccess;
}


#pragma mark - 移动文件(夹)
/**
    同复制文件夹，只是移动时若文件存在且不允许重写则把源文件移除而后返回YES
    如果文件存在且允许重写则移除要重写的文件而后移动源文件
 
    调用fileManager的moveItemAtPath:toPath:error:移动源文件
 */
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self moveItemAtPath:path toPath:toPath  overwrite:NO error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *__autoreleasing *)error {
    return [self moveItemAtPath:path toPath:toPath overwrite:NO error:error];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    return [self moveItemAtPath:path toPath:toPath overwrite:overwrite error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    
    //先要保证源文件路径存在, 不然抛出异常
    if (![self isExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在, 请检查源文件路径", path];
        return NO;
    }
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        //创建移动路径
        if (![self createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    
    //如果覆盖, 那么先删掉源文件
    if ([self isExistsAtPath:toPath]) {
        if (overwrite) {
            [self removeItemAtPath:toPath error:error];
        }else {
            [self removeItemAtPath:path error:error];
            return YES;
        }
    }
    //移动文件
    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
    
    return isSuccess;
    
}

#pragma mark - 根据URL获取文件名
/**
    根据文件路径获取文件名称，是否需要后缀
    直接通过字符串的lastPathComponent方法获取文件名称
    若不需要后缀则通过stringByDeletingPathExtension删除掉后缀
    
    获取文件所在的文件夹路径
    直接通过字符串的stringByDeletingLastPathComponent删除最后一个目录
    也就是最后一个' / '之后的内容包括' / '
 
    根据文件路径获取文件扩展类型
    直接通过字符串的pathExtension获取扩展名
    会从最后面截取' . '之后的内容
 
 */

//根据文件路径获取文件名称，是否需要后缀
+ (NSString *)fileNameAtPath:(NSString *)path suffix:(BOOL)suffix {
    NSString *fileName = [path lastPathComponent];
    if (!suffix) {
        fileName = [fileName stringByDeletingPathExtension];
    }
    return fileName;
}

//获取文件所在的文件夹路径
+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

//根据文件路径获取文件扩展类型
+ (NSString *)suffixAtPath:(NSString *)path {
    return [path pathExtension];
}

#pragma mark - 判断文件(夹)是否存在
/**
    判断文件路径是否存在直接通过fileManager的fileExistsAtPath:方法判断
 
    判断路径是否为空(判断条件是文件大小为0, 或者是文件夹下没有子文件)
    目标路径是一个文件并且文件大小是0
    或 目标路径是一个文件夹并且文件夹下没有子文件
 
    判断目录是否是文件夹,通过文件属性NSFileType得值是否为NSFileTypeDirectory
 
    判断目录是否是文件,通过文件属性NSFileType得值是否为NSFileTypeRegular
 
    可执行、可读、可写通过fileManager的isExecutableFileAtPath、
    isReadableFileAtPath、isWritableFileAtPath判断
 
 */


//判断 文件/文件夹 是否存在
+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//判断路径是否为空(判断条件是文件大小为0, 或者是文件夹下没有子文件)
+ (BOOL)isEmptyItemAtPath:(NSString *)path {
    return [self isEmptyItemAtPath:path error:nil];
}

+ (BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self isFileAtPath:path error:error] && [[self sizeOfItemAtPath:path error:error] intValue] == 0) || ([self isDirectoryAtPath:path error:error] && [[self listFilesInDirectoryAtPath:path deep:NO] count] == 0);
}

//判断目录是否是文件夹
+ (BOOL)isDirectoryAtPath:(NSString *)path {
    return [self isDirectoryAtPath:path error:nil];
}

+ (BOOL)isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeDirectory);
}

//判断目录是否是文件
+ (BOOL)isFileAtPath:(NSString *)path {
    return [self isFileAtPath:path error:nil];
}

+ (BOOL)isFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error{
      return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeRegular);
}

//判断目录是否可执行
+ (BOOL)isExecutableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}

//判断目录是否可读
+ (BOOL)isReadableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}

//判断目录是否可写
+ (BOOL)isWriteableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}

#pragma mark - 获取文件(夹)大小
/**
    获取文件/目录大小 通过属性的key值NSFileSize获取
    只是获取文件大小时，若目标路径不是文件则返回nil
 
    获取文件夹大小时先判断路径是否为文件夹，不是则返回nil
    而后深遍历文件夹累加每个文件的大小
 */

// 获取目录大小
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path {
    return [self sizeOfItemAtPath:path error:nil];
}

+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSNumber *)[self attributeOfItemAtPath:path forKey:NSFileSize error:error];
}

// 获取文件大小
+ (NSNumber *)sizeOfFileAtPath:(NSString *)path {
    return [self sizeOfFileAtPath:path error:nil];
}

+ (NSNumber *)sizeOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    //若目标路径不是文件则返回nil
    if ([self isFileAtPath:path error:error]) {
        //是文件则通过与获取目录大小同样的方法获取文件大小
        return [self sizeOfItemAtPath:path error:error];
    }
    return nil;
}

// 获取文件夹大小
+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path {
    return [self sizeOfDirectoryAtPath:path error:nil];
}

+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    // 获取文件夹大小时先判断路径是否为文件夹，不是则返回nil
    // 而后深遍历文件夹累加每个文件的大小
    if ([self isDirectoryAtPath:path error:error]) {//判断目录是否是文件夹
        NSArray *subPaths = [self listFilesInDirectoryAtPath:path deep:YES];
        NSEnumerator *contentsEnumurator = [subPaths objectEnumerator];
        
        NSString *file;
        unsigned long long int folderSize = 0;
        
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
        }
        return [NSNumber numberWithUnsignedLongLong:folderSize];
    }
    return nil;
}

/*********/

#pragma mark - 获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path {
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    } else if (totleSize > 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f];
    } else {
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;
}

/*********/


// 获取目录大小，返回格式化后的数值
+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path {
    return [self sizeFormattedOfItemAtPath:path error:nil];
}

+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self sizeOfItemAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

// 获取文件大小，返回格式化后的数值
+ (NSString *)sizeFormattedOfFileAtPath:(NSString *)path {
    return [self sizeFormattedOfFileAtPath:path error:nil];
}

+ (NSString *)sizeFormattedOfFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self sizeOfItemAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

// 获取文件夹大小，返回格式化后的数值
+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path {
    return [self sizeFormattedOfDirectoryAtPath:path error:nil];
}

+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSNumber *size = [self sizeOfDirectoryAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

#pragma mark - 写入文件内容
/**
    写入文件内容时，如果文件不存在就异常警告并返回NO
    如果文件路径不存在则返回NO
    如果文件存在，路径存在就根据文件所属类型转换并写入
    (不转换就是NSObject类型无法调用write方法)
    atomically是否允许持续写入
    其中JSON格式转变为字典类型
    UIImage格式通过UIImagePNGRepresentation转变为NSData类型
    NSCoding类型通过[NSKeyedArchiver archiveRootObject:content toFile:path]
    如果类型都不对则异常提示并返回NO
 
*/
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self writeFileAtPath:path content:content error:nil];
}

+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    
    if (!content) {
        [NSException raise:@"非法的文件内容" format:@"文件内容不能为nil"];
        return NO;
    }
   
    
    if ([self isExistsAtPath:path]) {//判断 文件/文件夹 是否存在
        if ([content isKindOfClass:[NSMutableArray class]]) {
            [(NSMutableArray *)content writeToFile:path atomically:YES];
        }else if([content isKindOfClass:[NSArray class]]){
            [(NSArray *)content writeToFile:path atomically:YES];
        }else if([content isKindOfClass:[NSMutableData class]]){
            [(NSMutableData *)content writeToFile:path atomically:YES];
        }else if([content isKindOfClass:[NSData class]]){
            [(NSData *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableDictionary class]]){
            [(NSMutableDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSDictionary class]]){
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSMutableString class]]){
            [[(NSString *)content dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSJSONSerialization class]]){
            [(NSDictionary *)content writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[NSString class]]){
            [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
        }else if ([content isKindOfClass:[UIImage class]]){
            [UIImagePNGRepresentation((UIImage *)content) writeToFile:path atomically:YES];
        }else if ([content conformsToProtocol:@protocol(NSCoding)]){
            
            if ([NSKeyedArchiver respondsToSelector:@selector(archiveRootObject:toFile:)]) {
                [NSKeyedArchiver archiveRootObject:content toFile:path];
            } else if ([NSKeyedArchiver respondsToSelector:@selector(archivedDataWithRootObject:requiringSecureCoding:error:)]) {
                // 不知道写法对不对
                [NSKeyedArchiver archivedDataWithRootObject:content requiringSecureCoding:YES error:error];
                [(NSString *)content writeToURL:[NSURL fileURLWithPath:path] atomically:YES encoding:NSUTF8StringEncoding error:error];
            }
        }else {
            //路径存在但写入失败则返回NO
            [NSException raise:@"非法的文件内容" format:@"文件类型%@异常, 无法被处理。",NSStringFromClass([content class])];
            return NO;
        }
    }else {
        //路径不存在则返回NO
        return NO;
    }
    //路径存在并写入成功则返回YES
    return YES;
}


#pragma mark - private methods

//转换错误信息,如果错误信息为空则返回YES。不过没有用到
+ (BOOL)isNotError:(NSError **)error {
    return ((error == nil) || ((*error) == nil));
}

//转换大小格式(传进来的值 bytes为单位 )
+ (NSString *)sizeFormatted:(NSNumber *)size {
    
    double convertedValue = [size doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB"];
    
    //存储大小满1024进1
    while (convertedValue > 1024) {
        convertedValue /= 1024.0f;
        
        multiplyFactor++;
    }
    //MB/GB/TB则保留两位小数否则保留0位小数
    //整数位只有4位
    NSString *sizeFormat = ((multiplyFactor > 1) ? @"%4.2f %@" : @"%4.0f %@");
    //显示如:2KB 或4.26MB 或1002.25GB
    return [NSString stringWithFormat:sizeFormat,convertedValue,tokens[multiplyFactor]];
}

//

/** 将文件大小转化成M单位或者B单位 */
+ (NSString *)getFileSizeString:(NSString *)size {
//    if ([size floatValue] >= 1024*1024*1024) { // 大于1G，则转化成G单位的字符串
//        return [NSString stringWithFormat:@"%.2fG",[size floatValue]/1024.00f/1024.00f/1024.00f];
//    } else //&& [size floatValue] < 1024*1024*1024
    if ([size floatValue] >= 1024*1024) {//大于1M，则转化成M单位的字符串
        return [NSString stringWithFormat:@"%.2fM",[size floatValue]/1024.00f/1024.00f];
    } else if ([size floatValue] >= 1024 && [size floatValue] < 1024*1024) { //不到1M,但是超过了1KB，则转化成KB单位
        return [NSString stringWithFormat:@"%.2fK",[size floatValue]/1024.00f];
    } else { //剩下的都是小于1K的，则转化成B单位
        return [NSString stringWithFormat:@"%.2fB",[size floatValue]/1.00f];
    }
}
/** 将文件大小转化成不带单位的数字 */
+ (float)getFileSizeNumber:(NSString *)size {
    
//    NSInteger indexG = [size rangeOfString:@"G"].location;
    NSInteger indexM = [size rangeOfString:@"M"].location;
    NSInteger indexK = [size rangeOfString:@"K"].location;
    NSInteger indexB = [size rangeOfString:@"B"].location;
    
    
    if (indexM < 1000) { //是M单位的字符串
        return [[size substringToIndex:indexM] floatValue] * 1024 * 1024;
    } else if (indexK < 1000) { //是K单位的字符串
        return [[size substringToIndex:indexK] floatValue] * 1024;
    } else if (indexB < 1000) {// 是B单位的字符串
        return [[size substringToIndex:indexB] floatValue];
    } else { //没有任何单位的数字字符串
        return [size floatValue];
    }
}

+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength {
    
    if (contentLength >= pow(1024, 3)) {//
        return (CGFloat)(contentLength / (CGFloat)pow(1024, 3));
    } else if (contentLength >= pow(1024, 2)) {//
        return (CGFloat)(contentLength / (CGFloat)pow(1024, 2));
    } else if (contentLength >= 1024) {//
        return (CGFloat)(contentLength / (CGFloat)1024);
    } else {//
        return (CGFloat)(contentLength);
    }
}

+ (NSString *)calculateUnit:(unsigned long long)contentLength {
    
    if (contentLength >= pow(1024, 3)) {
        return @"GB";
    } else if (contentLength >= pow(1024, 2)) {
        return @"MB";
    } else if (contentLength >= 1024) {
        return @"KB";
    } else {
        return @"B";
    }
}

@end
