/**
 https://juejin.cn/post/7276260308515045416#heading-19
 https://github.com/SnowGirls/Objc-Deallocating/tree/master
 
 键盘过度释放问题
 系统版本：iOS 16.0 ~
 复现逻辑：点击屏幕上半部的输入框（搜索框）展开非官方键盘，收起键盘，双击输入框
        搜狗输入法 输入框输入文字后 先让输入框失去焦点 然后双击输入框
 */


#import <Foundation/Foundation.h>

#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcUtil : NSObject

// call the origin method in the method list
+ (bool)invokeOriginalMethod:(id)target selector:(SEL)selector completion:(void (^)(Class clazz, IMP impl))completion ;

+ (bool)invokeOriginalMethod:(id)target selector:(SEL)selector class:(Class)clazz completion:(void (^)(Class clazz, IMP impl))completion;

@end


typedef NS_OPTIONS(NSUInteger, ObjcSeekerType) {
    ObjcSeekerTypeClass  = 1 <<  0,
    ObjcSeekerTypeInstance = 1 <<  1,
};



@interface ObjcSeeker : NSObject

@property(assign) ObjcSeekerType seekType;

@property(assign) BOOL isSeekBackward;

@property(assign) int seekSkipCount;
@property(assign) IMP impl;

- (void)seekOriginalMethod:(id)target selector:(SEL)selector ;

#pragma mark - Static util methods

+(IMP) seekInstanceNextOirignalImpl:(id)target selector:(SEL)selector ;
    
@end

NS_ASSUME_NONNULL_END
