//
//  MBProgressHUD.h
//  Version 0.9.2
//  Created by Matej Bukovinski on 2.4.09.
//

// This code is distributed under the terms and conditions of the MIT license. 

// Copyright (c) 2009-2015 Matej Bukovinski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol MBProgressHUDDelegate;

///HUD的类型
typedef NS_ENUM(NSInteger, MBProgressHUDMode) {
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
	MBProgressHUDModeIndeterminate,
	/** Progress is shown using a round, pie-chart like, progress view. */
	MBProgressHUDModeDeterminate,
	/** Progress is shown using a horizontal progress bar */
	MBProgressHUDModeDeterminateHorizontalBar,
	/** Progress is shown using a ring-shaped progress view. */
	MBProgressHUDModeAnnularDeterminate,
	/** Shows a custom view */
	MBProgressHUDModeCustomView,
	/** Shows only labels */
	MBProgressHUDModeText
};

typedef NS_ENUM(NSInteger, MBProgressHUDAnimation) {
	/** Opacity animation */
	MBProgressHUDAnimationFade,
	/** Opacity + scale animation */
	MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomOut = MBProgressHUDAnimationZoom,
	MBProgressHUDAnimationZoomIn
};


#ifndef MB_INSTANCETYPE
#if __has_feature(objc_instancetype)
	#define MB_INSTANCETYPE instancetype
#else
	#define MB_INSTANCETYPE id
#endif
#endif

#ifndef MB_STRONG
#if __has_feature(objc_arc)
	#define MB_STRONG strong
#else
	#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
	#define MB_WEAK weak
#elif __has_feature(objc_arc)
	#define MB_WEAK unsafe_unretained
#else
	#define MB_WEAK assign
#endif
#endif

#if NS_BLOCKS_AVAILABLE
typedef void (^MBProgressHUDCompletionBlock)();
#endif


/** 
 * 一个简单的HUD显示窗口包含一个进度指示器和短消息两可选的标签。
 * 此视图支持四种操作模式：
 *
 *  - MBProgressHUDModeIndeterminate - 显示一个uiactivityindicatorview
 *  - MBProgressHUDModeDeterminate   - 显示自定义的圆形进度指示器
 *  - MBProgressHUDModeAnnularDeterminate - 显示自定义环形进度指示器
 *  - MBProgressHUDModeCustomView    - 显示任意的，用户指定的视图
 */
@interface MBProgressHUD : UIView

/*!
 * 在某个view上添加HUD并显示
 *
 * 注意：显示之前，先去掉在当前view上显示的HUD。这个做法很严谨，我们将这个方案抽象出来：如果一个模型是这样的：我们需要将A加入到B中，但是需求上B里面只允许只有一个A。那么每次将A添加到B之前，都要先判断当前的b里面是否有A，如果有，则移除。
 */
+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 *  找到某个view上最上层的HUD并隐藏它。
 *  如果返回值是YES的话，就表明HUD被找到而且被移除了。
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 *   隐藏所有视图的 HUD
 *
 * @note This method sets `removeFromSuperViewOnHide`. The HUDs will automatically be removed from the view hierarchy when hidden.
 */
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

/**
 * 在某个view上找到最上层的HUD并返回它。
 *  返回值可以是空
 */
+ (MB_INSTANCETYPE)HUDForView:(UIView *)view;

/**
 *  找出所有子视图并返回他们的HUD。
 *
 * @param view
 * @return 返回所有发现HUD视图（mbprogresshud对象的数组）。
 */
+ (NSArray *)allHUDsForView:(UIView *)view;

///便利构造函数初始化HUD与窗口边界。调用指定的构造函数
- (id)initWithWindow:(UIWindow *)window;

///一个HUD的便利构造函数，用某个view来初始化HUD：这个view的bounds就是HUD的bounds
- (id)initWithView:(UIView *)view;

///显示HUD，有无动画。
- (void)show:(BOOL)animated;

///隐藏HUD，有无动画
- (void)hide:(BOOL)animated;

///在 delay秒 后隐藏HUD,有无动画。
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/** 
 * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
 *
 * This method also takes care of autorelease pools so your method does not have to be concerned with setting up a
 * pool.
 *
 * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread.
 * @param target The object that the target method belongs to.
 * @param object An optional object to be passed to the method.
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will not use
 * animations while (dis)appearing.
 */
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

#if NS_BLOCKS_AVAILABLE

/**
 * Shows the HUD while a block is executing on a background queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block;

/**
 * Shows the HUD while a block is executing on a background queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * Shows the HUD while a block is executing on the specified dispatch queue, then hides the HUD.
 *
 * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue;

/** 
 * Shows the HUD while a block is executing on the specified dispatch queue, executes completion block on the main queue, and then hides the HUD.
 *
 * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will
 * not use animations while (dis)appearing.
 * @param block The block to be executed while the HUD is shown.
 * @param queue The dispatch queue on which the block should be executed.
 * @param completion The block to be executed on completion.
 *
 * @see completionBlock
 */
- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
		  completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * A block that gets called after the HUD was completely hidden.
 */
@property (copy) MBProgressHUDCompletionBlock completionBlock;

#endif

/** 
 * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
 *
 * HUD的类型
 */
@property (assign) MBProgressHUDMode mode;

/**
 * The animation type that should be used when the HUD is shown and hidden. 
 *
 * @see 动画类型
 */
@property (assign) MBProgressHUDAnimation animationType;

/**
 * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
 * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds). 
 */
@property (MB_STRONG) UIView *customView;

/** 
 * The HUD delegate object. 
 *
 * @see MBProgressHUDDelegate
 */
@property (MB_WEAK) id<MBProgressHUDDelegate> delegate;

/** 
 * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
 * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
 * set to @"", then no message is displayed.
 */
@property (copy) NSString *labelText;

/** 
 * An optional details message displayed below the labelText message. This message is displayed only if the labelText
 * property is also set and is different from an empty string (@""). The details text can span multiple lines. 
 */
@property (copy) NSString *detailsLabelText;

/** 
 * The opacity of the HUD window. Defaults to 0.8 (80% opacity). 
 */
@property (assign) float opacity;

/**
 * The color of the HUD window. Defaults to black. If this property is set, color is set using
 * this UIColor and the opacity property is not used.  using retain because performing copy on
 * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
 */
@property (MB_STRONG) UIColor *color;

/** 
 * The x-axis offset of the HUD relative to the centre of the superview. 
 */
@property (assign) float xOffset;

/** 
 * The y-axis offset of the HUD relative to the centre of the superview. 
 */
@property (assign) float yOffset;

/**
 * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views). 
 * Defaults to 20.0
 */
@property (assign) float margin;

/**
 * The corner radius for the HUD
 * Defaults to 10.0
 */
@property (assign) float cornerRadius;

/** 
 * Cover the HUD background view with a radial gradient. 
 */
@property (assign) BOOL dimBackground;

///show函数触发到显示HUD的时间段,默认0
@property (assign) float graceTime;

///HUD显示的最短时间,默认为o
@property (assign) float minShowTime;

/**
 * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
 * If you don't set a graceTime (different than 0.0) this does nothing.
 * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
 * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
 * you need to set this property when your task starts and completes in order to have normal graceTime 
 * functionality.
 */
@property (assign) BOOL taskInProgress;

/**
 * Removes the HUD from its parent view when hidden. 
 * Defaults to NO. 
 */
@property (assign) BOOL removeFromSuperViewOnHide;

/** 
 * Font to be used for the main label. Set this property if the default is not adequate. 
 */
@property (MB_STRONG) UIFont* labelFont;

/**
 * Color to be used for the main label. Set this property if the default is not adequate.
 */
@property (MB_STRONG) UIColor* labelColor;

/**
 * Font to be used for the details label. Set this property if the default is not adequate.
 */
@property (MB_STRONG) UIFont* detailsLabelFont;

/** 
 * Color to be used for the details label. Set this property if the default is not adequate.
 */
@property (MB_STRONG) UIColor* detailsLabelColor;

/**
 * The color of the activity indicator. Defaults to [UIColor whiteColor]
 * Does nothing on pre iOS 5.
 */
@property (MB_STRONG) UIColor *activityIndicatorColor;

/** 
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0. 
 */
@property (assign) float progress;

/**
 * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
 */
@property (assign) CGSize minSize;


/**
 * The actual size of the HUD bezel.
 * You can use this to limit touch handling on the bezel area only.
 * @see https://github.com/jdg/MBProgressHUD/pull/200
 */
@property (atomic, assign, readonly) CGSize size;


/**
 * Force the HUD dimensions to be equal if possible. 
 */
@property (assign, getter = isSquare) BOOL square;

@end


@protocol MBProgressHUDDelegate <NSObject>

@optional

/** 
 * Called after the HUD was fully hidden from the screen. 
 */
- (void)hudWasHidden:(MBProgressHUD *)hud;

@end


/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
@interface MBRoundProgressView : UIView 

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Indicator progress color.
 * Defaults to white [UIColor whiteColor]
 */
@property (nonatomic, MB_STRONG) UIColor *progressTintColor;

/**
 * Indicator background (non-progress) color.
 * Defaults to translucent white (alpha 0.1)
 */
@property (nonatomic, MB_STRONG) UIColor *backgroundTintColor;

/*
 * Display mode - NO = round or YES = annular. Defaults to round.
 */
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end


/**
 * A flat bar progress view. 
 */
@interface MBBarProgressView : UIView

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

/**
 * Bar border line color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, MB_STRONG) UIColor *lineColor;

/**
 * Bar background color.
 * Defaults to clear [UIColor clearColor];
 */
@property (nonatomic, MB_STRONG) UIColor *progressRemainingColor;

/**
 * Bar progress color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic, MB_STRONG) UIColor *progressColor;

@end
