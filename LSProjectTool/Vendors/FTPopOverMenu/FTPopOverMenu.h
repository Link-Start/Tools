//
//  FTPopOverMenu.h
//  FTPopOverMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//
//
//  类似QQ和微信消息页面的右上角微型菜单弹窗

#import <UIKit/UIKit.h>
@class FTPopOverMenuConfiguration;

/**
 *  FTPopOverMenuDoneBlock
 *
 *  @param selectedIndex SlectedIndex
 */
typedef void (^FTPopOverMenuDoneBlock)(NSInteger selectedIndex);
/**
 *  FTPopOverMenuDismissBlock
 */
typedef void (^FTPopOverMenuDismissBlock)(void);

/// 设置
typedef FTPopOverMenuConfiguration *(^FTPopOverMenuConfigurationBlock)(void);

/**
 *  -----------------------FTPopOverMenuModel-----------------------
 */
@interface FTPopOverMenuModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id image;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title image:(id)image selected:(BOOL)selected;

@end

/**
 *  -----------------------FTPopOverMenuConfiguration-----------------------
 */
@interface FTPopOverMenuConfiguration : NSObject

@property (nonatomic, assign) CGFloat menuTextMargin;// Default is 6.
@property (nonatomic, assign) CGFloat menuIconMargin;// Default is 6.
/// 菜单每一项的高度
@property (nonatomic, assign) CGFloat menuRowHeight;
/// 菜单的宽度
@property (nonatomic, assign) CGFloat menuWidth;
/// 菜单圆角
@property (nonatomic, assign) CGFloat menuCornerRadius;
/// 菜单文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
/// 文字字体
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
/// 默认是NO, 如果设置为YES 则 image 的颜色将和 textColor 相同
@property (nonatomic, assign) BOOL ignoreImageOriginalColor;// Default is 'NO', if sets to 'YES', images color will be same as textColor.
/// 默认为 NO, 如果是YES,则将箭头以圆角绘制
@property (nonatomic, assign) BOOL allowRoundedArrow;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
/// 动画时长
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *selectedCellBackgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOffsetX;
@property (nonatomic, assign) CGFloat shadowOffsetY;
@property (nonatomic, strong) UIColor *coverBackgroundColor;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat horizontalMargin;

/// 选项列表的最大高度。
/// 如果选项列表高度 > 设置的最大高度，显示设置的最大高度
/// 如果选项列表高度 < 设置的最大高度，显示列表的真实高度
/// 如果设置的高度 超出 屏幕之外         ，显示距离屏幕安全距离的高度
@property (nonatomic, assign) CGFloat optionsListLimitHeight; // default: 0


/**
 *  defaultConfiguration
 *
 *  @return curren configuration
 */
+ (FTPopOverMenuConfiguration *)defaultConfiguration;

@end

/**
 *  -----------------------FTPopOverMenuCell-----------------------
 */
@interface FTPopOverMenuCell : UITableViewCell

@end
/**
 *  -----------------------FTPopOverMenuView-----------------------
 */
@interface FTPopOverMenuView : UIControl

@end

/**
 *  -----------------------FTPopOverMenu-----------------------
 */
@interface FTPopOverMenu : NSObject

//    menuArray supports following context:
//    1. image name (NSString, only main bundle),
//    2. image (UIImage),
//    3. image remote URL string (NSString),
//    4. image remote URL (NSURL),
//    5. model (FTPopOverMenuModel, select state support)

/**
 show method with sender without images
 
 @param sender sender
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;
/**
 show method with sender without images
 
 @param sender 箭头要显示的位置所在的控件
 @param menuArray 菜单数据
 @param configurationBlock 设置
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                   configurationBlock:(FTPopOverMenuConfiguration *(^)(void))configurationBlock
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with sender and image resouce Array
 
 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with sender, image resouce Array and configuration
 
 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                   configuration:(FTPopOverMenuConfiguration *)configuration
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event without images
 
 @param event event
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromEvent:(UIEvent *)event
                   withMenuArray:(NSArray *)menuArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event and imageArray
 
 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromEvent:(UIEvent *)event
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;


/**
 show method for barbuttonitems with event, imageArray and configuration
 
 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromEvent:(UIEvent *)event
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                   configuration:(FTPopOverMenuConfiguration *)configuration
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;
/**
 show method with SenderFrame without images
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromSenderFrame:(CGRect )senderFrame
                         withMenuArray:(NSArray *)menuArray
                             doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                          dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame and image resouce Array
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromSenderFrame:(CGRect )senderFrame
                         withMenuArray:(NSArray *)menuArray
                            imageArray:(NSArray *)imageArray
                             doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                          dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame, image resouce Array and configuration
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromSenderFrame:(CGRect )senderFrame
                         withMenuArray:(NSArray *)menuArray
                            imageArray:(NSArray *)imageArray
                         configuration:(FTPopOverMenuConfiguration *)configuration
                             doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                          dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;
/**
 *  dismiss method
 */
+ (void)dismiss;

- (FTPopOverMenu *)showForSender:(UIView *)sender
                        withMenu:(NSArray *)menuArray
                          config:(FTPopOverMenuConfiguration *)config
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

- (FTPopOverMenu *)showForSender:(UIView *)sender
                        withMenu:(NSArray *)menuArray
                          configBlock:(FTPopOverMenuConfiguration * (^)(void))configBlock
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

- (FTPopOverMenu *)showForSender:(UIView *)sender
                          window:(UIWindow*)window
                     senderFrame:(CGRect )senderFrame
                        withMenu:(NSArray *)menuArray
                  imageNameArray:(NSArray *)imageNameArray
                          config:(FTPopOverMenuConfiguration *)config
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

- (void)dismiss;

@end

