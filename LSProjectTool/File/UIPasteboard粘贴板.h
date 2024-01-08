//
//  UIPasteboard粘贴板.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/9/25.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//  https://www.mianshigee.com/note/detail/129381tsf/
//  https://www.mianshigee.com/note/detail/129381tsf/
#ifndef UIPasteboard____h
#define UIPasteboard____h

实际上，当用户通过上面的空间进行复制、剪切等操作时，被选中的内容会被存放到系统的剪切板中，并且这个剪切板并不只能存放字符串数据，其还可以进行图片数据与网址URL数据的存放。这个剪切板就是UIPasteboard类，开发者也可以直接通过它来操作数据进行应用内或应用间传值。

UIPasteboard类有3个初始化方法，如下：
//获取系统级别的剪切板
+ (UIPasteboard *)generalPasteboard;
//获取一个自定义的剪切板 name参数为此剪切板的名称 create参数用于设置当这个剪切板不存在时 是否进行创建
+ (nullable UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create;
//获取一个应用内可用的剪切板
+ (UIPasteboard *)pasteboardWithUniqueName;
上面3个初始化方法，分别获取或创建3个级别不同的剪切板，系统级别的剪切板在整个设备中共享，即是应用程序被删掉，其向系统级的剪切板中写入的数据依然在。自定义的剪切板通过一个特定的名称字符串进行创建，它在应用程序内或者同一开发者开发的其他应用程序中可以进行数据共享。第3个方法创建的剪切板等价为使用第2个方法创建的剪切板，只是其名称字符串为nil，它通常用于当前应用内部。

注意：使用第3个方法创建的剪切板默认是不进行数据持久化的，及当应用程序退出后，剪切板中内容将别抹去。若要实现持久化，需要设置persistent属性为YES。


UIPasteboard中常用方法及属性如下：

//剪切板的名称
@property(readonly,nonatomic) NSString *name;
//根据名称删除一个剪切板
+ (void)removePasteboardWithName:(NSString *)pasteboardName;
//是否进行持久化
@property(getter=isPersistent,nonatomic) BOOL persistent;
//此剪切板的改变次数 系统级别的剪切板只有当设备重新启动时 这个值才会清零
@property(readonly,nonatomic) NSInteger changeCount;

 下面这些方法用于设置与获取剪切板中的数据：

 1. 最新一组数据对象的存取：
//获取剪切板中最新数据的类型
- (NSArray<NSString *> *)pasteboardTypes;
//获取剪切板中最新数据对象是否包含某一类型的数据
- (BOOL)containsPasteboardTypes:(NSArray<NSString *> *)pasteboardTypes;
//将剪切板中最新数据对象某一类型的数据取出
- (nullable NSData *)dataForPasteboardType:(NSString *)pasteboardType;
//将剪切板中最新数据对象某一类型的值取出
- (nullable id)valueForPasteboardType:(NSString *)pasteboardType;
//为剪切板中最新数据对应的某一数据类型设置值
- (void)setValue:(id)value forPasteboardType:(NSString *)pasteboardType;
//为剪切板中最新数据对应的某一数据类型设置数据
- (void)setData:(NSData *)data forPasteboardType:(NSString *)pasteboardType;


 2.多组数据对象的存取：
//数据组数
@property(readonly,nonatomic) NSInteger numberOfItems;
//获取一组数据对象包含的数据类型
- (nullable NSArray *)pasteboardTypesForItemSet:(nullable NSIndexSet*)itemSet;
//获取一组数据对象中是否包含某些数据类型
- (BOOL)containsPasteboardTypes:(NSArray<NSString *> *)pasteboardTypes inItemSet:(nullable NSIndexSet *)itemSet;
//根据数据类型获取一组数据对象
- (nullable NSIndexSet *)itemSetWithPasteboardTypes:(NSArray *)pasteboardTypes;
//根据数据类型获取一组数据的值
- (nullable NSArray *)valuesForPasteboardType:(NSString *)pasteboardType inItemSet:(nullable NSIndexSet *)itemSet;
//根据数据类型获取一组数据的NSData数据
- (nullable NSArray *)dataForPasteboardType:(NSString *)pasteboardType inItemSet:(nullable NSIndexSet *)itemSet;
//所有数据对象
@property(nonatomic,copy) NSArray *items;
//添加一组数据对象
- (void)addItems:(NSArray<NSDictionary<NSString *, id> *> *)items;


上面方法中很多需要传入数据类型参数，这些参数是系统定义好的一些字符窜，如下：
//所有字符串类型数据的类型定义字符串数组
UIKIT_EXTERN NSArray<NSString *> *UIPasteboardTypeListString;
//所有URL类型数据的类型定义字符串数组
UIKIT_EXTERN NSArray<NSString *> *UIPasteboardTypeListURL;
//所有图片数据的类型定义字符串数据
UIKIT_EXTERN NSArray<NSString *> *UIPasteboardTypeListImage;
//所有颜色数据的类型定义字符串数组
UIKIT_EXTERN NSArray<NSString *> *UIPasteboardTypeListColor;


相比于上面两组方法，下面这些方法更加面向对象，在开发中使用更加方便与快捷：
//获取或设置剪切板中的字符串数据
@property(nullable,nonatomic,copy) NSString *string;
//获取或设置剪切板中的字符串数组
@property(nullable,nonatomic,copy) NSArray<NSString *> *strings;
//获取或设置剪切板中的URL数据
@property(nullable,nonatomic,copy) NSURL *URL;
//获取或设置剪切板中的URL数组
@property(nullable,nonatomic,copy) NSArray<NSURL *> *URLs;
//获取或s何止剪切板中的图片数据
@property(nullable,nonatomic,copy) UIImage *image;
//获取或设置剪切板中的图片数组
@property(nullable,nonatomic,copy) NSArray<UIImage *> *images;
//获取或设置剪切板中的颜色数据
@property(nullable,nonatomic,copy) UIColor *color;
//获取或设置剪切板中的颜色数组
@property(nullable,nonatomic,copy) NSArray<UIColor *> *colors;


对剪切板的某些操作会触发如下通知：
//剪切板内容发生变化时发送的通知
UIKIT_EXTERN NSString *const UIPasteboardChangedNotification;
//剪切板数据类型键值增加时发送的通知
UIKIT_EXTERN NSString *const UIPasteboardChangedTypesAddedKey;
//剪切板数据类型键值移除时发送的通知
UIKIT_EXTERN NSString *const UIPasteboardChangedTypesRemovedKey;
//剪切板被删除时发送的通知
UIKIT_EXTERN NSString *const UIPasteboardRemovedNotification;



#endif /* UIPasteboard____h */
