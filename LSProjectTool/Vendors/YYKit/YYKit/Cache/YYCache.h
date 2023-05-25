//
//  YYCache.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

@class YYMemoryCache, YYDiskCache;

NS_ASSUME_NONNULL_BEGIN

/**
 `YYCache` is a thread safe key-value cache. YYCache是线程安全的键值缓存
 
 It use `YYMemoryCache` to store objects in a small and fast memory cache,
 and use `YYDiskCache` to persisting objects to a large and slow disk cache.
 See `YYMemoryCache` and `YYDiskCache` for more information.
 */
@interface YYCache : NSObject

/** The name of the cache, readonly. */
/// 缓存的名称，只读
@property (copy, readonly) NSString *name;

/** The underlying memory cache. see `YYMemoryCache` for more information.*/
/// 底层内存缓存。
@property (strong, readonly) YYMemoryCache *memoryCache;

/** The underlying disk cache. see `YYDiskCache` for more information.*/
/// 底层磁盘缓存。
@property (strong, readonly) YYDiskCache *diskCache;

/**
 Create a new instance with the specified name.
 Multiple instances with the same name will make the cache unstable.
 
 @param name  The name of the cache. It will create a dictionary with the name in
     the app's caches dictionary for disk cache. Once initialized you should not 
     read and write to this directory.
 @result A new cache object, or nil if an error occurs.
 */
/// 使用指定的名称创建一个新实例。多个同名实例将使缓存不稳定
/// @param name 缓存的名称。它将创建一个名为应用程序的磁盘缓存字典。一旦初始化，就不应该读取并写入此目录
/// @result 生成一个新的缓存对象，如果发生错误，则返回nil
- (nullable instancetype)initWithName:(NSString *)name;

/**
 Create a new instance with the specified path.
 Multiple instances with the same name will make the cache unstable.
 
 @param path  Full path of a directory in which the cache will write data.
     Once initialized you should not read and write to this directory.
 @result A new cache object, or nil if an error occurs.
 */
/// 使用指定的路径创建新实例。多个同名实例将使缓存不稳定。
/// @param path 此缓存将在其中写入数据的目录的完整地址。一旦初始化，就不应该读写这个目录
/// @result 生成一个新的缓存对象，如果发生错误，则返回nil
- (nullable instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

/**
 Convenience Initializers
 Create a new instance with the specified name.
 Multiple instances with the same name will make the cache unstable.
 
 @param name  The name of the cache. It will create a dictionary with the name in
     the app's caches dictionary for disk cache. Once initialized you should not 
     read and write to this directory.
 @result A new cache object, or nil if an error occurs.
 */
/// 简易初始化器，使用指定的名称创建一个新实例。多个同名实例将使缓存不稳定。
/// @param name 缓存的名称。它将创建一个名为 应用程序的磁盘缓存字典。一旦初始化，就不应该读取并写入此目录
/// @result 生成一个新的缓存对象，如果发生错误，则返回nil。
+ (nullable instancetype)cacheWithName:(NSString *)name;

/**
 Convenience Initializers
 Create a new instance with the specified path.
 Multiple instances with the same name will make the cache unstable.
 
 @param path  Full path of a directory in which the cache will write data.
     Once initialized you should not read and write to this directory.
 @result A new cache object, or nil if an error occurs.
 */
/// 简易初始化器。使用指定的路径创建新实例。多个同名实例将使缓存不稳定。
/// @param path 缓存将在其中写入数据的目录的完整路径。一旦初始化，就不应该读写这个目录
/// @result 生成一个新的缓存对象，如果发生错误，则返回nil
+ (nullable instancetype)cacheWithPath:(NSString *)path;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

#pragma mark - 访问方法 Access Methods
///=============================================================================
/// @name 访问方法 Access Methods
///=============================================================================

/**
 Returns a boolean value that indicates whether a given key is in cache.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return NO.
 @return Whether the key is in cache.
 */
/// 返回一个布尔值，该值指示给定密钥是否正在缓存中。此方法可能会阻止调用线程，直到文件读取完成
/// @param key 标识值的字符串。如果为nil，只需返回 NO。
/// @return 返回密钥是否在缓存中
- (BOOL)containsObjectForKey:(NSString *)key;

/**
 Returns a boolean value with the block that indicates whether a given key is in cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key   A string identifying the value. If nil, just return NO.
 @param block A block which will be invoked in background queue when finished.
 */
/// 返回一个带块的布尔值，该 block 指示给定密钥是否在缓存中。当操作结束后，此方法立即返回并调用后台队列中传递的block。
/// @param key 标识值的字符串。如果为nil，只需返回 NO
/// @param block 完成后将在后台队列中调用的 block
- (void)containsObjectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key, BOOL contains))block;

