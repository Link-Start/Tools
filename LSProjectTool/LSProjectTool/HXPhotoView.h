//
//  HXPhotoView.h
//  微博照片选择
//
//  Created by 洪欣 on 17/2/17.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCollectionView.h"

/*
 *  使用选择照片之后自动布局的功能时就创建此块View. 初始化方法传入照片管理类
 */
@class HXPhotoView;
@protocol HXPhotoViewDelegate <NSObject>
@optional

// 当view更新高度时调用
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame;

// 删除网络图片的地址
- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl;

/**  网络图片全部下载完成时调用  */
- (void)photoViewAllNetworkingPhotoDownloadComplete:(HXPhotoView *)photoView;

@end

@interface HXPhotoView : UIView
@property (weak, nonatomic) id<HXPhotoViewDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *currentIndexPath; // 自定义转场动画时用到的属性
@property (strong, nonatomic) HXCollectionView *collectionView;

/**
 每行个数 默认3;
 */
@property (assign, nonatomic) NSInteger lineCount;

/**
 每个item间距 默认 3
 */
@property (assign, nonatomic) CGFloat spacing;

/**  删除某个模型  */
- (void)deleteModelWithIndex:(NSInteger)index;


@end