/**
 Returns the value associated with a given key.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
/// 返回与给定键关联的值，此方法可能会阻止调用线程，直到文件读取完成。
/// @param key 标识值的字符串。如果为 nil，只需返回 nil
/// @return 返回与键关联的值，如果没有与键关联的值，则返回 nil
- (nullable id<NSCoding>)objectForKey:(NSString *)key;

/**
 Returns the value associated with a given key.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @param block A block which will be invoked in background queue when finished.
 */
/// 返回与给定键关联的值。当操作结束后，此方法立即返回并调用后台队列中传递的 block。
/// @param key 标识值的字符串。如果为 nil，只需返回nil
/// @param block 完成后将在后台队列中调用的block
- (void)objectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key, id<NSCoding> object))block;

/**
 Sets the value of the specified key in the cache.
 This method may blocks the calling thread until file write finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 */
/// 设置缓存中指定密钥的值，此方法可能会阻止调用线程，直到文件写入完成。
/// @param object 要存储在缓存中的对象。如果为nil，则调用 'removeObjectForKey:'。
/// @param key 与值关联的键。如果为 nil，则此方法无效
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

/**
 Sets the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param block  A block which will be invoked in background queue when finished.
 */
/// 设置缓存中指定密钥的值。当操作结束后，此方法立即返回并调用后台队列中传递的block
/// @param object 要存储在缓存中的对象。如果为nil，则调用 'removeObjectForKey:'
/// @param key
/// @param block 完成后将在后台队列中调用的block
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key withBlock:(nullable void(^)(void))block;

/**
 Removes the value of the specified key in the cache.
 This method may blocks the calling thread until file delete finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
/// 删除缓存中指定密钥的值。此方法可能会阻止调用线程，知道文件删除完成。
/// @param key 标识要删除的键的值。如果为 nil，则此方法无效。
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 @param block  A block which will be invoked in background queue when finished.
 */
/// 删除缓存中指定密钥的值。操作完成后，此方法立即返回并调用后台队列中传递的block
/// @param key 标识要删除的值的键。如果为 nil，则此方法无效
/// @param block 完成后将在后台队列中调用的block
- (void)removeObjectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key))block;

/**
 Empties the cache.
 This method may blocks the calling thread until file delete finished.
 */
/// 清空缓存。此方法可能会阻止调用线程，直到文件删除完成。
- (void)removeAllObjects;

/**
 Empties the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
/// 清空缓存。当操作完成后，此方法立即返回并调用后台队列中传递的block
/// @param block 完成后将在后台队列中调用的block
- (void)removeAllObjectsWithBlock:(void(^)(void))block;

/**
 Empties the cache with block.
 This method returns immediately and executes the clear operation with block in background.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
/// 用 block 清空缓存。此方法立即返回，并在后台执行带 block 的清除操作。
/// @param progress 删除期间将调用此块，传递 nil 忽略。
/// @param end 此 block 将在末未调用，传递 nil 忽略。
- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;

@end

NS_ASSUME_NONNULL_END
